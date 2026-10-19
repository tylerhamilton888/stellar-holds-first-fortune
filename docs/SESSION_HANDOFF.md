# Animation refinement — runnable, unreleased milestone

2026-10-19 · continue from **animation-refinement58**, following **palette-fix58** on `integrate/whole-0.58.0`. The requested whole-character overhaul is still unfinished. No new Windows package was produced or represented as ready.

The user asked to proceed, then spotted doubled axes/hammers/picks in a generated rear-view sheet. Those were generation errors, not intended equipment. The duplicated-tool sheets were rejected and are not referenced by the game. Several carry redraws also failed proportional or footfall continuity and were rejected. Do not revive them as completed animation work.

## Integrated repairs

`assets/whole-v58/refinements.json` selects **42 complete keys**: twelve male-4 rear equipped keys, six male-5 rear keys, eight bun/bob axe keys, one bob spade key, eight complete bob rifle keys, and seven female reeling keys reusing their own raised-rod drawings. Original painted PNGs remain unchanged. The new selected paintings and exact built-in imagegen prompts/rejection decisions are in `refinements-production.json`.

The metadata extractor now supports explicit selective correction layouts. On three reviewed sheets it preserves isolated complete silhouettes and searches real row/column gutters for touching figures. This repairs tool clipping/neighbor fragments caused by fixed column cuts. A watershed experiment failed native review and was removed. The renderer still draws one complete figure; no independent head or limb assembly was added.

Rifle muzzle and fishing-line attachment coordinates now come from the actual drawn rightmost tool contour. The fishing line uses the same .85 scale as the surface actor. The prior source-purple correction is unchanged.

## What is not finished

Full visual release gate remains failed. Carry shoulders and mixed/double loads still need correction; the rejected carry trials did not solve this. Two-key equipped gaits still lack good passing poses. Male-4 corrected equipped rear hair is cropped, but older rear-quarter/idle/work art still has extra plaits. Male-3 topknot, loose-wave axe hair, some work-facing transitions and other identity drift remain. The bob rifle feet are complete; its gait is not newly certified. Material parity, tray occlusion, tattoos, lift-log and full directional work contacts remain. See `art/whole-integration-58.md`.

Do not treat this milestone or the last .57 Windows package as the finished repair. The source title remains development. Preserve all fourteen identities, saved palettes, progression and original assets.

## Validation and recovery

Read `testing/refinement58.md` for final native results and limits. Focused controls cover rear tool movement, load ownership, actual fishing/reeling and save/reload. Native review includes work, rifle boots, all male-4 equipment keys, tool sockets, gameplay captures and a short pose-motion sequence. Existing broad mining/Pinewood/combat results are historical, not rerun claims.

Pre-edit tag **pre-motion-refinement58** preserves `ec53abe1684aeb56dcc3d63c68923facd756f6ce` (palette-fix58), tree `cf129e8664e6cb481946eb24364bef228225865a`. Its recovery bundle was verified before edits. New incremental recovery follows palette-fix58; the companion Recovery.txt records exact commit/tree/hash and independent restore verification. Retain the .51 full baseline, release increments through .57, whole-figure-study-58, whole-integration-wip-58 and palette-fix58. No remote changed or pushed.

Use isolated saves and strictly sequential native displays. Wait for each runner's completion marker before starting another. `grips58.gd` and `palette_audit58.gd` now accept an output directory argument so previous evidence is preserved.
