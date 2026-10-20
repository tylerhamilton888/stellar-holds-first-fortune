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

The self-contained pack harness ran from an empty directory against this exact PCK with isolated saves. Developer fixtures are not dependencies of shipped resources. The existing official Windows executable is unchanged. This development build is not a replacement for the published 0.61.0 player release until separately delivered.

## Source migration

GitHub importer is prepared to verify a complete bundle by SHA-256 and expected source commit, join source and delivery histories on a new branch, and run the same native suite. Actual import/merge and fresh-checkout outcomes must be recorded in CURRENT_STATUS after completion, not inferred from local tests.

No prior backup was overwritten. Historical tests, art and source remain; current tests are selected by manifest rather than renaming every historical file.
