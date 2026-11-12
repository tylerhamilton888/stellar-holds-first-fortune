# Current status — 2026-11-12

Published Windows baseline remains **0.106.0** until the release gate publishes 0.107.0. Prior first-hour delivery evidence is preserved in history/CURRENT_STATUS-before-blueprints152.md.

## Surface room blueprint candidate

[PR #152](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/152), branch `feature/room-blueprints`, implements Stage A on the existing Hearthcraft system. See [BLUEPRINTS.md](BLUEPRINTS.md) and the preserved [directive](BLUEPRINT_DIRECTIVE.md). Stages B/C and provisional property-story changes remain deferred.

GitHub backup and native rendering blockers are resolved. Authenticated file-blob uploads can preserve the exact verified local Git tree without exposing file payloads; compare tree hashes before moving the branch. Native acceptance uses Godot 4.4.1. The local display requires its own Xauthority cookie and renderer/test in one isolated execution context.

Local native results so far: blueprint transactions 61 assertions; five-room manor 40; architecture styles 60; existing buildings 347. All passed with no script errors. Final manual-stair acceptance and LivingWorks regression are pending at this checkpoint. Tooling: 42 passed, output policy/diff checks passed. Inspected planner and furnished-manor screenshots; compacted controls and focused room zoom after review.

Do not merge or publish based only on these local results. Complete final affected checks, full PR/native coverage and exact-package release gates. Update this checkpoint with the exact source/run/release after verified delivery. Keep earlier builds/saves and bounded logs. No encoded assets or full diagnostic dumps in conversation.
