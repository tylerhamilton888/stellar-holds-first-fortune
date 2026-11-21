# The Stellar Holds: The First Fortune

**Stonebridge · 0.125.0.** Stand for Thane, meet Skarrin and make Old Stonewright’s Rise your home. Open the project in Godot 4.4.1 and run the main scene for the campaign. Open the pack with **I** or the journal with **J**.

[Inventory](docs/stonebridge-menus/pack.jpg) · [Crafting recipes](docs/stonebridge-menus/recipes.jpg) · [Campaign and menu changes](docs/CURRENT_STATUS.md)

A Godot 4.4.1 game about Dwarven work, exploration and building a home beneath the mountain.

## Play

Download the complete Windows ZIP from the [latest published release](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/latest). Choose the named **Stellar-Holds-First-Fortune-<version>-Windows.zip** asset; GitHub's automatic source archives are developer files, not playable builds.

Extract every file into a fresh folder. Run **FirstFortune.exe** beside **FirstFortune.pck**. Keep your previous build and saves; do not mix files from different releases. The [current status](docs/CURRENT_STATUS.md) records the verified published version and distinguishes it from newer source work.

Choose **New Game** and an empty fortune slot for the current opening, or **Load Game** to continue an existing fortune. Follow the [current playtest guide](docs/PLAYTEST_GUIDE.md).

## Current chapter

Version 0.124.0 gives editable cottages coherent stone-and-slate architecture and explicit **E** entry into their actual connected rooms. Existing layouts, belongings, stairs and crew routes are preserved. See [cottage review](docs/COTTAGE189.md) and [verified delivery](docs/CURRENT_STATUS.md).

The First Fortune begins with a modest holding in Stonebridge, bought through your parents’ savings. Choose how to improve your cottage, find work and earn civic recognition, then follow ancestral rescue, the engineering contest, Keldrath’s defense and a homecoming as Thane. The Hold's Ledger guides practical campaign milestones, Winter Stores and North Crossing restoration, with optional profession collections. Twelve characters offer friendship episodes. Three permanent mineworks support named districts and gated expansion. Marriage remains future work.

Surface room blueprints let you lay out connected rooms on your chartered holding, review shared construction costs, build within reach and furnish them to suit. Open the Building Book (**O**) and choose **Plan Your Holding**. Underground, the Living Works book adds saved chamber and corridor guides, excavation progress, reachable finishing and stair landing guides. Mine with normal tools, then furnish the cleared rooms. Cellar stair plans connect the ground-floor home to those existing claim-mine rooms. Clear both landings, fit the paid stairs, then use Shift+E to travel with carried supplies. Version 0.110.0 adds [upper-floor blueprints](docs/UPPER158.md), support/access warnings and saved stair guides. Recruited miners can now use household beds and walk between home and mine in 0.111.1; see [crew routes](docs/WORKERS160.md). Version 0.112.0 adds [physical freight routes](docs/FREIGHT162.md) between marked mine stockpiles and household chests, using the same crew and connected stairs. Version 0.115.0 introduces [the family-purchased Rise](docs/HOME169.md), with an editable starter cottage, parent letter and optional first shift. Two civic contributions earn household recognition; the property is already yours. See [underground notes](docs/EXCAVATION154.md) and [connected cellar notes](docs/CELLAR156.md).

Version 0.114.0 adds [consistent building grids](docs/GRID167.md), live room dimensions and alignment guides. The [A Home and a Fortune roadmap](docs/HOME_AND_FORTUNE_ROADMAP.md) records the subsequent tool, crafting and progression work.

Version 0.116.0 adds [reinforced picks and basalt masonry](docs/TOOLS171.md): stronger contacts, careful block recovery, dressed basalt floors and advance planning with actual material/knowledge checks. Existing tools and excavations remain intact.

Version 0.117.0 adds [cross-profession tool components](docs/COMPONENTS173.md): make or buy a shaped haft, forged pickhead and fittings, then assemble a reinforced pick. Completed manufacturing credits the relevant profession; existing tools stay owned. The inventory now keeps character details visible while its item grid scrolls.

Version 0.123.0 improves [room visibility](docs/VISIBILITY185.md): opening rooms follow the player to reveal upper furnishings and exits, while tall foreground props fade when they hide your Dwarf. It includes Borin’s optional repair and the earlier discovery scenes. Check [current status](docs/CURRENT_STATUS.md) for verified Windows delivery.

Published version 0.121.0 adds [character introductions and quest scenes](docs/SCENES181.md): meet Rurik, Sigrid and Borin, then see short saved/skippable story beats for the forge, Winter Stores and rescue dispatch.

Version 0.120.0 adds [Rise presentation polish](docs/RISE179.md): a cottage approach, gentler arrival guidance, household-aware lodge greetings and two optional family letters. Civic registration no longer puts an unchosen ore lesson first in the journal.

Version 0.119.0 lets you supply the Cold Forge and Winter Stores through gathering, crafting or buying. Rescue readiness depends on civic recognition, a steel pick, safe underground preparation, stocked Winter Stores and three contributions; unrelated craft lessons and home renovation are optional. See [civic livelihoods](docs/LIVELIHOOD177.md).

Version 0.118.0 adds [Borin’s specialist commissions](docs/COMMISSIONS175.md): bring materials and pay his fee for a steel pick, reinforced assembly or individual components. His expertise provides a route without player research or friendship requirements; paid work grants no personal crafting experience.

## Develop and release

Read [current status](docs/CURRENT_STATUS.md), [handoff](docs/SESSION_HANDOFF.md), then [AGENTS.md](AGENTS.md). Clone `master`, which contains the editable game and original assets. Use Godot **4.4.1 stable**, the standard editor, and Python 3.11 or newer. Open `project.godot`; the editor imports assets. F5 runs the project.

- [Development](docs/DEVELOPMENT.md): ownership and implementation conventions.
- [Testing](docs/TESTING.md) and [validation policy](docs/VALIDATION_POLICY.md): focused development checks and complete release gates.
- [Release procedure](docs/RELEASE_PIPELINE.md): requested publication, evidence, retries and documentation.
- [Backlog](docs/BACKLOG.md): current playtest priorities.

Use file-only command capture and new output directories as documented in AGENTS.md. A successful export alone is not release acceptance.

Original assets, UIDs and previous releases remain preserved. Earlier README instructions are in [history](docs/history/README-before-doc-consolidation-2026-11-10.md).
