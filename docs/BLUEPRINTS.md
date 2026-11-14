# Surface room blueprints — Stage A

Implementation: [PR #152](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/152). Released in 0.107.0. See [CURRENT_STATUS](CURRENT_STATUS.md) for verified delivery and evidence. Requirements: [owner directive](BLUEPRINT_DIRECTIVE.md).

## Player experience

Building Book → Plan Your Holding opens a selectable floor map on chartered property. Drag a rectangle, choose an optional designation and structural floor, and join rooms with doorways. Click to select; wheel zooms and middle-drag pans. Unstarted plans can be redrawn without spending supplies. Add a new doorway before removing an old planned opening; recover already-built openings through fine construction.

Build within reach performs up to 32 nearby construction/finishing steps. Actual Hearthcraft floors, walls, doors and roofs consume the existing pack. Existing pieces reduce the quote, and the combined estimate counts shared pieces once. Shared foundation material and finish ownership follow the earlier room plan, independently of construction order. Removing a plan preserves every physical piece, furnishing and stored item.

Hearthstone, Forgehold and Oathhall use the existing architectural painters. Advanced finishing requires stoneworking/fine masonry; estimates are available before research or supplies are ready. Coverage determines cost. Paid finishes live on physical tiles and survive plan removal; their material record is returned once when the underlying floor is recovered. Renovating leaves furniture and stocked chests in place.

Designation is a label and source of suggested defaults, never equipment permission. An undesignated hall can contain a usable bed and cooking hearth. Descriptive comfort/heritage uses existing LivingWorks furniture values; it adds no artificial room level or production reward.

## Persistence and bounds

Saved plans are additive under the existing claim building's `blueprints152` dictionary. Structural pieces remain ordinary Hearthcraft tiles; optional `style87` and `finish_paid152` fields belong to those physical tiles. No duplicate inventory, storage capacity, excavation reward or construction economy is introduced.

Version 0.110.0 extends planning to ground and four upper floors, with rectangles from 3–20 tiles per side and up to 64 saved plans across the holding. See [upper-floor notes](UPPER158.md). Existing records are never truncated. Existing authored buildings, furniture modes, fine construction and manual stairs remain available. Plans and physical construction persist independently.

## Acceptance

Native Godot 4.4.1 checks cover GUI dragging, a connected five-room manor, exact shared material estimates/payments, mixed-use sleeping/cooking, workshop equipment, actual chest deposits, renovation, actual save-file reloads, missing materials, stale actions, doorway changes, finish research and once-only recovery. Existing architecture/style and LivingWorks regressions are included. Native screenshots have been inspected at gameplay scale; the primary controls and material quote fit the visible book area. Source and exact-package manifests include both blueprint cases.

The first raw dictionary reload comparison failed because serialized numeric types differed. Comparing normalized serialized records passed, including all furnishings and stocked storage; no property-loss fix was necessary. Current evidence and release gates are tracked in CURRENT_STATUS.

## Later stages

Stage B adds underground room and stair landing guides in 0.108.0; see [underground blueprint notes](EXCAVATION154.md). Manual stairs remain supported and tested. The first Stage C slice adds [connected home/cellar stairs](CELLAR156.md) in 0.109.0. The second Stage C slice adds [upper-floor blueprints](UPPER158.md) in 0.110.0. Household [worker routes](WORKERS160.md) shipped in 0.111.1 and physical [freight routes](FREIGHT162.md) in 0.112.0. Version 0.113.0 adds [Old Stonewright’s Rise](RISE165.md); see current status for delivery.
