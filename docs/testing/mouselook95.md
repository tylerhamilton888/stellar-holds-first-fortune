# Mouse-look exploration acceptance — delivered 0.85.0

Release: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.85.0
Source: 76d0c5195bf95d74dbb8c0fed54b52213d490190
Runtime tree: 7e20f238fea428591c3a81da60a151b94394ff82
Runtime merge (PR #61): 09dda3c57f6fc0d2a69f0c2e1e1e3d4e07dbaff7

## Verification

- Full source run 40800423957: 38 gameplay cases plus people-preview passed.
- Exact Windows-pack run 40800559860: 28 cases / 1,970 assertions passed.
- Local regressions: navigation94 31, combat 44, mining 38, dev_testing 49, menu92 35 — 197 assertions passed.
- Final native mouse-look: 46 assertions, test-results/mouselook95-visible. Final local exported mouse-look/navigation: 77 assertions, test-results/mouselook95-final-pack. PCK audit: all 3,345 entries passed.
- All seven final local native/export mouse-look captures are byte-identical. Hosted export matches all seven native captures. See delivery.json for exact hashes and build/asset verification; no unverified whole-image equivalence is claimed.

The native Input.parse_input_event case covers unscaled mouse motion, sensitivity/inversion, bounded tilt/zoom, close framing, unchanged world state, retained terrain batches, pointer handoff, held-click suppression, menus/map/survey/placement/focus, persistent settings, actual mining contact, zero-energy strike/guard/dodge, camera-relative collision movement and overhead/zone/title exit. Navigation retains separate free-cursor coverage.

Reviewed orbit, both close-camera limits, camera options, reticle mining/combat, stair routes and original artwork. Close framing avoids hotbar overlap. Billboard root anchoring follows camera pitch. A player-only depth override keeps its tilted paper drawing readable against rock faces; enemies/props retain normal occlusion. The initial test harness now allows the native window two frames to complete capture before motion injection.

## Final local timing probe

Godot 4.4.1 GL Compatibility, Mesa llvmpipe, Xvfb 1280×720. 150 rendered frames per sample, first 30 discarded, small two-floor developer fixture. Mean/p95 milliseconds: overhead idle 26.34/40.51; exploration idle 19.78/27.39; continuous orbit 20.95/28.99; orbit while moving 19.73/26.29; combat 18.61/25.40. See performance.txt. These observations do not establish Windows-device performance.

## Limits and recovery

Mines only, one physical floor at a time. Aim/collision share the original ground-plane simulation; no free-flight or independent 3D physics. Construction retains overhead placement. Windows hardware/audio and subjective sensitivity/comfort remain owner playtests. Source, tag, clean build report and uploaded ZIP metadata agree. The downloaded build report and evidence archive were verified against GitHub SHA256 digests; the full ZIP was not independently redownloaded.

Runtime is retained on exploration/mouselook95, release/0.85.0 and recovery/mouselook95-final. Verified incremental mouselook95-final-checkpoint.bundle requires d31a4dd8970957c38bdeba574b00ce6dd6c5e985, retained in master history. Preserve all previous backups/releases.
