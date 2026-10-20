# Weight of the Mountain 0.42.0 verification
Godot 4.4.1 Linux; isolated user directories throughout. This tests the existing main game and its native viewport.

| Gate | Result |
|---|---|
| Pre-change checkpoint | pre-weight-20261018 at 606aa9651d870c2c6166b8a2d654a3d74dcec9f3; full bundle verified before edits |
| Hauling model and real main-game save/economy flow | 34 passed, 0 failed |
| Integrated Deepworks flow | 45 passed, 0 failed |
| Native held mouse, keys and actual UI buttons | 15 passed, 0 failed |
| Pinewood | 53 passed, 0 failed |
| Campaign | 43 passed, 0 failed |
| Existing smoke runner | Title, continuity, slots, granular, controller, opening, outpost, industry passed |
| Native visual review | Anticipation, contact, fracture, filled cart/bucket, haulage board, ledger, stockpile, unloading, lower-level cart/survey and Pinewood inspected |
| Export | Windows PCK generated; native Linux PCK boot/capture verified |
| Final recovery | Full bundle verified and restored into a separate bare repository, fsck checked; ZIP integrity and SHA-256 manifest accompany release |

The hauling test exercises the actual settlement entry, iron breaking, persistent damage/fracture, unchanged stored inventory during extraction, no duplicate rewards, overflow conservation, full-bucket movement, idempotent delivery, original smelting/trade, exact cart construction costs, nearby loading, capacities, physical cart movement, linked stairs, parked depth, remote unloading rejection, stockpile transfer, actual save/load, ledger costs, new ore-lens continuity, three ore yields, an actual 0.41-shaped save upgrade, and separate site ownership.

The native test injects held mouse input into main._process, releases it, moves diagonally, presses V, activates the actual Carve button, descends/ascends, reloads, opens H, activates Build wheelbarrow, presses C, moves with the cart, presses U, opens L, selects the actual Steel button and reloads again. Fixtures supply the cart's construction ingots/timber; ordinary mining and delivery are exercised live. Screenshots use staged cargo to expose fill states and capture phases; these are visual fixtures, not claims of a full unassisted campaign.

During validation, a degenerating debris polygon produced renderer errors at the end of its animation. Proportional vertices fixed it; the subsequent rendered input run had no active-play errors. Depth transitions now clear old debris. A seed-dependent integration fixture assumed one iron face always yielded two ore; it now mines a second real face before testing the unchanged smelting recipe, covering lean deposits too. No resources are injected to satisfy that recipe test.

Selected new/changed source is limited to Deepworks, hauling, main/state integration, tests and documentation. Pinewood code/assets are unchanged. Existing automation retains supplied direct delivery and real floor/stair navigation; no new autonomous hauling simulation is claimed.

Known teardown ObjectDB/resource-in-use warnings and software-renderer VSync warnings remain. Windows execution, real-speaker listening, a real user's historical save, exhaustive campaign completion, long-session balancing, large rail networks and player acceptance of feel are not established by these tests. Rails and ledger reservations are explicitly deferred.
