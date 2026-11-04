"""Release safety tests: missing evidence and changed bytes must block publication."""
import copy
import contextlib
import io
import hashlib
import json
import os
import subprocess
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path
from unittest.mock import patch

import check_pack
import verify_release
from verify_release import verify_build, verify_reports


class PipelineTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.sha = 'a' * 40
        self.cases = [('test'+str(i), 'extends SceneTree', 'TEST') for i in range(9)]
        contents = {name: name.encode() for name in ['FirstFortune.exe', 'FirstFortune.pck',
                    'GODOT-LICENSE.txt', 'GODOT-COPYRIGHT.txt', 'version.txt', 'START-HERE.txt']}
        hashes = {name: hashlib.sha256(data).hexdigest() for name, data in contents.items()}
        contents['FILE-HASHES.sha256'] = ''.join(f'{h}  {name}\n' for name, h in hashes.items()).encode()
        self.archive = self.root/'Stellar-Holds-First-Fortune-1.2.3-Windows.zip'
        with zipfile.ZipFile(self.archive, 'w') as z:
            for name, content in contents.items():
                z.writestr(name, content)
        self.build = dict(version='1.2.3', commit=self.sha, dirty=False, files=hashes,
                          zip_bytes=self.archive.stat().st_size,
                          zip_sha256=hashlib.sha256(self.archive.read_bytes()).hexdigest())
        (self.root/'build.json').write_text(json.dumps(self.build))
        self.reports = []
        for i in range(4):
            assigned = [x[0] for x in self.cases[i::4]]
            self.reports.append(dict(schema=1, source_sha=self.sha, pack_sha256=hashes['FirstFortune.pck'],
                shard_index=i, shard_count=4, focused=False, complete=True,
                expected_cases=[x[0] for x in self.cases], assigned_cases=assigned,
                results=[dict(test=x, passed=True, checks=2, errors=[], exit_code=0, seconds=1.0) for x in assigned]))

    def gate(self, reports=None):
        paths = []
        for i, report in enumerate(self.reports if reports is None else reports):
            p = self.root/f'report-{i}.json'; p.write_text(json.dumps(report)); paths.append(p)
        return verify_reports(paths, self.build, self.sha, 4, self.cases)

    def test_real_suite_shards_preserve_every_test_once(self):
        cases = check_pack.load_cases()
        for count in (1, 2, 4, 8):
            parts = [check_pack.select_cases(cases, shard_index=i, shard_count=count) for i in range(count)]
            names = [case[0] for part in parts for case in part]
            self.assertEqual(len(names), len(cases))
            self.assertEqual(set(names), {x[0] for x in cases})

    def test_selection_errors_cannot_silently_skip_tests(self):
        for kwargs in [dict(shard_count=0), dict(shard_index=-1), dict(shard_index=4, shard_count=4),
                       dict(selected=['missing']), dict(selected=['test0'], shard_count=4),
                       dict(shard_index=9, shard_count=10)]:
            with self.subTest(kwargs=kwargs), self.assertRaises(ValueError):
                check_pack.select_cases(self.cases, **kwargs)

    def test_complete_gate_and_identical_candidate_pass(self):
        build = verify_build(self.root, self.sha, extract_pack=True)
        self.assertEqual(build, self.build)
        self.assertEqual((self.root/'FirstFortune.pck').read_bytes(), b'FirstFortune.pck')
        result = self.gate()
        self.assertEqual(result['cases'], 9)
        self.assertEqual(result['assertions'], 18)

    def test_missing_extra_and_duplicate_shards_fail(self):
        for reports in [self.reports[:-1], self.reports+[self.reports[0]], [self.reports[0]]*4]:
            with self.subTest(), self.assertRaises(ValueError): self.gate(reports)

    def test_stale_focused_incomplete_and_different_package_fail(self):
        for key, value in [('source_sha','old'), ('pack_sha256','other'), ('focused',True),
                           ('complete',False), ('expected_cases',[]), ('assigned_cases',[]), ('shard_count',3)]:
            reports = copy.deepcopy(self.reports); reports[0][key] = value
            with self.subTest(key=key), self.assertRaises(ValueError): self.gate(reports)

    def test_failures_errors_missing_or_duplicate_cases_fail(self):
        for key, value in [('passed',False), ('exit_code',1), ('errors',['SCRIPT ERROR']), ('checks',0)]:
            reports = copy.deepcopy(self.reports); reports[0]['results'][0][key] = value
            with self.subTest(key=key), self.assertRaises(ValueError): self.gate(reports)
        for mutate in [lambda x: x.pop(), lambda x: x.append(x[0])]:
            reports = copy.deepcopy(self.reports); mutate(reports[0]['results'])
            with self.subTest(), self.assertRaises(ValueError): self.gate(reports)

    def test_dirty_or_different_source_fail(self):
        with self.assertRaises(ValueError): verify_build(self.root, 'wrong')
        self.build['dirty'] = True
        (self.root/'build.json').write_text(json.dumps(self.build))
        with self.assertRaises(ValueError): verify_build(self.root, self.sha)

    def test_changed_archive_bytes_fail(self):
        with self.archive.open('ab') as stream: stream.write(b'changed')
        with self.assertRaises(ValueError): verify_build(self.root, self.sha)

    def test_changed_embedded_pack_fails_even_with_new_zip_digest(self):
        with zipfile.ZipFile(self.archive) as z: entries = {n:z.read(n) for n in z.namelist()}
        entries['FirstFortune.pck'] = b'different pack'
        with zipfile.ZipFile(self.archive, 'w') as z:
            for n, data in entries.items(): z.writestr(n, data)
        self.build.update(zip_bytes=self.archive.stat().st_size, zip_sha256=hashlib.sha256(self.archive.read_bytes()).hexdigest())
        (self.root/'build.json').write_text(json.dumps(self.build))
        with self.assertRaises(ValueError): verify_build(self.root, self.sha)

    def test_runner_requires_exit_marker_and_no_errors(self):
        pack = self.root/'fake.pck'; pack.write_bytes(b'pack')
        outcomes = [(0, 'TEST: 2 passed / 0 failed', True), (1, 'TEST: 2 passed / 0 failed', False),
                    (0, 'missing completion', False), (0, 'TEST: 2 passed / 0 failed\nSCRIPT ERROR: bad', False)]
        for i, (code, log, passed) in enumerate(outcomes):
            output = self.root/f'run-{i}'
            argv = ['check_pack.py','--godot','/fake','--pack',str(pack),'--output',str(output)]
            with contextlib.redirect_stdout(io.StringIO()), patch.object(sys, 'argv', argv), patch.object(check_pack, 'load_cases', return_value=self.cases[:1]), \
                    patch.object(check_pack.subprocess, 'run', return_value=subprocess.CompletedProcess([], code, log)):
                if passed: check_pack.main()
                else:
                    with self.assertRaises(SystemExit): check_pack.main()
            report = json.loads((output/'report.json').read_text())
            self.assertEqual(report['complete'], passed)
            self.assertEqual(report['results'][0]['passed'], passed)

    def test_publication_summary_must_match_candidate(self):
        summary = self.gate()
        path = self.root/'summary.json'
        argv = ['verify_release.py','--candidate',str(self.root),'--source-sha',self.sha,'--summary',str(path)]
        for key, value in [(None,None), ('zip_sha256','changed'), ('pack_sha256','changed'),
                           ('source_sha','old'), ('passed',False), ('cases',8), ('shards',3)]:
            proof = dict(summary)
            if key: proof[key] = value
            path.write_text(json.dumps(proof))
            with self.subTest(key=key), contextlib.redirect_stdout(io.StringIO()), patch.object(sys, 'argv', argv), \
                    patch.object(verify_release, 'load_cases', return_value=self.cases):
                if key:
                    with self.assertRaises(ValueError): verify_release.main()
                else: verify_release.main()

    def test_runner_isolates_each_case_save_and_work_directory(self):
        pack = self.root/'fake.pck'; pack.write_bytes(b'pack'); output = self.root/'isolated'
        argv = ['check_pack.py','--godot','/fake','--pack',str(pack),'--output',str(output)]
        with contextlib.redirect_stdout(io.StringIO()), patch.object(sys, 'argv', argv), \
                patch.object(check_pack, 'load_cases', return_value=self.cases[:2]), \
                patch.object(check_pack.subprocess, 'run', return_value=subprocess.CompletedProcess([],0,'TEST: 2 passed / 0 failed')) as run:
            check_pack.main()
        calls = run.call_args_list
        self.assertNotEqual(calls[0].kwargs['cwd'], calls[1].kwargs['cwd'])
        self.assertNotEqual(calls[0].kwargs['env']['XDG_DATA_HOME'], calls[1].kwargs['env']['XDG_DATA_HOME'])
        self.assertTrue(json.loads((output/'report.json').read_text())['complete'])

    def test_timeout_retains_failure_proof(self):
        pack = self.root/'fake.pck'; pack.write_bytes(b'pack'); output = self.root/'timeout'
        argv = ['check_pack.py','--godot','/fake','--pack',str(pack),'--output',str(output)]
        with contextlib.redirect_stdout(io.StringIO()), patch.object(sys, 'argv', argv), patch.object(check_pack, 'load_cases', return_value=self.cases[:1]), \
                patch.object(check_pack.subprocess, 'run', side_effect=subprocess.TimeoutExpired('fake',360,b'partial')):
            with self.assertRaises(SystemExit): check_pack.main()
        report = json.loads((output/'report.json').read_text())
        self.assertFalse(report['complete'])
        self.assertFalse(report['results'][0]['passed'])
        self.assertIn('timed out', report['results'][0]['errors'][0])


if __name__ == '__main__':
    unittest.main()
