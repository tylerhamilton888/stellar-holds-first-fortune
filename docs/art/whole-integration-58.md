# Whole-character integration — development checkpoint

2026-10-19. The user approved the complete-figure direction and requested its integration. This checkpoint activates that renderer in the existing game. It is **not a visually accepted release** and must not be packaged as a finished .58 build.

Every current HoldFolk paint call now selects a complete painted figure, including its head, body, feet and gripping hands. Surface, Deepworks, ordinary NPCs, work and character portraits share the backend. There is no active separate-head assembly fallback. The previous implementation and original images remain available for recovery. The seated Lord retains his existing dedicated throne artwork; it has not been redrawn in this pass.

## Source and registration

`assets/whole-v58` contains seven male and seven female identities, each with core, utility, handling and equipped sheets, plus correction sheets. `production.json` preserves the exact generation/edit instructions. A supplied drawing is not automatically an accepted animation frame.

`tools/measure_whole_frames.py` measures alpha components and roots without modifying the original PNGs. `frames.json` records bounds, roots, per-sequence scale, neighboring-fragment exclusions and correction-source overrides. `extraction-review.json` names sheets whose touching drawings required segmentation. Native review caught clipped boots and stray neighboring fragments; wider seam search corrected the reviewed core crops. Do not assume every utility/handling/equipped crop is accepted merely because the metadata is valid.

Purple hair is a **reserved source pigment**, used to identify hair pixels for the saved character palette. The active renderer replaces it with the selected hair color. Native `hair-palette.png` shows oak, honey, copper and iron grey on complete figures. Skin recoloring is applied to painted material pixels, not a separate circular head layer. Cloth and jewelry colors are also retained; tattoo decoration is not yet implemented in this backend.

## Release blockers — observed, not hypothetical

| Area | Remaining correction |
|---|---|
| Carrying | Several front/back paired keys switch the load between shoulders. Some rear-quarter keys turn fully away. Double logs can read as one broad horizontal load; mixed loads also switch sides. Redraw complete keys with a stable carrying side. |
| Equipped movement | Two keys per facing lack sufficient passing poses. Some variants turn between keys. Male 4/5 second back keys show a face; female 4 rifle drawings reach the source bottom edge and lose boots. Male 3 loses its topknot in later rows. |
| Work identity | Female axe correction gives proper axes but changes hairstyles in some keys. Male 4 rear utility hair and several female bun poses also drift. Preserve each identity through the complete motion. |
| Work props | Female 4 utility frame 17 is a saw instead of a spade. Female utility fishing frame 27 shows harvesting contents. Some front-held tools differ from the corresponding working tool. |
| Material parity | Carried stones/logs are now painted into the supporting figure, but mineral markings and exact shared-ground/stockpile/station material appearance need reconciliation. Supply contents still need proper tray-rim occlusion and per-view placement. |
| Contact and special poses | Verify drawn tool contacts against actual mine faces, tree trunks and station tops. Calibrate rifle muzzle sockets per facing. Lift-log currently shares a carry drawing; tattoo options and some full directional work/push sequences are unfinished. Compare creator identity names with the new paintings before release. |

The native core silhouettes now have connected heads/bodies, matching skin and visible feet. This does not establish motion quality for all actions. Review complete sequences at gameplay scale and normal playback speed, then re-run affected real input/ownership checks. Fix individual complete-frame sequences; do not hide defects by mapping saved identities to a default or restoring the old composite rig.

No mining resistance, movement speed, terrain, material ownership, quest or save schema was changed in this integration. Existing mechanical successes do not override the visual blockers above.
