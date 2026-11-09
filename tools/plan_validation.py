#!/usr/bin/env python3
"""Conservative PR test selection. Unmapped runtime changes require full coverage."""
from output_safety import emit
import argparse
import json
import math
import os
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SMOKE = ['loading', 'firstvisit99']  # Startup plus real isolated fortune save/reload.
# These are reviewed dependency groups, not filename guesses. Shared owners fall
# through to full coverage. Adding a new runtime file also falls through to full.
DOMAINS = {
    'restoration139': ('scripts/ledger137.gd', 'scripts/campaign138.gd', 'scripts/restoration139.gd'),
    'work132': ('scripts/work132.gd', 'scripts/work_view132.gd'),
    'troll133': ('scripts/troll133.gd',),
    'traditions126': ('scripts/traditions126.gd',),
}


def full_cases(manifest):
    return list(dict.fromkeys(case for i in range(1, 5)
                             for case in manifest['suites'][f'gameplay-{i}']))


def plan(paths, manifest, force_full=False):
    all_cases = full_cases(manifest)
    known = manifest['cases']
    selected = set()
    reasons = []
    full = force_full
    test_paths = {v['script']: k for k, v in known.items()}
    domains = {path: suite for suite, files in DOMAINS.items() for path in files}
    for path in sorted(set(paths)):
        if path.startswith('docs/') or path in ('AGENTS.md', 'SESSION_HANDOFF.md', 'README.md'):
            continue
        if path in test_paths:
            selected.add(test_paths[path])
            reasons.append(f'{path}: changed test')
        elif path in domains:
            selected.update(manifest['suites'][domains[path]])
            if domains[path] == 'work132':
                selected.update(manifest['suites']['restoration139'])
            reasons.append(f'{path}: {domains[path]} integration group')
        elif path in ('tools/check.py', 'tools/plan_validation.py', 'tools/output_safety.py'):
            selected.update(SMOKE)
            reasons.append(f'{path}: runner/planner startup and save checks')
        elif path.startswith(('tools/', '.github/workflows/')):
            reasons.append(f'{path}: tooling tests (package rehearsal is explicit)')
        else:
            full = True
            reasons.append(f'{path}: shared or unmapped change; full source coverage')
    if full:
        selected.update(all_cases)
    if selected:
        selected.update(SMOKE)
    missing = selected - known.keys()
    if missing:
        raise ValueError(f'Unknown test IDs: {sorted(missing)}')
    cases = sorted(selected)
    # Up to four workers; small changes avoid four cold checkouts/imports.
    count = min(4, max(1, math.ceil(len(cases) / 6)))
    matrix = {'include': [{'shard': i, 'cases': cases[i::count]} for i in range(count)]}
    return dict(mode='full' if full else ('focused' if cases else 'tooling/docs'),
                cases=cases, matrix=matrix, run_gameplay=bool(cases), reasons=reasons)


def changed_paths(base, head):
    # --no-renames includes both sides of a rename; deletion still affects selection.
    result = subprocess.run(['git', 'diff', '--name-only', '--no-renames', '-z', base, head],
                            cwd=ROOT, check=True, capture_output=True)
    return [p for p in result.stdout.decode().split('\0') if p]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--base')
    parser.add_argument('--head', default='HEAD')
    parser.add_argument('--full', action='store_true')
    parser.add_argument('--output', type=Path, default=Path('test-results/validation-plan.json'))
    args = parser.parse_args()
    manifest = json.loads((ROOT / 'tests/suites.json').read_text())
    try:
        paths = changed_paths(args.base, args.head) if args.base else []
        result = plan(paths, manifest, args.full or not args.base)
    except (subprocess.CalledProcessError, UnicodeError):
        result = plan([], manifest, True)
        result['reasons'].append('Diff unavailable; full source coverage')
    args.output.parent.mkdir(parents=True, exist_ok=True)
    (args.output.parent / '.gdignore').touch()
    args.output.write_text(json.dumps(result, indent=2) + '\n')
    emit(json.dumps(dict(mode=result['mode'], case_count=len(result['cases']),
                         run_gameplay=result['run_gameplay'])))
    if os.environ.get('GITHUB_OUTPUT'):
        with open(os.environ['GITHUB_OUTPUT'], 'a') as out:
            out.write('matrix=' + json.dumps(result['matrix']) + '\n')
            out.write('run_gameplay=' + str(result['run_gameplay']).lower() + '\n')
    if os.environ.get('GITHUB_STEP_SUMMARY'):
        with open(os.environ['GITHUB_STEP_SUMMARY'], 'a') as out:
            out.write(f"Validation: **{result['mode']}**, {len(result['cases'])} source cases.\n\n")
            out.write('Detailed selection and reasons are in the validation-plan artifact.\n')


if __name__ == '__main__':
    main()
