# Character rendering correction, 0.36

The 0.35 review GIF was rejected. Its poses did not produce a proper alternating walk. Its low-resolution bake and extra sprite-atlas pass enlarged sampling errors, and its material masks left warm source pigment while also misclassifying shaved skin and some equipment.

## Rendering

`tools/quality36/export.gd` extracts the existing authored designs at twice their previous runtime resolution. The `actors-v36` textures and `palette-v36` masks are immutable game assets. Portraits use 384px sources. The creator uses a 288px sprite viewport and 384px portrait viewport. Cached pose textures are drawn directly, without a second low-resolution atlas bake.

`tools/quality36/bake_walk.py` produces 16 complete frames for every normal/axe-shield design, 320 frames total, at 336px. The torso and integrated gear retain their authored poses. A continuous trouser mesh joins each hip to its painted boot cuff, and each knee-high boot keeps its shape. The resulting complete frame is drawn as one texture during gameplay. No leg pieces are cut or rotated during runtime rendering.

The two feet alternate a half-cycle apart. During stance, the foot retreats 40 world units while the player advances 40. The other boot clears the floor by six units. An 80-unit stride drives gameplay timing, with sounds at frames 0 and 8. Hand, shoulder, chest, neck and head sockets remain available, and handheld weapons repaint the actual fingers over their grips.

## Materials

The old low-resolution masks are only seed hints. Gold hair cores establish regions; shaded edges are admitted within a bounded neighborhood. Warm skin is independently preserved. A global warm-color flood is avoided because brown leather and hair shadows overlap in color. Independent eyebrow islands, enclosed crown highlights and long braid ends are included. Portraits also have explicit forehead, collar and buckle boundaries, because warm skin highlights and hair cannot always be distinguished by color. The results are saved as per-pixel material IDs, not inferred during play.

The player's 32 walking textures are colored and cached at fortune entry, before movement begins, to avoid first-step coloring hitches.

The final review uses actual game rendering, dark/pale palette sheets and video. Structural tests alone are not a visual approval gate. A few static frames cannot establish that a walk feels good, so the review includes continuous cycles against ground ticks and movement through Keldrath.

## Rebuild

Use Godot 4.4.1 to run `tools/quality36/export.gd`, then run `materials.py` and `bake_walk.py` with Python, Pillow, NumPy and SciPy. The source archive includes the original sheets and generated boot-paint reference. Import assets in Godot after rebuilding.
