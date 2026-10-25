Current handoff: docs/SESSION_HANDOFF.md. Release 0.74.0 is published, verified and merged; the records below are historical.

# 0.64.0 — The Hold of Three Hearths (source verified)

Work branch polish/keldrath68; start local 84141d65c35c4bed6f593d736dbfb096b50674dc, remote main 2130a077612d3a70c0e67e01ac4db2c30539f97f. Pre-edit tag pre-keldrath68 and verified incremental recovery/pre-keldrath68.bundle preserve the baseline; previous backups are untouched. Never force-push restored local history over GitHub.

Read CURRENT_STATUS and testing/civic68.md. HoldWardDesign owns authored ward pockets, stable distant painting and cached stone paving. HoldCivicArt owns original atlas crops and exit side geometry. Furnishings shares new prop art/cost/footprints with player construction. Surface adds fixed freight storage using existing chest records, notices, and restrained interaction cues. Latest user direction: reduce captions; architecture must communicate doors and routes. Preserve the approved player gait and functional Great Stairs.

Run suite civic and the exact-pack checker (now includes civic68). Verify Ivar's escort after moving the quarters lamp away from his route. Test freight deposit/reload/recovery from a valid approach, five interior exits, all wards and resident/public routes. Native visual captures are local QA artifacts, not runtime assets. New art provenance and exact prompts live in assets/hold-kit68.

Native source verification passed all 315 checks. A clean Windows export passed the audit of all 3,165 packed entries; all 161 exact-pack gameplay checks also passed. Local verified-civic68 and recovery/verified-civic68.bundle preserve this source/evidence, requiring pre-keldrath68 / 84141d65. GitHub PR #11 preserves runtime e9fc82ac86bfea87f9cc68e25639923c1bcae14f; all 34 changed paths match local blob hashes. Hosted validation 39671981253 is still pending; do not claim it passed or merge before checking. No new release is published. Publication remains pending. GitHub main and v0.63.0 are the previous verified delivery. Large image transfer is isolated on an asset branch; verify content hashes before using binary blobs in the runtime tree. Do not include transfer chunks in the game branch.

# 0.63.0 — Living terraces (published and verified)

Published v0.63.0: one complete Windows ZIP at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.63.0. Release source 472e12bf47c0784c84f3e763da7778dc9cbe740e; hosted run 39656676389 passed all publication gates. The uploaded ZIP is 701,152,760 bytes and SHA-256 f273ba088776f8a8bd52ae56ae7c941d3b2c68ff614cd34b98791734ee975eb3; both match the clean hosted build report. Tag target matches the build source. See testing/living67/hosted-build.json and delivery.json. Earlier releases are preserved.

Base milestone PR #8 merged at 09666eaf2ba6f06598b3f0ac52249615243d3be2. Final visual review caught an adjacent-ward resident hidden by shared stair artwork; PR #9 corrected foreground sorting without duplicate actors or ownership changes. Full corrected source gate 39656307242 passed all twelve gameplay cases and import; PR #9 merged at e8a62f08f9ea6a950ba0176bc0bd071927292707 with an identical runtime tree. Native correction checks: 51 passed. The corrected local exact PCK passed 97 checks; the hosted exact-pack ambient, continuity and living cases also passed. Earlier local packages are superseded.

Continue from GitHub main. Local recovery tag verified-living67-delivery and the new verified-living67-delivery.bundle preserve final source/evidence, requiring pre-living-hold67 / 1401303d8bfd0bda6ccd4e8a30244580aae49f3a. Earlier verified-living67-visibility / 13f1043dce58845757b76103233b04e7d1bda8a7 and all previous bundles remain intact. Local restored history differs from GitHub; never force-replace remote history. The persistent release tag preserves the complete published source.

HoldTerraces connects three saved wards in continuous projected space (stride 1740), preserving camera/gait and loaded carts across normal movement. HoldRoutines compiles nine home/work/tavern journeys per seed, samples saved elapsed time and releases navigation grids. Only active/visible adjacent architecture and residents draw. Public rovers and story hosts retain previous behavior. HoldRoomLayout owns the larger forge; HoldMasonryArt uses assets/hold-kit67. Carved pillars and low workshop tables share the existing build/collision/save catalogue; tables are decoration, not another processing system.

Preserve the approved player walk: only preparation changed, not player artwork/descriptors. Distinct interiors, service stairs/lift, mining, forestry, economy and save schema remain. This is bounded terraced architecture, not arbitrary 3D occlusion or a complete population/economic simulation. Read testing/living67.md, testing/living67/visibility.md and PLAYTEST_GUIDE.md. Windows hardware/audio and artistic acceptance still need the player's machine.

Release orchestration prepares the package while an identical-source gate runs, requires successful source and exact-pack tests before publishing, and allows 55 minutes for cold import and verification. Earlier publisher runs were intentionally cancelled before publication. Large art transfers and a transient local exec interruption were recovered; no previous backup or release was replaced.

# 0.62.1 session handoff

Published release v0.62.1: one Windows ZIP at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.62.1. Release source 7c51669f17b94ceb835b99fa9572f03e75cad880; hosted build report and published digest are verified in testing/continuity66/hosted-build.json. The release job completed all gameplay and exact-pack gates. Continue from GitHub main; preserve the player walk and this release.

Runtime merged through PR #6: 285a2bc41c827b415a51ce3c284e3335b5342d43. Full hosted gameplay validation 39611887147 passed. Work: polish/continuity66. Verified starting remote main: a669d925f27f6f04b9bffdae88efafc72cf9ddac (0.62.0); hosted validation 39497203974 succeeded. Local pre-continuity66 preserves the restored baseline d720885 and all older recovery bundles remain untouched. Remote history must not be force-replaced by the local restored history.

