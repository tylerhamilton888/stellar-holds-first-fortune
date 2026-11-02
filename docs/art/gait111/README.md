# Ragnhild — authored world locomotion

Ragnhild is the second active named world bundle after Dagna. Four existing resting views and sixteen whole painted walking keys preserve her copper crown braid, sleeveless pine-green tunic, strong athletic feminine silhouette and short brown boots. The fixed named height is 64px. Other eight extracted candidates remain disabled.

The original sheet and an attempted twenty-frame replacement repeated leading feet. New direction-by-direction paintings used Dagna's reviewed whole poses as motion references while retaining Ragnhild's own shape and identity. The last front passing pose still repeated the supporting leg; a red/blue diagnostic established image-right planted/image-left raised, then a whole-figure brown/proportion cleanup replaced that key. Native frame review covered four-direction contacts, contrasting passing feet, opposing arms, body orientation, complete crops and resting transitions. Owner visual acceptance is still open.

Runtime metadata selects complete paintings from `ragnhildfront`, `ragnhildside`, `ragnhildquarter`, `ragnhildback` and `ragnhildpassing`; old assets remain. These WebP sources are lossless conversions of the original generated PNGs. No limbs were assembled or rotated. Exact prompts, reference images and source filenames are recorded in [production.json](production.json). Cache revision: `story105-world11`.

Ragnhild is `road_folk:3` in greenfields, moving between (630,500) and (820,500) at 38 units/s with existing seven-second rests. She has no current authored farming/drinking/combat activity route. Those actions continue through the existing functional renderer; do not assign a future worker role without adding matching whole art. Route timing, inventory, saved appearance and partner rescue are unchanged.

Integration coverage: production registration, all four views and keys, unsupported-action fallback, 82 samples of both route directions and rests, snapshots, save/reload identity/inventory and partner rescue. The complete exported-pack gate includes this new case, and gameplay shards cover every source case exactly once.

Reproduce the native board with `godot --audio-driver Dummy --path . --script res://tests/review_story_gait111.gd -- /tmp/ragnhild-review`; append `preview` for loop frames. Run `tools/check.py --suite story_world111` and the exact pack cases listed in testing/gait111/acceptance.json. The native loop is in [ragnhild-walk.gif](../../testing/gait111/ragnhild-walk.gif).
