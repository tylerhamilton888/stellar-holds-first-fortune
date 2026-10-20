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
