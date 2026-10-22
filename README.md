# The Stellar Holds: The First Fortune

A Godot 4.4.1 game about Dwarven work, exploration and building a home beneath the mountain.

## Play

Download the complete Windows ZIP from [Releases](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases). Extract all files and run `FirstFortune.exe` beside `FirstFortune.pck`. GitHub's automatic source archives are developer files, not playable Windows builds.

## Develop

1. Clone this repository. `main` contains the complete editable game and original assets; open `project.godot` in Godot 4.4.1.
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

Familiar Faces (0.67.1) corrects character artwork continuity, hair shading, walk registration and complete utility poses. Character creation previews walking, working and carrying with turn controls. [Download the complete Windows build](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.67.1). See [verification](docs/testing/appearance74.md). The worksite, first-shift, furnishing and loading improvements from 0.67.0 remain integrated.

Work & Knowledge (0.65.0) adds thirteen illustrated discipline tabs, twelve active paths, thirteen optional techniques and the eight established research methods. Press **Y** to browse. Brewing is reserved for its future production loop. Existing saves and earned abilities are preserved. Keldrath, the first-shift lesson and ancestral Overseer-to-Thane quest remain integrated. Read the [playtest guide](docs/PLAYTEST_GUIDE.md), [progression architecture](docs/PROGRESSION_NEXT.md) and [verification record](docs/testing/disciplines71.md).

## Project map

- `scripts/`: runtime systems; `main.gd` coordinates the game.
- `assets/`, `audio/`: original artwork, metadata and sound, with stable resource paths.
- `tests/support/`: shared native-game fixture; `tests/suites.json`: current acceptance manifest.
- `tools/`: validation, packaging and asset-authoring utilities.
- `docs/`: current handoff, art direction, system notes and historical evidence.

Historical release notes are retained in [README history](docs/history/README-through-0.61.md). Original assets, UIDs and prior recovery history remain preserved.
