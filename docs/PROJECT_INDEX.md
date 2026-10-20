# Foundation development index — 0.61.1

- DEVELOPMENT.md: contributor workflow, architecture boundaries, builds and releases.
- TESTING.md / ../tests/suites.json: current native acceptance gates.
- testing/foundation62.md: local mechanical/visual/export verification.
- ../scripts/menu_view.gd: shared presentation; ../scripts/build_info.gd: version source.
- ../tools/check.py / build.py: reproducible verification and packaging.
- ../.github/workflows/: source-history import and routine validation.
- CURRENT_STATUS.md / SESSION_HANDOFF.md: migration completion and next work.

# Current development index — 0.61.0

| Item | Purpose |
|---|---|
| SESSION_HANDOFF.md / CURRENT_STATUS.md | Current implementation, recovery and remaining boundaries |
| testing/ambient61.md | Current native gameplay/export verification and visual evidence |
| scripts/ambient_props.gd / furnishings.gd | Shared animated hearths; fountain water effects |
| scripts/arrival_escort.gd / opening_scene.gd | Prepared, distance-timed scene actors |
| scripts/whole_frames.gd / world_zones.gd | Whole-frame preparation and town gait |
| scripts/appearance.gd | Canonical Copperkettle family names |
| tests/ambient61.gd / pack_ambient61.gd | Focused native source/export checks |
| tests/intro53.gd / grips58.gd | Orientation and equipped/cargo regressions |
| ART_DIRECTION.md | Existing approved whole-character visual authority |
| PLAYTEST_GUIDE.md | Player acceptance route |
| Stellar-Holds-First-Fortune-0.61.0-Windows.zip | One complete playable Windows download |
| Stellar-Holds-0.61.0-Recovery.bundle + Recovery.txt | Incremental source checkpoint and exact restoration metadata |

Private delivery repository: `tylerhamilton888/stellar-holds-first-fortune`. Its main branch holds delivery documentation, not the full editable game. Source checkpoint tags/commits in recovery files are authoritative. Older releases remain available.

Preserve the full .51 baseline and all increments: .52, .53, .53.1, .54, .55, .55.1, .56, .57, whole-figure-study58, whole-integration-wip58, palette-fix58, animation-refinement58, folk-quality58, whole-motion59, portraits60, and .60 delivery. The .61 increment starts at .60 delivery `19e2795c1e4170ac118485c58e0f6be9e4163820`. Historical test/art records remain under `docs/testing` and `docs/art`; previous source documents remain in Git history.
