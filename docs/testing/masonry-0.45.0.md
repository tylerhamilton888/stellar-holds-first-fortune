# 0.45.0 verification
Godot 4.4.1 Linux, isolated save roots. Pre-change tag pre-masonry-0.45.0 and prior verified 0.44.0 full-history bundle preserve recovery; checksum rechecked before edits.

| Check | Result |
|---|---|
| Masonry integration/model | 25 passed |
| Native full masonry workflow | 12 passed |
| Existing Living Works | 37 passed |
| Existing Deepworks | 45 passed |
| Existing hauling | 34 passed |
| Z-level route lessons | 13 passed |
| Pinewood | 53 passed |
| Continuity smoke | 10 passed |

New coverage includes partial cuts/reload, exactly one owner per block, ore/basalt gates, local supply bounds, partial dressing, empty supply, ordinary/dressed conversion, delivered-only construction, genuine room-quality gain, once-only lesson reward, research yield, real recruited worker fetch/dress/return, in-flight save/reload, release conservation and additive old-save defaults.

Native UI test uses actual mouse/key events for held extraction, placement, caching, E at bench, held dressing, haul controls, floor finishing, reward and worker assignment. It verifies refreshed menu bounds and reload. Visual captures inspect quarry contact, supported carrying pose, marked pile, foreground bench/chisel work, lesson controls, NPC carrying and dressing, and the pale dressed floor. Test room/supply budgets are explicit fixtures; personal-loop input is produced by actual quarrying.

Fixed during integration: cancelling an old tool mode retained a recovery swing and could interfere with subsequent finishing; repeated O-panel refresh could grow beyond screen bounds. Partial saved JSON numeric normalization was corrected in the test comparison, without changing production save semantics.

Pack boot and full bundle restore/fsck verification are recorded in RECOVERY_VERIFICATION_0.45.0.json. Windows execution and speaker listening remain unverified on this Linux host. Existing shutdown resource warnings remain. Worker simulation uses existing active-site scheduling, not an always-running global labor simulation.
