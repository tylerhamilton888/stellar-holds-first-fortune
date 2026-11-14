# A Home and a Fortune — next milestones

Owner directive received 2026-11-14: [complete supplied text](design/HOME_AND_FORTUNE_DIRECTIVE.md). Building-grid polish was delivered in 0.114.0. The owner has now requested the family-origin opening; its 0.115.0 candidate implementation is documented in HOME169.md. Validation/publication are pending.

## Delivered baseline

0.113.0 already provides surface/underground/upper-floor blueprinting, cellar links, household workers, freight and Ivar’s provisional-use introduction. Retain those systems. The new directive supersedes the future story direction of provisional ownership; it does not mean the family-origin opening is already implemented.

## Active milestone: family-origin opening

The parents bought Old Stonewright’s Rise as a modest gift; Ivar is its practical local guide. New players reach a weathered, usable cottage with basic sleeping/storage in roughly 5–10 minutes. First-shift mining becomes an attractive optional opportunity. Two contributions become civic household recognition, not a transfer of land already owned. Add a warm initial parental letter; family purchase remains unrelated to ancestry.

Modify the existing owners, not parallel systems:

- `first_visit99.gd` and `opening_scene.gd`: arrival, initial focus, optional work guidance and saved/skippable staging.
- `frontier103.gd` and `claim_scene127.gd`: current provisional offer, permanent permit, home recognition and Ivar’s property introduction. Reconcile old provisional/permanent saves additively without replaying rewards or revoking rights.
- `surface.gd`, existing architecture/Hearthcraft and chest ownership: seed only a new fortune’s modest dwelling, bed and storage on the same holding. Never seed over an established house or inventory.
- `ledger137.gd`, `work132.gd`, `campaign138.gd` and onboarding/journal text: distinguish ownership from civic registration, credit genuine improvements to the starter home and keep the player’s selected ambition prominent. Audit consumers of permit/home_reward/claim_id before changing semantics.

First implementation slice: save-safe ownership migration plus brief arrival/property introduction, parental letter and modest new-save accommodation; retain the existing crafting economy. Validate through real new-game input, skipping/reloading, both existing tenure states and preservation of household/worker/storage records. Review recognition requirements so the starter dwelling does not automatically pay an improvement reward or force rebuilding. Publish only after the established source/package gates.

## Subsequent order

1. Tool capabilities and advanced materials: extend existing hardness, equipment, research and blueprint requirements; allow ambitious plans before the player can build them.
2. Cross-profession manufacturing: a small useful set of hafts, heads, fittings and advanced equipment; keep everyday recipes simple.
3. Specialist commissions and alternative acquisition: existing NPC mentors, buying, commissioning and reliable permanent routes; prevent circular requirements or compulsory friendships.
4. Ledger/sandbox integration: recognize completed work, give civic projects tangible benefits, and remove arbitrary introductory craft gates while preserving the authored campaign.
5. Environmental/experiential polish: the neglected Rise becomes a personal stronghold; family letters and NPC reactions, without new upkeep chores.

Preserve the same property through Thaneship, all possessions and story records. The family supplied the beginning; the player builds the fortune. Ordinary Windows playtesting remains necessary throughout.
