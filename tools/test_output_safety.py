"""Behavioral flood tests and CI policy tests for known payload regressions."""
import contextlib
import io
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import build
import check
import check_output_policy
import output_safety
import plan_validation
import read_diagnostics


class OutputSafetyTests(unittest.TestCase):
    def test_reader_skips_giant_encoded_line_and_preserves_file(self):
        with tempfile.TemporaryDirectory() as tmp, contextlib.redirect_stdout(io.StringIO()) as stream:
            log = Path(tmp) / 'diagnostics.log'
            data = b'SCRIPT ERROR: data:image/png;base64,' + b'A' * 1000000 + b'\nERROR: useful detail\n'
            log.write_bytes(data)
            read_diagnostics.inspect(log, 'ERROR:')
            self.assertEqual(log.read_bytes(), data)
        self.assertIn('useful detail', stream.getvalue())
        self.assertNotIn('A' * 160, stream.getvalue())
        self.assertLess(len(stream.getvalue().encode()), 1200)

    def test_unicode_flood_and_encoded_lines_cannot_expand_console(self):
        with contextlib.redirect_stdout(io.StringIO()) as stream:
            output_safety.emit('data:image/png;base64,' + 'A' * 1000000)
            for _ in range(1000):
                output_safety.emit('界 ' * 1000)
        self.assertLessEqual(len(stream.getvalue().encode()), 8000)
        self.assertNotIn('A' * 160, stream.getvalue())
        self.assertNotIn('base64,', stream.getvalue())

    def test_error_storm_keeps_full_log_but_small_failure_report(self):
        log = 'LOADING63: 1 passed / 0 failed\n' + 'SCRIPT ERROR: ' + 'A' * 500000 + '\n'
        log += 'SCRIPT ERROR: repeated\n' * 100000
        with tempfile.TemporaryDirectory() as tmp, contextlib.redirect_stdout(io.StringIO()) as stream:
            output = Path(tmp) / 'case'
            with patch.object(check.subprocess, 'run', return_value=subprocess.CompletedProcess([], 0, log)):
                self.assertFalse(check.run('/fake', 'core', output, True, selected=['loading']))
            self.assertEqual((output / 'loading.log').read_text(), log)
            report = json.loads((output / 'results.json').read_text())
            self.assertEqual(report[0]['error_count'], 100001)
            self.assertFalse(report[0]['passed'])
            self.assertLess((output / 'results.json').stat().st_size, 2000)
        self.assertLess(len(stream.getvalue().encode()), 512)
        self.assertNotIn('A' * 160, stream.getvalue())

    def test_build_timeout_retains_partial_diagnostics(self):
        with tempfile.TemporaryDirectory() as tmp:
            log = Path(tmp) / 'build.log'
            with patch.object(build.subprocess, 'run', side_effect=subprocess.TimeoutExpired('fake', 900, b'partial\xff')):
                with self.assertRaisesRegex(RuntimeError, 'timed out'):
                    build.command('/fake', [], log)
            self.assertEqual(log.read_bytes(), b'partial\xff')

    def test_large_plan_stays_in_file_with_machine_outputs_preserved(self):
        with tempfile.TemporaryDirectory() as tmp, contextlib.redirect_stdout(io.StringIO()) as stream:
            root = Path(tmp)
            paths = ['scripts/new%d.gd' % i for i in range(10000)]
            with patch('sys.argv', ['plan_validation.py', '--base', 'base', '--output', str(root / 'plan.json')]), \
                    patch.object(plan_validation, 'changed_paths', return_value=paths), \
                    patch.dict('os.environ', {'GITHUB_OUTPUT': str(root / 'outputs'), 'GITHUB_STEP_SUMMARY': str(root / 'summary')}):
                plan_validation.main()
            plan = json.loads((root / 'plan.json').read_text())
            self.assertEqual(len(plan['reasons']), 10000)
            self.assertEqual(json.loads(stream.getvalue())['mode'], 'full')
            self.assertIn('run_gameplay=true', (root / 'outputs').read_text())
            self.assertLess((root / 'summary').stat().st_size, 512)
        self.assertLess(len(stream.getvalue()), 512)

    def test_repository_policy(self):
        self.assertEqual(check_output_policy.violations(), [])

    def test_policy_rejects_new_dumps_uncaptured_jobs_and_document_growth(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            for name in check_output_policy.BUDGETS:
                path = root / name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text('short')
            (root / 'tools').mkdir()
            workflow = root / '.github/workflows/bad.yml'
            workflow.parent.mkdir(parents=True)
            self.assertEqual(check_output_policy.violations(root), [])
            (root / 'tools/new_tool.py').write_text('import base64\nprint(base64.b64encode(b"bad"))\n')
            workflow.write_text('run: python3 tools/new_tool.py\n')
            (root / 'docs/SESSION_HANDOFF.md').write_text('x' * 4001)
            failures = check_output_policy.violations(root)
            self.assertTrue(any('direct print' in f for f in failures))
            self.assertTrue(any('encoded binary' in f for f in failures))
            self.assertTrue(any('bypasses capture' in f for f in failures))
            self.assertTrue(any('exceeds 4000' in f for f in failures))


if __name__ == '__main__':
    unittest.main()
