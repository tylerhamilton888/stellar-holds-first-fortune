# Dagna — implemented world bundle

Dagna is the first active named world bundle: four resting views, sixteen walk keys and four drinking keys. Other named candidates remain disabled. The new drawings use matching brown boots, physical right contact / left passing / left contact / right passing, opposing arm motion and consistent outfit/accessory placement. Enlarged keys and native 62px frames were reviewed; source tests are not the basis of visual acceptance.

The core atlas has uneven row spacing. Measured boundaries `0,281,546,817,1073,1374` preserve complete hair/boots that uniform grid cuts clipped. The importer now accepts validated `--row-edges`; invalid bounds are rejected before replacing metadata. New front drawings replace the undersized opposite-half torso; new back passing drawings lift alternate heels beside the planted calf. Original assets/studies remain recoverable.

Dagna's present reachable contexts are the wayside host route and partner rescue. She is not in the recruitable crew. A three-second sip occupies part of her existing seven-second route pause; positions, speed, elapsed-clock determinism, interactions and inventory are unchanged. The rest of each pause uses relaxed idle frames. Drink routing uses all four whole drawings; it does not substitute a generic character. Unsupported future actions retain the existing functional renderer, so a future worker/combat role must add authored actions before being assigned to her.

`dagna.json` assembles metadata references to complete source paintings, never limbs. Source and exact prompts: [production.json](production.json). Cache revision for named art is `story105-world8`; player/background art and saved appearance dictionaries are unchanged. Export rules explicitly include the dynamic world JSON files.

Acceptance: [gait108 evidence](../../testing/gait108/acceptance.json). Native focused checks passed 1,282 assertions; focused exact-pack checks passed 1,158. All 3,437 exported entries passed hash/bounds/path audit. Reviewed actual tavern walking/sipping captures and save/rescue identity. This is a local verified source milestone, not a new Windows release or full-cast completion.

Reproduce visual review: `godot --audio-driver Dummy --path . --script res://tests/review_story_gait108.gd -- /tmp/new-dagna-review`. Append `preview` for the compact four-view loop frames. Run `tools/check.py --suite story_world108` with the pinned engine and native display; `tools/check_pack.py` includes the new integration case in the complete release gate. `--case` selects focused local pack checks only; the release workflow omits it and still runs every case.

Next: Ragnhild's complete four-view bundle with her athletic silhouette and sustainable idle; then the rest of the named cast with each character's actual activity requirements. Do not copy Dagna's body shape onto every woman. Read `docs/art/STORY_ART_IMPLEMENTATION.md` and `docs/ROMANCE_CAST.md`.
