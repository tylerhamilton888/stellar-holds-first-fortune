# Current status
Updated 2026-10-18 UTC. Build **0.42.0**, checkpoint **weight-0.42.0**.

## The Weight of the Mountain
Integrated into the existing Deepworks, with its five persistent depths, same-location stairs, survey, discoveries, original Dwarf art and settlement routes. Pinewood, NPCs, inventories, recipes, trade, progression and crew systems remain in place.

Mining now has a 0.32-second anticipation/contact/follow-through cycle, a brief contact hold, material sounds, optional subtle shake, angular breakup fragments, dirt dust and crystal splinters. Ordinary stone still breaks in one contact. A broken face lightly fractures adjacent hard rock; neighbors cannot break or yield without being struck. Steel/basalt and slagcaster costs remain.

Newly mined stone, ores, coal and slag enter a **64-unit bucket**. Crystals stay in the existing pack. Build a **320-unit wheelbarrow** for 6 timber + 2 iron ingots: positioned equipment automatically loads nearby excavation, can be taken/parked, follows actual stairs while in hand and stays on its recorded depth when parked. Collision uses the handler's clear footprint, avoiding corner snagging. No weight slowdown. Overflow becomes persistent recoverable piles. Marked stockpiles stay put until loaded. Supplies have exactly one owner; delivery transfers into existing inventory, never duplicates it.

**H** haulage board; **C** take/park cart; **U** unload into entrance stores, a nearby cart, or a local stockpile; **Shift+U** load nearby piles; **L** project ledger. Returning by the entrance/map also delivers nearby cargo. The ledger tracks wheelbarrow, iron, steel research or drive assembly using existing requirements, shows delivered/field supplies and shortages, and spends nothing. Existing crews retain their provisioned direct delivery service and physical multilevel excavation.

Lean/banded/rich ore yields 1/2/4 units, with different visible mineral densities. Grade is derived from seed/XYZ and continues through depths. New worlds have an enlarged dipping iron lens connected to their existing seam. Loaded terrain is never regenerated; old deposits acquire deterministic grade without moving or replacing cells.

## Save compatibility
Schema 1 gains global `hauling` (bucket/project) and per-site `deepworks[site].haulage` (cart and piles). Existing inventory remains unrestricted stored stock; no retroactive weight conversion. All old terrain, depth, links, fixtures, discoveries and crew remain. The 0.41 legacy side-view migration still makes a byte-exact backup and archives old terrain/structures rather than transplanting them. A new-game/load now explicitly rebinds the mining controller to the loaded world.

## Verification and limits
Godot 4.4.1 Linux: hauling/conservation 34 checks; integrated Deepworks 45; native input/UI 15; Pinewood 53; campaign 43; all existing smoke suites pass. Rendered views cover anticipation, contact, breakup, filled containers, stockpile, unloading, ledger, lower-level cart and Pinewood. PCK export/boot and recovery verification are recorded in `testing/weight-0.42.0.md` and the release verification file.

This is a stable bucket/wheelbarrow milestone. Rails, elevators, powered freight and independently simulated hauling workers are future. One cart per site; all bulk units use equal capacity. Ledger reservations and recursive production planning are not implemented. Original side-facing Dwarf drawings remain; dedicated eight-facing art, ramps, deeper streaming, fluids and ported legacy mine combat remain future. Real-player acceptance for mining feel/balance, Windows execution, real historical player saves and speaker listening are still unverified. Known ObjectDB/resource-in-use teardown warnings remain.
