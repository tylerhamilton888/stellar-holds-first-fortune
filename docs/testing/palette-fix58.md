# Hair palette correction verification

2026-10-19 · checkpoint `palette-fix58`, following `whole-integration-wip-58`. Focused active-renderer correction, not a new Windows release.

## Reproduced defect

The user was right: `whole-0.58.0/hair-palette.png` retained purple. The hue .67–.95 and saturation >.10 cutoffs excluded red-violet shadows and muted highlights. Resizing before recoloring also mixed the reserved source pigment into edges. The original delivered preview had 1,554 pixels with red and blue each more than 3/255 above green; visible connected patches remained in hair and its edges.

## Correction

`HoldWholeFrames.texture` recognizes the reserved pigment by its red/blue excess over green. It resolves mixed fringes softly, keeps natural hair blends from producing new mauve, and performs source palette conversion before resampling. Transparent pixels remain transparent; original PNGs, identity geometry, saved palette choices and mechanics are unchanged. Intentional purple clothing is converted independently and retained. No separate head/skin patch and no finished-preview paint-over were introduced.

## Executed checks

Godot 4.4.1, native software OpenGL display, isolated test data, Dummy audio. Logs and structured results are in `palette-fix58/`.

- `palette_audit58.gd`: **2,576 frame/color cases, 0 failed**, covering all **2,464 active frames** across fourteen identities and core/utility/handling/equipped families in iron grey, plus every saved hair choice on each front idle. Examined **45,466,893 visible source-resolution output pixels**. A failure is red and blue both >2/255 above green with alpha >=32/255 in a naturally colored, neutral-clothed figure.
- Protected materials: **103,482 control pixels** remained byte-identical when only hair changed. Heather and Night violet clothing still contain intentional purple. Controls include skin, clothing, leather and metal in both body types.
- `grips58.gd`: **18 passed / 0 failed** on the corrected renderer, including actual selection, walking, carry priority, material ownership, reload and prepared turn/selection textures.
- Native corrected palette, 112 identity/color front previews and four movement/work contact sheets captured. Inspected enlarged and gameplay-scale renders. Creator capture uses the corrected renderer and preserves live palette updates.

The corrected composite preview has no large missed-purple patches. Nine isolated low-chroma display pixels exceed the same >3/255 channel-difference metric after filtering/compositing, versus 1,554 before; the largest such connected component is one pixel. The full-resolution asset audit above is separate from these final display-interpolation measurements. Do not claim that every possible blended screen pixel is mathematically non-purple.

## Scope and limits

This corrects pigment coverage and filtering order. It does not establish acceptance of carry shoulders, hairstyle continuity, facing, source crops, tool contacts or other recorded animation defects. Those remain in `art/whole-integration-58.md`. No new Windows package, audio test or hardware benchmark is claimed. Earlier 98 gameplay checks belong to the previous integration checkpoint; 18 input checks were repeated for this fix. Original source art and earlier preview evidence remain for recovery/comparison.
