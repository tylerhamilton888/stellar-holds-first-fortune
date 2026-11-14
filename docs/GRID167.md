# Building-grid presentation

`HoldBuildPreview.world_grid` uses the existing world origin and structural spacing, with the placement mode’s existing subdivision. It clips to `HoldSurface.CLAIM_GROUNDS` (also used by the unchanged claim-ground test) or the current interior’s actual bounds. Fine construction no longer uses the old 1300×600 preview rectangle. Catalogue placement gains the same grid; furniture retains its fine subdivisions. Gold dashed lines follow the current anchor/structural cell center.

The Blueprint Book reports the full footprint, including wall tiles, during dragging and for the selected plan. Screen-space labels remain readable at map zoom levels. Exact matching room edges/centers produce guides against other plans on the selected floor. Neither guides nor labels change saved coordinates, validity, costs, material use or input snapping. Room sizes remain 3–20 tiles per side.

Regression coverage extends existing blueprints152, blueprint_manor152 and architecture cases: expanded-plot/cutout coverage, coordinate consistency, existing snap spacing, guide geometry, native drag preview, and resource conservation while previewing all three world modes. Review captures at gameplay scale and at enlarged-room positions.

The new [A Home and a Fortune roadmap](HOME_AND_FORTUNE_ROADMAP.md) is future work. The current grid task does not revise property acquisition or seed cottages into existing saves.

Local validation: all five focused native cases passed (537 assertions) plus 42 tooling tests and the output-policy check. Reviewed the three world placement modes, selected and dragged room labels, and shared-wall alignment guides. Published 0.114.0 passed all 11 release jobs: 87 source cases and 77 exact-package cases / 14,561 assertions. Public metadata and asset identity were verified; see CURRENT_STATUS.md.
