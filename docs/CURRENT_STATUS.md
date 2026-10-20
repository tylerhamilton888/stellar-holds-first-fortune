# Foundation 0.61.1 — source migration in progress

2026-10-20. Playable public-to-owner release remains **0.61.0**. Foundation runtime is behavior-preserving: menu widget/theme/shell code extracted to `HoldMenuView`; title and packaging share `HoldBuild`; current native tests share `tests/support/game_fixture.gd`.

Local validation: **201 passing checks**, including actual mining, Pinewood, hauling/workstations, Z-levels, tutorial, menus and legacy save migration. Exact exported PCK passed 11 of these checks and all 3,132 file integrity checks. See `testing/foundation62.md`. Windows execution/audio/hardware performance remain untested here.

`tools/check.py` is the current acceptance runner. `tools/build.py` packages one complete Windows ZIP with source metadata and hashes. `tests/suites.json` selects current tests. GitHub PR #1 installed the reviewed import and validation workflows.

Pending at this checkpoint: upload the full source recovery bundle, run the GitHub import workflow, verify its fresh checkout, and merge the imported source branch. Do not claim delivery-only main is the editable project until that is confirmed. Preserve both existing release tags and all recovery bundles.

Next cleanup is incremental: further menu/session extraction, legacy dependency audit, and shared geometry/animation rules only where evidence justifies changes. No blanket renderer removal, asset moves, save rewrite or gameplay redesign occurred.
