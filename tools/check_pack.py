#!/usr/bin/env python3
"""Native checks against the exported pack, from empty working and save directories."""
import argparse, json, os, re, subprocess, tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--godot', required=True)
    p.add_argument('--pack', type=Path, required=True)
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args(); output = a.output.resolve(); output.mkdir(parents=True, exist_ok=False)
    engine = str(Path(a.godot).resolve()); pack = str(a.pack.resolve())
    cases = [('ambient', (ROOT/'tests/pack_ambient61.gd').read_text(), 'PACK AMBIENT61')]
    # Inline only the test fixture. Game scripts/assets must resolve inside the pack.
    fixture = (ROOT/'tests/support/game_fixture.gd').read_text()
    body = (ROOT/'tests/continuity66.gd').read_text().split('\n', 1)[1]
    cases.append(('continuity', fixture+'\n'+body, 'CONTINUITY66'))
    body = (ROOT/'tests/living67.gd').read_text().split('\n', 1)[1]
    cases.append(('living', fixture+'\n'+body, 'LIVING67'))
    body = (ROOT/'tests/civic68.gd').read_text().split('\n', 1)[1]
    cases.append(('civic', fixture+'\n'+body, 'CIVIC68'))
    body = (ROOT/'tests/firstshift69.gd').read_text().split('\n', 1)[1]
    cases.append(('firstshift', fixture+'\n'+body, 'FIRSTSHIFT69'))
    body = (ROOT/'tests/ancestral70.gd').read_text().split('\n', 1)[1]
    cases.append(('ancestral', fixture+'\n'+body, 'ANCESTRAL70'))
    body = (ROOT/'tests/disciplines71.gd').read_text().split('\n', 1)[1]
    cases.append(('disciplines', fixture+'\n'+body, 'DISCIPLINES71'))
    body = (ROOT/'tests/polish72.gd').read_text().split('\n', 1)[1]
    cases.append(('polish', fixture+'\n'+body, 'POLISH72'))
    body = (ROOT/'tests/firsthour73.gd').read_text().split('\n', 1)[1]
    cases.append(('firsthour', fixture+'\n'+body, 'FIRSTHOUR73'))
    body = (ROOT/'tests/appearance74.gd').read_text().split('\n', 1)[1]
    cases.append(('appearance', fixture+'\n'+body, 'APPEARANCE74'))
    body = (ROOT/'tests/roads75.gd').read_text().split('\n', 1)[1]
    cases.append(('roads', fixture+'\n'+body, 'ROADS75'))
    body = (ROOT/'tests/work76.gd').read_text().split('\n', 1)[1]
    cases.append(('work', fixture+'\n'+body, 'WORK76'))
    body = (ROOT/'tests/keldrath77.gd').read_text().split('\n', 1)[1]
    cases.append(('keldrath', fixture+'\n'+body, 'KELDRATH77'))
    body = (ROOT/'tests/homestead78.gd').read_text().split('\n', 1)[1]
    cases.append(('homestead', fixture+'\n'+body, 'HOMESTEAD78'))
    body = (ROOT/'tests/royal79.gd').read_text().split('\n', 1)[1]
    cases.append(('royal', fixture+'\n'+body, 'ROYAL79'))
    body = (ROOT/'tests/people82.gd').read_text().split('\n', 1)[1]
    cases.append(('people', fixture+'\n'+body, 'PEOPLE82'))
    body = (ROOT/'tests/combat83.gd').read_text().split('\n', 1)[1]
    cases.append(('combat', fixture+'\n'+body, 'COMBAT83'))
    results = []
    for name, script, marker in cases:
        capture = output/name; capture.mkdir()
        with tempfile.TemporaryDirectory(prefix='stellar-pack-') as temp:
            directory = Path(temp); harness = directory/'check.gd'; harness.write_text(script)
            env = os.environ.copy(); env.update(XDG_DATA_HOME=str(directory/'save'), APPDATA=str(directory/'save'), LOCALAPPDATA=str(directory/'save'))
            proc = subprocess.run([engine, '--path', temp, '--main-pack', pack, '--audio-driver', 'Dummy',
                                   '--rendering-method', 'gl_compatibility', '--script', str(harness), '--', str(capture)],
                                  cwd=temp, env=env, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=360)
        log = proc.stdout; (output/(name+'.log')).write_text(log)
        match = re.search(re.escape(marker)+r': (\d+) passed / 0 failed', log)
        errors = [line for line in log.splitlines() if ('SCRIPT ERROR:' in line or line.startswith('ERROR:'))
                  and not re.search(r'ERROR: \d+ resources still in use at exit', line)]
        ok = proc.returncode == 0 and bool(match) and not errors
        results.append(dict(test=name, passed=ok, checks=int(match[1]) if match else 0, errors=errors))
        (output/'results.json').write_text(json.dumps(results, indent=2))
        print(name, 'PASS' if ok else 'FAIL', flush=True)
        if not ok: print(log[-5000:]); raise SystemExit(1)

if __name__ == '__main__': main()

