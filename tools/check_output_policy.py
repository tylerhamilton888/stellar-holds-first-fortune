#!/usr/bin/env python3
"""Reject known output-safety regressions in repository tools and CI definitions."""
import ast
from pathlib import Path
import re
import subprocess
from output_safety import emit

ROOT = Path(__file__).resolve().parents[1]
BUDGETS = {'AGENTS.md': 8000, 'docs/SESSION_HANDOFF.md': 4000,
           'docs/CURRENT_STATUS.md': 4000, 'docs/CHANGELOG.md': 8000}
# These two reviewed implementations own bounded output. All other tools use emit.
OUTPUT_OWNERS = {'output_safety.py', 'capture_command.py'}


def violations(root=ROOT):
    failures = []
    if (root / '.git').exists():
        tracked = subprocess.check_output(['git', 'ls-files', '-z', '--', 'tools/*.py',
            '.github/workflows/*.yml', '.github/workflows/*.yaml'], cwd=root, stderr=subprocess.PIPE)
        for name in tracked.decode().split('\0'):
            if name and not (root / name).is_file():
                failures.append(f'tracked policy input missing from checkout: {name}')
    for name, limit in BUDGETS.items():
        path = root / name
        if not path.is_file():
            failures.append(f'missing required current document: {name}')
        elif path.stat().st_size > limit:
            failures.append(f'current document exceeds {limit} bytes: {name}')
    for path in sorted((root / 'tools').rglob('*.py')):
        if path.name.startswith('test_') or path.name in OUTPUT_OWNERS:
            continue
        source = path.read_text()
        tree = ast.parse(source)
        for node in ast.walk(tree):
            forbidden = None
            if isinstance(node, ast.Name) and node.id == 'print':
                forbidden = 'direct print; use bounded emit'
            if isinstance(node, ast.Attribute) and node.attr in ('b64encode', 'encodebytes', 'b2a_base64'):
                forbidden = 'encoded binary path needs an explicit reviewed transfer design'
            if isinstance(node, ast.Call):
                target = ast.unparse(node.func)
                if target in ('builtins.print', 'os.write', 'os.system') or target.startswith(
                        ('sys.stdout.', 'sys.stderr.', 'logging.')):
                    forbidden = 'console bypass; use bounded emit or file capture'
            if forbidden:
                failures.append(f'{path.relative_to(root)}:{node.lineno}: {forbidden}')
    for path in sorted((root / '.github/workflows').glob('*.y*ml')):
        for number, line in enumerate(path.read_text().splitlines(), 1):
            if re.search(r'python3? (?:tools/\S+\.py|-m (?:unittest|pip))', line):
                if not any(wrapper in line for wrapper in ('tools/capture_command.py --log ', '$RUNNER_TEMP/output-safety/capture_command.py" --log ')):
                    failures.append(f'{path.name}:{number}: tool command bypasses capture')
            if re.search(r'\bbase64\b|b64encode|\btee\b', line):
                failures.append(f'{path.name}:{number}: encoded output or console mirror')
    return failures


def main():
    failures = violations()
    for failure in failures[:15]:
        emit(failure)
    emit('Output policy:', 'FAIL' if failures else 'PASS', 'violations:', len(failures))
    return bool(failures)


if __name__ == '__main__':
    raise SystemExit(main())
