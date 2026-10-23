# Royal Hall and grounded Keldrath verification

Baseline: published 0.70.0 and main 92751bd7660a00eb688720e2c1145d978b00677f. Local pre-royal79 retains the identical delivery tree at 980b78db59df11b0f2e76478e106a7555245be96. Verified incremental qa79/pre-royal79.bundle requires 80edbc423f50de8e3cedaa80f47f72a719149660. Remote recovery/pre-royal79 preserves main; all earlier archives/releases remain.

Initial royal native case: 69 assertions passed. Corrected atlas boundaries remove cropped crowns and use complete painted silhouettes. Measured native screenshots reviewed for the throne, aisle and actual top-down audience. Final combined ward/hall review, broader source regression, exact-export gate and release remain pending.

The first test fixture left its game node alive at process exit; the fixture now queues the game for deletion before quitting, matching current acceptance fixtures. This must be rechecked in final logs.

Recovery continuation: the frozen session's tracked edits, new scripts and all three original PNGs were recovered into local checkpoint 221db8b on an isolated worktree. The published baseline and original worktree remain intact. A dialogue-boundary teleport was fixed, and audience animation preparation now warms the up-facing poses used on screen.

Recovered logs record 480 passing assertions across royal (69), roads (81), civic (64), living (51), continuity (35), appearance (64), Keldrath (47) and homestead (69). A fresh native royal run after the continuation fixes passes 72 assertions with exit zero and no script errors. It covers dialogue-position continuity, skipping during the entrance, idempotent completion, inventory/save preservation, return to Crownward, physical bases and complete royal silhouettes. Native hall, seated king, audience, gate and ward captures were visually reviewed. Full hosted source and exact-export release gates remain pending.

Final local exact-export gate: all 15 cases passed, 693 assertions, with no script errors or resource-leak messages. The initial ambient harness still inspected retired side-view scene fields; it was updated to drive scene time and inspect actual top-down petitioner/King movement. The revised full gate passed. Source runtime is byte-identical to clean build 0b0b963; later changes are external tests and delivery evidence. Local build audit verified 3,263 PCK entries. Full hosted validation/release remains pending; nothing has been merged or published.

Publication blocker: automatic approval review rejected one hall-kit.png transfer chunk despite exact SHA256 verification and private-repository admin/push permission checks. It requires explicit owner authorization naming tylerhamilton888/stellar-holds-first-fortune and the completed source/artwork/Windows release. No alternate upload route was attempted after the verified retry was rejected.
