# Current handoff — worker routes, release candidate

Published baseline: **0.110.0**, source PR #158 and delivery docs #159. See [CURRENT_STATUS](CURRENT_STATUS.md). Baseline master: `6963c58`.

Active work: [PR #160](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/160), branch `feature/estate-worker-routes`, candidate **0.111.0**. User requested the next blueprint piece: household-worker navigation. The implementation connects recruited miners to real household beds through built floors, upper stairs and cellar stairs, preserving mine assignments and saved positions. See [WORKERS160](WORKERS160.md).

Focused validation: pinned Godot 4.4.1 import and parsing passed; workers160 passed 31 assertions in headless and native runs; 42 tooling tests passed. Reviewed native resident rendering and the scrolled berth controls. Evidence: `test-results/workers160-native7` and `test-results/workers160-tooling2.log`. The new case is registered in source and exact-package catalogues.

Pending: full PR/source and exported-package gates, merge, verified Windows publication and final delivery-document reconciliation. No publication or full-gate success is claimed yet. Preserve prior releases and saves; follow [release procedure](RELEASE_PIPELINE.md). Automated freight remains the next separate blueprint piece. Provisional-property story integration remains deferred.
