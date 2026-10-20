# 0.61.0 — Life in the Hold

2026-10-20 UTC. Focused follow-up to the user-approved 0.60.0 characters/portraits. Source recovery tag: `ambient-0.61.0`; pre-edit checkpoint: `pre-ambient61` at `19e2795c1e4170ac118485c58e0f6be9e4163820`.

- Opening escort now waits for character preparation, including Ivar's scene-only walking frames. Inside transitions also prepare him. Both actors use whole painted frames; no separate heads or rotating limbs were introduced.
- Town walking uses distance-based cadence appropriate to the residents' shorter, slower stride, holding direction through pauses. The royal audience now ties its gait to actual travel rather than wall-clock time.
- Painted hearth fire moves within its aperture, with soft light and restrained embers. The masonry and iron guard stay fixed. Town and player-crafted hearths share this renderer, recipe and collision footprint.
- Fountains have moving highlights down both spouts and small elliptical ripples inside the basin. Removed the oversized paving circle; basin collision and navigable streets remain.
- Orla and Hedrik are both Copperkettle. The existing canonical cast accessor updates older saved Orla names while preserving cast ID, appearance, relationships and progress.

The road-to-Keldrath prologue remains an illustrated sequence. This pass repairs animated in-world escort/audience playback; it does not turn every story plate or stationary dialogue pose into a new animation.

Validation: 87 passing checks this pass: intro53 (20), ambient61 (36), grips58 (20), exact exported pack (11). Native captures reviewed for fire/water alignment, walking keys, interiors, escort and married-name dialogue. All 3,128 PCK entries passed hash/bounds/path verification. Linux Godot 4.4.1, software OpenGL and Dummy audio; Windows execution, audible balance and player-device performance still require playtesting. No new antivirus verdict is claimed.

No save schema/location, inventory rules, terrain generation, mining balance, Pinewood, quest rewards or automation logic changed. No character raster art changed. Existing broader art/transport/combat backlog remains separate.

Download the one complete Windows ZIP from the private GitHub release. Extract all files into a new folder and run `FirstFortune.exe` beside `FirstFortune.pck`. The executable remains the verified unmodified official Godot 4.4.1 runtime. Older releases and recovery bundles remain intact.

Continue from this source checkpoint, not GitHub's delivery-only main branch. Read `testing/ambient61.md` and `PROJECT_INDEX.md`, then task-relevant files. The connected private repository `tylerhamilton888/stellar-holds-first-fortune` hosts build releases and delivery documents; its tag history is distinct from source recovery tags. A full editable source migration into its main branch has not been performed.

Key files: `scripts/arrival_escort.gd`, `opening_scene.gd`, `whole_frames.gd`, `world_zones.gd`, `ambient_props.gd`, `furnishings.gd`, `appearance.gd`. Preserve original raster sources. Fire animation caches 24 small meshes and moves only fire UVs; no per-frame image processing or new scene nodes. Water effects are drawn in the fountain's existing depth-sorted draw call and respect its occlusion fade. All effects use the simulation clock, including pause/focus behavior.

Tests: `intro53.gd` now uses the current prewarming-aware fixture and accepts an output path instead of overwriting historical evidence. `ambient61.gd` tests all three wards, old names, rendered props, actual construction/reload and escort gating. `pack_ambient61.gd` is self-contained for running against the exact exported PCK from an empty directory. Require explicit completion marker AND runner exit; use isolated save directories and sequential native displays.

Recovery: the complete .51 baseline and every increment through .60 delivery were verified and restored before edits; `git fsck --full` passed and the source tree matched `6212fae0f64452b470acc6b935c0c6ab5a463d60`. Apply `Stellar-Holds-0.61.0-Recovery.bundle` after the exact .60 delivery commit above; consult the companion Recovery.txt for the new commit/tree/hash and independent restore result. Keep all older backups.
