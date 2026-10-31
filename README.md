# The Stellar Holds: The First Fortune

A Godot 4.4.1 game about Dwarven work, exploration and building a home beneath the mountain.

## Play

Download the complete Windows ZIP from [Releases](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases). Extract all files and run `FirstFortune.exe` beside `FirstFortune.pck`. GitHub's automatic source archives are developer files, not playable Windows builds.

## Develop

1. Clone this repository. `master` contains the complete editable game and original assets; open `project.godot` in Godot 4.4.1.
2. Install **Godot 4.4.1 stable**, the standard editor (not .NET), and Python 3.11 or newer.
3. Open `project.godot`. The editor imports assets; run `main.tscn` with F6 or the project with F5.
4. Read [AGENTS.md](AGENTS.md), [handoff](docs/SESSION_HANDOFF.md), and [development guide](docs/DEVELOPMENT.md).

Run current native acceptance checks, with a display available:

```sh
python tools/check.py --godot /path/to/godot --suite gameplay --output test-results/my-check
```

On Linux without a desktop, prefix with `xvfb-run -a`. Every test gets isolated saves. Use a new output directory each run. See [testing](docs/TESTING.md) for visual review and exported-build checks.

Build one Windows package:

```sh
python tools/build.py --godot /path/to/godot --windows-runtime /path/to/verified/FirstFortune.exe --output build/my-build
```

The runtime must be the unchanged official 4.4.1 template already shipped in 0.61.0. The tool checks its hash before packaging. Build output includes PCK integrity results, source identification and file hashes. Successful packaging does not replace gameplay or Windows playtesting.

## Current chapter

A Clearer Hold (0.88.0) cleans up the title, gameplay HUD and shared menus, including clearer settings and scrolling. [Download the complete Windows build](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.88.0). First visit offers a guided opening, while existing fortunes remain available. See [current status](docs/CURRENT_STATUS.md) and the [playtest guide](docs/PLAYTEST_GUIDE.md).

## Project map

- `scripts/`: runtime systems; `main.gd` coordinates the game.
- `assets/`, `audio/`: original artwork, metadata and sound, with stable resource paths.
- `tests/support/`: shared native-game fixture; `tests/suites.json`: current acceptance manifest.
- `tools/`: validation, packaging and asset-authoring utilities.
- `docs/`: current handoff, art direction, system notes and historical evidence.

Historical release notes are retained in [README history](docs/history/README-through-0.61.md). Original assets, UIDs and prior recovery history remain preserved.
