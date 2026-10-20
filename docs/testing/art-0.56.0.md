# Folk and furnishing repair — 0.56.0
2026-10-19 UTC. Baseline `landmarks-0.55.1`; checkpoint `art-0.56.0`.

## Repairs and visual decisions
Recovered and inspected the October 19 user concept. Reproduced the beard-bottom collar anchor, undersized/disconnected heads, face-shadow hair recoloring, idle/walk hand swap and mug foreground clipping. Corrected registration and palette masks, preserving identities and existing drawn work poses. Newly generated front/rear and side lower-body keys provide actual contact/passing silhouettes. Two full-body candidate sheets were rejected for repeated contacts and clothing drift. Boots were widened/darkened to match existing standing/work material; fingers cropped by the torso boundary were restored. These are registered drawn layers, not a claim that every full animation was redrawn from scratch.

New transparent furniture sprites share construction recipes, footprints, previews and occupancy through `HoldFurnishings`. Town and player items use the same source. Cups/kettles are small separate props. Fixed a real blocked bartender approach by moving the table row, kept the counter solid and allowed conversation across it. Removed overlapping floating action labels; focused resident names. Pinewood remaining trunks use the shared log, smaller scale and depletion stages after the fall; rooted bark replaces a plain stump rectangle.

## Completed checks
| Suite | Passed | Scope |
|---|---:|---|
| integration56.gd | 76 | Four facings/four movement phases across 14 identities, attached heads, stable supporting hand, distinct planted/lifted side silhouettes; nine room approaches/exits and solid bases; three ward routes; nine buildable furnishings, overlap rejection, full bed occupancy, exact old-save copy, reload and refunds. |
| mining55.gd | 38 | Held work, visible damage stages, physical yields, processing/crafting, carts, mastery, geology, actual Z passage and persistence. |
| handworks55.gd | 32 | Carry/stockpile/breaker/saw/cart, house costs, Pinewood felling and raw logs, upgrades and persistence. |
| landmarks551.gd | 60 | Five-depth feature identity, collisions/reach, crew route, legacy correction, passage continuity and repeated reload. |
| external pack56.gd | 76 | Integration suite repeated independently against the final exported PCK. |

**282 completed checks passed.** Creator palette refresh and female normalization assertions also completed. The earlier integration attempt found a genuinely blocked tavern stance and an overlapping test construction fixture; both were corrected before the passing source/exported runs. Counts exclude incomplete attempts and do not imply all historical tests were rerun.

Native source and pack screenshots were visually inspected: enlarged/gameplay-scale head/body and footwork sheets, all seven identity variants, pick contact, complete drinking silhouettes, single/double cargo and pushing; creator portraits; tavern/home/forge/commission/throne; mine fracture/carry/station; Pinewood remaining-trunk stages. Evidence: `art-0.56.0/`. Regression scripts were copied with only capture output directories redirected to this release; their assertions were unchanged.

`motion56.gd` captured 180 native frames: male/female, both horizontal directions, empty and stone-loaded, actual movement/camera/hotbar. `Stellar-Holds-0.56.0-Walking.mp4` presents 12 seconds at 15 captured frames/s. This is a visual sampling clip, not an FPS benchmark. Individual contact/passing frames and the compiled file were checked; no motion interpolation is used.

Native environment: Linux Godot 4.4.1, Xvfb, Mesa llvmpipe, Dummy audio. Exported data was exercised with the Linux editor runtime, not Windows. Existing retained-resource warnings at shutdown remain (3–10 resources in affected harnesses), separate from completed gameplay checks. No gameplay/script errors in the completed passing runs. Windows execution, audible balance and performance on the user's machine remain unverified.

## Package and recovery
All 2,678 PCK entries passed checksum, bounds, relative-path and executable-extension audits. The Windows executable is byte-identical to the official Godot 4.4.1 template: `b493c1d53fb915f7805f360cfe42d1c3126e720dfc234a4b0f2feb99200f9a4b`. No batch launcher, installer or editor is shipped. ZIP member/CRC checks and independent Git restoration are recorded in the accompanying Verification/Recovery artifacts.

No fresh antivirus scan or Windows Defender verdict is claimed. The previous signature-download failure remains unresolved; do not inherit an earlier package's scan result.

Prior recovery tags/bundles and original assets remain. Old fortunes receive a byte-exact unique `.pre-art-560-*.bak` before loading. No terrain regeneration or non-mining progress reset. New catalogue bases retain old furniture anchors; unusually crowded old arrangements may require moving a decoration. Some rear/pushing directions share drawings, and old mine primitives/exterior ornaments, broader architectural/interior polish and industrial NPC jobs remain backlog. User visual acceptance is not implied by passing tests.
