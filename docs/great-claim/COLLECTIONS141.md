# 0.101.0 — Collections of the hold

Three optional profession collections live in the Hold’s Ledger, after the first paid shift. Deliver carried goods you produced; each delivery spends the existing shared work allowance, so trade seals and bridge orders cannot reuse it. Partial deliveries and rewards survive save/load. No deadline, campaign marks, trade seals, research grants or mandatory campaign gates are added. Collections remain available after authentication.

| Collection | Deliveries | Completion proof | Reward |
| --- | --- | --- | --- |
| Miner | 6 iron ore, 6 copper ore, 4 coal, 6 dressed stone, 2 crystal | Stoneworking; two deeper-floor crystal processed | Reusable Surveyor’s dressed-stone recipe: 5 stone + 1 water → 3 dressed stone |
| Smith | 4 iron, 3 copper, 4 machine parts, 12 cartridges | Lit forge, Precision forging, steel pick, combat introduction | One tempered hammer instance; current equipment stays selected |
| Hearthkeeper | 6 provisions and either 4 turnips + 4 barley, or 4 trout + 4 perch | Field kit, two cooked meals, furnished room or registered home | Supper-table plan and its first 6 timber + 2 stone; works with shared meals and dining comfort |

Choose garden or river before the first Hearthkeeper delivery. The choice then persists with its escrow. Each completed page keeps a signed acknowledgment from Edda, Borin or Maren. The existing research gates, lessons, civic restoration and later story owners remain authoritative.

State: `surface.collections141` version 1 stores paid slots, claimed IDs and the chosen route. Production remains in Work132; equipment remains in Equipment93; crafting remains in State; placing/moving/recovering furniture remains in Surface. No existing resource paths or art assets are replaced.

Validation: `collections141` checks the new behavior and affected ledger/work/campaign/restoration/equipment/menu cases. The new focused case also belongs to gameplay-2 and the exact-pack harness. Automated checks cover payment/locality, invalid inputs, partial reload, reward duplication, actual research/crafting/equipment, both food routes, real table placement/shared meals, migration and closed-contest access. Human normal-speed pacing remains unverified.
