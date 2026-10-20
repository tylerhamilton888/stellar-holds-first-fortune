#!/usr/bin/env python3
"""Run the current acceptance manifest with isolated saves and explicit completion gates."""
import argparse, json, os, re, subprocess, tempfile, time
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]

def run(godot, suite, output, skip_import=False):
    manifest = json.loads((ROOT / 'tests/suites.json').read_text())
    output.mkdir(parents=True, exist_ok=False)
    engine = str(Path(godot).resolve()) if Path(godot).exists() else godot
    results = []
    jobs = [] if skip_import else [('import', ['--headless', '--editor', '--import', '--quit'], None)]
    for name in manifest['suites'][suite]:
        case = manifest['cases'][name]
        capture = output / name
        capture.mkdir()
        jobs.append((name, ['--audio-driver', 'Dummy', '--rendering-method', 'gl_compatibility',
                            '--script', 'res://' + case['script'], '--', str(capture)], case['marker']))
    for name, args, marker in jobs:
        started = time.monotonic()
        with tempfile.TemporaryDirectory(prefix='stellar-' + name + '-') as save:
            env = os.environ.copy()
            env.update(XDG_DATA_HOME=save, APPDATA=save, LOCALAPPDATA=save)
            try:
                proc = subprocess.run([engine, '--path', str(ROOT), *args], cwd=ROOT, env=env,
                                      stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                      text=True, timeout=900 if name == 'import' else 360)
                log, code = proc.stdout, proc.returncode
            except subprocess.TimeoutExpired as exc:
                log = exc.stdout or b''
                if isinstance(log, bytes): log = log.decode(errors='replace')
                log += '\nTIMEOUT\n'
                code = -1
        (output / (name + '.log')).write_text(log)
        errors = [line for line in log.splitlines() if ('SCRIPT ERROR:' in line or line.startswith('ERROR:'))
                  and not re.search(r'ERROR: \d+ resources still in use at exit', line)]
        match = re.search(re.escape(marker) + r': (\d+) passed / 0 failed', log) if marker else True
        passed = code == 0 and not errors and bool(match)
        results.append(dict(test=name, passed=passed, exit_code=code, errors=errors,
                            checks=int(match[1]) if marker and match else 0,
                            seconds=round(time.monotonic()-started, 2)))
        (output/'results.json').write_text(json.dumps(results, indent=2))
        print(name, 'PASS' if passed else 'FAIL', flush=True)
        if not passed:
            print(log[-5000:])
            return False
    return True

if __name__ == '__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--godot',required=True)
    p.add_argument('--suite', choices=list(json.loads((ROOT / 'tests/suites.json').read_text())['suites']), default='core')
    p.add_argument('--output',type=Path,required=True,help='New directory; never overwrite previous evidence')
    p.add_argument('--skip-import',action='store_true')
    a=p.parse_args()
    raise SystemExit(0 if run(a.godot,a.suite,a.output.resolve(),a.skip_import) else 1)
