# Living terraces 67 — verification

Native Godot 4.4.1, 1280×720 Linux llvmpipe rendering, isolated saves. Final local suite is in progress; the first three final cases passed 48 living + 81 household + 35 continuity checks. Final results will be recorded before publication.

Coverage: physical routes sampled at 5-unit spacing for all nine residents; both Great Stairs in both directions; camera continuity; loaded cart ownership and cargo; no preparation at continuous seams; actual player movement from quarters across the gallery to Borin; expanded forge door; same resident across rooms and reload; crafted pillar collision and persistence. Final native work-contact sequence and pillar/stair captures were visually inspected.

Earlier failing runs were retained outside the repository. Repairs include stair endpoint caps, a blocked nearest navigation node, an art-class name collision (the original Deepworks masonry module was restored unchanged), and two fixture problems: entering home from the wrong return ward and sending skipped-intro inputs before the loader finished. Forge benches were reduced to working height and workers aligned to the painted hammer's contact position. Retaining walls now cull independently of the offscreen stair.

Architecture limits: three continuous projected terrace plates, distinct building interiors, nine scheduled households; public rovers and quest hosts remain on their previous logic. Only the forge receives a larger plan. No new economic production, arbitrary 3D occlusion or Windows execution is claimed. Preserved player art, mining, timber, economy and save schema.

Recovery: pre-living-hold67 tag and verified incremental bundle retain local 1401303d8bfd0bda6ccd4e8a30244580aae49f3a. Remote base 7fa8479904295103d16d1aedbbe8121419f45587 remains in normal Git history. Original masonry PNG SHA-256 3f8208b3bd7bb588f20676e53d6f180bf3705f86398afa7427d9d5fcca9a8cd8. Large direct uploads failed; a separate transfer branch reassembles only hash-verified artwork. No previous release or backup is replaced.
