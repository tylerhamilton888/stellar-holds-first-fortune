#!/usr/bin/env python3
"""Native checks against the exported pack, from empty working and save directories."""
from output_safety import emit, error_summary
import argparse, hashlib, json, os, re, subprocess, tempfile, time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def load_cases():
    cases = [('ambient', (ROOT/'tests/pack_ambient61.gd').read_text(), 'PACK AMBIENT61')]
    # Inline only the test fixture. Game scripts/assets must resolve inside the pack.
    fixture = (ROOT/'tests/support/game_fixture.gd').read_text()
    for name, marker in [('blueprints152', 'BLUEPRINTS152'), ('blueprint_manor152', 'BLUEPRINT_MANOR152')]:
        body = (ROOT / ('tests/' + name + '.gd')).read_text().split('\n', 1)[1]
        cases.append((name, fixture + '\n' + body, marker))
    body = (ROOT/'tests/living_forges148.gd').read_text().split('\n', 1)[1]
    cases.append(('living_forges148', fixture+'\n'+body, 'LIVING_FORGES148'))
    body = (ROOT/'tests/forge147.gd').read_text().split('\n', 1)[1]
    cases.append(('forge147', fixture+'\n'+body, 'FORGE147'))
    body = (ROOT/'tests/civic145.gd').read_text().split('\n', 1)[1]
    cases.append(('civic145', fixture+'\n'+body, 'CIVIC145'))
    body = (ROOT/'tests/entryways144.gd').read_text().split('\n', 1)[1]
    cases.append(('entryways144', fixture+'\n'+body, 'ENTRYWAYS144'))
    body = (ROOT/'tests/mineworks143.gd').read_text().split('\n', 1)[1]
    cases.append(('mineworks143', fixture+'\n'+body, 'MINEWORKS143'))
    body = (ROOT/'tests/collections141.gd').read_text().split('\n', 1)[1]
    cases.append(('collections141', fixture+'\n'+body, 'COLLECTIONS141'))
    body = (ROOT/'tests/restoration139.gd').read_text().split('\n', 1)[1]
    cases.append(('restoration139', fixture+'\n'+body, 'RESTORATION139'))
    body = (ROOT/'tests/campaign138.gd').read_text().split('\n', 1)[1]
    cases.append(('campaign138', fixture+'\n'+body, 'CAMPAIGN138'))
    body = (ROOT/'tests/ledger137.gd').read_text().split('\n', 1)[1]
    cases.append(('ledger137', fixture+'\n'+body, 'LEDGER137'))
    body = (ROOT/'tests/polish135.gd').read_text().split('\n', 1)[1]
    cases.append(('polish135', fixture+'\n'+body, 'POLISH135'))
    body = (ROOT/'tests/troll133.gd').read_text().split('\n', 1)[1]
    cases.append(('troll133', fixture+'\n'+body, 'TROLL133'))
    body = (ROOT/'tests/work132.gd').read_text().split('\n', 1)[1]
    cases.append(('work132', fixture+'\n'+body, 'WORK132'))
    body = (ROOT/'tests/invasion131.gd').read_text().split('\n', 1)[1]
    cases.append(('invasion131', fixture+'\n'+body, 'INVASION131'))
    body = (ROOT/'tests/friendship130.gd').read_text().split('\n', 1)[1]
    cases.append(('friendship130', fixture+'\n'+body, 'FRIENDSHIP130'))
    body = (ROOT/'tests/story_art105.gd').read_text().split('\n', 1)[1]
    cases.append(('story_art105', fixture+'\n'+body, 'STORYART105'))
    body = (ROOT/'tests/story_world105.gd').read_text().split('\n', 1)[1]
    cases.append(('story_world105', fixture+'\n'+body, 'STORYWORLD105'))
    body = (ROOT/'tests/story_world108.gd').read_text().split('\n', 1)[1]
    cases.append(('story_world108', fixture+'\n'+body, 'STORYWORLD108'))
    body = (ROOT/'tests/story_world111.gd').read_text().split('\n', 1)[1]
    cases.append(('story_world111', fixture+'\n'+body, 'STORYWORLD111'))
    body = (ROOT/'tests/story_world112.gd').read_text().split('\n', 1)[1]
    cases.append(('story_world112', fixture+'\n'+body, 'STORYWORLD112'))
    body = (ROOT/'tests/story_world113.gd').read_text().split('\n', 1)[1]
    cases.append(('story_world113', fixture+'\n'+body, 'STORYWORLD113'))
    body = (ROOT/'tests/story_world116.gd').read_text().split('\n', 1)[1]
    cases.append(('story_world116', fixture+'\n'+body, 'STORYWORLD116'))
    body = (ROOT/'tests/story_world117.gd').read_text().split('\n', 1)[1]
    cases.append(('story_world117', fixture+'\n'+body, 'STORYWORLD117'))
    body = (ROOT/'tests/story_world118.gd').read_text().split('\n', 1)[1]
    cases.append(('story_world118', fixture+'\n'+body, 'STORYWORLD118'))
    body = (ROOT/'tests/story_world119.gd').read_text().split('\n', 1)[1]
    cases.append(('story_world119', fixture+'\n'+body, 'STORYWORLD119'))
    body = (ROOT/'tests/story_world120.gd').read_text().split('\n', 1)[1]
    cases.append(('story_world120', fixture+'\n'+body, 'STORYWORLD120'))
    body = (ROOT/'tests/story_batch121.gd').read_text().split('\n', 1)[1]
    cases.append(('story_batch121', fixture+'\n'+body, 'STORYBATCH121'))
    body = (ROOT/'tests/story_batch122.gd').read_text().split('\n', 1)[1]
    cases.append(('story_batch122', fixture+'\n'+body, 'STORYBATCH122'))
    body = (ROOT/'tests/story_batch123.gd').read_text().split('\n', 1)[1]
    cases.append(('story_batch123', fixture+'\n'+body, 'STORYBATCH123'))
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
    body = (ROOT/'tests/enemies84.gd').read_text().split('\n', 1)[1]
    cases.append(('enemies', fixture+'\n'+body, 'ENEMIES84'))
    body = (ROOT/'tests/dev_testing85.gd').read_text().split('\n', 1)[1]
    cases.append(('dev_testing', fixture+'\n'+body, 'DEV_TESTING85'))
    body = (ROOT/'tests/hearthknot128.gd').read_text().split('\n', 1)[1]
    cases.append(('hearthknot128', fixture+'\n'+body, 'HEARTHKNOT128'))
    body = (ROOT/'tests/architecture86.gd').read_text().split('\n', 1)[1]
    cases.append(('architecture', fixture+'\n'+body, 'ARCHITECTURE86'))
    body = (ROOT/'tests/architecture87.gd').read_text().split('\n', 1)[1]
    cases.append(('architecture_style', fixture+'\n'+body, 'ARCHITECTURE87'))
    body = (ROOT/'tests/combat88.gd').read_text().split('\n', 1)[1]
    cases.append(('combat_art', fixture+'\n'+body, 'COMBAT88'))
    body = (ROOT/'tests/energy90.gd').read_text().split('\n', 1)[1]
    cases.append(('energy', fixture+'\n'+body, 'ENERGY90'))
    body = (ROOT/'tests/traditions126.gd').read_text().split('\n', 1)[1]
    cases.append(('traditions126', fixture+'\n'+body, 'TRADITIONS126'))
    body = (ROOT/'tests/calendar91.gd').read_text().split('\n', 1)[1]
    cases.append(('calendar', fixture+'\n'+body, 'CALENDAR91'))
    body = (ROOT/'tests/menu92.gd').read_text().split('\n', 1)[1]
    cases.append(('menu92', fixture+'\n'+body, 'MENU92'))
    body = (ROOT/'tests/menu_quality100.gd').read_text().split('\n', 1)[1]
    cases.append(('menu_quality100', fixture+'\n'+body, 'MENUQUALITY100'))
    body = (ROOT/'tests/equipment93.gd').read_text().split('\n', 1)[1]
    cases.append(('equipment93', fixture+'\n'+body, 'EQUIPMENT93'))
    body = (ROOT/'tests/navigation94.gd').read_text().split('\n', 1)[1]
    cases.append(('navigation94', fixture+'\n'+body, 'NAVIGATION94'))
    body = (ROOT/'tests/mouselook95.gd').read_text().split('\n', 1)[1]
    cases.append(('mouselook95', fixture+'\n'+body, 'MOUSELOOK95'))
    body = (ROOT/'tests/bench96.gd').read_text().split('\n', 1)[1]
    cases.append(('bench96', fixture+'\n'+body, 'BENCH96'))
    body = (ROOT/'tests/expedition97.gd').read_text().split('\n', 1)[1]
    cases.append(('expedition97', fixture+'\n'+body, 'EXPEDITION97'))
    body = (ROOT/'tests/workplace98.gd').read_text().split('\n', 1)[1]
    cases.append(('workplace98', fixture+'\n'+body, 'WORKPLACE98'))
    body = (ROOT/'tests/firstvisit99.gd').read_text().split('\n', 1)[1]
    cases.append(('firstvisit99', fixture+'\n'+body, 'FIRSTVISIT99'))
    body = (ROOT/'tests/lodge100.gd').read_text().split('\n', 1)[1]
    cases.append(('lodge100', fixture+'\n'+body, 'LODGE100'))
    body = (ROOT/'tests/mountain104.gd').read_text().split('\n', 1)[1]
    cases.append(('mountain104', fixture+'\n'+body, 'MOUNTAIN104'))
    body = (ROOT/'tests/frontier103.gd').read_text().split('\n', 1)[1]
    cases.append(('frontier103', fixture+'\n'+body, 'FRONTIER103'))
    body = (ROOT/'tests/greatclaim102.gd').read_text().split('\n', 1)[1]
    cases.append(('greatclaim102', fixture+'\n'+body, 'GREATCLAIM102'))
    body = (ROOT/'tests/ridge124.gd').read_text().split('\n', 1)[1]
    cases.append(('ridge124', fixture+'\n'+body, 'RIDGE124'))
    body = (ROOT/'tests/courtship101.gd').read_text().split('\n', 1)[1]
    cases.append(('courtship101', fixture+'\n'+body, 'COURTSHIP101'))
    body = (ROOT/'tests/claim127.gd').read_text().split('\n', 1)[1]
    cases.append(('claim127', fixture+'\n'+body, 'CLAIM127'))
    return cases


