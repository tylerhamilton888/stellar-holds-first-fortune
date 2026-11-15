# Tools and basalt masonry — 0.116.0 delivered

**Current recipe:** 0.117.0 supersedes the direct raw-material reinforced-pick payment described below with one shaped haft, forged pickhead and fitting set. The total self-made raw cost and owned tools are unchanged. See [component manufacturing](COMPONENTS173.md). In 0.118.0, [Borin’s commissions](COMMISSIONS175.md) offer a paid alternative to learning the manufacturing techniques; requirements below describe self-crafting.

The existing steel pick still costs 5 iron and 2 timber after Tempered steel. Reinforced tools research requires Tempered steel, 6 iron, 3 copper and 65 coins. The pick upgrade then costs 8 iron, 2 copper, 3 coal and 2 timber at the lit communal forge. Neither step consumes materials from behind its own access gate. Existing market purchases provide an alternative source of basalt materials.

## Ownership and behavior

`tool_capabilities.gd` owns shared tool costs, eligibility, local transaction guards, basalt guidance and contact power. The existing `state.steel` remains authoritative. The optional `outpost.reinforced_pick` flag defaults to false and persists through the established save dictionary. Research alone grants neither tool. Duplicate, remote, unresearched or underfunded transactions do not spend materials.

Deepworks pick power progresses from 1.0 to 1.65 to 2.1. Reinforced careful contacts on basalt recover two blocks rather than four ordinary stone. Normal pick/hammer and thermal output remain unchanged. Existing rock kinds and generated/saved geology are not replaced. Raw blocks retain their item identity through Handworks and bulk hauling; both new materials are accepted by pallets and the existing freight item catalogue.

Fine masonry unlocks a recipe (2 basalt blocks + 1 water → 2 dressed basalt) and a dark jointed floor (1 dressed basalt per tile, craft 3). The Living Works painter reuses the existing ashlar joints. Blueprint selection never requires research or stock; execution uses the existing per-surface knowledge/payment checks. The book explains acquisition beside the selected finish.

## Validation and follow-up

The first full release gate caught the new basalt description pushing the inventory summary below the viewport. New entries now retain the established catalogue order, with acquisition guidance in the forge/planning screens. menu92 explicitly checks basalt selection in a full pack.

Extended frontier103 covers local/remote/duplicate/payment guards, research versus forging, actual save reload, blocked basalt, ordinary versus careful yields, physical loads and material production. Extended excavation154 covers advance planning, research/material rejection, exact surface payment and visual floor review. Eight local native cases passed 565 assertions; 42 tooling tests passed. Full source/package release checks passed; CURRENT_STATUS.md records the published evidence. Ordinary Windows input, audio, perceived tool speed and progression balance still need playtesting.

This is the first capability/material slice. Hafts, heads and fittings arrived in 0.117.0; paid specialist commissions are implemented in 0.118.0. Later forge-equipment capabilities remain future work.
