# Foundation 0.61.1 verification

2026-10-20. Baseline: `ambient-0.61.0` (`300ec660c3b66ee2dcf2c0866d8c52b0e872603f`); pre-edit tag `pre-foundation62`.

## Local checks

201 passing checks across native source and exact exported pack:

| Case | Passing checks |
|---|---:|
| Menu navigation, callbacks, pause, history and reload | 9 |
| Full orientation and skip/resume | 20 |
| Ambient/citizen animation, surnames and construction | 36 |
| Equipped tools and cargo | 20 |
| Deliberate mining, ownership and Z-level passages | 38 |
| Physical materials and workstations | 32 |
| Town/trail/Pinewood/home journey and legacy save migration | 35 |
| Exact exported PCK, dialogue, escort and save/reload | 11 |

Every successful case completed with exit zero and its explicit summary, without script errors. Linux Godot 4.4.1, native software OpenGL, Dummy audio. Menu captures inspected; original styling, control arrangement and artwork preserved. No Windows execution, audible mix or hardware-performance claim.

Initial test issues are retained in local logs: the copied key helper lacked physical_keycode, so action-mapped Inventory/Escape did not fire; the old journey expected two-hit excavation, which predates deliberate mining. The shared fixture now sends both keycodes, and the journey uses bounded contacts for ownership verification. `mining55` still tests actual held-input timing and resistance, so no gameplay balance was weakened to satisfy the old assertion.

## Build

`tools/build.py` produced one complete Windows ZIP from clean runtime commit `1ee67e6993f8bbe24c49608419351b1a017b9f1b`. All 3,132 PCK entries passed MD5/SHA-256, bounds and path checks; ZIP CRC checks passed. See `foundation62/build.json` for exact hashes. Only fixtures/docs/workflow formatting changed afterward; runtime source remains identical.

The self-contained pack harness ran from an empty directory against this exact PCK with isolated saves. Developer fixtures are not dependencies of shipped resources. The existing official Windows executable is unchanged. The complete Windows ZIP is delivered in release foundation-0.61.1; earlier player builds remain available.

## Source migration

GitHub importer is prepared to verify a complete bundle by SHA-256 and expected source commit, join source and delivery histories on a new branch, and run the same native suite. Actual import/merge and fresh-checkout outcomes must be recorded in CURRENT_STATUS after completion, not inferred from local tests.

No prior backup was overwritten. Historical tests, art and source remain; current tests are selected by manifest rather than renaming every historical file.

## Completed independent and hosted verification

The complete bundle restored into a separate Git repository with no borrowed object store; fsck passed and the tree matched `1d408177da6b894a983dea34207905531d1bd7e9`. Fresh import and all 190 source checks passed. A fresh Windows PCK exported successfully and all 3,132 entries passed the audit; the standalone pack harness passed 11 checks. All payload entries match the delivered PCK except generated `.godot/uid_cache.bin`, so no cross-machine byte-identical PCK claim is made.

GitHub import run 39479233597 and PR validation run 39479668647 passed. GitHub core subtree hashes match the local snapshot. PR #2 joined source to main. Both source bundle and Windows ZIP sizes/digests match the local artifacts. The full source bundle and prior releases remain unchanged.

The hosted cold import took approximately 322 seconds. After successful validation, the import timeout was raised from 360 to 900 seconds to allow slower runners; per-gameplay-case timeouts remain 360 seconds. This tooling-only adjustment does not change game behavior or the tested Windows payload.
