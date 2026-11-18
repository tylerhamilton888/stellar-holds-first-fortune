# Current status — clarity196 merged into game source

Public Windows release remains 0.124.0. Source baseline: master 1a5633176866f744f9292bc3b06c72c275278f84. Source merged into master through PR #191 at 2494a0dce48f237f1196664d652d6385c75becc8. See CLARITY196.md.

The 0.125 presentation checkout and its local recovery bundle are missing from this session. GitHub has no presentation/holding191 ref. This branch is a clarity/research-visibility patch over recovered 0.124; it does not contain or replace the approved Mason’s Book and other 0.125 visuals. Integration with that source remains blocked.

Implemented practical menu/style/building/skill/research labels, aligned notifications, functional building descriptions and actual optional furnishing lists. Named town destinations, stable save IDs and existing owned buildings remain intact. New prefab technology requirements: multi-storey homes need Stoneworking; workshops need Precision forging; halls need Fine masonry. Basic single-storey homes remain available. Selection and commit guards prevent stale callbacks from bypassing research. Known but unaffordable plans stay visible. Furniture/recipes hide entries locked by their existing research/collection rules. No new NPC services, costs or save schema.

Godot 4.4.1 import and 143 focused assertions passed: architecture_style 69, menu_quality100 36, disciplines 38 at test-results/clarity196-r1. Output policy and whitespace checks passed. Building details and final skill-progress captions reviewed. Final menu_quality100 repeated at clarity196-final: 36 passed, no script errors. Full source/package and Windows validation are not claimed.

Owner explicitly authorized pushing the changes to the game on 2026-11-18. Source is merged and durably backed up at clarity/player-language196, commit 25c57c7c660c3efad5f236bc09b4c7bf8e65cc27, PR #191. Uploaded tree exactly matches local tested tree 011c64da38cc84469c915ba3d81b7d1093bca6a6. Repository validation: https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/44328310927 (all six jobs passed: tooling, four gameplay groups and aggregate validation). No Windows release attempted. Preserve the missing visual branch if recovered; this patch does not restore it.

Prior verified delivery: history/CURRENT_STATUS-before-clarity196.md.
