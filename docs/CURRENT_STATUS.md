# Current status — 2026-11-13

## Published build

**[0.109.0 — A cellar beneath your home](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.109.0)** remains the verified public Windows release. Source PR #156 and delivery PR #157 merged. Its exact source, hashes, checks and release receipt are retained in [the previous checkpoint](history/CURRENT_STATUS-before-upper158.md). Preserve that release and existing saves.

## Active work: upper-floor blueprints

Branch `feature/upper-blueprints`, based on master `d1fea58c88009d4446cd58b1ae6f7f1f39c96612`. Candidate **0.110.0** is not yet published. This is the second Stage C slice, not completion of the stage.

Implemented floor selection (ground plus four upper storeys), additive floor-specific plans, support/access status, aligned stair guides, local paid construction and floor-specific finish quotes. Paid roof decks are reused without duplicate floor charges. Planning does not move the player; old records default to ground. Existing manual construction, cellar travel, inventory and storage remain authoritative. See [upper-floor notes](UPPER158.md).

Native acceptance is in progress. Early checks found fixture placement/approach problems and a roof-deck finish rendering issue, now corrected. The final scenario covers a ground kitchen, upper bedroom/storage, renovated cold reload and a connected cellar workshop/storage. Affected surface/manor/cellar regressions and visual review are required before release. Tooling: 42 tests passed.

Next: complete focused native checks, review images, commit/upload the exact source, open the source PR, run required PR and full source/package release gates, merge after passing, publish and verify assets, then reconcile delivery docs separately. Follow [release procedure](RELEASE_PIPELINE.md). Never describe merged source as published delivery.

## Limits

Household-worker routes and automated freight across the surface/mine boundary remain future Stage C work. Carts stay parked for household stairs. No new mine depths, automated excavation or property-story integration are added. Normal-speed Windows input, audio, performance and enjoyment still need player testing.
