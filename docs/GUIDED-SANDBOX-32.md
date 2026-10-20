# Guided sandbox foundation: 0.32.0

Keldrath's recurring cast is authored and visually stable. Ivar, Orla, Hedrik,
Borin, Eldric, Brann and Eirik have fixed profiles across world seeds. The six
existing named recruit candidates also keep fixed identities. Existing saves
receive these canonical profiles when a named NPC is looked up.

Four additional candidates are generated once per fortune and saved. They cover
mining, smithing, engineering and surveying. Names, appearance and authored voice
archetypes vary by seed. Their dialogue uses the game's ordinary personality,
gender and relationship substitutions. They can be hired, assigned work,
tracked and helped with a personal project like the named recruits.

## Claim business

The system checks actual claim conditions every five active play seconds. It
offers one matter at a time and waits 45 active play seconds after resolution
before offering another eligible matter. Offers do not interrupt play. There
are no deadlines. Defer keeps the matter available; decline records the choice
without material cost or a trust penalty. Decisions must be made at the claim.

| Matter | Eligibility | Choices and consequences |
| --- | --- | --- |
| A place at the table | Owned camp and a hired dwarf | Share 4 provisions and 2 water; add 4 timber for a permanent visible common table. |
| A seam worth keeping | Player or crew actually works ore, with an exposed surviving seam and a miner or surveyor | Spend 1 copper and 1 provision to mark a named working, or build a normal anchored roof frame beside the face and report it. |
| The sound of a good workshop | Stage 2 camp, queued production, smith or engineer | 2 parts and 1 copper calibrate supplied workshop assistance by 5%; alternatively 4 timber and 2 provisions add a visible rack and 240 productive seconds of assistance. |
| An address worth remembering | Stage 3 freight beacon and a hired dwarf | Deliver a seed-selected order of common resources for 110 crowns. |

Support reports require the actual geology, a nearby surviving ore body, a
recorded constructed frame, its complete lintel and solid footings. A floating
or demolished support cannot complete the request. A depleted or inaccessible
working can be declined instead of forcing an impossible objective.

Successful matters add 2 percentage points of contribution for the participating
dwarf, capped at 6 points. Material costs and rewards apply once. Decisions,
participants, markers, furnishings and trust are stored under the world seed
and claim identity, with a readable Chronicle entry. Save/load preserves these.

## Scope

These are four authored, condition-driven templates, not unlimited generated
quests. The current game still has its existing claim progression. This change
does not add multi-planet ownership, autonomous narrative generation, marriage
or a complete galactic economy. Its data model separates local histories so
future settlements can reuse templates without sharing decisions accidentally.

## Validation

Automated checks cover contrasting world seeds, stable cast, generated crews,
real ore and construction, local decisions, material payment, once-only rewards,
furnishings, contribution, save/load and menu rendering. Two different fortunes
were exercised with different supper and seam decisions. Native Godot captures
were reviewed for the claim panels and illustrated anniversary. The Windows
runtime is included but has not been executed on Windows in this environment.
