# Shared architecture — 0.76.0: published and verified

`HoldBuildingPlans` describes all 22 prepared designs: nine household fronts, eight civic/town buildings, the archive, cottage, workshop, farmhouse and wayside inn. Original atlas crops, proportions and household identities remain at their original paths. Both world addresses and player instances consume those plans, `HoldBuildingArt` and `HoldFurnishings`. Room dimensions, door geometry, stair placement and component layouts have shared owners. NPC identities and public services remain attached to their original addresses.

The Building Book offers visual categories, furnished plans or empty shells, and real material costs. Instances have stable room IDs, private chests, movable/recoverable furnishings, physical workstations, cooking/rest/comfort and hearth-plus-worktable crafting. Side/rear bays expand the usable floor; up to five storeys have aligned stairs. Moving a building preserves contents and room IDs. Recovery requires empty rooms and returns paid shell materials. Ordinary grid construction stays save-compatible and its wall/door/floor tools also edit plan interiors. Existing painted façades are reusable architectural styles; arbitrary per-window façade editing is not introduced.

Owned interiors and building alterations use additive `surface.architecture86` records. Existing furnishings/chests/equipment keep their established owners and formats. Loading a pre-architecture save retains an exact `.pre-architecture86-*.bak` before autosave. No original assets, UIDs or normal/test save boundaries are replaced. Expanded eastern claim grounds fit large halls without moving existing landmarks.

## Acceptance

- `architecture-preview`: constructs all 22 plans, compares every floor and editable component against the original definition, checks actual door connections, stairs, resting approaches, material transactions, working equipment/cooking/smelting, save/reload, stored items after relocation, extension geometry, shell recovery, obstruction refusal and scrolling menus.
- `architecture-regression`: homestead, Keldrath, royal, roads, work, developer testing and menus.
- Full source: 30 gameplay cases plus people-preview. Exact export: 20 cases; the architecture test is flattened into the external pack harness using the shared fixture.
- Native before/after captures cover original tavern, forge, royal hall, family homes, countryside inn and cottage. Player captures cover representative exteriors/interiors, royal furnishings, expansions and catalogue controls.

Local final parity gate: 301 assertions, zero engine errors (`architecture86-ground`). Seven focused cases passed 343 assertions (`architecture86-regression`). The native keyboard walkthrough passed 20 checks (`architecture86-walkthrough`); its later terrain capture is visual evidence only. Original/player facades, household rooms, royal hall, forge components, five-floor workshop, catalogue/renovation menus and river boundary were reviewed. Local candidate validation measured 6–11 ms.

Final source: ff840c816d451e75babaf1fecdc3c776c8b8a1e2 / tree 2ae39e202456a24fab98af2df25f8d286a28fb72. PR #43, source run 40249460487 and release run 40249459330. Source CI passed all 30 gameplay cases and people-preview. Release verification passed the package audit and all 20 exact-export cases: 1,550 assertions, including 301 architecture checks. Exported catalogue and royal-hall captures were reviewed. Windows device performance/audio remain hands-on testing.

PR #43 merge 6ff9dc03b56624903d46debdd79990d8b1de97c9 has the identical runtime tree. Release: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.76.0
Windows ZIP: 729,897,845 bytes; SHA256 1478b9f514d8e050de5e7160727fb368b110fdb5bd4b7e7a5fedc1610a588cf4. Downloaded build.json digest 243d7e7f8a60259236352105315c2766077e04c3b14d1864b5786ef24dab63b8 and verification-evidence.tar.gz digest a9b471d6ffdeecb0fc58b23ac5316c4347e5692193f04c6971ce9512685f3b3c match GitHub metadata. Build report and source proof identify the clean final runtime commit; report and uploaded ZIP metadata agree.

Final runtime is retained by the verified architecture86-ground-verified.bundle and recovery/architecture86-ground-verified branch. Earlier checkpoints remain intact. Evidence was downloaded to architecture86-release; runtime paths and original assets were not relocated.
