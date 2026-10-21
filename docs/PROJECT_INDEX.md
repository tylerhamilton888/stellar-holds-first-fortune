# The Hold of Three Hearths — 0.64.0

- scripts/hold_ward_design.gd: deterministic civic, social, industrial and domestic composition; cached paving; scenic mountain depth.
- scripts/hold_civic_art.gd / assets/hold-kit68: original art, measured crops and open exit side geometry; production.md records provenance.
- scripts/furnishings.gd: five new craftable civic/industrial decorations using shared footprints.
- scripts/surface.gd: additive fixed freight storage, public notices, proximity key cues without floating destination captions.
- scripts/room_layout.gd: exit camera framing; existing room/return coordinates retained.
- tests/civic68.gd / docs/testing/civic68.md: route, exit, furniture, storage and save regression evidence.

# Living terraces — 0.63.0

Published v0.63.0: `testing/living67/hosted-build.json`, `delivery.json` and `hosted-source-visibility.json` record the verified package, tag and source gates. Final local recovery tag: `verified-living67-delivery`; GitHub retains the complete published source and previous releases.

- scripts/hold_terraces.gd: shared projected ward coordinates, normal-movement stairs, rails and camera continuity.
- scripts/hold_routines.gd: compiled household/work/tavern journeys sampled from saved time.
- scripts/room_layout.gd: expanded forge plan, bounds, exit, camera and furnishing positions.
- scripts/hold_masonry_art.gd / assets/hold-kit67: original painted architecture and measured crops.
- scripts/furnishings.gd: craftable carved pillars and low workshop tables.
- tests/living67.gd / docs/testing/living67.md: route clearance, loaded crossings, persistence and rendered contact evidence.

# Physical continuity — 0.62.1

- scripts/letters.gd: optional writing-desk story and journal copy.
- scripts/surface.gd: bedside anchors, stair trips and actor/tread sorting.
- scripts/world_zones.gd / hold_neighborhood.gd: facade coverage, clear streets, actual lower-floor cutaways.
- assets/town-walk66 / scripts/whole_frames.gd: NPC-only passing poses; player frames unchanged.
- tests/continuity66.gd / docs/testing/continuity66.md: native mechanical and visual evidence.
- tools/install_windows_runtime.py / check_pack.py / .github/workflows/windows-release.yml: pinned single-ZIP release delivery.

# Keldrath galleries — 0.62.0

- scripts/hold_neighborhood.gd: residential galleries, connected home floors, painted stair envelopes, neighbors.
- scripts/floor_pattern.gd: continuous cached timber/stone floor drawing.
- scripts/world_zones.gd / surface.gd: ward geometry, doorstep links, interaction selection and bounds.
- tests/hold65.gd / testing/hold65.md: collision, doors, Z traversal, persistence and native visual QA.

# Modular building refinement — 0.61.3

- scripts/build_preview.gd: shared world-space grid, valid/blocked footprint and labels.
- scripts/furnishings.gd: canonical furniture art, geometry, recipes and dressed variants.
- scripts/surface.gd: snapped placement, safe repositioning and wall-slide facing.
- scripts/hearthcraft.gd / handworks.gd: construction/equipment preview eligibility.
- tests/modular64.gd / docs/testing/modular64.md: focused checks and evidence.

Title/loading presentation: scripts/loading_view.gd; frame cache: scripts/whole_frames.gd; regression and evidence: tests/loading63.gd and docs/testing/loading63.md.

# Foundation development index — 0.61.1

- DEVELOPMENT.md: contributor workflow, architecture boundaries, builds and releases.
- TESTING.md / ../tests/suites.json: current native acceptance gates.
- testing/foundation62.md: local mechanical/visual/export verification.
- ../scripts/menu_view.gd: shared presentation; ../scripts/build_info.gd: version source.
- ../tools/check.py / build.py: reproducible verification and packaging.
- ../.github/workflows/: source-history import and routine validation.
- CURRENT_STATUS.md / SESSION_HANDOFF.md: verified GitHub source migration and next work.

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
