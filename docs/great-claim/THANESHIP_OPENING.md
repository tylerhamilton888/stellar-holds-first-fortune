# Opening chapter: worker to Thane

Implementation 131 extends the authenticated-claimant story through Keldrath's defense and a homecoming as Thane. It does not begin marriage or the larger commissioned-district expansion. Those remain the next development chapter after polishing this endpoint.

## Playable sequence

1. After the royal reception, deliver four loaves, four iron and six timber at three marked ward preparations. The player explicitly chooses when to attend the ceremony; there is no calendar deadline.
2. The procession is interrupted. Accept or refuse Skarrin's proposed duel. The response is saved as courage/restraint and acknowledged in the scene; no skip can choose it. The King refuses to let the ceremony become a private wager. A separate gate shot shows the released gate bar and invaders entering.
3. Seven defense fronts span all three existing wards: Oath Court, Copper Kettle refuge, forge pumps, Great Stairs troll, breached gate, service passage and Skarrin. Twelve enemy groups contain 27 combatants, including the player's troll and Skarrin. Enemies use existing attack sectors, line-of-sight, guard/parry/dodge, stagger, armor and persistent wounds.
4. Three fronts require physically leading a familiar character to a refuge after combat. Two require holding E to operate a mechanism. Guards provide limited nearby support but cannot finish enemies for the player. After the player's troll battle, five more arrive and Eirik visibly intervenes while the player continues the defense.
5. Defeat Skarrin in real combat, then place him in custody. Gather the survivors to witness the King's return with the troll trophy. Attend the trial and explicitly choose justice, mercy or lament for his squandered gifts. All three receive distinct acknowledgement; the established guilty verdict and solemn execution remain fixed.
6. A separate investiture grants the saved Thane title. Return through the existing gate and road to the same Stonebridge trial yard for the homecoming. Existing houses, discoveries, belongings, relationships and ordinary activities continue.

## Recovery and rewards

`surface.invasion131` owns preparations, stage/front/wave, choices/reputation, escorted positions, secured fronts, infirmary-ration keys, scene/beat and Thaneship/homecoming. Old welcomed saves enter at preparation. Legacy non-frontier fortunes retain their earlier ancestry route. No new top-level save format is introduced.

Enemy wounds and defeats use stable `invasion131/front/wave/slot` keys in existing combat state. Existing salvage and warrior XP are awarded once by Skirmish. Investiture grants five warrior XP once. Secured fronts restore twenty health. A ward defeat returns the player to the royal infirmary with belongings, secured fronts and enemy progress preserved; infirmary rations are once per front. Ordinary non-invasion rescue rules remain unchanged.

Menus and scenes pause gameplay. Scene beats persist before staging; load restages current motion. Escape stops at any unanswered choice. Repeated completion is inert. Title/fortune changes clear staged actors and restore UI. Manual mechanism progress is transient and safely restarts, without spending materials twice. No civilian death countdown or permanent failure is imposed.

## Pacing and polish boundary

The intended opening spans multiple play sessions: first shift and physical material handling; civic projects; a player-designed home; contribution marks; rescue and ancestral authentication; the engineering contest; Keldrath exploration; preparations and the defense; judgment and homecoming. Friendship, cooking, gardens, fishing and home improvement offer useful pauses throughout.

A first-time player taking part in these activities should have hours of play, but no measured human completion time is claimed. Automated tests accelerate movement and combat and cannot establish that estimate. Do not add day-count locks or inflate material prices just to force a duration. The next owner playtest should record active time per phase, navigation confusion, combat retries and optional activities, then tune the slow or rushed portions.

Polish acceptance for this delivery includes readable journal/HUD instructions, marker and witness framing, real enemy-body clearance, explicit decisions, native visual review, physical interactions, loss/retry, scene recovery and preservation of a built house. Full human pacing, Windows-device performance and audible mix remain playtest items. Broader marriage, supervisors, districts and reconstruction projects are future features, not implied unlocks.

## Presentation ownership

`HoldInvasion131`: progression, local tasks, front spawn definitions and practical recovery.
`HoldThaneScene131` / `HoldThaneLines131`: in-world staging, explicit choice pauses and authored dialogue.
`HoldSkirmish`: authoritative player/enemy contacts and rewards; no duplicate combat engine.

Eirik's battle and trophy-return poses are complete original paintings based on his existing identity. Source and exact prompt: `assets/thane131/PRODUCTION.md`. The execution uses a brief obscured impact, no gore display. Fallen scorched beams mark the damaged streets without destroying player furniture or creating hidden collision blockers.

## Next: full opening-chapter playtest and polish

| Phase | What to record | Polish signal |
| --- | --- | --- |
| First shift and civic work | Active work time, instruction rereads, supply trips | Remove unclear steps and unnecessary backtracking. |
| Home, rescue and ancestry | Building freedom, navigation stalls, rescue retries | Protect player ownership and make the next useful action clear. |
| Contest and Keldrath | Contest retries, ward navigation, ceremony readiness | Keep the handoff into the finale legible without rushing exploration. |
| Invasion and judgment | Combat retries, gear used, escort clarity, scene readability | Tune abrupt difficulty changes; preserve explicit choices and recovery. |
| Thane homecoming | Actual house, belongings, workshops and relationships | Confirm the endpoint feels earned and leaves ordinary play available. |

Play once following the main story with modest gear and once including crafting and friendship detours. Record optional activity time separately. Review camera, motion, sound, skipping and reloads at normal speed. Tune rushed or repetitive stretches before adding the next chapter's districts, marriage and household conclusions.
