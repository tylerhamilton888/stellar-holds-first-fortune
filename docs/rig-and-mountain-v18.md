# 0.18: ten complete dwarves and mountain geology

The creator retains separate given and family names. A new worker is not introduced as an existing House or clan. The family record is reserved for future genealogy; `founded` starts false. Marriage, descendants and dynasty progression remain future systems.

## Character assets

Five male and five female integrated designs; hair and beards belong to the drawings, not detached attachments. Women have no facial hair. The seeded population retains an 85% male / 15% female distribution. Portraits remain the existing illustrated system, with corresponding hairstyle choices.

`HoldEquipmentRig.sockets(profile, frame, mode)` exposes head, neck, chest, shoulder, hand and boots in feet-relative coordinates. Modes cover normal movement/work, axe combat, armed walking and guard/parry. The renderer mirrors the complete pose, including sockets, in one transform. `register_item(id, frames)` accepts pose-specific equipment artwork. Profile keys `visual_head`, `visual_chest`, `visual_shoulder` select registered items; atlas keys include these IDs and registry revision. Artists must author coverage and occlusion into pose-specific equipment frames: this is an attachment API, not automatic deformation of a single helmet or plate. Existing armor continues to use the garment mask.

## Geological model

Seeded mountain silhouette → variable soil overburden → rock → deep basalt. Winding lodes form in host rock. Ten irregular chambers connect by passages; the short worked entrance ends at an earthen face. Coal lies under the starter adit for the first commission. Roots and sealed springs reward exploration. Gameplay remains seven-pixel destructible terrain, with larger continuous surface art.

World addresses retain galaxy seed, planet and region coordinates. The generation revision is 2. Future planets can supply biome, gravity, mineral frequency and strata parameters before this region generator runs; neighboring regions will require boundary samples and shared cave endpoints before seamless planetary streaming is implemented. This release is not yet a galactic streaming world.

Older mine grids regenerate on load or first revisit; character, possessions and progression remain. A player saved in the replaced mine returns to its entrance. This deliberately replaces older excavations as requested.

P toggles dirt sifting and equips the shovel. Sifting takes a slower, smaller stroke. Only consumed dirt can yield fractional traces; clues point toward actual nearby mineral cells. Sixteen trace grains produce a resource unit, and fractions persist in saves.

Roof frames require two firm footings. Their posts stand beside the walking lane; the lintel is solid and catches loose earth. Removing a footing or lintel dismantles the remaining frame. Timber structures require a connected path to terrain, and ladder chains must ultimately reach terrain or a grounded structure. Unsupported pieces are recovered at reduced value, without periodic maintenance chores.
