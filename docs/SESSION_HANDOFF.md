# Session handoff — character and quest scenes candidate

Read CURRENT_STATUS.md and AGENTS.md first. Requested source uploads, PR, merge and verified Windows delivery are authorized. Keep outputs bounded; no subagents unless requested.

## Current work

Branch feature/quest-scenes181 builds on master c755fd174da317e35a0ff85847e15909da05d748, delivered 0.120.0. Version 0.121.0 adds Rurik/Sigrid opening introductions, optional Borin introduction and short forge/Winter Stores/rescue scenes. Quest transactions commit before UI scenes. Additive surface.quest_scene181 owns only pending/seen presentation; old completed quests do not replay. See SCENES181.md.

Pinned import and 42 tooling tests passed. Focused evidence: test-results/scenes181-reviewed (opening146 57, ledger137 48, campaign138 218) plus scenes181-focus/mountain104 (44). Native views checked all speakers and quest presentations; captions fit, portraits refresh and interaction prompts are hidden. Preserve quest locality, rewards, saved-beat resume and skip behavior.

## Next actions

Confirm final focused results, open the source PR, start release/0.121.0 at the reviewed commit, merge only after required checks, verify public metadata and reconcile delivery documentation per RELEASE_PIPELINE.md. Existing release remains 0.120.0 until publication.

Normal Windows pacing/input/audio and the older intermittent freight-route issue remain follow-ups. Keep original estates, belongings, workers, artwork and the authored campaign.

[Previous handoff](history/SESSION_HANDOFF-before-scenes181.md).
