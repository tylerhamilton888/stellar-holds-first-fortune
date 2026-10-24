# Faces of the Hold — implementation and acceptance

Baseline: main 93eba993e1dd522400145fba89b5bea5eda9be34 (0.71.2). PR #35 / feature/folk82.

`people.gd` owns additive `surface.people` records, created on first local conversation. Six authored principal personas have motives, concerns, familiarity lines, preferences and work reasons. Supporting residents use seeded temperament templates and independent preferences; no per-frame personality generation. `npc_appearances` retains their existing rendered identity. Conversation checks locality for each transfer. The saved world clock supplies separate one-workday talk/gift/favor limits. Gifts consume one pack item; favors consume two requested items and reimburse their listed value. Nothing takes materials from facilities, chests or hold stock. Existing schedules, recruitment traits, services and quests retain their owners.

`mine_entrance.gd` provides the shared footprint, mouth/crossing dimensions, approach tracks and original painted masonry modules. `roads.gd` uses a wider mine-only crossing plane. General room/road portals retain their thresholds.

Inspection found broad adze-like heads in male core 20/23 and utility 0/3/4/7. The approved whole-motion59 pick keys already show a consistent pointed head. Descriptor rest/recovery phases now select those complete frames, with original raised/contact frames retained. No source textures, palettes or cached-image contents changed; no cache invalidation is required. A generated candidate was rejected for missing an identity row and duplicating tools. It is not shipped. The source-inspection workflow records comparison boards.

Acceptance required: people82 source and exact-export case; full gameplay gate; actual entrance, conversation, gift, notebook and pick board review. Tests cover locality, real transfers, daily limits, preferences, familiarity dialogue, identity preservation and save/reload, plus centered/off-center movement and pier collision at both mines. Status pending until CI completes.

Recovery: complete baseline and feature branch are on GitHub. Local folk82 directory contains only retrieved/changed source and is not a complete game checkout. Preserve all older releases and recovery branches.
