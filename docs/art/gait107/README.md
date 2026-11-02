# Dagna whole-frame studies — 107

These are unapproved production studies, not finished world animation. No character bundle is activated.

The brown-boot core sheet supplies idles and candidate walk frames. Dagna's logical atlas metadata references untouched whole frames in `dagnacore`, `dagnafront`, `dagnarearone` and `dagnareartwo`. The original `dagna.webp` is preserved. Corrected rear-quarter first-contact art reverses the arm opposing the forward leg. `dagnadrink` stores four separate drink poses but is not routed at runtime.

Native candidate extraction and production quarantine: **746 checks passed**, plus successful Godot import. Captures/results: `docs/testing/gait107`. Front opposite-half frames still shrink the torso relative to the first half. The later alternate moves the belt pouch to the other side and is rejected. Do not activate these assets or expand batch production from them. Per-frame full-silhouette normalization also needs review; correct drawings must maintain body proportions at the intended scale.

Importer now supports explicit positive `--columns` and `--rows`, so whole-frame pair and drink studies can be extracted without fabricating a 4x5 layout. Default 4x5 behavior is unchanged. All imported sprites retain their source pixels; no limbs were assembled or rotated.

Next: correct front contact/passing whole drawings and stable body scale, verify all four physical foot sequences in native motion, then finish reachable activities and routing. The complete named cast remains outstanding. See `docs/great-claim/IMPLEMENTATION_REVIEW.md` for the separate requested intro audit.
