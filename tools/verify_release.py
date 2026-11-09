#!/usr/bin/env python3
"""Fail-closed verification of a Windows candidate and the complete exported suite."""
from output_safety import emit
import argparse
import hashlib
import json
import re
import shutil
import zipfile
from pathlib import Path

from check_pack import load_cases, select_cases


def digest(stream):
    return hashlib.file_digest(stream, 'sha256').hexdigest()


def verify_build(directory, source_sha, extract_pack=False):
    directory = Path(directory)
    build = json.loads((directory/'build.json').read_text())
    if build['commit'] != source_sha or build['dirty'] is not False:
        raise ValueError('Candidate source mismatch or dirty build')
    version = build['version']
    if not re.fullmatch(r'\d+\.\d+\.\d+', version):
        raise ValueError('Invalid version')
    archive = directory/f'Stellar-Holds-First-Fortune-{version}-Windows.zip'
    if archive.stat().st_size != build['zip_bytes']:
        raise ValueError('ZIP size mismatch')
    with archive.open('rb') as stream:
        if digest(stream) != build['zip_sha256']:
            raise ValueError('ZIP digest mismatch')
    files = {'FirstFortune.exe', 'FirstFortune.pck', 'GODOT-LICENSE.txt',
             'GODOT-COPYRIGHT.txt', 'version.txt', 'START-HERE.txt'}
    if set(build['files']) != files:
        raise ValueError('Unexpected build manifest members')
    with zipfile.ZipFile(archive) as z:
        names = z.namelist()
        if len(names) != len(set(names)) or set(names) != files | {'FILE-HASHES.sha256'}:
            raise ValueError('Unexpected or duplicate ZIP members')
        for name in sorted(files):
            with z.open(name) as stream:
                if digest(stream) != build['files'][name]:
                    raise ValueError('ZIP member digest mismatch: '+name)
        expected_hashes = ''.join(f'{h}  {name}\n' for name, h in build['files'].items())
        if z.read('FILE-HASHES.sha256').decode() != expected_hashes:
            raise ValueError('Embedded checksum manifest mismatch')
        if extract_pack:
            with z.open('FirstFortune.pck') as src, (directory/'FirstFortune.pck').open('wb') as dst:
                shutil.copyfileobj(src, dst)
    return build


def verify_reports(paths, build, source_sha, shard_count, cases=None):
    cases = load_cases() if cases is None else cases
    names = [case[0] for case in cases]
    if len(names) != len(set(names)) or not names:
        raise ValueError('Invalid case catalogue')
    if len(paths) != shard_count or shard_count < 1:
        raise ValueError('Missing or extra shard reports')
    seen_shards, completed = set(), []
    total_checks, shard_seconds = 0, []
    for path in paths:
        r = json.loads(Path(path).read_text())
        index = r['shard_index']
        if type(index) is not int or index in seen_shards or not 0 <= index < shard_count:
            raise ValueError('Duplicate or invalid shard index')
        seen_shards.add(index)
        if (r['schema'] != 1 or r['source_sha'] != source_sha or
                r['pack_sha256'] != build['files']['FirstFortune.pck'] or
                r['shard_count'] != shard_count or r['focused'] is not False or
                r['complete'] is not True or r['expected_cases'] != names):
            raise ValueError('Incomplete, focused, stale or mismatched shard report')
        assigned = [case[0] for case in select_cases(cases, shard_index=index, shard_count=shard_count)]
        results = r['results']
        if r['assigned_cases'] != assigned or [x['test'] for x in results] != assigned:
            raise ValueError('Missing, extra or duplicate test results')
        for result in results:
            if (result['passed'] is not True or result['exit_code'] != 0 or result['errors'] or result.get('error_count', 0) != 0 or
                    type(result['checks']) is not int or result['checks'] < 1):
                raise ValueError('A packaged-game test did not pass')
            total_checks += result['checks']
        completed.extend(assigned)
        shard_seconds.append(sum(x['seconds'] for x in results))
    if set(completed) != set(names) or len(completed) != len(names):
        raise ValueError('Suite coverage is not exactly once')
    return dict(version=build['version'], source_sha=source_sha, pack_sha256=build['files']['FirstFortune.pck'],
                zip_sha256=build['zip_sha256'], cases=len(names), assertions=total_checks,
                shards=shard_count, shard_seconds=shard_seconds, passed=True)


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--candidate', type=Path, required=True)
    p.add_argument('--source-sha', required=True)
    p.add_argument('--extract-pack', action='store_true')
    p.add_argument('--reports', type=Path)
    p.add_argument('--shard-count', type=int, default=4)
    p.add_argument('--output', type=Path)
    p.add_argument('--summary', type=Path, help='Bind publication to the verified candidate')
    a = p.parse_args()
    build = verify_build(a.candidate, a.source_sha, a.extract_pack)
    if a.summary:
        summary = json.loads(a.summary.read_text())
        if (summary.get('passed') is not True or summary.get('source_sha') != a.source_sha or
                summary.get('zip_sha256') != build['zip_sha256'] or
                summary.get('pack_sha256') != build['files']['FirstFortune.pck'] or
                summary.get('cases') != len(load_cases()) or summary.get('shards') != a.shard_count):
            raise ValueError('Publication proof does not match this candidate')
    if a.reports:
        summary = verify_reports(sorted(a.reports.glob('**/report.json')), build, a.source_sha, a.shard_count)
        if a.output:
            a.output.parent.mkdir(parents=True, exist_ok=True)
            a.output.write_text(json.dumps(summary, indent=2)+'\n')
        emit('Release verified; cases:',summary['cases'],'assertions:',summary['assertions'])
    else:
        emit('Verified candidate', build['version'], build['zip_sha256'])


if __name__ == '__main__':
    main()