Read CURRENT_STATUS and testing/continuity66.md. New personal story: letters.gd, surface points, onboarding journal. Facade rectangles and lower-floor projection: world_zones.gd. Stair geometry and residential layout: hold_neighborhood.gd; timed traversal and bedside approach: surface.gd. NPC-only passing keys: assets/town-walk66 and the town_walk descriptor; normal player/core/motion assets are unchanged. The user's latest instruction explicitly approved the player walk and identified townsfolk as the problem. Do not replace the player walk.

Verified source checkpoint: remote 7d7e7d75c4e07de37ed49b0c1817441f48b5158b (PR #6), local verified-continuity66 / aa75c504. All 46 changed remote paths matched local Git blob hashes. 254 distinct source checks plus 35 final repeats and 46 exact-pack checks passed. Incremental recovery bundle verified without replacing older backups.

Run tools/check.py suites continuity and locomotion; exports additionally use tools/check_pack.py from empty working/save folders. Include town-walk66/frames.json in exports. Bump HoldBuild.VERSION for any later art/cache changes. Cutaway cost is bounded to one adjacent ward's clipped facades, with no second viewport or NPC simulation. Further continuous floor occlusion/architectural overlap remains backlog.

Windows release workflow builds only a deliberate release/<version> branch. It verifies the official runtime hash, full gameplay, PCK inventory, ZIP integrity and exact exported gameplay before creating a new versioned release. An already successful full source gate can be reused only after tracked-file equality is checked (documentation and release orchestration excluded); a running matching gate is awaited. It refuses to replace an existing release. No personal saves or credentials belong in the repository.

# 0.62.0 source handoff

Current branch: world/keldrath65. Pre-edit local tag pre-keldrath65 preserves 31dd944; prior modular PR #4 passed hosted CI and merged at a5535e144e298756016152eaa289d3f6ad8dfc11. Older releases and source bundle remain untouched.

Read CURRENT_STATUS and testing/hold65.md. hold_neighborhood.gd owns residential coordinates, homes, stair rail geometry and resident schedules. world_zones.gd integrates those with existing wards. floor_pattern.gd caches original continuous wood/stone meshes and restrained surface grain. surface.gd handles household room links, correct upstairs exits, expanded ward bounds and interaction priority. New IDs are additive room:folk_<ward>_<family>_<floor>; existing save schema, inventory and claimed construction are unchanged. Area IDs carry household level; HUD reports ward-relative absolute Z.

Run tools/check.py --suite hold with isolated native saves. New full gameplay case: tests/hold65.gd. Building bases are explicit physical footprints; painted roofs remain occluding/fading art. Private legacy houses are still closed; nine added family homes are enterable. Resident routines are simple deterministic street/hearth cycles, not a full job/day simulation. No Windows release exported for this source milestone.

# 0.61.3 source handoff

Continue modular placement work on polish/modular64; pre-modular64 preserves local 0.61.2. Read CURRENT_STATUS and testing/modular64.md. Shared grid/footprint renderer: scripts/build_preview.gd. Furniture validation/repositioning: surface.gd. House eligibility: hearthcraft.ready_to_build. Equipment eligibility: handworks.placement_ready. Native gate: tools/check.py --suite modular. Keep previews and commit rules aligned, and preserve chest record identity during moves.

This is an incremental building/collision polish pass, not acceptance of every outstanding animation/art issue. No new Windows release yet. Existing v0.61.2 remains available. Update branch/PR status after integration; do not replace older releases.

# 0.61.2 handoff

Continue from GitHub main. PR #3 merged at `d539cb535fad79fb2bd141ed73e5c3a848ad9bf0`; release `v0.61.2` preserves complete runtime source `4169069d9f80e6fae3dc33deee855c8b16a13916`. The clean local build used `1ab53f235b345ae7a1d5520962fa2ef20d920b95` with matching runtime files. Local `pre-loading63` preserves the prior checkpoint; older releases and the complete foundation source recovery bundle are untouched.

Read CURRENT_STATUS.md, DEVELOPMENT.md and testing/loading63.md. AGENTS.md applies. Title/loading implementation: scripts/loading_view.gd, main.gd and whole_frames.gd. Metadata is HoldBuild.VERSION 0.61.2. The loader uses existing original Keldrath art, job-count progress and a short completion fade. It sits on canvas layer 100 above Ivar and all menus. Existing input/scene gates are retained.

Animation PNGs are derived cache data under user://animation-cache/<version>/. **Bump the build version whenever source artwork, frame metadata or recoloring logic changes.** Do not change or delete saves to clear caches. Cold preparation, engine startup and synchronous world generation remain performance follow-ups. New-character creation randomizes from the canonical appearance/name pools; defaults() remains stable for save migration, and wardrobe mode retains saved identity.

Verification: 190 existing gameplay checks plus 19 final feature checks; the same 19 checks passed against the exported pack. Hosted gameplay CI also passed (39484028846). See testing/loading63 for screenshots, logs, regression summary and build metadata. The initial 11-check loading case was superseded by the 19-check case and is not counted twice. All 3,134 PCK entries and ZIP integrity passed. GitHub asset size/SHA match local. Native Windows and audible mix have not been tested.

Use tools/check.py with tests/suites.json, sequential native rendering and isolated save data. tools/build.py exports one complete Windows ZIP using the pinned official runtime. Full editable source is in GitHub; do not rerun the one-time import workflow or rewrite release tags. Earlier complete bundle remains in release foundation-0.61.1. Further changes should use focused branches and regression evidence.
