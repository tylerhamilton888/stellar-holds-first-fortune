# A hearth of your own — player-built home milestone

Owner addition, 2026-11-01: the frontier section lasts long enough that the player must earn a permanent space to design and build, rather than remain confined to a furnished bunkhouse room.

Implemented for new frontier fortunes; native acceptance passed; hosted delivery pending.

1. Retain the bunkhouse's private upstairs room while the player settles in.
2. A paid first shift plus two completed civic projects earns a residential permit from Ivar's local shift book. No purchased royal title or Thaneship is implied.
3. The eastern household grounds begin without an automatic cottage or workshop. The player chooses the home site, plan, layout, materials, furniture and connected upper floors, or constructs floors/walls/doors/roof/stairs piece by piece.
4. Register a roofed home with a bed and light/hearth for 60 marks, once. Piece-built homes must be enclosed with a door; disconnected walls or uncovered floors do not qualify.
5. Preserve the plot, stored belongings, design, interiors and Z-levels through saves and subsequent story chapters. Thaneship must expand rights on this same territory, never replace it.

Implementation owners: frontier103.gd for permit and once-only milestone; architecture.gd/building_plans.gd for shared shells and connected room storeys; hearthcraft.gd for piece construction, shelter and stacked walkable floors; surface.gd/hearth.gd for furniture and household use.

Acceptance: local eligibility/payment guards, no free cottage, construct a chosen house through the real placement transaction, enter it, add/climb an upper floor, register once, reload identical rooms; test enclosed/missing-roof/open-wall freeform recognition. Existing household and architecture suites cover structural costs, supports, stair routes and furnishings. Keep public town buildings protected while making their exact plans available to the player.
