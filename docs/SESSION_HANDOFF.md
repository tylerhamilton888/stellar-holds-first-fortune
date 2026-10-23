# 0.71.0 — Beneath the Stone Crown: locally verified, publication pending

Recovered the frozen session into isolated branch feature/royal79-recovered. Expanded King's Hall, royal walking/sitting, the in-world audience, mounted signs, grounded ward surrounds and the relocated King's Gate are implemented. Fixed dialogue advancement restarting the player's entrance. Native royal verification passes 72 assertions; all 15 exact-export cases pass 693 assertions. Original artwork, progression and saves are preserved. Full hosted source/release gates and publication remain pending explicit repository/payload authorization required by automatic approval review. See ROYAL_HALL.md and testing/royal79.md.

# 0.70.0 — Hearth & Homestead: published, verified and merged

Continue from main f058b996473324ad15f7edfc6956c6fdad86c3f0 (PR #26). Its tree 35109513bc14533c7cb3ccd2e10229e28e2af3d4 matches verified source 6f595bac649ac266c989a1fe2e3d45c0bed52fb9. Rivers replace the proposed isolated pools: fish along accessible banks at the claim, Stonebridge and Greenhearth. Four forgiving crops, four meals, home comfort, mastery techniques and Hedrik's optional supper favor are implemented. Existing saves and approved characters remain intact.

Hosted source run 39979630313 passed import and all 23 gameplay cases. Release run 39980955955 attempt 2 passed all 14 exact-export cases and published one complete Windows ZIP. Uploaded size 719,947,148 bytes and SHA256 61f85acd1c343c2b9386c0a7842adbc265f719ea9aa4a108562cc32ef0b7d2d2 match the hosted build report and release asset digest. Download: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.70.0. The first attempt's GitHub HTTP 500 was resolved by retrying; no old release was replaced.

Local focused/regression checks passed 492 assertions across 12 cases; exact-export homestead passed 69. Hosted export gardening, watering, riverbank, kitchen and home visuals reviewed. Downloaded attempt-1 evidence SHA256: 8c6be951b8e79feeb515ae3d89f086fac7bb29439d9e34bcd1c571fc06a3adb7. Prior checkpoints remain intact. See testing/homestead78.md for recovery and limitations.

# 0.69.0 — Stone & Hearth: published and merged

Source run 39963593854 and release run 39963621454 passed. Published single Windows ZIP: 719,902,750 bytes; SHA256 d08e3a3d73a07fc5935b2afe1fd90709fcfdb8df310507c99b72025ceb0054fb, matching hosted build report and asset digest. PR #25 merged at 80edbc423f50de8e3cedaa80f47f72a719149660; tree 6d79f1670a2e8fcd3f9ec3f64b850f37f733f469 matches the locally reviewed source/export. The earlier upload block was resolved by explicit owner approval. Recovery/pre-homestead78 and local pre-homestead78 preserve the complete released source; prior recovery archives/bundles remain intact.

# 0.68.1 — Honest Work: published, verified and runtime merged

The extra player bucket and legacy rock/arm overlay are removed. Existing personal cargo, shoulder loads and approved whole-character artwork remain intact. Five fixed workshop props now have level fronts and upright supports, shared by live equipment, construction previews and the workshop board.

Player-operated stonebreakers and sawbenches deliver completed output directly into the pack, including normal mastery bonuses. Plain E collects older output left on a bench. Racks, pallets and carts retain deliberate storage transfers; hold crew materials remain protected. Partial jobs, recipes, work credit and saves keep their existing records. First-shift guidance advances on automatic collection.

One complete Windows ZIP is published at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.68.1. Its 714,596,045 bytes and SHA-256 af5774d5d3379fe4fd72fbda0767ab1adb8774bf7227dd597b7e1665e9af22bd match the clean hosted build report and uploaded asset digest. Tag v0.68.1 preserves source 6da44ffe28fb6b4cf8f1f639293b872285944ac4, tree 8e253d392ad1a6423a3ba6ab916e80f96b073309.

Hosted source run 39879928695 passed import and all 21 gameplay cases: 810 assertions. Release run 39880976032 passed the 3,219-entry PCK audit and all 12 exact-package cases: 503 assertions. Downloaded evidence digests were verified and accepted logs contain no script errors or leaks. Local focused verification passed 314 assertions and local exact-package verification passed 503. Native source, local export and hosted export visuals were reviewed. See testing/work76.md and testing/work76.

PR #23 merged at 045486ddeb1e560eebccb052143b96377d5ffcf0 with the identical verified runtime tree 8e253d392ad1a6423a3ba6ab916e80f96b073309. Continue from GitHub main after integrating the separate delivery documentation. On 2026-10-23 the owner explicitly authorized merging directed work after required testing and review; no separate routine merge confirmation is needed.

Baseline: local pre-work76 at 53cdc61845e8eaebacc65a4d6ac287fc832bb8f3; its verified incremental bundle requires 209408538d2fe62773175b27d6313a17db8a8cff. Final delivery checkpoint: verified-work76-delivery, with a local incremental bundle requiring pre-work76 and a persistent GitHub recovery branch. Earlier checkpoints/releases remain intact. Windows hardware performance/audio and final visual acceptance remain player testing.

Latest player feedback: Keldrath buildings feel repeated. The audit confirms repeated household names/fronts/interior templates and two shared public-façade pairs; public service doors are unique. See KELDRATH_IDENTITY_AUDIT.md. This diagnosis is recorded for a focused town identity pass, not claimed fixed by Honest Work.

# 0.68.0 — Roads & Hearths: published and verified

The giant-avatar travel map is no longer part of play. Walk through character-scale paths, gates, mine arches and ordinary doorways; G opens directions. Stonebridge has a wayside hearth, kitchen/storage, bridge supplies and mine staging; Pinewood adds loan processing and timber orders; Greenhearth adds a permanent four-bed allotment, farmhouse services and produce orders. Six residents use the approved whole-character artwork. Existing saves, excavation, inventory, cargo, claims and progression are preserved.

One complete Windows ZIP is published at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.68.0. Its 709,006,709 bytes and SHA-256 6381876c2532a492dfe3ebc0ebca5d3b9ef93c61340cc31d598eb6a8a139284b match the clean hosted build report and uploaded asset digest. Tag v0.68.0 preserves source a64af2e41dd5d645833173f1020ecafe452fe649. PR #21 merged at ea38817cb27fe90ae531b1f037926b0be2af2c73 with identical tree 441ba3da8dfa177cb546e6e3888d2aa10a80730d.

Hosted source run 39870961710 passed import and all 20 gameplay cases: 784 assertions. Release run 39870964362 passed the 3,208-entry PCK audit and all 11 exact-package cases: 477 assertions. Native visuals were reviewed, and nine supplementary local exported kitchen/lease/cargo checks passed. Clean hosted logs contain no script errors or leak messages. Earlier runs hit execution time limits; final gates passed after increasing only CI budgets. See testing/roads75.md and testing/roads75.

Continue from GitHub main. Recovery/pre-world75 preserves the pre-change main checkpoint 1e2374f2cd87f9a4830923c4dc31136e0638eb03. Final recovery: verified-world75-delivery (separately verified local incremental bundle requiring pre-world75, plus a persistent GitHub recovery branch). Older releases/checkpoints remain intact. Scenes still load individually; local residents are ambient. Next: player review of crossing readability, countryside density and work pacing. The work-board keyboard-help footer can extend below 1280×720; its primary controls remain visible and tested. Windows hardware performance/audio remain device playtesting.

# 0.67.1 — Familiar Faces: published and verified

One complete Windows ZIP is available at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.67.1. Its 708,989,468 bytes and SHA256 a521b291b52e43789d6d61905868c8390ce2a987fa6ad916273a93c106c72bdb match the clean hosted build report.

Town walk contacts now inherit canonical corrected artwork, preventing retired beard/hair drawings from reappearing. Measured hair and passing-pose calibration, complete bare-crown/high-ponytail side walks, corrected greatbeard utility crops and shared whole-character rendering preserve identity. Character creation previews standing, walking, working and carrying with turn controls. Existing saves, names, sculpts, inventories and work mechanics are unchanged; corrected derived artwork prepares a new cache on first use.

Native appearance checks passed 64 assertions and related core checks passed 104; the same 64 appearance checks also passed against the local exported PCK. All fourteen identity boards plus creator, town and tavern scenes were visually reviewed. Hosted source run 39837733726 passed 704 checks across 19 cases. Release run 39837735551 attempt 2 passed 10 exact-package cases (397 checks) and published successfully. Release source e6f23d7829ad121b82475350bc4edbe6c4588d85 and PR #19 merge e9b8239f9a959e4ff2fbc6895aec9a6d79271a88 share tree 96510cc5e2023b03aa82011e17e919fba9a720fd.

Continue from GitHub main. Pre-change recovery/pre-appearance74 and all older versions remain intact. Final recovery checkpoint: verified-appearance74-delivery (separately verified local incremental bundle requiring pre-firsthour73, plus persistent GitHub recovery branch). Evidence: testing/appearance74. Windows device performance, sound and final artistic acceptance remain player testing. This repairs source selection and specific poses; it is not a redraw of the entire animation library.

# 0.67.0 — A Good Day’s Work: published and verified

One complete Windows ZIP is available at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.67.0. Its 707,638,184 bytes and SHA256 d77216cc175bc2f3729ced90c666aa27c8678fbdf4397ab14e00b26aa0d5951b match the clean hosted build report.

Includes physical outdoor workstations and safe work approaches; contextual first-shift guidance and stockpile connection previews; eight starter-quarter furnishing plans (O); reduced interaction and animation-preparation overhead. Existing saves, work yields and approved whole-painted actors are preserved.

Hosted source run 39795166172 passed 640 checks across eighteen cases. Release run 39795998750 attempt 2 passed all nine exact-package cases and published successfully. Local verification passed 401 targeted checks and 333 exact-package checks; native visuals were inspected. The release tag preserves e94f475ca66d363149a89a776728833fa4e2b496. PR #17 merged at 977a1d9b571eb0fef45525f4246e2070f19878b7 with identical tree 5716fad4574e715b134f36b733f9ae19307f3d12.

Continue from GitHub main. Recovery/pre-firsthour73, prior releases and archives remain intact. Final recovery: verified-firsthour73-delivery (local incremental bundle and persistent GitHub branch). Evidence: testing/firsthour73 and testing/firsthour73.md. Next: player feedback on work approaches, lesson clarity, furnishing and repeat transitions. Windows device performance/audio remain playtest items.

# 0.66.0 — Hearth & Stone: published and verified

One complete Windows ZIP is published at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.66.0. Uploaded size 707,549,210 bytes and SHA256 5a1312685202057d74448d759e487770868aa5e0725d25adcdea137a63f31d4a match the clean hosted build report. Tag v0.66.0 points to release source 5af5f8e546546b4e0b06940516afa4aa5b4f57fd. PR #15 merged at 87afd5ee79dbae4b17bcb13bfdf1e58dd5e7da46 with the identical verified tree.

Hosted source run 39707677406 passed import and all seventeen gameplay cases. Release run 39707717931 passed all 3,199 PCK integrity entries and all eight exact-export cases. Local verification passed 311 source checks and 315 exact-package checks; gameplay-scale native visuals were inspected. Evidence: testing/polish72. Windows hardware performance/audio and artistic acceptance remain player-device testing.

Continue from GitHub main. Final local recovery tag verified-polish72-delivery has a separately verified incremental bundle requiring pre-polish72. Earlier backups and releases remain intact. The release tag preserves the delivered source. The user explicitly approved the original texture-sheet upload and isolated import workflow within the agreed scope; import run 39707494879 verified its hashes. Transfer helpers remain on asset/hold72 and are excluded from main and the runtime.

Next: player feedback on free-hand side-walk cadence, front-door collision/readability, room composition and menu navigation. This pass refines existing complete action frames; it does not redraw the entire animation library. No new roof-access gameplay or textile economy was introduced.

# 0.66.0 — implementation record

Local baseline pre-polish72 preserves b8859ccd38b86adc099fdb37af0e85c3e0115514; verified recovery/pre-polish72.bundle requires pre-disciplines71. GitHub recovery/pre-polish72 preserves e9ce5175679b5295fe1e9ab79b8c6396fa4a1ad4. Earlier releases remain untouched. Work branch polish/hold72.

Player and resident free-hand side walking now share the complete passing drawings. Distance-driven stride is 57.2 units per cycle (formerly 78), retaining movement speed, tools and whole painted actors. Building draw order follows the physical front edge so a player outside the wall remains visible. Painted slate roofs, side masonry and rear coping show the existing full collision envelope; mountain bedrock anchors the outer boundaries. Rooms retain their dimensions and saved placements, gaining grouped seating, shelves, lighting and original woven rugs.

Menus have consistent selected peer tabs including Skills, shallow peer navigation, ordinary Back for nested screens, pack search, keyboard-following scroll and explicit personal-menu pause behavior. Art provenance and exact prompt: assets/hold-kit72/README.md. Native targeted suite passed 311 checks, including all wards, representative interiors, escort, resident routes, stairs, held equipment, menus, disciplines and reload. Visuals inspected at gameplay scale. Exact export and hosted delivery subsequently passed; see the verified delivery record above.

# 0.65.0 — Work & Knowledge: published and verified

The complete Windows ZIP is published at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.65.0. Uploaded size 705,326,179 bytes and SHA-256 f6899cf79ba4696720bbe74734fdba052efb4cdcdbfc4a94c49d369eb01b815f match the clean hosted build report. Tag v0.65.0 points to release source 29f73c9ea10630503df56e5c79822e4788f70f44. Runtime PR #13 merged at 29099653e6566003cbf8ee93bc4fbcfc2e28462f with the identical verified tree.

Full hosted source validation 39696445457 passed import and all sixteen gameplay cases. Release run 39696891128 passed the 3,197-entry package audit and all seven exact-export cases. Local verification passed 193 targeted source checks and 240 exact-package checks, with native menu visual review. See testing/disciplines71 for evidence. Windows hardware performance/audio and player acceptance remain device testing.

Continue from GitHub main. Final local checkpoint verified-disciplines71-delivery has a separately verified incremental bundle requiring pre-disciplines71; earlier bundles and releases remain intact. The release tag preserves complete delivered source. Next: player feedback on work pacing, unlock clarity and menu navigation; future dedicated Brewing production and deeper branches remain scoped follow-up work.

# Implemented progression

Thirteen discipline tabs are integrated into the existing game. Open with Y, the inventory, pause menu or Survey Office. Y deliberately leaves underground U unloading and T crew assignment intact. The menu pauses play, keeps its discipline tabs separate from the scrolling details, supports keyboard focus and uses thirteen original vector emblems. Each technique displays its effect, work threshold, research and prerequisite. Learning retains lifetime experience; there is no universal spendable XP currency.

Twelve paths have live work sources; Brewing is explicitly reserved for a future dedicated work loop, with no fake unlocks. Thirteen optional techniques improve physical recovery, processing output, production efficiency, farming/fishing yield, dodge recovery, crew capacity or cart capacity. The eight existing research methods are also shown in their relevant paths and still unlock the existing equipment, construction and industry. Existing research costs and access remain intact. This is an expandable first tier, not a complete endgame tree.

HoldDisciplines owns definitions, eligibility, one-time migration and saved progress in hauling.disciplines. Completed-work hooks stay in gameplay owners. Legacy Miner/Mason/Forester/Smith counters and automatic hauling unlocks remain; the historically combined forestry counter seeds both Forestry and Woodworking once. Existing harvests, catches, cleared threats and crew counts receive credit. New sawing awards Woodworking separately from felling. Overseer mastery is separate from civic appointment and grants no communal stock permission.

Pre-edit local tag/bundle pre-disciplines71 preserves e5759a89376a3d1e08fe0c5c5ef616ca264d37c4 (bundle requires pre-ancestral70). GitHub recovery/pre-disciplines71 preserves remote main 87cc8846a8681e044230ed2853680041927aa072. Old releases and backups remain intact. Read testing/disciplines71.md for verification status. The published Windows release is v0.65.0.

# 0.64.0 — Published and verified

One complete [Windows ZIP](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/download/v0.64.0/Stellar-Holds-First-Fortune-0.64.0-Windows.zip) is published. Size: 705,278,506 bytes; SHA-256 `717d5ba55b3bf01be61731b247901b51157601db8b630b45e9979ace35b79f46` matches the clean hosted build report. Release tag v0.64.0 points to verified source c9958797c2a453bbc26934c5832d1db3d36c0f3d. All fifteen hosted gameplay cases and all six exact-export cases passed. Source run 39679087059; release run 39679089395. PR #11 merged at 3bb211b335c940ddd877c8103e788fbf320af9da with an identical tree. Earlier releases remain intact.

Includes the Three Hearths civic refinement, the practical mine worksite with protected hold stock, and The Stone Remembers: physical rescue, Eldric's evidence-based charter research, Overseer appointment and development-gated investiture as Thane. Existing purchased mountains, excavation and other progress remain preserved. Research and appointment use the existing conversations and journal. Local verification included 239 related source checks, 23 quest/UI checks and 203 exact-package checks. Windows hardware performance/audio and artistic acceptance still require the player's device.

Next: discuss experience gains and readable personal development trees/charts. Current work counters and nine research methods are preserved; no full skill-tree redesign is implemented. See PROGRESSION_NEXT.md, PLAYTEST_GUIDE.md and testing/ancestral70.

Continue from GitHub main. Local history is a recovery graph; never force-replace the remote. Pre-ancestral70 / b2df6bb1eaa541150eaa08c4e87a6e60e939ee37 and earlier bundles are preserved. Verified-ancestral70-pack / 6998163ceb56fc889e229f4b61b03906afa0448c records source/local evidence. The final delivery checkpoint adds hosted evidence and is saved separately as verified-ancestral70-delivery with an incremental bundle requiring pre-ancestral70. The persistent release tag preserves complete delivered source.

Efficiency: finish the exact-pack harness before launching the cold hosted gates. Fixture inlining cannot retain a duplicate helper name; firstshift69 uses press(), leaving the shared key() helper intact. Do not push docs onto an active runtime PR: its diff retriggers full validation. Final evidence belongs in a separate docs-only PR after runtime validation. Cold import plus the complete suite took about 30 minutes; publication ran the six package cases after reusing that exact-source gate. Do not claim pending checks passed.

# Ancestral charter — Overseer to Thane

The Stone Remembers is an additive quest stored in outpost.ancestral_claim. Ivar offers a rescue after the first paid shift and initial audience/next-work conversation. The quest uses an existing depth-1 hold cavern and never overwrites excavated terrain. Open a continuous walkable bypass, speak to the miners with E, and keep their route clear until both reach the entrance. Saved positions/path progress support mid-rescue reloads. The recovered slab then goes to Eldric.

Eldric preserves the tablet; the Lord supplies an archive comparison and Ivar the family registration. Eldric authenticates the ancestral reclamation right to nearby Old Delving, not Keldrath. The Lord appoints an Overseer without a charter purchase. Existing saves keep their selected claim and camp stage. Commercial charters remain an alternative. Complete the workshop/beacon, recruit two Folk and hold 12 food plus 12 water to petition for investiture as Thane. Recognition grants no access to communal stock. This is a playable staged conversation and fieldwork quest, not a bespoke cinematic or a new political simulation.

Personal progression audit: Handworks saves miner/mason/forester/smith counters. Mining awards productive faces; processing awards masonry/forestry jobs. Strong shoulders unlock at 12 miner faces or 8 masonry/forestry jobs; Miner 40 adds controlled section work and cart capacity. The smith counter has no comparable developed branch yet. Technology has nine existing prerequisite-linked methods. Neither is currently a comprehensive personal skill tree. Preserve counters when designing the next progression pass.

New test: ancestral70 in the full gameplay and exact-pack gates. It exercises actual excavation/path connectivity, walking evacuation, mid-rescue saves, evidence prerequisites, local-only interactions, appointment, investiture and old-claim preservation. Verification results must be recorded before release.

# 0.64.0 candidate — First shift and final civic polish

Continue from polish/keldrath68 / PR #11. Pre-edit local tag pre-firstshift69 and recovery/pre-firstshift69.bundle preserve e928483c79f8ff112ba509c027f1344d10d0c5ec. Do not overwrite earlier bundles or force-replace remote history.

FirstShift extends the existing Ivar commission owner, retaining its original panel. The real hold mine now establishes loan Handworks benches and a separate hold-owned crew bay once, without replacing occupied equipment or excavated terrain. New worlds have a larger clear entrance bay; old cell arrays are preserved. The lesson records actual lifting, stocking, processing, collecting and construction events in existing Handworks saves. Ivar can explicitly issue a once-only timber allowance in person. Crew stock, work orders and output remain hold property; no early Lord authority or public reserve access is implemented.

The two painted workers move finite raw records through a real rack and breaker, then rest. This is a bounded demonstration, not a new economy or renewable giveaway. Player benches exclude hold-owned inputs. Visible facility bases participate in player/navigation collision; work approaches go around them. Soft authored lamp pools and restrained vent motion finish the civic composition. Fake inventory-mirroring mine storage art and overlapping context bars were removed.

Run suite firstshift and the exact-pack checker, which now includes the practical introduction. Review all wards, mine work and the J lesson. Source tests, package verification and release publication must be recorded before claiming delivery. The earlier hosted civic gate was cancelled, not passed. v0.63.0 remains the last published build until the new release is verified.

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
