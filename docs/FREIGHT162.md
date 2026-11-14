# Household freight

Released in 0.112.0 through [PR #163](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/163). CURRENT_STATUS.md records the verified delivery.

Choose **O → Plan Your Holding → Freight for the household** on your claim. Select a recruited miner, direction, material, marked mine stockpile and a chest on the selected floor. In the mine, U away from the entrance and wheelbarrow marks a stockpile. Household chests are existing furniture; create and stock them normally. Routes carry stack items, not Handworks raw-load records or communal supplies.

A trip carries up to 32 units. The original worker walks to the source, picks up only available stock, follows actual clear passages and stairs, then deposits at the destination. Freight yields to existing masonry cargo and unladen rest periods. Carried loads finish before rest; provisions use the ordinary crew food supply. Mine assignment and household berth remain unchanged. Bots and other worksites are excluded.

Orders live additively in the claim building's freight162 dictionary. A carried load has exactly one owner there; source and destination keep their existing item dictionaries. Crew position/floor remains in the established crew record. Paths are transient and recalculated after reload. Stops finish the current delivery; return commands physically bring the load to its source. A missing or obstructed destination retains the load. Restore access or return it; an unrecruited/reassigned carrier waits until assigned as a miner again. A laden order cannot be replaced.

Freight does not make stored supplies available to remote crafting. Wheelbarrows remain underground. Existing manually carried cargo, mine furniture, room construction and saves keep their owners. No new mine depths, free excavation, property narrative or raw-load automation is introduced.

Acceptance: freight162 exercises the actual book control, paid rooms/stairs/furniture, existing stockpile and chest actions, both directions, partial loads, mine and upstairs cold reloads, dynamic obstructions, deeper ladders, stop/return, removed chests, legacy-site rejection and exact cargo conservation. Native preflight passed 43 freight assertions, 33 existing worker assertions and 49 cellar assertions; all 42 tooling tests passed. Reviewed native screenshots cover the book, upstairs crate and perspective-mine crate. All full source/package gates passed for 0.112.0; ordinary Windows performance and play feel remain player checks.
