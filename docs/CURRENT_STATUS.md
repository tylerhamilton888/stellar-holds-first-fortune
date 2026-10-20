# 0.62.0 — Keldrath galleries and collision refinement (source)

Keldrath's three existing Z wards now extend south across guarded gallery bridges into residential streets. Nine enterable family homes have distinct neighbors, furnished hearths and upper rooms; matching stair coordinates connect each room pair and the residential wards. Upper rooms have no phantom ground-level exit. Original story doors, the Ivar arrival, royal audience, trade, claims and Deepworks routes remain in place.

The collision pass unifies painted stair rail envelopes, enlarges the actual ward floor bounds, blocks open shafts/railings, prioritizes aligned doors over passing citizens, and checks building sides/corners with real movement. Houses retain solid ground footprints and depth-sorted painted upper facades. This remains 2D architecture, not free-form 3D interiors carved out of the exterior sprite.

Clean-floor pass: continuous staggered timber boards and dressed stone courses replace repeated atlas strips in interiors, ward paving, bridges and crafted floors. Original cached meshes plus subtle material grain preserve deterministic joints without expensive per-frame regeneration. Source textures are retained for recovery.

199 focused native checks passed; final 80-check household/collision rerun also passed. Native visuals inspected. See testing/hold65.md. No new Windows export yet; latest downloadable package remains v0.61.2. Prior checkpoint pre-keldrath65 and GitHub's completed PR #4 preserve the previous source milestone.

# 0.61.3 — Modular placement refinement (source milestone)

Build mode now shows a subtle snapped grid and green PLACE / red BLOCKED footprint for furniture, house construction and handworks equipment. Preview eligibility includes materials, reach and existing placement/access rules; house previews now include route validation. Furniture snaps at 10 units, equipment at 20 and construction at 40. Ordinary play hides the grid.

Owned furniture and filled chests can be repositioned without paying again, losing contents or deleting the original on cancellation. Close storage rows preserve front access. Town and crafted tea tables/serving counters share catalogue dressing and geometry. Wall sliding faces actual movement; blocked movement stops gait. No save-schema or source-art changes.

171 focused native checks passed; grid/furniture/foundation visuals inspected. Source backed up in GitHub PR #4. See testing/modular64.md for verification and limits. Latest downloadable Windows package remains v0.61.2; this source milestone has not been exported as a new Windows release. Prior checkpoints and releases are preserved.

# 0.61.2 — Welcome to the Hold

2026-10-20. Implemented and merged via PR #3 (`d539cb535fad79fb2bd141ed73e5c3a848ad9bf0`). The title uses the current whole-character held-pick artwork. An illustrated overlay above HUD and cutscenes shows rotating hints and actual animation-preparation progress. Release-scoped disk caching reuses recolored frames across launches. New fortunes start with randomized editable Dwarven names and appearances; existing identities and save format are preserved.

**228 local checks passed**: 190 existing gameplay checks, 19 loading/identity checks, and 19 against the exact exported PCK. Native visuals inspected. Hosted full gameplay validation passed, run 39484028846. All 3,134 pack entries and the complete Windows ZIP passed integrity checks. GitHub's asset digest matches the local ZIP.

[Download 0.61.2](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.61.2): one Windows ZIP, 698,806,969 bytes; SHA-256 `7a3b83aaf213bc4681a9eaa211ae9f1015b8d7058d0bf91d554d76e05874f6a2`. Release tag points to complete source `4169069d9f80e6fae3dc33deee855c8b16a13916`. Prior releases and the full foundation source bundle remain intact.

First-time preparation still costs work; cached preparation was about 1.35 seconds for 488 frames on the Linux software renderer. This is not a Windows hardware performance guarantee. Windows execution/audio remain player-test limitations. Details, captures, logs and cache-invalidation rules: testing/loading63.md. Development workflow and foundation history: DEVELOPMENT.md and testing/foundation62.md.
