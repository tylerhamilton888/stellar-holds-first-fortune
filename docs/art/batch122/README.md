# Named cast batch 122

Ivar, Hedrik, Borin, Eldric and Brann: 128 complete painted poses. Each has four resting views and sixteen walking keys; Hedrik and Brann have four drinking keys, Borin and Brann four hammer keys, and Brann twelve mining keys covering front, side and rear. Existing 62px stature and identity records are preserved.

The built-in image generator created whole paintings using the approved Bram gait and each character's established portrait. `prompts.json`, `action-prompts.json`, `identities.json`, `sources.json` and `action-sources.json` record briefs and source selections. Runtime WebPs retain the generated pixels losslessly. Local source paths describe provenance, not runtime dependencies. Earlier generated attempts remain available in the original working folder.

Eldric's rear sleeves and beard bindings were corrected. Brann's rear mining contact was redrawn to strike ahead, and owner feedback prompted corrected overhead wrist/hand alignment and simple two-point pick heads in the front/rear contacts. Whole-frame bounds preserve tools crossing nominal atlas row boundaries. No limbs or tools were synthesized by code.

`import_actions.py` measures connected whole-figure bounds and boot baselines. All four work keys share one body-height calibration for each direction, so raised tools do not shrink the character. Atlas import only measures extraction bounds and encodes lossless WebP; the game paints each figure intact.

Reachable activities were traced through lodge/escort, tavern, forge, research, recruitment and underground worker/workshop code. Unsupported future actions retain their existing functional renderer. Brann's masonry cargo remains the existing separate world block. No new activities, gameplay balance or save fields were invented.

Native visual review, all 5,891 source assertions and all 5,866 exact-package assertions passed; 3,773 packed entries verified. Results are recorded in `docs/testing/batch122/acceptance.json`. The combined GIF shows ordered keys at the walking cadence; actual activity timing is verified in the live captures. User visual acceptance remains open; technical tests alone do not establish art quality.
