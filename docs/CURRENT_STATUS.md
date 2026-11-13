# Current status — 2026-11-13

## Published build

**[0.109.0 — A cellar beneath your home](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.109.0)** remains the verified public Windows release. Source PR #156 and delivery PR #157 merged. Its exact source, hashes, checks and release receipt are retained in [the previous checkpoint](history/CURRENT_STATUS-before-upper158.md). Preserve that release and existing saves.

## Active work: upper-floor blueprints

Branch `feature/upper-blueprints`, based on master `d1fea58c88009d4446cd58b1ae6f7f1f39c96612`. Candidate **0.110.0** is not yet published. This is the second Stage C slice, not completion of the stage.

Implemented floor selection (ground plus four upper storeys), additive floor-specific plans, support/access status, aligned stair guides, local paid construction and floor-specific finish quotes. Paid roof decks are reused without duplicate floor charges. Planning does not move the player; old records default to ground. Existing manual construction, cellar travel, inventory and storage remain authoritative. See [upper-floor notes](UPPER158.md).

Focused native acceptance passed **208 assertions**: upper158 51, blueprints152 61, cellar156 49 and blueprint_manor152 47. The obsolete manor assertion forbidding upstairs planning was replaced with availability/floor-isolation coverage. Tooling passed 42 tests. Native floor-picker and furnished-room images were reviewed.

[Source PR #158](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/158) is ready. Exact candidate source: `088f3d75cf0d4b00369503eae8695e30a43638bd`; tree: `a22f2822cc4a10d0c35c702020bdb8436d123a1e`. [PR checks](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43441172297) and [verified Windows release](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43441360497) are running. The release branch is frozen at this source. Do not restart healthy jobs.

Next: merge PR #158 only after its required checks pass; monitor the independent source/package verification through publication, retrieve public assets and compare version/source/hashes, then finalize this delivery-doc branch and merge it after docs checks. Follow [release procedure](RELEASE_PIPELINE.md). The candidate is not yet a verified published release.

## Limits

Household-worker routes and automated freight across the surface/mine boundary remain future Stage C work. Carts stay parked for household stairs. No new mine depths, automated excavation or property-story integration are added. Normal-speed Windows input, audio, performance and enjoyment still need player testing.
