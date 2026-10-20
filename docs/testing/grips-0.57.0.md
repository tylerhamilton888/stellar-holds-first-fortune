# 0.57.0 — Grip and proportion verification
2026-10-19 UTC. Linux Godot 4.4.1, native graphical viewport under Xvfb, Mesa llvmpipe and Dummy audio. Isolated save directories. No player saves used. Tests require explicit completion markers, not merely script parsing or exit zero.

| Suite | Completed assertions | Coverage |
|---|---:|---|
| grips57.gd | 18 | Real number keys while moving; all four tools; actual/empty supply; lift/put-down priority; exact inventory/ground-load reload; rifle; prepared facings |
| integration56.gd | 76 | 14 identity variants, head attachment, four foot keys, nine rooms, three wards, doors/services, furnishing footprints/placement/refunds and saves |
| mining55.gd | 38 | Deliberate held excavation, interruption/reach, physical ore, stations/carts, mastery, formations, real Z passages and persistence |
| handworks55.gd | 32 | Stone/timber, shoulder ownership, racks, breaker, saw, carts, crafting cost, felling and saved loads |
| combat_edges53.gd | 10 | Guard, mail, dodge, parry cooldown, ammunition/wall blocking, hammer stun and pause |
| pack57.gd against final exported PCK | 18 | Independent self-contained repetition of the new interaction/save checks |
| **Total** | **192** | All completed assertions passed |

An initial combat run used the .53 fixture, which did not wait for the later sprite preparation gate; one input assertion failed before play was ready. The fixture now waits for preparation, matching current gameplay, and its original assertions all pass. Combat gameplay was not modified to hide this. Test output is retained under `grips-0.57.0/logs`.

## Native visual review
`grips-0.png` through `grips-3.png` cover both bodies, all six equipped states, four facings, rest/walk and enlarged/gameplay sizes. World captures show real selected supplies in the tray. Tools and hands are in the same drawn body, not independent icons. Review found and corrected a female collar strip over the mouth, stale boot pixels beneath the upper crop, a stray rear-hair fragment and the old clipped raised-tool strip across the face/beard. Raised work tools now pass behind the head.

`poses/` records ordinary footwork, pick/drinking phases, one/two shoulder loads, pushing, hammer work, identity variants, interiors and fallen timber. Mining and handworks captures record actual contact, rock damage, raw/processed materials and Pinewood. `combat/` includes real rifle/hammer/telegraph states. Final exported-package captures are under `pack/`.

Motion.mp4 is 180 native gameplay frames at 15 fps, 1280×720, 12 simulated seconds: male pick, female axe, male supply tray, female physical stone load, each moving right/left. H.264/yuv420p, fast-start, full decode and frame count verified. This samples motion, not hardware performance; audio is not included.

## Package and recovery
2,683 final PCK entries: relative paths, byte bounds, MD5 and SHA-256 verified. No embedded executables/native extensions/launcher scripts. The Windows EXE matches the unchanged official 4.4.1 release runtime SHA-256 `b493c1d53fb915f7805f360cfe42d1c3126e720dfc234a4b0f2feb99200f9a4b`. ZIP membership, every entry hash and CRC are verified; eight explicitly selected members, no installer or batch launcher. No fresh antivirus verdict is claimed.

Checkpoint `grips-0.57.0` follows independently verified `art-0.56.0`, preserved by `pre-grip-0.57.0` before editing. Source update and incremental Git bundle are checked against committed blobs and restored into the independent full-chain repository with full fsck and exact commit/tree comparison. Recovery.txt records the precise values and restore commands. Earlier backups are retained.

## Limits
Some native harnesses report retained objects/resources at shutdown after completing. No gameplay/script errors occur in the completed passing runs. Windows execution, real audio and performance on the user's hardware were not tested. Body/head/footwork remain registered layers; holding upper bodies stay steady as drawn feet cycle. Not all work/combat directions are newly drawn. Broader world-art backlog remains. Passing tests do not establish the user's artistic acceptance. No save format, mining resistance or movement speed changed.
