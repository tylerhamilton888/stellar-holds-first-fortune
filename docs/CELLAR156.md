# Connected home and cellar — Stage C, first slice

Released in **0.109.0** through [PR #156](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/156). See [CURRENT_STATUS](CURRENT_STATUS.md) for verified delivery. The broader Stage C is not complete.

## Ownership and geometry

HoldEstateCellar connects the existing freeform surface home and the existing claim Deepworks. Home building.cellars156 stores up to 16 additive {x,y,built} records. It does not create a new mine, inventory, room model or worker roster. Ground level and mine depth 0 share X/Y tile coordinates; the supported mine boundary limits valid landings. Old homes without this field remain unchanged.

Plan at your feet from either side using the Plans book. Mining and ground-floor construction remain separate work. Fitting requires five clear surface floor tiles, five genuinely excavated lower tiles, a lower route to the existing mine entrance and 4 timber / 2 stone in the pack. The operation pays once, never carves terrain and never creates ore. Unbuilt guides can be removed freely. Built connections stay protected to preserve access.

Shift+E checks both destinations before crossing. The existing scene transitions own travel, cargo and saving. Landing input takes priority over nearby raw-load dressing and the contextual prompt matches that priority. Existing surface furnishings, mine furniture, materials pallets and cargo stay in their established records. New placement and recovery checks keep both landings clear; old obstructions prevent travel instead of silently moving the player elsewhere.

## Boundary of this slice

Household-worker routes were added in 0.111.1; see [crew routes](WORKERS160.md). Recruited miners assigned a real household bed walk through the existing cellar connection while retaining their original roster, mine assignment and storage ownership. Workers at other worksites retain their existing behavior. Carts must still be parked before this household stair; carried supplies may cross, but automated freight and remote stock transfers remain deferred. Upper-floor room-blueprint editing shipped in 0.110.0; see [upper-floor notes](UPPER158.md). Existing manual upper stairs and mine stairs remain available.

## Validation

The cellar156 native/exact-package case builds a surface room, plans a stair through the book, saves an unfinished connection, excavates a cellar through real mining contacts, pays for stairs, traverses actual input, places furnishings and stocked storage, and reloads on both sides. It rejects blocked destinations, missing materials, duplicate payment, remote/cross-site travel, cart crossing and destructive landing placement. Native captures cover the surface stair, underground stair and book controls. Required affected regressions are blueprints152, excavation154 and navigation94; full release gates remain mandatory.

Focused acceptance passed 201 assertions, including 49 in the final cellar case with a recreated game loading the underground save. Tooling passed 42 tests. Full source, exact-package and publication gates passed; published metadata and receipt were independently compared after upload.
