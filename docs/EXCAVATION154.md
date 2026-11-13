# Underground blueprints — Stage B

Released in **0.108.0** through [PR #154](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/154).

Extends the existing mine's Living Works book (O) with Plan Your Holding and a Plans tab. Drag saved chamber/corridor rectangles, optionally label them, mine with normal tools, then prepare the cleared chamber for existing furnishings and finishes. The first Stage C slice adds [home/cellar connections](CELLAR156.md) in 0.109.0; [upper-floor planning](UPPER158.md) followed in 0.110.0. Unified worker/freight integration remains future work.

## Ownership and conservation

Plans live in the site-local Deepworks `blueprints154` record. They do not own or replace terrain, mining damage, ore, cargo, furnishings, storage or worker data. Costs are physical finish coverage, with no fabricated aboveground shell around bedrock. Finishing uses LivingWorks research, material payments and surface records, within player reach. Removing a guide preserves the actual room and all possessions.

Rectangles are 3–20 tiles per side; 64 plans are supported per mine without truncating existing records. Physical mining locks structural redraw; new rectangles extend the work. Plans reject faults, reserved adits, landmarks and overlapping floor space. Existing excavations reduce work remaining. The planning map reveals only surveyed terrain; world guides use surveyed cells.

Cleared plans become ordinary LivingWorks rooms with optional designations. Installed furniture determines workshop/bedroom worker roles; an undesignated chamber can contain mixed equipment. Existing masonry assignments, furnishing, production and physical storage remain their authoritative owners. This stage does not automate excavation or create worker mining rewards.

## Stairs and limits

Stair guides connect adjacent levels within the original five depths. Cross-shaped guides appear on both levels. Both five-tile landings must already be excavated and walkable before fitting through the existing stair owner. Reach the lower landing through existing mine access and mine it normally. Blueprint stair fitting cannot delete rock or grant yields. Existing manual stair construction and lateral mineworks adits remain available. No surface-to-mine estate connection or additional levels are introduced.

## Acceptance in progress

The native excavation154 case covers GUI dragging, unchanged terrain/resources on planning, interrupted mining and actual reload, connected chamber excavation, exact finish costs/research/idempotence, actual workstation use and stocked storage, worker movement, guide removal and stair travel/reload. It joins the full source and exact-package manifests. Focused native Godot 4.4.1 acceptance passed 233 assertions: excavation154 60, navigation94 31, blueprints152 61, mineworks143 43 and mining 38. Tooling passed 42 tests. Native planner, furnished chamber, distinct stone walls and stair/finish controls were visually reviewed. Map inspection exposed a lazy metadata mutation; initialization now creates the additive planning record before map viewing. Full source and exact-package release gates are separate; see [CURRENT_STATUS](CURRENT_STATUS.md) for verified delivery.
