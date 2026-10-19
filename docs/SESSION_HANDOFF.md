# Folk quality — runnable, unreleased milestone

2026-10-19 · continue from **folk-quality58**, following **animation-refinement58** on `integrate/whole-0.58.0`. This implements the user's full-beard requirement and focused character repairs. The larger animation overhaul remains unfinished; no new Windows package is represented as ready.

## Integrated work

All seven male identities have full beards. The former moustache-only sculpt keeps its index, face, saved palette and other identity data, but is now “Grand moustache & beard.” Its chin/jaw remains covered through idle, movement, tools, work, drinking and hauling. The legacy clean-shaven enum remains for female/backward compatibility; male normalization never selects it.

Thirteen new complete-figure source PNGs supply **356 distinct active key substitutions**. `assets/whole-v58/refinements.json` is the exact selection; `quality-production58.json` records built-in imagegen briefs and decisions. Original PNGs and prior rear-tool repairs remain. All male axe sequences now show an actual axe throughout the stroke. Male3 equipped topknot, male4 cropped rear/nape and female2 loose-wave axe hair have targeted continuity repairs. Male2 handling extraction excludes an observed neighboring rifle fragment. A separate complete male5 raised-pick painting replaces a source key touching the next row; a bottom-only crop was insufficient and was discarded.

The renderer still paints one complete figure. No separate head, floating tool or new limb assembly. Reserved purple source pigment is replaced by the saved natural hair colour; always run the palette audit after new art. Mining balance, movement speed, material ownership, terrain, save schema and progression are unchanged.

## Validation

Read `testing/quality58.md` and `testing/quality58/` for final evidence. **97/97 focused native gameplay checks**: beard identity/creator/movement/reload 27, Pinewood/material handling/workstations 32, Deepworks mining/progression/stairs/reload 38. Native review covers selected full sheets, all male/female axe phases, enlarged male5 pick/axe/drink, colour variants, creator, Keldrath, tavern, throne and real work. Palette results are recorded separately in the verification report. Checks use Godot 4.4.1, isolated data, software OpenGL and Dummy audio.

## Remaining release gates

Carry shoulders, mixed/double cargo shape and side continuity remain. Equipped two-key gaits still need good passing poses. Broader material parity, tray occlusion, tattoos, lift-log and full directional work contacts remain. This beard repair preserves existing load poses; it does not certify their continuity. Other world/architecture quality, audio and hardware performance were not accepted by these tests. The last Windows package is still .57.0, with visuals rejected by the user. Do not call this a finished .58 release.

## Recovery and efficiency

Pre-edit tag **pre-quality-beards58** preserves `a610e73d0dc61a6a5c767a379708bc0f51d2b8ab` (animation-refinement58), tree `ff539e10d987ae80a3205d5b6bda91f1ea0781f1`. Its bundle was independently verified before editing. New recovery is `Stellar-Holds-Folk-Quality58.bundle`, incremental after animation-refinement58; the companion Recovery.txt records exact commit/tree/hash and independent restore verification. Preserve the .51 full baseline, increments through .57, whole-figure-study-58, whole-integration-wip-58, palette-fix58 and animation-refinement58. No remote changed or pushed.

Native displays must be strictly sequential: require runner completion AND explicit test marker before starting another. Use isolated saves. `handworks55.gd` and `mining55.gd` now accept output directory and male sculpt arguments; defaults preserve existing tests. Keep historical evidence separate from rerun claims. The source title remains development. Preserve all fourteen identities, palettes, original assets, UIDs and saves.
