# Surface room blueprints — Stage A

Implementation: [PR #152](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/152). Candidate version: 0.107.0. See CURRENT_STATUS for publication; source work alone is not a released build. Requirements: [owner directive](BLUEPRINT_DIRECTIVE.md).

## Player experience

Building Book → Plan Your Holding opens a ground-floor map on chartered property. Drag a rectangle, choose an optional designation and structural floor, and join rooms with doorways. Click to select; wheel zooms and middle-drag pans. Unstarted plans can be redrawn without spending supplies. Add a new doorway before removing an old planned opening; recover already-built openings through fine construction.

Build within reach performs up to 32 nearby construction/finishing steps. Actual Hearthcraft floors, walls, doors and roofs consume the existing pack. Existing pieces reduce the quote, and the combined estimate counts shared pieces once. Shared foundation material and finish ownership follow the earlier room plan, independently of construction order. Removing a plan preserves every physical piece, furnishing and stored item.

Hearthstone, Forgehold and Oathhall use the existing architectural painters. Advanced finishing requires stoneworking/fine masonry; estimates are available before research or supplies are ready. Coverage determines cost. Paid finishes live on physical tiles and survive plan removal; their material record is returned once when the underlying floor is recovered. Renovating leaves furniture and stocked chests in place.

Designation is a label and source of suggested defaults, never equipment permission. An undesignated hall can contain a usable bed and cooking hearth. Descriptive comfort/heritage uses existing LivingWorks furniture values; it adds no artificial room level or production reward.

## Persistence and bounds

Saved plans are additive under the existing claim building's `blueprints152` dictionary. Structural pieces remain ordinary Hearthcraft tiles; optional `style87` and `finish_paid152` fields belong to those physical tiles. No duplicate inventory, storage capacity, excavation reward or construction economy is introduced.

This stage supports ground-floor surface rectangles from 3–20 tiles per side and up to 64 saved plans. Existing records are never truncated. Existing authored buildings, furniture modes, fine construction and manual stairs remain available. Plans and physical construction persist independently.

## Acceptance

Native Godot 4.4.1 checks cover GUI dragging, a connected five-room manor, exact shared material estimates/payments, mixed-use sleeping/cooking, workshop equipment, actual chest deposits, renovation, actual save-file reloads, missing materials, stale actions, doorway changes, finish research and once-only recovery. Existing architecture/style and LivingWorks regressions are included. Native screenshots have been inspected at gameplay scale; the primary controls and material quote fit the visible book area. Source and exact-package manifests include both blueprint cases.

The first raw dictionary reload comparison failed because serialized numeric types differed. Comparing normalized serialized records passed, including all furnishings and stocked storage; no property-loss fix was necessary. Current evidence and release gates are tracked in CURRENT_STATUS.

## Later stages

Stage B excavation and Stage C connected multilevel estates are unimplemented. Manual stairs remain supported and tested; there is no planned stair placement, underground room planning or new unified worker/freight routing. Provisional Old Stonewright's Rise story integration is also deferred. Do not advertise those features as included in 0.107.0.
