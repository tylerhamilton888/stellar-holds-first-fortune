# 0.46.0 integrated surface/homestead verification
Godot 4.4.1 Linux, software OpenGL native display at 1280×720, isolated user data. No player save used.

- `tests/input_homestead46.gd`: **35 passed / 0 failed**. Real movement/key/mouse input for active mechanics; fixture positions set between route checkpoints. Covers first introduction sequence, original seated Lord, forge stairs and lift, gate, actual mine excavation, linked descent/ascent, Pinewood held axe, sale, craft queue, claim cottage, chest conservation/proximity, placement/door clearance, improvement, bed, home reload and old-save backup.
- `tests/test_deepworks41.gd`: **45 passed / 0 failed**. Expected public mine exit now asserts High Trail instead of obsolete basin map. Includes worker/automaton real same-XY stair routing and save data.
- `tests/test_masonry45.gd`: **25 passed / 0 failed**. Actual material conversion, lesson, NPC fetching/dressing/returning and saved in-flight cargo.
- Inspected 12 native captures under `homestead-0.46.0/`: hold, foreman, throne, forge, trail, Pinewood, claim, cottage, storage, upgraded cottage, home board and directions. Final visual adjustment removes a flat overlay rug in favor of the painted textile and subtle fire glow.
- Fixed during testing: first Pinewood tree-array initialization; diagonal/collision substeps; forge landing safe spawn; room camera bounds; actual introduction choice coverage; home inventory JSON numeric comparison.
- Exported PCK native boot and bundle restoration are release gates. The exported build is tested using the Linux engine; packaged Windows launcher requires Windows acceptance. No claim of human full-route playthrough or audible mixing review. Known engine ObjectDB/resource shutdown warnings remain, with no gameplay SCRIPT ERROR in final native run.

Recovery uses tag `homestead-0.46.0`, full-history bundle, source ZIP, Windows ZIP and docs ZIP. Pre-change tag `pre-homestead-0.46.0` and 0.45.1 recovery files are retained. Additive save migration creates an original file copy before any new autosave.
