# Friendship stories

Friendship is independently worthwhile. Stories never require or grant romance, patron selection or a marriage commitment. Gifts and ordinary conversations keep their existing rules. No friendship decay, deadlines or missed-visit penalties are added.

## Implemented scope

Twelve authored characters each have three sequential episodes: Alden, Maren, Dagna, Torvik, Ragnhild, Ketil, Brynja, Hakon, Ivar, Borin, Orla and Hedrik. Other residents retain their existing dialogue/favors. Skarrin does not acquire a loyal-friend reward arc.

| Friendship | Episode | Reward |
| --- | --- | --- |
| 5: familiar | A small practical kindness, showing what the character cares about | Useful supplies, 1 relevant discipline XP, saved memory |
| 12: trusted | A more personal task and revealing scene | Useful supplies, 2 relevant discipline XP, saved memory |
| 18: close | A quiet shared moment with no material cost | A small gift and an individually named memory/keepsake entry |

Keepsakes here are journal memories, not tradable inventory items. Physical rewards use existing item IDs. XP enters the existing discipline system with unique event keys; no second skill system is introduced.

## Player flow

A local conversation offers the next unlocked story. Accepting creates a nearby, named E interaction in that location; the story panel and journal identify it. The player brings the listed pack materials, reads the situation and chooses a sensible response. A wrong answer costs nothing and may be reconsidered. Completed practical work is saved. Return to the character and explicitly choose to spend time together, then watch the scene. Items and XP are paid once at scene completion, including Skip. Skipping cannot bypass the task. Accepted stories remain available if friendship falls; later episodes still need their own thresholds.

High-friendship existing saves start with the earliest unplayed episode and may catch up in order. No rewards or introductions are invented on load. Saved beats replay their current motion, then finish without repeating costs or rewards. Returning to title or changing saves clears staged actors.

## Maren: Manners at Supper

At 12 friendship, help set supper at the Wayfarer's Hearth. Two rude miners, associated with Skarrin but not accompanied by him, insult the cook. Maren visibly upends a table and says: “If you're going to act like orcs, you can eat like orcs!” Dagna objects about the table; the men put it right. Maren has saved the covered pot and makes sure the player's meal is warm. After Skarrin's departure, the setup calls them former crewmen rather than implying he has returned.

The scene has a bespoke four-pose, whole-character lift, a visibly rotating table, retreating miners, a reaction and cleanup. No real furniture or possessions are destroyed. The table/plates and extra miners exist only during the scene. Her 18-friendship moment reverses the hospitality: somebody finally makes a place for the cook.

## Presentation and expansion

Use original whole-character art, brief visible movement and readable captions in actual locations. Continue waits for the current action, Escape skips, and control returns promptly. The current non-Maren scenes use small staging, prop inspection and whole-character social poses; there is no recorded dialogue or musical performance audio. Ordinary friendship conversations remain ordinary. Additional cast arcs can extend the stable character/index definitions without resetting saved episodes. Keep faith contextual and occasional.

Runtime owners: `HoldFriendship130` (transactions, availability, journal), `HoldFriendshipStories130` (authored episodes), `HoldFriendScene130` (transient staging). Pending scene and records live additively under `surface.friendship130`. The existing `HoldOpeningScene` boundary pauses gameplay and hides interactive HUD controls.
