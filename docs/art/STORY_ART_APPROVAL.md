# Story art approval checkpoint

Status: owner accepted the concept direction and authorized translation into the established portrait/sprite system, emphasizing bold shapes, colors and readability. Owner explicitly allowed a representative preview before implementation. First translation proof is in `story-translation/preview.png`; no generated art has yet been wired into gameplay. Review this checkpoint before resuming art production or the next story milestone.

The owner requested bespoke named-character art and four illustrated loading scenes, all presented before implementation. Subsequent direction: keep the male designs, correct Ivar's extra arm, make women less anime and more grounded adults, and allow tasteful open necklines and bare arms without a sexualized aesthetic. Existing in-world models remain the gameplay-scale standard.

## Review set

- A: six courtship candidates — Dagna, Ragnhild, Brynja Brasshaven, Torvik, Ketil, Hakon Ironroot.
- B: frontier cast — Ivar Deepmeasure, Skarrin, Edda, Rurik Stonehand, Sigrid Emberbraid.
- C: Keldrath — Orla Copperkettle, Hedrik Copperkettle, Borin Cinderthumb, Eldric Farspan, Lord Eirik Granitecrown.
- D: road and work crew — Bram, Sten, Brann Rivethand, Dagr Flintrivet, Odrin Slatehand.
- E: companions — Osvik Coilward, Tovan Cairnbolt, Kelvar Ventwright, Yrsa Cinderlace; additional High King design is explicitly provisional, not a newly established personal identity.
- W-revised supersedes the women in A/B/C: Dagna, Ragnhild, Brynja, Orla, Edda, Sigrid. Yrsa already uses the revised direction in E.
- Ivar-corrected supersedes Ivar in B: one arm holds the ledger, the other rests at his side; lamp hangs from the belt.
- L1–L4: mining/hauling, forging/craftsmanship, building a home, riverside gardening/fishing/meal. Illustrated wide scenes, no baked text/UI; lower region reserved for later tips.

Generated previews are presented in the review conversation. These are concept sheets and scene proposals, not complete world sprite sheets or animation sets. Concept direction is now accepted; technical production validation remains necessary. No further routine authorization is required to implement validated assets within this scope.

## Implementation milestones

1. **Complete: concept review.** Owner is reasonably happy with revised cast and all four loading scenes. Translate to the existing game style.
2. **Current: production translation proof.** Dagna, Ivar and Skarrin have simplified fixed-color portraits and four-view idle studies. Mechanical atlas extraction proves readability at 86px portraits/62px figure height. This is not an engine capture. Walk studies repeat extended-leg poses and lack satisfactory passing keys: rejected for runtime use. Preserve the idle/portrait visual direction while repairing movement, then extend to the remaining cast, expressions, work/carry states. Preserve Eirik's established identity. Do not replace existing animations with static frames or switch named identities to generic artwork mid-action.
3. **Loading presentation.** Prepare approved scenes for actual display sizes and UI safe areas. Check readability and transition behavior without baking tips into paintings.
4. **Integration and verification.** Only after approval, wire assets into named profiles and loading view; preserve saves/resource identities; run relevant checks and visually review the game. Record delivery evidence.

The existing player-home milestone remains authoritative: the player's own customizable permanent plot, buildable multi-storey architecture and connected Z-levels. The town must combine functional occupied buildings and works in progress. Loading paintings must respect that language; they do not establish new building mechanics or exempt scenery from the “if you can see it, you can build it too” standard.
