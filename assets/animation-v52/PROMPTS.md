# Drawn locomotion and hauling provenance — 0.52
Original artwork generated with the built-in image-generation tool using the game's existing Dwarf body atlases as references. Original PNG bytes are retained. The descriptions below summarize generation direction; they are not verbatim tool prompts.

| Retained asset | Generated source | Direction and use |
|---|---|---|
| male-walk.png | exec-9ec573a3-11ca-4a68-9fdf-0e59644c766c.png | Eight matching headless male walking bodies, side and rear diagonal. Ink contours, painterly cartoon shading, teal tunic, navy trousers, leather boots and pack. Upper-body keys retained. |
| female-walk.png | exec-1dcb3277-ef50-4d61-88a7-6a4947b695d4.png | Corresponding female side and rear-diagonal bodies, same costume, palette and scale. Upper-body keys retained. |
| male-carry.png | exec-dbff51fc-faec-446a-97b3-ccf5d81da9e8.png | Twenty supported cargo stances: rock, log, two rocks, two logs, mixed pair; front, side, rear diagonal, back. Corrected rear single carry hides the chest-held load behind the torso. |
| female-carry.png | exec-6305049f-9b13-4ade-81ec-6987ac1d550b.png | Corresponding female hauling bodies. Last rear mixed-load cell was rejected; renderer uses the equivalent clothed male rear torso with the correct female head. |
| legs.png | exec-21be9731-2d76-4e95-81ad-0c4c16a7ac42.png | Eighteen drawn hips-to-feet contact/pass/recovery keys, front/profile/back. Distinct guide colors identify opposite legs during authoring; runtime converts these to the shared navy palette. |

Several initial generations repeated the same leading boot and were rejected. The shipped runtime pairs registered drawn torso/arm keys with drawn lower-body keys instead of rotating limb fragments. No generated source is presented as a fully usable animation without review. `bounds.json` records measured alpha regions and manually separated touching cells. Registration/palm constants live in `drawn_locomotion.gd`.

Runtime palette normalization keeps the saved costume and skin; existing directional head masks keep each player's identity. The underlying .51 work/idle assets and original legacy paths are preserved. Review charts, actual gameplay captures and a native gait clip are in docs/testing/animation-0.52.0.
