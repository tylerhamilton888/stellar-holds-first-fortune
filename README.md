# The Stellar Holds: The First Fortune

A Godot 4.4.1 game about Dwarven work, exploration and building a home beneath the mountain.

## Play

Download the complete Windows ZIP from the [latest published release](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/latest). Choose the named **Stellar-Holds-First-Fortune-<version>-Windows.zip** asset; GitHub's automatic source archives are developer files, not playable builds.

Extract every file into a fresh folder. Run **FirstFortune.exe** beside **FirstFortune.pck**. Keep your previous build and saves; do not mix files from different releases. The [current status](docs/CURRENT_STATUS.md) records the verified published version and distinguishes it from newer source work.

Choose **New Game** and an empty fortune slot for the current opening, or **Load Game** to continue an existing fortune. Follow the [current playtest guide](docs/PLAYTEST_GUIDE.md).

## Current chapter

The First Fortune follows a new worker from Stonebridge's bunkhouse through a player-built home, ancestral rescue, the engineering contest, Keldrath's defense and a homecoming as Thane. The Hold's Ledger guides practical campaign milestones, Winter Stores and North Crossing restoration, with optional profession collections. Twelve characters offer friendship episodes. Three permanent mineworks support named districts and gated expansion. Marriage remains future work.

Surface room blueprints let you lay out connected rooms on your chartered holding, review shared construction costs, build within reach and furnish them to suit. Open the Building Book (**O**) and choose **Plan Your Holding**. Underground, the Living Works book adds saved chamber and corridor guides, excavation progress, reachable finishing and stair landing guides. Mine with normal tools, then furnish the cleared rooms. Cellar stair plans connect the ground-floor home to those existing claim-mine rooms. Clear both landings, fit the paid stairs, then use Shift+E to travel with carried supplies. Version 0.110.0 adds [upper-floor blueprints](docs/UPPER158.md), support/access warnings and saved stair guides. Recruited miners can now use household beds and walk between home and mine in 0.111.1; see [crew routes](docs/WORKERS160.md). Version 0.112.0 adds [physical freight routes](docs/FREIGHT162.md) between marked mine stockpiles and household chests, using the same crew and connected stairs. Version 0.113.0 introduces [Old Stonewright’s Rise](docs/RISE165.md), with provisional use after the first paid shift and permanent tenure after two contributions. See [underground notes](docs/EXCAVATION154.md) and [connected cellar notes](docs/CELLAR156.md).

## Develop and release

Read [current status](docs/CURRENT_STATUS.md), [handoff](docs/SESSION_HANDOFF.md), then [AGENTS.md](AGENTS.md). Clone `master`, which contains the editable game and original assets. Use Godot **4.4.1 stable**, the standard editor, and Python 3.11 or newer. Open `project.godot`; the editor imports assets. F5 runs the project.

- [Development](docs/DEVELOPMENT.md): ownership and implementation conventions.
- [Testing](docs/TESTING.md) and [validation policy](docs/VALIDATION_POLICY.md): focused development checks and complete release gates.
- [Release procedure](docs/RELEASE_PIPELINE.md): requested publication, evidence, retries and documentation.
- [Backlog](docs/BACKLOG.md): current playtest priorities.

Use file-only command capture and new output directories as documented in AGENTS.md. A successful export alone is not release acceptance.

Original assets, UIDs and previous releases remain preserved. Earlier README instructions are in [history](docs/history/README-before-doc-consolidation-2026-11-10.md).
