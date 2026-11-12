# Current status — 2026-11-12

Published Windows baseline remains **0.106.0** until the current release gate publishes 0.107.0.

## Surface room blueprints

Stage A is implemented in [PR #152](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/152), reviewed source `e20067f7d564b186ea3fce60a919f926b143c577`, tree `bf8e1e3fa0803df8a760ecb058eb9ddb600bae97`. See [BLUEPRINTS.md](BLUEPRINTS.md) and [owner directive](BLUEPRINT_DIRECTIVE.md). Surface rooms use the existing Hearthcraft economy and save data. Excavation planning, unified multilevel estates and provisional property-story changes remain deferred.

Local native acceptance: 566 passing assertions (blueprints 61, furnished manor 47, architecture styles 60, architecture 347, LivingWorks 51). Tooling: 42 passing tests; output policy and diff checks passed. Native visual review passed after compacting the planner, focusing room zoom and correcting furniture approach assessment. Manor coverage includes shared costs, mixed-use furnishings, stocked storage, renovation, manual stairs and save/reload.

## Delivery in progress

- [PR validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43269561230) runs full source coverage.
- [Windows release](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43270053006) runs on `release/0.107.0` at the exact reviewed source. It requires 82 native source cases and 72 exact-package cases before publication.
- Merge PR #152 only after required checks pass. Verify published ZIP, build metadata, receipt and evidence before recording delivery. Follow [release procedure](RELEASE_PIPELINE.md).

The local command environment disconnected after source and evidence were committed. GitHub source is safe and its workflows continue independently; monitor through the connected GitHub tools. Do not restart healthy queued/running jobs. Documentation updates belong on `docs/blueprints-107-delivery`; do not move the active release branch for notes.

Earlier first-hour release evidence: [history](history/CURRENT_STATUS-before-blueprints152.md). Preserve previous releases/saves and bounded diagnostics.
