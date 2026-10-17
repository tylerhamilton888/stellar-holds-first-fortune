# 0.38.1 playtest corrections

- Removed the painted rectangle and interaction for the office royal stair. Crownward is the royal hall entry and exit. Older saved room-return links are repaired at exit.
- Upward strikes select the raised-arm drawing and its hand socket. The ray can find ceiling material, while reach still uses the actual fixed tool length. Body, tool and foreground fingers use the same work frame. The contact sound still occurs at the impact phase.
- Replaced large concave cave-backing triangulation with opaque column strips following each original surface cell. Rock texture stays fixed in world space. Camera movement and texture alpha cannot expose sky behind the cave.
- Conversation responses sit outside the scrolling text area. Quest details use compact portrait/name/dialogue headers, with marked quest actions and a return-to-conversation choice. Unrelated social requests no longer appear in service screens or Ivar's journal. Remote views are identified as journal or claim-ledger entries. Returning to conversation resets stale menu history.

## Verification

Native Godot checks: 260 passed for overhead selection and actual excavation across ten designs, both facings and three aim offsets; distant target rejection; office shortcut removal; legacy royal exit repair; opaque background sampling across fractional camera offsets and two seeds.

Opening progression: 13 passed through dialogue buttons, including employment, introductions, coal delivery, Crownward audience, second commission, both independent gifts and the exchange. Existing revision checks: 1080 passed.

Visual review includes every upward work pose for a male and female, mine camera movement, office without the stair, Crownward exit, commissions, lessons, local errands, ordinary conversation and anniversary dialogue. Response buttons are checked against the usable screen bounds.

Tested with Godot 4.4.1 on Linux. The supplied official Windows runtime and launcher have not been executed on Windows here.
