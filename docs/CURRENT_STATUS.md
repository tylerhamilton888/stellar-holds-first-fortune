# 0.64.0 — The Hold of Three Hearths (source verified)

Keldrath retains its three wards, Great Stairs, homes, interiors and established routes. Authored civic, social and industrial pockets now give each ward a distinct purpose: the Oath Court has a memorial and founders’ orrery; the Common Hearth has grouped tavern seating and trade lockboxes; the Iron Terrace separates workshop, freight and training equipment. Domestic lamps, household plaques and communal seating reinforce the Kin Galleries.

Original illustrated distant galleries and pumping works replace the empty perimeter. These are non-playable scenery behind the existing boundaries. New civic furnishings share the player's crafting, placement and collision catalogue. Fixed freight chests use existing persistent storage, with no free supplies or new economy.

Interior exits have painted open doors, solid side leaves, a clear threshold and camera framing above the hotbar. Automatic door captions, tracked-destination banners and overhead names are removed. A small nearby E cue and the existing contextual footer/guide supply interaction information; physical building signs remain. Player artwork and gait are unchanged.

Native source verification passed 315 checks across civic, living, hold, orientation, world, modular and ambient cases, with no script errors. Another 161 checks passed against the clean exported pack. Source is backed up in PR #11 and recovery tag verified-civic68. Hosted validation remains pending. No 0.64.0 release is published yet; v0.63.0 remains the last verified download. See testing/civic68.md and SESSION_HANDOFF.md.

# 0.63.0 — Living terraces (published)

Keldrath's Crownward, Hearthward and Forgeward now connect through long walkable Great Stairs. Normal movement crosses the ward boundary without a fade or input lock, keeping the camera, gait and loaded handcart continuous. Painted masonry provides retaining walls, balustrades, columns and a wider forge exterior. Existing enclosed service stairs and lift remain useful shortcuts.

Nine household residents now travel from upper rooms, down their household stairs, through actual doorways, across wards, to work, the Copper Kettle and home. Journeys and appearance are deterministic from the existing seed and saved world clock. Forge workers use whole painted hammer poses with stone on low benches. Story services remain available; the six ordinary street rovers per ward still use their established public routes. This is ambient occupational life, not new economic automation.

Borin's forge has a larger accessible workshop wing, camera-following floor plan and matching doorway. Houses and other shops retain separate compact interiors. Carved stone pillars and low workshop tables use the same craft/place/collision/save catalogue as existing player furniture. Materials and old progress remain compatible.

Published [v0.63.0](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.63.0): one complete Windows ZIP, 701,152,760 bytes. Full hosted gameplay and exact exported-package gates passed. GitHub's asset digest matches the clean build report; source, evidence and previous versions are recoverable. See testing/living67.md and SESSION_HANDOFF.md. This is a bounded continuous-terrace implementation, not arbitrary 3D architecture or a rebuild of every interior. Player art is unchanged. Native Windows performance, sound and artistic acceptance still need the player's machine.

# 0.62.1 — Town motion and physical continuity

Player walk art and ordinary stride timing are preserved. Town residents and Ivar use whole-character side passing poses, with the same distance clock as the player. NPC-only selection prevents these poses from changing player or portrait frames. All fourteen town identities keep the existing palette pipeline and full male beards.

Painted facade wall bodies now block feet; the southern homes were moved clear of story-door approaches, and citizen routes avoid the fountain. Bed interactions approach the side. The starting writing desk and crafted desks offer an optional letter home, stored once with a readable journal copy; inventories and quest stage are preserved. Wardrobe/home management remains available at the desk.

Town/household stair interactions take 1.5 seconds along the painted flight, with solid rails/top caps and matching XY landings across Z. Treads render behind the climbing Dwarf. Gallery openings crop real lower-ward architecture with a fixed visual drop; only the active ward simulates. This is a bounded cutaway, not completion of a fully continuous stacked hold. Deepworks and player-built floor systems remain intact.

Native source verification: 254 distinct passing checks plus a 35-check final repeat. Another 46 checks passed against the exact exported pack; PCK and ZIP integrity passed. Evidence is recorded in testing/continuity66.md. Windows release delivery uses the pinned official runtime and requires full native gameplay, pack inventory/ZIP integrity, and exact-pack tests. See RELEASE_NOTES.md. Full hosted gameplay validation 39611887147 passed and PR #6 merged as 285a2bc41c827b415a51ce3c284e3335b5342d43. Prior versions and saves are preserved.

Published Windows release: [v0.62.1](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.62.1), one complete ZIP, 700,029,838 bytes. SHA-256 `38a2918a4ce9436174b8741088a395378e01e0b0a186e07000f0cb7589124283`. GitHub's asset size and digest match the hosted build report. Tag target: `7c51669f17b94ceb835b99fa9572f03e75cad880`; tracked source was clean. Release run 39614387128 passed the reused identical-source gate, all 3,147 PCK-entry checks, ZIP integrity, and both exported-game harnesses before publication. Older releases were not replaced.

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
