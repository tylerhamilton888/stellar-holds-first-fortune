# First-hour refinement verification

Source baseline: 94b2b2e1edb34e6766e6c4e0b677947105456498 (0.66.0). Exact restored tree matches 9fd4c99920fb94f43dafd7f0e67d2800d0ddaf58. Recovery branch and original source archive preserved.

Native tests use Godot 4.4.1, Xvfb/Mesa and isolated saves. First shift: 19 checks; arrival: 20; quarters/letter/equipment persistence: 18. Visual review covers the quarters plans, placed furniture, original bedside/chest/desk, mine worksite and Pinewood equipment. Related native regressions also passed: Handworks 32, loading 19, polish 75 (221 targeted source checks total). The clean local Windows package passed the 3,201-entry audit and all nine exact-pack cases (333 checks). Hosted verification and publication remain pending.

Measured same-source interaction benchmark (100 nearest queries, microseconds): Hearthward 109794 → 22815; quarters 94273 → 16430; tavern 370250 → 44277. Cold queued textures: Hearthward 1068 → 972; quarters 564 → 276; tavern 724 → 492. These are local subsystem measurements, not Windows frame-rate claims. Cold startup remains approximately 2.4–2.5 seconds before queued artwork preparation.

The former saw test assumed a path through a non-solid bench. Solid outdoor bases revealed a blocked diagonal approach. Work now routes around both bench corners; the bounded test includes approach time and still requires the exact two-unit yield. Work duration is unchanged.

New progress is additive under existing surface.facts. Furniture remains in existing surface.decor/chests; equipment remains in hauling facilities. No save deletion or terrain regeneration. Texture cache reuse is restricted to the unchanged artwork revision; cache data is derived and independent of saves.

The first hosted run exposed an old mining fixture that placed facilities under the player. Updated fixtures now stand on clear floor and place loose cart loads beside the cart, preserving normal E priority. All 38 mining checks passed natively after this correction; the runtime safety guard remains enabled. The initial hosted failure is retained in run 39791760681.
