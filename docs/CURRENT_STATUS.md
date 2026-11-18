# Current status — clarity196 isolated candidate

Public Windows release remains 0.124.0. Source baseline: master 1a5633176866f744f9292bc3b06c72c275278f84. Local branch: clarity/player-language196. See CLARITY196.md.

The 0.125 presentation checkout and its local recovery bundle are missing from this session. GitHub has no presentation/holding191 ref. This branch is a clarity/research-visibility patch over recovered 0.124; it does not contain or replace the approved Mason’s Book and other 0.125 visuals. Integration with that source remains blocked.

Implemented practical menu/style/building/skill/research labels, aligned notifications, functional building descriptions and actual optional furnishing lists. Named town destinations, stable save IDs and existing owned buildings remain intact. New prefab technology requirements: multi-storey homes need Stoneworking; workshops need Precision forging; halls need Fine masonry. Basic single-storey homes remain available. Selection and commit guards prevent stale callbacks from bypassing research. Known but unaffordable plans stay visible. Furniture/recipes hide entries locked by their existing research/collection rules. No new NPC services, costs or save schema.

Godot 4.4.1 import and 143 focused assertions passed: architecture_style 69, menu_quality100 36, disciplines 38 at test-results/clarity196-r1. Output policy and whitespace checks passed. Building details and final skill-progress captions reviewed. Final menu_quality100 repeated at clarity196-final: 36 passed, no script errors. Full source/package and Windows validation are not claimed.

Earlier automatic approval review required fresh explicit authorization to publish source/reference changes. No upload, PR, merge or release attempted. A durable remote backup is not yet established for this isolated candidate. Preserve this work separately; do not overwrite the missing visual branch with the older base.

Prior verified delivery: history/CURRENT_STATUS-before-clarity196.md.
