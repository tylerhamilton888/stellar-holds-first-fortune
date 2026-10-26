# Shared architecture — 0.76.0 (verification in progress)

`HoldBuildingPlans` describes all 22 prepared designs: nine household fronts, eight civic/town buildings, the archive, cottage, workshop, farmhouse and wayside inn. Original atlas crops, proportions and household identities remain at their original paths. Both world addresses and player instances consume those plans, `HoldBuildingArt` and `HoldFurnishings`. Room dimensions, door geometry, stair placement and component layouts have shared owners. NPC identities and public services remain attached to their original addresses.

The Building Book offers visual categories, furnished plans or empty shells, and real material costs. Instances have stable room IDs, private chests, movable/recoverable furnishings, physical workstations, cooking/rest/comfort and hearth-plus-worktable crafting. Side/rear bays expand the usable floor; up to five storeys have aligned stairs. Moving a building preserves contents and room IDs. Recovery requires empty rooms and returns paid shell materials. Ordinary grid construction stays save-compatible and its wall/door/floor tools also edit plan interiors. Existing painted façades are reusable architectural styles; arbitrary per-window façade editing is not introduced.

Owned interiors and building alterations use additive `surface.architecture86` records. Existing furnishings/chests/equipment keep their established owners and formats. Loading a pre-architecture save retains an exact `.pre-architecture86-*.bak` before autosave. No original assets, UIDs or normal/test save boundaries are replaced. Expanded eastern claim grounds fit large halls without moving existing landmarks.

## Acceptance

- `architecture-preview`: constructs all 22 plans, compares every floor and editable component against the original definition, checks actual door connections, stairs, resting approaches, material transactions, working equipment/cooking/smelting, save/reload, stored items after relocation, extension geometry, shell recovery, obstruction refusal and scrolling menus.
- `architecture-regression`: homestead, Keldrath, royal, roads, work, developer testing and menus.
- Full source: 30 gameplay cases plus people-preview. Exact export: 20 cases; the architecture test is flattened into the external pack harness using the shared fixture.
- Native before/after captures cover original tavern, forge, royal hall, family homes, countryside inn and cottage. Player captures cover representative exteriors/interiors, royal furnishings, expansions and catalogue controls.

Local final parity gate: 299 assertions, zero engine errors. Final local regression, source CI and exact-pack release evidence are pending. Windows device performance/audio remain hands-on testing.
