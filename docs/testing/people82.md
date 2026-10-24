# Faces of the Hold — implementation and acceptance

Runtime source: f241aee9c728e317572b67c294c45d657185c80d; tree 86fe3856349df5323a019124543e8fc5f7520cb9. PR #35 targets master (renamed from main).

Twelve authored personalities cover six principal characters and six countryside residents. Other household residents retain seeded, persistent personalities. Gifts consume real pack items; small favors consume two requested items and reimburse their listed value. Locality and one-world-day limits apply. The People notebook remembers discovered tastes, relationship history and countryside whereabouts. Dagna staffs the Wayfarer's Hearth inside; familiar greetings retain practical instructions. Four adult, single future romance candidates have dormant metadata only; no dating or marriage is enabled.

The shared mine footprint aligns masonry piers, opening, walk-in threshold and approach tracks at Old Workings and the claim. Pick rest/recovery frames use approved complete pick poses without changing original textures or identity palettes.

## Fixes and focused evidence

JSON numeric story counters are normalized before the narrative-upgrade early return. Invalid prerelease item IDs are repaired without rerolling valid preferences, current valid favors or earned relationship history. All authored and generated preference/work item IDs are checked against the actual item catalogue.

Local native Godot 4.4.1 people-preview passed 380 assertions with zero script errors on the final source. Hosted people-preview passed in run 40137875448, job 121003221541. Coverage includes actual dialogue and transfers, six countryside story menus, staffed interior route, familiar greetings, notebook whereabouts, migration preservation/idempotence, invalid-item repair, dormant candidate eligibility/exclusions, centered/off-center mine entry and pier collision.

Reviewed native captures: both entrances, seven male pick sequences, Ivar/neighbor personality, gift picker, favor terms, People notebook, Dagna's story and familiar welcome, and staffed Hearth. Screens use scrollable panels where necessary.

## Player smoke test

1. Load an existing save, visit the Wayfarer's Hearth, and speak with Dagna inside. Check the bunk, kitchen and storage.
2. Ask a countryside resident about their life and preferences; give an item from your pack or fulfill a paid favor. Open N to find the remembered details and whereabouts.
3. Save and reload, then confirm the same person retains their identity, discovered tastes and familiarity.
4. Approach both mine entrances from the center and slightly off-center. Walk through the visible opening; the masonry piers should remain solid.
5. Mine facing different directions and watch the complete pick swing, including recovery.
6. On Windows, report display resolution, performance, audio issues and unclear menu/dialogue choices.

## Recovery and limits

Complete current source is retained locally in stellar-full and verified bundle stellar-full-verified-people.bundle, and remotely at recovery/people72-native-verified. The local clone/bundle contains the complete current checkout with shallow history, not a full historical mirror. Earlier bundles, recovery branches and releases remain intact.

Native verification uses Linux software rendering and dummy audio. Windows device performance and audible quality still require player testing. Character ambitions described in dialogue are not additional implemented activities.

## Published release verification

Source run 40137875448 passed all 26 gameplay cases and focused people-preview. Release run 40137928083 passed the 3,269-entry PCK audit and all 16 exact-export cases: 1,082 assertions, including 380 in people. Downloaded verification-evidence.tar.gz matched SHA256 745581a8ef475e86d6ac9de0d6439eb49d562302ed0cc03f697acb6d37ed22f8; every packaged result passed with no script errors.

Published v0.72.0 source and PR #35 merge c512e9ec1c1d3a1fbd8dfd5df1a751794719a372 share tree 86fe3856349df5323a019124543e8fc5f7520cb9. Windows ZIP is 725,151,889 bytes with SHA256 13666ead4d977760da6cb05f6eb2dd44d36847e755536a892b331cfec343381d, matching the clean build report and GitHub asset digest.
