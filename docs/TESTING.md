# Restoration139

The affected suite includes invasion131 and troll133. Their late-story fixtures reconstruct established pre-crossing archive saves and assert authentication; the fresh progression guard remains covered by restoration139.

`restoration139-focus` exercises staged locality, partial structure and work orders, real research/forge/cooking, shared production-credit spending, arbitrary/overfill inputs, every pure specialty and mixed service, physical river/rail collision, unchanged southern crossing, once-only recognition, authored scene/skip/save recovery, new authentication gate and old-save preservation. `restoration139` adds campaign138, ledger137, work132, frontier103, mountain104 and claim127. Included in core/gameplay/gameplay-2 and the exact-pack catalogue (64 cases). Inspect the ruined seats, restored crossing, project book and Ivar/Skarrin scene at gameplay scale. Human completion time and perceived fairness of specialty costs are not established by automated checks.

# Campaign138

`campaign138-focus` verifies fresh eligibility, production/technology requirements, saved partial structural/provision deliveries, actual local assembly and trading, unchanged rewards, visible supplies, fishing/farming and specialist/mixed alternatives, local rescue dispatch and migration. `campaign138` adds work132, frontier103, mountain104, claim127, greatclaim102, ledger137 and firstvisit99. The focused case is in core/gameplay/gameplay-2 and the exact-pack harness (63 cases). Review native and exported project controls, physical approach, stocked interior and the campaign panel.

# Ledger 137

`ledger137-focus` covers escrow, invalid/remote/excess deliveries, JSON reload, forge inspection and production requirements, exact wage/payment, legacy completion, visible civic rewards, and Skarrin’s local once-only welcome gift and milestone dialogue. `ledger137` adds work132, frontier, lodge, people, polish and first-visit save regressions. Included in gameplay-2/core/gameplay and the exact-pack harness.

# Release orchestration

Windows exact-package checks run on four independent runners, with sequential isolated cases per runner. All 64 cases remain mandatory; the final gate verifies exact coverage and common source/PCK/ZIP identity. Focused checks never satisfy release coverage. See [RELEASE_PIPELINE.md](RELEASE_PIPELINE.md). Test pipeline failure handling with `python3 -m unittest discover -s tools -p test_release_pipeline.py -v`.

# Visual polish 135

`polish135-focus` exercises the real first-load payment and room handoff, optional trade route, Ivar acknowledgment, quick-bar viewport/actor clearance, preserved inventory, material resources and progressive disclosure. `polish135` adds lodge, first-visit, menu, handling, frontier and work regressions; `polish135-art` verifies the final art in the opening, full inventory/recipes and homestead. The focused case runs in gameplay-2 and the exact-pack harness. Inspect the actual captures: packed inventory, recipes, worksite, stair landing, reward card, garden/river context, trial gallery and combat workers. Use sequential engine runs on memory-limited hosts.

# Giant trolls 133

`troll133-focus` checks eight approach directions, committed fist targets, painted-contact alignment, circle boundaries, both blows, actual Space input, interruption, pause, blocked steps, large-body clearance, saved wounds, perspective art and five-giant scene reload. `troll133` adds enemy, combat, equipment-art, developer-room, invasion and perspective regressions. The case is mandatory in core/gameplay/gameplay-3 and the exact-pack harness. Review native giant/player scale, both fists, walking contacts, King counter and trophy. Do not infer human difficulty from accelerated checks.

# Useful hands 132

`work132-focus` covers local quest reports, real bench/forge/fieldwork/hauling/survey/return-route hooks, once-only rewards, forged tool guards, specialist and mixed 180-mark paths, material budgets, household construction, migration, reload and closed-contest preservation. `work132` adds the affected opening, frontier, ancestry, trial, crafting, roads, bench, discipline and menu regressions. The case is mandatory in core/gameplay/gameplay-2 and the exact-pack harness. Review first-step, active lesson, contribution options, plot/home milestone and closed-contest captures. Balance by active play time remains a human playtest item.

# Thaneship opening 131

