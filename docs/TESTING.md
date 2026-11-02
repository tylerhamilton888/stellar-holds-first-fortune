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

The targeted case checks early-interest choices and release, same-day changes of mind, active player courtship/betrothal, both introductions, long skips, saved numeric normalization, warning/courtship/betrothal transitions, stale callbacks, friendship access, actor uniqueness, collision/approaches and both location displays. Existing courtship101 now exercises all eight candidates; mountain104 verifies both new partners in the physical rescue. Native review: `tests/review_ridge124.gd`, with production records in art/ridge124/README.md and final evidence in testing/ridge124.
