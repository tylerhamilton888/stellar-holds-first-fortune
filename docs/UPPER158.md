# Upper-floor blueprints — Stage C, second slice

Released in **0.110.0** through [PR #158](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/158). See [CURRENT_STATUS](CURRENT_STATUS.md) for delivery status. This extends [surface blueprints](BLUEPRINTS.md) and [home/cellar connections](CELLAR156.md); it does not finish Stage C.

The Building Book selects ground or upper floors 1–4 independently of the player's physical location. The roof deck remains level 5. Rooms may be planned before supports exist; their status distinguishes missing support from missing built stair access. Construction requires visiting the selected floor and actual support/access. Existing roof decks supply already-paid floors.

The additive room `z` field defaults to zero for old saves. Plans, shared boundaries and finish quotes are scoped to their floor. Physical geometry, furnishings, inventory, storage and transactions remain in their existing owners. Planning reads missing levels without creating physical tiles. Removing a guide never removes construction or contents.

Stair guides live in `blueprints152.stairs158`, with lower floor and X/Y. Up to 32 guides and 64 total room plans are supported without truncating old records. Both stair ends must avoid room boundaries. Build locally at the lower landing through the existing builder for 4 timber / 2 stone. E climbs; Shift+E descends. Existing manual stairs also satisfy access checks. Built stairs retain the existing protected recovery rules.

The focused native case exercises stacked plans, support/access warnings, exact payments, physical stair input, furnishing and storage, renovation, cold reload and three-level travel. Existing surface, manor and cellar cases remain regression gates. Focused acceptance passed 208 assertions (upper158 51, blueprints152 61, cellar156 49, blueprint_manor152 47), plus 42 tooling tests. Native floor-picker and furnished-room images were reviewed. Full release validation passed 85 source cases and 75 package cases / 14,452 assertions; see current status for the exact source, run and hashes.

Resident/worker travel across surface and mine, automated freight, new mine depths and property-story integration remain deferred. Normal-speed Windows input, audio, performance and enjoyment still require player testing.
