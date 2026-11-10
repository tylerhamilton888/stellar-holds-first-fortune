# The Stellar Holds: The First Fortune

A Godot 4.4.1 game about Dwarven work, exploration and building a home beneath the mountain.

## Play

Download the complete Windows ZIP from the [latest published release](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/latest). Choose the named **Stellar-Holds-First-Fortune-<version>-Windows.zip** asset; GitHub's automatic source archives are developer files, not playable builds.

Extract every file into a fresh folder. Run **FirstFortune.exe** beside **FirstFortune.pck**. Keep your previous build and saves; do not mix files from different releases. The [current status](docs/CURRENT_STATUS.md) records the verified published version and distinguishes it from newer source work.

Choose **New Game** and an empty fortune slot for the current opening, or **Load Game** to continue an existing fortune. Follow the [current playtest guide](docs/PLAYTEST_GUIDE.md).

## Current chapter

The First Fortune follows a new worker from Stonebridge's bunkhouse through a player-built home, ancestral rescue, the engineering contest, Keldrath's defense and a homecoming as Thane. The Hold's Ledger guides practical campaign milestones, Winter Stores and North Crossing restoration, with optional profession collections. Twelve characters offer friendship episodes. Three permanent mineworks support named districts and gated expansion. Marriage remains future work.

## Develop and release

Read [current status](docs/CURRENT_STATUS.md), [handoff](docs/SESSION_HANDOFF.md), then [AGENTS.md](AGENTS.md). Clone `master`, which contains the editable game and original assets. Use Godot **4.4.1 stable**, the standard editor, and Python 3.11 or newer. Open `project.godot`; the editor imports assets. F5 runs the project.

- [Development](docs/DEVELOPMENT.md): ownership and implementation conventions.
- [Testing](docs/TESTING.md) and [validation policy](docs/VALIDATION_POLICY.md): focused development checks and complete release gates.
- [Release procedure](docs/RELEASE_PIPELINE.md): requested publication, evidence, retries and documentation.
- [Backlog](docs/BACKLOG.md): current playtest priorities.

Use file-only command capture and new output directories as documented in AGENTS.md. A successful export alone is not release acceptance.

Original assets, UIDs and previous releases remain preserved. Earlier README instructions are in [history](docs/history/README-before-doc-consolidation-2026-11-10.md).
