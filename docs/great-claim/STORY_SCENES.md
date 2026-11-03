# Short scenes in a playable world

The owner's presentation direction applies throughout the story: notable beats should include brief, enjoyable in-game scenes. Use the established whole-character artwork, actual locations, actor movement and a visible action. Let the player read at their own pace, then return promptly to useful play. Keep ordinary conversations ordinary.

## Implemented in the rightful-claimant chapter

| Beat | Visible action | Return to play |
| --- | --- | --- |
| Public challenge | Ivar and the workers gather beside both claimants' lift frames; Skarrin steps forward. | The player reads drawings, selects fittings and physically builds the lift. |
| Proof load and verdict | Both crates rise; Skarrin's unsecured load drops back while the player's catch holds. Ivar offers Master of Works; Skarrin refuses and walks away. | The western road opens. The household and its belongings remain in place. |
| First journey | The player and Ivar walk west; the next shot frames the actual King's Gate and its neighboring streets. | Free exploration of all three wards, including their seamless stairs. |
| Royal reception | Eirik rises from the throne and walks down the aisle to receive the claimant. | Free exploration or the road home. No early Thaneship is granted. |

The reception prepares for the formal investiture; it does not replace the interrupted ceremony in milestone 05. The completed-chapter journal does not reveal that future interruption.

## Thaneship presentation in implementation 131

The interrupted procession, visible gate breach, royal intervention and trophy return, trial, investiture and same-world homecoming now have staged scenes. The invasion has playable battles and practical rescue/defense objectives. Explicit duel and trial decisions cannot be skipped. Acceptance is in progress; see [Thane opening](THANESHIP_OPENING.md).

## Next presentation work after the opening chapter

- **Household expansion:** courtship conclusions, marriage and the first shared hearth remain future work. Preserve the player's chosen house, possessions, partner and relationships.
- **Earlier-story polish:** the rescue's homecoming celebration and ancestry authentication are suitable for brief staged scenes when that chapter is revisited. Their existing playable rescue and evidence-gathering remain authoritative; current text panels are not completed cinematic staging.

The Thane homecoming is the stopping point for opening-chapter expansion. Review the whole chapter's pacing, clarity and presentation before adding these later systems.

## Recovery and continuity

`HoldClaimScene127` currently uses the existing `HoldOpeningScene` pause/input boundary and the surface's depth-sorted actor rendering. Each saved beat restages its current movement after a load. Scene completion is idempotent. Continue waits for the current movement; Skip completes that scene without bypassing construction requirements. Session changes remove old staged nodes, and resumed scenes hide interactive HUD controls immediately.

For new scenes, test both normal completion and interruption: save during motion, reload, skip, leave to title, and resume. Check actor routes against current buildings, prevent duplicate residents, preserve camera/actor continuity, and restore control and HUD state. Give useful feedback when a carried load or attached cart prevents joining a scene. Test the real movement and interaction paths, not only direct state transitions.

Use religious customs sparingly where an oath, family gathering or remembrance naturally calls for them. Ordinary craftsmanship and fellowship already express the culture; most lines need no divine reference. See [Dwarven religion](../lore/DWARVEN_RELIGION.md).

## Friendship scenes

Friendship milestones now have their own optional staged moments. See [Friendship stories](FRIENDSHIP_STORIES.md) for scope, task/reward ownership and the table-flip incident. These do not replace the remaining main-story milestones or add romance prerequisites.
