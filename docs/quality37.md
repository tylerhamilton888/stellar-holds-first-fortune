# Character review, version 0.37.0

## Scope

Address disappearing braids, excessive stride width and portrait material boundaries. Current saves and gameplay systems are unchanged. Walking speed changed from 190 to 160 world units per second; stance travel changed from 80 to 64 world units per cycle. Acceleration, braking, collision and input buffering retain their prior implementation.

## Art pipeline

The offline walk baker uses one neutral head and its complete braids per design and equipment state. Moving arm poses are composited in front where appropriate. Each result is a complete 336-pixel frame. The game draws those frames, without assembling head or leg pieces during walking. Sixteen poses for ten designs in two equipment states give 320 frames.

Portrait material channels are continuous coverage values at 512 pixels, with a separate garment silhouette and complete exposed-scalp coverage. Coverage is stored as raw RGBA bytes, not an alpha-bearing texture import. Runtime recoloring blends each material from the original pixel, preserving painted shading and original alpha.

Rebuild scripts are in `tools/quality37`. Python dependencies are in its `requirements.txt`. The walk baker uses the original source export and metadata produced by the quality36 export script. The source archive excludes reproducible raw exports and Godot import caches.

## Verification

- Source project rendered under Godot 4.4.1, Mesa software OpenGL, Linux.
- Full sixteen-frame female and male walking cycles reviewed at gameplay scale and 2x, plus all ten normal and axe/shield variants.
- Four portrait palettes per design reviewed: flaxen, raven, snow and raven with changed complexion/clothing.
- Character checks cover continuous material coverage, non-overlapping channels, protected skin/fittings/background, exposed scalp, consistent head source, sole baseline, hand anchors and stance travel.
- Controller checks cover acceleration, reversal, collision and jump behavior.
- The MP4 uses scripted poses in the actual game renderer. It is visual evidence, not a Windows playtest or a claim that every gameplay situation was exercised.
- Exported pack is separately loaded to check all walk assets, portrait textures, startup and the warmed player cycle.

The bundled Windows runtime cannot be executed in this Linux environment.
