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
