# Great Claim implementation plan

Owner authorization: implement the full attached directive and six romance candidates, split into milestones with durable checkpoints. OWNER_DIRECTIVE.md preserves the provided source verbatim. The attractiveness and bespoke story-art clarification in ../ROMANCE_CAST.md also applies.

Read CHECKPOINT.md first on every continuation. Read only the active milestone and relevant source owners next. Update the checkpoint after every tested coherent change and before a context handoff. Advance a milestone only after its acceptance criteria pass; a data scaffold or document is not completed gameplay. Preserve original assets, UIDs, stable NPC IDs, existing saves and previous releases.

1. [Six lives at the claim](01-cast-relationships.md) — implemented; native checks passed.
2. [A Dwarf’s Worth](02-frontier-ledger.md) — frontier town and local services implemented; native and full hosted source acceptance passed; merged as PR #74; delivered in 0.92.0.
3. [A hearth of your own](02b-player-home.md) — earned plot, player-designed home and Z-level construction; native and full hosted source acceptance passed; merged as PR #74; delivered in 0.92.0.
4. [The mountain remembers](03-rescue-ancestry.md) — playable rescue/authentication implemented; native, local exported and full hosted source acceptance passed; merged as PR #75. Delivered in 0.92.0; all named story artwork is now complete and included in 0.93.0.
5. [The rightful claimant](04-contest-keldrath.md) — implemented; source PR #101 merged after all five hosted checks; 380 native and 380 exact-export chapter assertions passed. Windows 0.93.0 published.
6. [The King returns](05-invasion-trial.md) — implemented in 131; acceptance in progress.
7. [The First Fortune](06-thaneship-household.md) — investiture/homecoming implemented in 131; acceptance in progress. Marriage and directed-development expansion remain queued.

## Story presentation

Follow [Story scenes](STORY_SCENES.md) for short in-world staging, explicit choice handling, skip/reload recovery and the remaining notable beats. Eight romance candidates are now present, including Alden and Maren.

## Cultural reference

Use [Dwarven religion](../lore/DWARVEN_RELIGION.md) at sensible moments in the remaining milestones. Keep religious references occasional; this reference does not add a new story gate or change milestone order.

## Delivery rules

Keep the game launchable after each phase. Commit and back up coherent work through the existing repository review workflow. Use focused native tests during iteration, full hosted validation for merges, and exact-package checks for Windows publication. If the full story cannot reach a competent standard in one pass, the owner directive explicitly prioritizes a polished vertical slice and durable systems; report the remaining milestone list accurately. Never label the full narrative complete because its outline or flags exist.
