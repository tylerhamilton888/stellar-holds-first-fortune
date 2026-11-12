# Underground blueprints — Stage B candidate

Extends the existing mine's Living Works book (O) with Plan Your Holding and a Plans tab. Drag saved chamber/corridor rectangles, optionally label them, mine with normal tools, then prepare the cleared chamber for existing furnishings and finishes. Stage C surface/underground estate integration remains deferred.

## Ownership and conservation

Plans live in the site-local Deepworks `blueprints154` record. They do not own or replace terrain, mining damage, ore, cargo, furnishings, storage or worker data. Costs are physical finish coverage, with no fabricated aboveground shell around bedrock. Finishing uses LivingWorks research, material payments and surface records, within player reach. Removing a guide preserves the actual room and all possessions.

Rectangles are 3–20 tiles per side; 64 plans are supported per mine without truncating existing records. Physical mining locks structural redraw; new rectangles extend the work. Plans reject faults, reserved adits, landmarks and overlapping floor space. Existing excavations reduce work remaining. The planning map reveals only surveyed terrain; world guides use surveyed cells.

Cleared plans become ordinary LivingWorks rooms with optional designations. Installed furniture determines workshop/bedroom worker roles; an undesignated chamber can contain mixed equipment. Existing masonry assignments, furnishing, production and physical storage remain their authoritative owners. This stage does not automate excavation or create worker mining rewards.

## Stairs and limits

Stair guides connect adjacent levels within the original five depths. Cross-shaped guides appear on both levels. Both five-tile landings must already be excavated and walkable before fitting through the existing stair owner. Reach the lower landing through existing mine access and mine it normally. Blueprint stair fitting cannot delete rock or grant yields. Existing manual stair construction and lateral mineworks adits remain available. No surface-to-mine estate connection or additional levels are introduced.

## Acceptance in progress

The native excavation154 case covers GUI dragging, unchanged terrain/resources on planning, interrupted mining and actual reload, connected chamber excavation, exact finish costs/research/idempotence, actual workstation use and stocked storage, worker movement, guide removal and stair travel/reload. It joins the full source and exact-package manifests. The first complete native case passed 59 assertions; current affected regressions are in progress. Review of the furnished chamber prompted a wall-art distinction and guides on both stair landings; those final visuals still require a rerun. Tooling passed 42 tests. Do not call this candidate released until the normal release gates pass.
