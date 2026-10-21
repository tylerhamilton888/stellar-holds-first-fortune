# 0.63.0 — Living terraces (verification in progress)

Work branch world/living-hold67. Started from remote main 7fa8479904295103d16d1aedbbe8121419f45587 and restored local 1401303d8bfd0bda6ccd4e8a30244580aae49f3a. Local tag pre-living-hold67 and its verified incremental bundle preserve the starting state; older releases and backups are untouched. Local history differs from remote history: publish changed blobs on the verified remote parent, never force-push the restored local history.

HoldTerraces projects the three saved wards into one continuous terrace space (stride 1740). Great Stairs cross through normal movement with unchanged camera/gait and attached cargo; save positions remain ward-local. Enclosed service stairs/lift and separate building interiors remain. HoldRoutines compiles nine household journeys once per seed and samples the persisted elapsed clock; grids are released after compilation. Only the active ward and visible adjacent architecture/people draw. Ordinary public rovers and story hosts retain their existing behavior.

HoldRoomLayout owns the expanded forge floor, exit, camera and furnishings. HoldMasonryArt uses the original assets/hold-kit67 atlas. Shared carved pillars and low workshop tables are craftable furnishing catalogue entries; tables are decorative, not duplicate processing systems. WholeFrames.prepare warms town routes; player animation descriptors and artwork are unchanged. Keep the approved player walk.

Read testing/living67.md for gates, observed fixes and limitations. Run suite living; full gameplay and exact-pack gates are required before release. tests/intro53 now waits for the existing loading gate before sending skipped-intro gameplay inputs. No save schema, mining, economy or forestry changes. Latest published release remains 0.62.1 until publication is verified.

# 0.62.1 session handoff

Published release v0.62.1: one Windows ZIP at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.62.1. Release source 7c51669f17b94ceb835b99fa9572f03e75cad880; hosted build report and published digest are verified in testing/continuity66/hosted-build.json. The release job completed all gameplay and exact-pack gates. Continue from GitHub main; preserve the player walk and this release.

Runtime merged through PR #6: 285a2bc41c827b415a51ce3c284e3335b5342d43. Full hosted gameplay validation 39611887147 passed. Work: polish/continuity66. Verified starting remote main: a669d925f27f6f04b9bffdae88efafc72cf9ddac (0.62.0); hosted validation 39497203974 succeeded. Local pre-continuity66 preserves the restored baseline d720885 and all older recovery bundles remain untouched. Remote history must not be force-replaced by the local restored history.

Read CURRENT_STATUS and testing/continuity66.md. New personal story: letters.gd, surface points, onboarding journal. Facade rectangles and lower-floor projection: world_zones.gd. Stair geometry and residential layout: hold_neighborhood.gd; timed traversal and bedside approach: surface.gd. NPC-only passing keys: assets/town-walk66 and the town_walk descriptor; normal player/core/motion assets are unchanged. The user's latest instruction explicitly approved the player walk and identified townsfolk as the problem. Do not replace the player walk.

Verified source checkpoint: remote 7d7e7d75c4e07de37ed49b0c1817441f48b5158b (PR #6), local verified-continuity66 / aa75c504. All 46 changed remote paths matched local Git blob hashes. 254 distinct source checks plus 35 final repeats and 46 exact-pack checks passed. Incremental recovery bundle verified without replacing older backups.

Run tools/check.py suites continuity and locomotion; exports additionally use tools/check_pack.py from empty working/save folders. Include town-walk66/frames.json in exports. Bump HoldBuild.VERSION for any later art/cache changes. Cutaway cost is bounded to one adjacent ward's clipped facades, with no second viewport or NPC simulation. Further continuous floor occlusion/architectural overlap remains backlog.

Windows release workflow builds only a deliberate release/<version> branch. It verifies the official runtime hash, full gameplay, PCK inventory, ZIP integrity and exact exported gameplay before creating a new versioned release. An already successful full source gate can be reused only after tracked-file equality is checked (documentation and release orchestration excluded); a running matching gate is awaited. It refuses to replace an existing release. No personal saves or credentials belong in the repository.

# Current session handoff

0.62.0 source milestone on world/keldrath65: Keldrath residential galleries, connected household floors, collision and clean-floor pass. Read docs/SESSION_HANDOFF.md, docs/CURRENT_STATUS.md and docs/testing/hold65.md. Previous source checkpoint and releases are preserved. Latest Windows release remains 0.61.2.
