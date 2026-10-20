# Title and loading presentation — 0.61.2

The title now draws the same whole-character held-pick frame as gameplay, bypassing the retired side-view atlas. Its existing original Keldrath illustration is retained, with clearer menu labels and a larger foreground Dwarf.

`HoldLoadingView` owns the illustrated preparation overlay on canvas layer 100, above HUD, modal menus and Ivar's cutscene. Hints sit above the bar and rotate every nine seconds. Progress is completed animation jobs divided by scheduled jobs; completion fades out over 0.22 seconds. There is no simulated timer or mandatory minimum wait. Existing scene and input gates remain authoritative.

Prepared, recolored gameplay frames are cached as PNGs under `user://animation-cache/<build version>/`. Missing/unreadable images regenerate from the original assets. Cache pixels are compared against freshly prepared pixels in the regression test. Save data is untouched. Bump HoldBuild.VERSION whenever source artwork, frame metadata or recoloring logic changes, including development builds intended for distribution. These derived files may be removed independently of saves. This avoids repeated CPU palette conversion across launches; it does not eliminate the first preparation of a new appearance or version, engine startup or synchronous world generation.

Tests: `tests/loading63.gd` is included in core and gameplay suites. It exercises title presentation, real preparation, input gating, overlay priority, completion, Ivar continuity, exact cached pixels and full-queue reuse. Native captures: title, loading and Ivar. Existing orientation and world journey cases cover escort completion, interior/area transitions and reload behavior. Test timings are software-rendered Linux measurements, not Windows performance promises.

New-character creation now starts from `HoldAppearance.random_profile(randi())`, using the existing canonical name/design/palette pools. Name and look remain editable; wardrobe mode retains the current saved profile. This deliberately leaves `defaults()` stable for migration fallbacks and deterministic fixtures. Added checks cover creation fields, acceptance, wardrobe and save/reload identity.

Verified 2026-10-20: 190 existing gameplay checks plus 19 final loading/identity checks, and the same 19 checks against the exact exported PCK: **228 passing checks**. The first suite run also passed the initial 11-check loading case; it is superseded by the final 19-check run, not added to the total. Title, loading, creator and actual Ivar handoff were visually inspected. All 3,134 PCK entries and the single ZIP passed integrity verification.

Exact pack: 485 initially queued frames prepared in 22.887 seconds including capture overhead; 488 disk-cached frames prepared in 1.352 seconds. These software-rendered Linux observations are not a controlled hardware benchmark.

Build source: local `1ab53f235b345ae7a1d5520962fa2ef20d920b95`, matching runtime files on GitHub `4169069d9f80e6fae3dc33deee855c8b16a13916`. ZIP: 698,806,969 bytes, SHA-256 `7a3b83aaf213bc4681a9eaa211ae9f1015b8d7058d0bf91d554d76e05874f6a2`. PCK SHA-256 `ed8c04bda84116ef4d60f802f30c1fc7c2ffe386187e041841672c72d950c397`. Windows execution and audible mix remain untested.

Delivery: GitHub release `v0.61.2` (418792854), verified asset digest and size match. Hosted full gameplay validation passed (39484028846). PR #3 merged at `d539cb535fad79fb2bd141ed73e5c3a848ad9bf0`. The release tag itself preserves the complete source, rather than a delivery-only tree. Prior backups are unchanged.