def select_cases(cases, selected=None, shard_index=0, shard_count=1):
    if shard_count < 1 or not 0 <= shard_index < shard_count:
        raise ValueError('Shard index must be in [0, shard_count)')
    if selected and shard_count != 1:
        raise ValueError('Focused --case checks cannot be combined with release shards')
    names = [case[0] for case in cases]
    if len(set(names)) != len(names):
        raise ValueError('Duplicate case names in exported suite')
    if selected:
        unknown = set(selected) - set(names)
        if unknown:
            raise ValueError('Unknown pack case: ' + ', '.join(sorted(unknown)))
        cases = [case for case in cases if case[0] in selected]
    shard = cases[shard_index::shard_count]
    if not shard:
        raise ValueError('Empty release shard')
    return shard


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--godot')
    p.add_argument('--pack', type=Path)
    p.add_argument('--output', type=Path)
    p.add_argument('--case', action='append', dest='selected_cases', help='Focused verification only; cannot satisfy the full release gate')
    p.add_argument('--shard-index', type=int, default=0)
    p.add_argument('--shard-count', type=int, default=1)
    p.add_argument('--source-sha', default=os.environ.get('GITHUB_SHA', 'local'))
    p.add_argument('--list-cases', action='store_true')
    p.add_argument('--list-output', type=Path, help='Write the full case list to this new file')
    a = p.parse_args()
    all_cases = load_cases()
    try:
        cases = select_cases(all_cases, a.selected_cases, a.shard_index, a.shard_count)
    except ValueError as exc:
        p.error(str(exc))
    if a.list_cases:
        listing=json.dumps([name for name, _, _ in cases])
        if a.list_output:
            with a.list_output.open('x') as stream: stream.write(listing+'\n')
            emit('Case list saved; count:',len(cases))
        elif len(listing.encode()) > 2000:
            p.error('Case list exceeds console budget; provide --list-output')
        else: emit(listing)
        return
    if not all((a.godot, a.pack, a.output)):
        p.error('--godot, --pack and --output are required for execution')
    output = a.output.resolve(); output.mkdir(parents=True, exist_ok=False)
    engine = str(Path(a.godot).resolve()); pack = str(a.pack.resolve())
    with open(pack, 'rb') as stream:
        pack_sha = hashlib.file_digest(stream, 'sha256').hexdigest()
    results = []
    report = dict(schema=1, source_sha=a.source_sha, pack_sha256=pack_sha,
                  shard_index=a.shard_index, shard_count=a.shard_count,
                  focused=bool(a.selected_cases), expected_cases=[x[0] for x in all_cases],
                  assigned_cases=[x[0] for x in cases], results=results, complete=False)
    def record():
        (output/'results.json').write_text(json.dumps(results, indent=2))
        (output/'report.json').write_text(json.dumps(report, indent=2))
    record()
    for name, script, marker in cases:
        capture = output/name; capture.mkdir()
        started = time.monotonic()
        with tempfile.TemporaryDirectory(prefix='stellar-pack-') as temp:
            directory = Path(temp); harness = directory/'check.gd'; harness.write_text(script)
            env = os.environ.copy(); env.update(XDG_DATA_HOME=str(directory/'save'), APPDATA=str(directory/'save'), LOCALAPPDATA=str(directory/'save'))
            try:
                proc = subprocess.run([engine, '--path', temp, '--main-pack', pack, '--audio-driver', 'Dummy',
                                       '--rendering-method', 'gl_compatibility', '--script', str(harness), '--', str(capture)],
                                      cwd=temp, env=env, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=360)
                log, code = proc.stdout, proc.returncode
            except subprocess.TimeoutExpired as exc:
                raw = exc.stdout or ''
                log = (raw.decode(errors='replace') if isinstance(raw, bytes) else raw) + '\nERROR: Test timed out after 360 seconds\n'
                code = -1
        (output/(name+'.log')).write_text(log)
        match = re.search(re.escape(marker)+r': (\d+) passed / 0 failed', log)
        errors, error_count = error_summary(log)
        ok = code == 0 and bool(match) and not errors
        results.append(dict(test=name, passed=ok, checks=int(match[1]) if match else 0, errors=errors, error_count=error_count,
                            exit_code=code, seconds=round(time.monotonic()-started, 2)))
        record()
        emit(name, 'PASS' if ok else 'FAIL', flush=True)
        if not ok:
            emit('Failure details saved in per-case log; errors:', error_count); raise SystemExit(1)
    report['complete'] = True
    record()


if __name__ == '__main__': main()
