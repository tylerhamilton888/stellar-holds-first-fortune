## Countryside follow-up acceptance

Added six actual local story-menu checks, preservation/idempotence coverage for pre-authored records, four candidate-direction checks and married/unreviewed exclusions. Capture dagna-road-story alongside the existing visuals. Native and exact-export runs remain pending; local gdparse and content consistency passed. No new test suite is needed: people82 already runs in both gates.

# 0.72.0 — Faces of the Hold: implemented, release blocked

PR #35 (feature/folk82) contains the pick continuity correction, shared mine-mouth geometry and readable entrances, authored principal personalities, persistent supporting acquaintances, gifts, paid favors and a People notebook. Latest runtime source: a1a78ba577b1339c475d7862382742a5f12a24e7; runtime tree 567b0d70aa5b02620ca2eeaafb13e30c60fc591c.

Preliminary native preview on cb1ee36d4ba928145388a50927c2bc37355528e2 (run 40133184007, job 120989155104) passed 256 assertions and failed two full-record save/reload comparisons. Actual captured notebook retained the relationships. Final code normalizes JSON numeric counters and moves favor terms to a dedicated screen; those fixes have passed syntax parsing but have NOT yet passed a native rerun. Reviewed preliminary visuals: both entrances, seven male pick sequences, Ivar/neighbor conversations, gift picker and notebook.

GitHub blocked final validation run 40133925376 and the release build before any steps started: “The job was not started because an Actions budget is preventing further use.” Observed directly in the signed-in Actions UI. No billing settings were changed. Complete-source ZIP recovery through the signed-in browser timed out twice; there is no complete local playable checkout.

Do not merge or publish as verified yet. After the owner restores Actions capacity: run full native gameplay (26 cases) and people-preview; review the new favor-details screen; run the exact-export gate (16 cases); verify ZIP/digest and runtime tree; merge PR #35 and record delivery. release/0.72.0 currently points to the runtime source above, and no v0.72.0 release was created. The last published build remains v0.71.2. Local partial-edit bundle folk82-edits.bundle and complete remote recovery/pending-folk82 preserve this checkpoint. Earlier releases/backups remain intact.

# Faces of the Hold — implementation and acceptance

Baseline: main 93eba993e1dd522400145fba89b5bea5eda9be34 (0.71.2). PR #35 / feature/folk82.

`people.gd` owns additive `surface.people` records, created on first local conversation. Six authored principal personas have motives, concerns, familiarity lines, preferences and work reasons. Supporting residents use seeded temperament templates and independent preferences; no per-frame personality generation. `npc_appearances` retains their existing rendered identity. Conversation checks locality for each transfer. The saved world clock supplies separate one-workday talk/gift/favor limits. Gifts consume one pack item; favors consume two requested items and reimburse their listed value. Nothing takes materials from facilities, chests or hold stock. Existing schedules, recruitment traits, services and quests retain their owners.

`mine_entrance.gd` provides the shared footprint, mouth/crossing dimensions, approach tracks and original painted masonry modules. `roads.gd` uses a wider mine-only crossing plane. General room/road portals retain their thresholds.

Inspection found broad adze-like heads in male core 20/23 and utility 0/3/4/7. The approved whole-motion59 pick keys already show a consistent pointed head. Descriptor rest/recovery phases now select those complete frames, with original raised/contact frames retained. No source textures, palettes or cached-image contents changed; no cache invalidation is required. A generated candidate was rejected for missing an identity row and duplicating tools. It is not shipped. The source-inspection workflow records comparison boards.

Acceptance required: people82 source and exact-export case; full gameplay gate; actual entrance, conversation, gift, notebook and pick board review. Tests cover locality, real transfers, daily limits, preferences, familiarity dialogue, identity preservation and save/reload, plus centered/off-center movement and pier collision at both mines. Status pending until CI completes.

Recovery: complete baseline and feature branch are on GitHub. Local folk82 directory contains only retrieved/changed source and is not a complete game checkout. Preserve all older releases and recovery branches.

