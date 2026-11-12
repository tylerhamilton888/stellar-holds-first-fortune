# Room blueprinting — draft checkpoint

Branch: `feature/room-blueprints`, based on master `dbe6a7e` (published game remains 0.106.0). Requirements: [owner directive](BLUEPRINT_DIRECTIVE.md).

## Implemented draft subset

Building Book → Plan Your Holding opens a ground-floor map on chartered property. Drag a 3–20 tile rectangle; choose an optional designation and stone/oak flooring. Redraw an unstarted plan without paying. Add shared doorways and select saved plans. Build within reach performs up to 32 ordinary Hearthcraft component transactions, using the existing pack, collision, proximity and route checks. Walk around the plan and repeat to finish. Existing pieces reduce the remaining quote. Removing metadata leaves all physical property intact. Furniture and fine construction retain their existing menus and systems.

Saved data is additive under the existing claim building's `blueprints152` dictionary. No separate economy, shell refund, storage capacity, equipment permission or production reward is introduced. Drawn plans do not create physical walls. Built floors/walls/doors/roofs remain ordinary Hearthcraft pieces. No existing save migration or asset path changes.

## Verified locally

Godot 4.4.1 full import exited zero with no script errors. Focused headless game test: **31 passed / 0 failed**, exit zero, no script errors (`test-results/blueprints-headless/runner.log`). It covers free editing, quotes and exact expenditures, connected doors, shared built boundaries, overlap/terrain rejection, physical completion, idempotent payments, JSON round trips, missing supplies and off-property callbacks. This is not native input/visual acceptance or a complete save-file round trip.

Tooling: 42 Python tests passed; output-policy check passed; `git diff --check` passed. Full native and exact-package release gates have not run.

## Incomplete — do not merge or release yet

Stage A is **not complete**. Native visual/input review could not run in this session: a local X server could not establish listening sockets; the available desktop terminal opened but would not accept focus/text. No rendered planner screenshot has been accepted.

Remaining Stage A work:
- Review map readability and selection at 960×540; add useful zoom/pan if needed. Review world guides beside actual Dwarf art.
- Validate real drag/doorway input, furnishing/use and navigation in the connected five-room manor, including a fully undesignated mixed-use room.
- Complete doorway relocation/removal, whole-plan shared estimates, clear blocked/inaccessible/completed status presentation and construction progress feedback.
- Integrate per-room compatible styles and paid renovations without moving equipment; reconcile LivingWorks quality rather than adding another scoring system.
- Verify actual save-file reloads, old-save property/storage/worker preservation, stale callbacks, manual edits and equipment obstructing work. Current JSON test is narrower.
- Add accepted tests to required native/exact-package manifests, run affected regressions and full release gates. Review all UI changes before merge.

Stage B excavation and Stage C connected estates are unimplemented. Existing manual stairs remain available; this draft does not add planned stairs or demonstrate vertical estate travel. No campaign/property-grant changes were made. Retain 0.106.0 until a coherent validated Stage A is ready.
