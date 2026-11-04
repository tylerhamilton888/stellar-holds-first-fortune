# The North Crossing — restoration139

The rescue leaves a town worth returning to. This Act IV project repairs the old northern span, shortening the route between Old Workings and the survey hall. It is deliberately a real second crossing of the existing river, not an invisible project flag or a replacement for the southern bridge.

## Stages and ownership

1. Return the survey crew and open the Winter Stores. Inspect the west abutment at (1080,510).
2. Deposit 12 dressed stone, 24 timber and 4 iron at the bunkhouse Ledger. Ledger137 owns saved escrow. Dressed stone may be obtained through masonry or trade.
3. Supply three crew shifts through the project book while standing at the Ledger. Repeat one specialty or mix routes. Each shift accepts saved partial deposits; after the first deposit its chosen item is fixed until complete.
4. Return to the west bank and fit the span. The crew does the construction with your supplies; Stoneworking is required. It opens continuous walkable floor between the banks at y=465–535 with physical rails. No second material payment. Recognition is 100 marks once, before authentication; optional work cannot reopen an old closed score.
5. Gather Ivar and Skarrin. Ivar names the contributors; Skarrin claims the original abutments as his achievement, then resents Ivar sharing the credit. A short native scene saves its beat and supports skipping. If Skarrin has already left, Ivar instead acknowledges the completed work without resurrecting him.

| Specialty | Research | Supply per shift | Source |
|---|---|---|---|
| Smith | Precision forging | 4 machine parts | Completed forge jobs |
| Builder | Fine masonry | 20 timber OR 36 stone | Processed player loads |
| Provisioner | Hearthkeeping | 6 bread OR 6 hotpot OR 5 chowder | Completed cooking jobs |

Three shifts have identical narrative value. Their active-play times are not asserted equal. Inventory and the Work132 earned-minus-spent ledger must both cover a delivery. Depositing spends that shared production credit, so earlier trade seals and bridge orders cannot reuse it. Materials are fungible; the system proves cumulative player output, not item-instance provenance. It never consumes nearby storage automatically.

## Campaign and compatibility

Fresh first visits explicitly initialize restoration139 without a legacy exemption. Returning saves first seen at ancestry stage 4 or later preserve their already-earned archive/authentication path. No migration grants a bridge, materials, score or title. For fresh fortunes, family/archive evidence can be researched alongside restoration; final authentication waits until the work has been witnessed. Accepted trial, royal and Thane stages continue unchanged.

State is additive under surface.restoration139: version, inspected, orders, optional order_paid, built, dedicated, scene, beat and legacy. Existing owners retain inventory, escrow, production facts, ancestry, rewards, homes and relationships. The scene subclasses the established claim scene for controls, actor painter and gait, but owns its own saved beat and completion. Existing bridge rendering accepts an optional vertical offset; its default is unchanged.

## Owner playtest

After the rescue and Winter Stores, follow the project from the Ledger. Make a small structural deposit and a partial work-order deposit; save/reload. Try a single trade or switch trades between complete shifts. Check whether requirements explain procurement and research clearly. Walk the finished route from the mine toward the survey hall, gather the crew, then finish ancestry at Edda's desk. Record active time and any dull repetition. Optional legacy work should leave closed scores untouched.

## Acceptance and delivery

Nine affected source cases pass 1,755 assertions; four focused exported cases pass 907. All 3,901 package entries and 13 pipeline unit tests pass. Native and exported visuals were reviewed. All five hosted source jobs and all 64 exported cases (13,917 assertions) passed, including the final identical-build verifier. See [receipt and limits](../testing/restoration139/acceptance.json).

Merged in [PR #125](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/125) as `279ac1648762b18b9f35b622b2a18b6701315edf`. Its tree `48458e516ce5184b160f937478e364e2fe8dcf19` matches the tested source. Head `cd6e68389e34bf3a8361b00197f2c4a356e4cb53`; tested PR merge `f2a1347b8ce6a99afff85deba1fc8feabe86bae6`. [Native run](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41893233736) and [complete package rehearsal](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41893233723) succeeded. Windows 0.97.2 remains published; this work did not publish a new release.