`invasion131_focus` covers preparations, physical E interactions, sequential combat groups, actual weapon contacts, escort/mechanism tasks, defeat/infirmary recovery, saved wounds, scene choices/skip/load, royal routes, once-only title awards, all trial opinions and original-house continuity. `invasion131` adds the prior claimant/friendship and combat/menu regressions. The new case is mandatory in core/gameplay/gameplay-1 and the exact-pack harness. Human pacing is not inferred from accelerated tests.

# Friendship stories 130

`--suite friendship130_focus` checks all 36 episode paths, thresholds, local tasks, wrong/missing-cost guards, unique payouts, romance/storage preservation, actor routes, native scenes, saved-beat recovery and title/resume. `--suite friendship130` adds people, courtship, pairing, main-story scenes and menu regression checks. The new case is mandatory in core/gameplay/gameplay-2 and the exact-pack harness.

# Current acceptance checks

Use Godot 4.4.1, Python 3.11+, and isolated test data. Never test against personal saves.

```sh
python tools/check.py --godot /path/to/godot --suite gameplay --output test-results/unique-run
```

A native display is required; on Linux CI use `xvfb-run -a` and `LIBGL_ALWAYS_SOFTWARE=1`. The runner imports first, executes sequentially, and requires exit zero, no script errors and an explicit passing summary. Every case has independent temporary save directories. Cold asset import allows 900 seconds; each gameplay case allows 360 seconds. Timeouts and missing completion markers fail the run. Existing output directories are refused.

`tests/suites.json` is the authoritative list. `core` covers menus, orientation, ambient animation and held equipment. `gameplay` adds excavation/Z-levels, material handling and a settlement-to-world journey with legacy-save migration. The shared fixture lives in `tests/support/game_fixture.gd`; historical filenames remain to preserve links and resource paths. Exact-export tests must remain standalone.

Inspect captured inventory/settings/directions, escort, fountain/fire, held-tool and mining/workstation images at gameplay scale. Compare to baseline when presentation code changes. Passing state assertions alone do not establish visual quality.

For each Windows release, use `tools/build.py`, then run `tests/pack_ambient61.gd` externally against the resulting PCK from an empty working directory with an isolated save directory. Require its completion marker plus successful exit. Repeat affected input workflows against the pack when runtime dependencies change. Record Windows/audio/performance limitations honestly.

Historical evidence and acceptance notes: [0.61.0](testing/ambient61.md), [foundation](testing/foundation62.md), [earlier testing index](testing/HISTORY.md). Historical tests may target retired mechanics; do not treat all versioned files as current gates.

## Ridge courtship 124

`--suite ridge124` runs the new relationship story plus courtship, people, calendar, roads, mountain rescue, portraits, named world art and final-cast regressions. `--suite ridge124_focus` runs the targeted story alone. The new case is also mandatory in core, gameplay and gameplay-4. Exact-export checks use `tools/check_pack.py --case ridge124` alongside the affected existing cases.

The targeted case checks early-interest choices and release, same-day changes of mind, active player courtship/betrothal, both introductions, long skips, saved numeric normalization, choice-triggered courtship/betrothal, all six alternative partners, failed invitations, legacy countdown preservation, load reconciliation, stale callbacks, friendship access, actor uniqueness, collision/approaches and both location displays. Existing courtship101 now exercises all eight candidates; mountain104 verifies both new partners in the physical rescue. Native review: `tests/review_ridge124.gd`, with production records in art/ridge124/README.md and final evidence in testing/ridge124.

## Dwarven traditions 126

`--suite traditions126` covers the new behavioral case plus calendar, lodge, frontier, furnishing, Keldrath and ridge relationships. `--suite traditions126-focus` runs only the new case. It is also included in core, gameplay and gameplay-4. `tools/check_pack.py --case traditions126` runs the fixture against the exported game. Review the eight-column seasonal offsets, shrine/catalogue, memorial, Cupday/Namesday scenes and optional Oath Stone inscription.

## Hearthknot 128

`--suite hearthknot128` exercises crafting/payment, queue and relationship reloads, missing/stale/remote/ineligible offers, ordinary-gift protection, trade protection, all eight courtships, ridge pairing, people, frontier services and book menus. `--suite hearthknot128-focus` runs the new case only. It is mandatory in core, gameplay and gameplay-4, and available through `tools/check_pack.py --case hearthknot128`. Review the crafted-token pack view, missing-token instruction, ready invitation and accepted response captures.
