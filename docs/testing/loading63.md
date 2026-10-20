# Title and loading presentation — 0.61.2

The title now draws the same whole-character held-pick frame as gameplay, bypassing the retired side-view atlas. Its existing original Keldrath illustration is retained, with clearer menu labels and a larger foreground Dwarf.

`HoldLoadingView` owns the illustrated preparation overlay on canvas layer 100, above HUD, modal menus and Ivar's cutscene. Hints sit above the bar and rotate every nine seconds. Progress is completed animation jobs divided by scheduled jobs; completion fades out over 0.22 seconds. There is no simulated timer or mandatory minimum wait. Existing scene and input gates remain authoritative.

Prepared, recolored gameplay frames are cached as PNGs under `user://animation-cache/<build version>/`. Missing/unreadable images regenerate from the original assets. Cache pixels are compared against freshly prepared pixels in the regression test. Save data is untouched. Bump HoldBuild.VERSION whenever source artwork, frame metadata or recoloring logic changes, including development builds intended for distribution. These derived files may be removed independently of saves. This avoids repeated CPU palette conversion across launches; it does not eliminate the first preparation of a new appearance or version, engine startup or synchronous world generation.

Tests: `tests/loading63.gd` is included in core and gameplay suites. It exercises title presentation, real preparation, input gating, overlay priority, completion, Ivar continuity, exact cached pixels and full-queue reuse. Native captures: title, loading and Ivar. Existing orientation and world journey cases cover escort completion, interior/area transitions and reload behavior. Test timings are software-rendered Linux measurements, not Windows performance promises.

New-character creation now starts from `HoldAppearance.random_profile(randi())`, using the existing canonical name/design/palette pools. Name and look remain editable; wardrobe mode retains the current saved profile. This deliberately leaves `defaults()` stable for migration fallbacks and deterministic fixtures. Added checks cover creation fields, acceptance, wardrobe and save/reload identity.
