# A Home and a Fortune — next milestones

Owner directive received 2026-11-14: [complete supplied text](design/HOME_AND_FORTUNE_DIRECTIVE.md). Building-grid polish was delivered in 0.114.0. The family-origin opening is delivered in 0.115.0; implementation and validation are documented in HOME169.md. The first tool/material slice is delivered in 0.116.0 (TOOLS171.md): reinforced picks, basalt recovery and advanced floor finishing. The first cross-profession manufacturing slice is delivered in 0.117.0 (COMPONENTS173.md): craft or buy hafts, heads and fittings for reinforced-pick assembly. 0.118.0 adds Borin’s first paid commission/acquisition slice (COMMISSIONS175.md); 0.119.0 delivers the first Ledger/sandbox integration slice (LIVELIHOOD177.md). Environmental/experiential polish follows.

## Delivered baseline

0.113.0 already provides surface/underground/upper-floor blueprinting, cellar links, household workers, freight and Ivar’s provisional-use introduction. Retain those systems. The family-origin opening in 0.115.0 supersedes provisional ownership while retaining those building and household systems.

## Delivered in 0.115.0: family-origin opening

The parents bought Old Stonewright’s Rise as a modest gift; Ivar is its practical local guide. New players reach a weathered, usable cottage with basic sleeping/storage with a 5–10 minute arrival target still requiring normal-speed playtesting. First-shift mining becomes an attractive optional opportunity. Two contributions become civic household recognition, not a transfer of land already owned. Add a warm initial parental letter; family purchase remains unrelated to ancestry.

Modify the existing owners, not parallel systems:

- `first_visit99.gd` and `opening_scene.gd`: arrival, initial focus, optional work guidance and saved/skippable staging.
- `frontier103.gd` and `claim_scene127.gd`: current provisional offer, permanent permit, home recognition and Ivar’s property introduction. Reconcile old provisional/permanent saves additively without replaying rewards or revoking rights.
- `surface.gd`, existing architecture/Hearthcraft and chest ownership: seed only a new fortune’s modest dwelling, bed and storage on the same holding. Never seed over an established house or inventory.
- `ledger137.gd`, `work132.gd`, `campaign138.gd` and onboarding/journal text: distinguish ownership from civic registration, credit genuine improvements to the starter home and keep the player’s selected ambition prominent. Audit consumers of permit/home_reward/claim_id before changing semantics.

First implementation slice: save-safe ownership migration plus brief arrival/property introduction, parental letter and modest new-save accommodation; retain the existing crafting economy. Validate through real new-game input, skipping/reloading, both existing tenure states and preservation of household/worker/storage records. Review recognition requirements so the starter dwelling does not automatically pay an improvement reward or force rebuilding. Publish only after the established source/package gates.

## Capability audit and first delivered slice

Start with `geology.gd` hardness, `deepworks_play.gd` mining feedback, `frontier103.gd` tool transactions, `forge147.gd`, `data.gd` research and `excavation_blueprints.gd` material access. Existing steel crafting requires Tempered steel research plus 5 iron and 2 timber; planning already counts basalt tiles blocked by the missing pick. 0.116.0 reconciles mineworks/deepworks messages with the actual requirement to forge the tool. Preserve current steel ownership and saved excavation plans. Extend capabilities only after this shared path is clear; test planning before access, blocked execution and successful work after acquisition.

## Subsequent order

1. Tool capabilities and advanced materials: the first slice is delivered in 0.116.0. Broader advanced-metal and forge-equipment capabilities remain later extensions; preserve planning before acquisition.
2. Cross-profession manufacturing: the first haft/head/fittings chain is delivered in 0.117.0. Broader advanced equipment and additional component uses remain future extensions; keep everyday recipes simple.
3. Specialist commissions and alternative acquisition: the first paid Borin service is implemented in 0.118.0. Personal specialist stories and further techniques remain extensions. Preserve buying, self-making and reliable permanent routes; prevent circular requirements or compulsory friendships.
4. Ledger/sandbox integration: delivered in 0.119.0. Existing facts/deposits count, supplied projects unlock their actual services, and unrelated craft/home gates are removed. Authored rescue safeguards and North Crossing specialist orders remain.
5. Environmental/experiential polish: the 0.120.0 candidate adds a cottage approach, gentler arrival, family milestone letters and lodge reactions without upkeep chores (RISE179.md). Continue with normal-speed review before choosing further interior/environment work.

Preserve the same property through Thaneship, all possessions and story records. The family supplied the beginning; the player builds the fortune. Ordinary Windows playtesting remains necessary throughout.
