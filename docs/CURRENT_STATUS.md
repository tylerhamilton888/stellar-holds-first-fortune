# Current status
Updated 2026-10-18 UTC. Build **0.41.0**, checkpoint **deepworks-0.41.0**.

## Current playable milestone
Deepworks replaces the active side-view mine in the existing game. Both employer and claimed mines use independent deterministic worlds: five 80×64 geological layers, 40-unit cells, connected mineral seams, rock bands, natural caverns, crystal chambers, ruined survey works and two rare deep discoveries. Existing settlement/basin routes enter it directly.

WASD / arrows move in eight directions without gravity. Hold LMB to excavate with pick/shovel; ordinary rock clears on one contact, iron/crystal resist, basalt needs steel. Material-specific original sounds, dust/debris, damage cracks and immediate inventory rewards are integrated. Original Dwarf art, grip overlays and stone textures are reused; new worksite/landmark details are code-authored.

V / F1 opens the mine board. Carve stairs while stationary for 1.2 seconds; E descends and Shift+E ascends at the same XY. All five depths can be connected. X / Tab / K previews the layer below. Work lamps cost timber/coal and persist. T assigns miners/automaton to the current depth; they physically walk excavated tunnels and connected stairs, respecting supplies and mineral priorities. M retains recruitment/industry. Slagcaster uses existing energy cells and slag recipes.

## Preserved systems
Pinewood 0.40.0 and its art/mechanics are unchanged. Settlement, characters, quests, inventory, economy, crafting, research, recruitment, industrial upgrades and save slots remain integrated. Legacy Geology, construction, and related tests remain in source for compatibility and recovery; active excavation now uses Deepworks.

## Save compatibility
Schema remains 1 with additive `deepworks[site]`: layers/cells/damage/seen/features/fixtures, links, depth/position, crew locations and assignments. Inventory rewards use the existing save inventory. Loading a legacy save first makes a uniquely named, byte-exact `.pre-deepworks-<time>.bak` beside it; loading aborts if backup fails. Legacy cells, structures, ladders and site snapshots remain archived in saves. **Old tunnel shapes and structures are not transplanted into the new perspective.** Their original save is recoverable in 0.40.0; new geology begins deterministically at the entrance. No prior project backup is overwritten.

## Verification
Godot 4.4.1 Linux: Deepworks flow/model checks, rendered mouse/key/button gameplay checks, Pinewood 53 checks, campaign 43 checks, and the prior smoke suite pass. Full results and limitations: `docs/testing/deepworks-0.41.0.md`. Native captures cover entrance, pick impact, excavation, lower-layer survey, geode, ruins, build board, Pinewood and both sexes at four tool-contact directions. PCK export and boot are release gates. Windows package includes the established 4.4.1 engine and launcher.

## Boundaries / next work
This is an integrated playable first Deepworks milestone, not the completed industrial-mine vision. Dedicated ramps/hoists, streaming beyond five layers, richer fluid simulation and new eight-facing character drawings remain future. Legacy mine-specific combat/hostile salvage is not ported into Deepworks; surface/training equipment systems remain. Older sample/sift mechanics are superseded inside Deepworks by below-layer surveying. Old constructed routes remain archived rather than recreated as working top-down structures. Those are explicit compatibility boundaries, not completed migrations.

Windows execution, a real user's historical save and speaker listening remain unverified. Existing ObjectDB/resource-in-use shutdown warnings remain. Do not label this exhaustive gameplay certification. Next: Windows player acceptance for aiming/feel, old-save recovery, long crew sessions and mineral-yield balance. Broader space/family/worldforging features remain future as before.
