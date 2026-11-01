# A Dwarf’s Worth

Status: ledger, functional frontier town and local services implemented; native acceptance passed. Wider narrative cast and later story remain queued.

## Deliverable

Start new fortunes in a modest frontier bunkhouse, preserve the personal-room progression, keep Keldrath a later destination. Authored settlement of 10–15 narrative characters plus working background population. Great Claim Ledger with actual contributions, visible construction and sensible competitor milestones; establish hereditary privileges before the reveal.

## Read before editing

scripts/first_visit99.gd; scripts/worker_lodge100.gd; scripts/roads.gd; scripts/world_zones.gd; scripts/handworks.gd; scripts/people.gd

Also read ../CURRENT_STATUS.md, CHECKPOINT.md, OWNER_DIRECTIVE.md sections relevant to this milestone, and ../DEVELOPMENT.md. Code and fresh test evidence override historical completion claims.

## Acceptance

Play the first 15 minutes; real resource/work transactions and visible projects; no duplicated rewards; rerun gathering, building, menus and saves. Existing fortunes retain geography and progress.

## Guardrail

Do not fake contribution progress with elapsed time or turn the opening into dialogue-only tutorials.

## Checkpoint record

Record implementation commits, state keys/migrations, tests actually run, reviewed captures, incomplete items and exact next action here before moving on.

Foundation implemented in great_claim102.gd: additive new-fortune entry, bounded real work credit, local atomic donations, three permanent visible furnishing projects, milestone-based competitor totals, early hereditary law. Old saves receive no silent enrollment. This does not yet deliver the frontier opening, full 10–15 authored cast, Skarrin interactions or local services. Keep Keldrath reachable until those services and subsequent chapters are ready.

Native acceptance: ledger 79, disciplines 38, firstvisit99 23, lodge100 48; all passed. Final ledger case repeated after visual refinement; reviewed ledger and both trail improvement captures. See ../testing/great-claim101/acceptance.json.

## Frontier town implementation, 2026-11-01

New fortunes now start in Stonebridge's real two-floor bunkhouse, with the private room above. Ordinary building instances provide the communal forge, survey hall/archive and watch house/stores. Existing Wayfarer's Hearth, Pinewood yard, Greenhearth and Old Workings complete the town's working destinations. A marked, partly laid storehouse foundation becomes a functional public building after a material contribution. Paths connect actual doors and work areas; the old Keldrath gateway façade is absent here.

Every town shell is in the same catalogue the player uses. Public records are protected from demolition/material recovery; ownership does not require a separate art or construction system. The survey hall and bunkhouse have real aligned stairs and accessible upper floors. Player plans and piece construction retain their existing Z rules.

The home milestone is specified separately in 02b-player-home.md. Ivar handles real commissions locally, the forge consumes ore/coal, the survey hall handles research, and stores trade supplies/seeds with the existing purse and market stock. Keldrath is gated for this new opening; old fortunes retain their original geography. Skarrin and Edda join the supporting cast; Skarrin's friendship is capped below trusted respect.

State owner: surface.frontier103, version 1. Stable building IDs reference surface.architecture86. Existing surface.great_claim102 and first_visit99 remain authoritative for contribution/first-shift facts. The household permit uses the existing claim terrain/storage owners but means residential tenure at this story stage. Later Thaneship must preserve the same records.
