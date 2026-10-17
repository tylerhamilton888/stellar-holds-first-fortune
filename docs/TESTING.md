# Focused validation
Run from a recovered checkout with Python 3 and Godot 4.4.1:
```sh
python3 tools/smoke.py --godot /absolute/path/to/godot
```
Windows also accepts the executable path. The runner imports resources, boots the title, then runs existing targeted tests and a small integration smoke. It isolates user data through XDG_DATA_HOME/APPDATA/LOCALAPPDATA; never run save-writing tests against live player saves. Logs/results go to ignored `test-results/`. Use `--skip-import` only after a successful current import.

Coverage: title/new-game initialization; synthetic three-slot save/reload and replacement isolation; terrain/cuts/collection; controller movement; opening dialogue progression; smelting/trade; crew recruitment/assignment/physical work; industry/progression; survey/sift and downward cutting. Headless tests do not establish visual quality, audio mixing or Windows launcher behavior. Known teardown resource warnings are recorded separately; other Godot errors fail the runner. A timeout also fails.

For a single task, run the smallest relevant test under isolated user data. Historical capture scripts may contain old absolute output paths; inspect before using them. `down43.gd`, `survey42.gd`, `review40.gd` and `interiors41.gd` are recent visual harnesses, not portable smoke entry points.

Manual release checks: launch Windows batch; new game and Continue; copy/load a real prior save; move/jump/climb; cut above/below/beside; collect and craft/sell; check crew work and return route; inspect relevant menus/animation/contact and audio. Record build, platform, fixture and result. Do not label an unrun check passed.

Export from the project root:
```sh
godot --headless --path . --export-pack 'Windows Desktop' /absolute/output/FirstFortune.pck
```
Use a separate staging directory with the established Windows Godot executable and launcher. Match engine 4.4.1; retain notices. Test the exported PCK and ZIP integrity. This infrastructure-only task does not require a new gameplay binary.

## Pinewood (0.40.0)
Run `--headless --path . --script res://tests/test_forestry40.gd` with isolated user data. It covers migration, all character designs/facings, invalid reach/tool/airborne contact, exact rewards, exhausted-target rejection, save/reload and basin round trip. `tests/capture_forestry40.gd -- --output=/absolute/review-directory` requires a graphics display and writes native captures. Use `--audio-driver Dummy` in a display-only CI environment. Keep existing test data isolated.

`test_campaign.gd` now aims at the actual tree instead of the superseded x=275 fixture. `test_expedition25.gd` retains two obsolete continuous-travel expectations; see the release verification note. Do not re-enable manual mine/hold walking just to satisfy them.
