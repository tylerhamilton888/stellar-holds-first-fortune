# Current status — 2026-11-12

## Published Windows build

**[0.108.0 — Underground blueprints](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.108.0)** is published. [Source PR #154](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/154) merged after all required checks passed.

- Release source: `9da4bf24d2001afd5771f71130343b66631165ae`; source tree: `870e7e9f1a6395bc25e4fd3358fe1d09afd5a820`.
- Merge commit: `88a70b6fc00ddd824f6d133f90f14e8f55c27f5a`.
- [Release run](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43293815234): all 11 jobs passed, including 83 native source cases, 73 exact-package cases (14,352 assertions), aggregate verification and publication.
- [PR validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43293182847): all four gameplay groups and aggregate gate passed.
- Public assets: Windows ZIP, build.json, release-summary.json and verification-evidence.tar.gz, all uploaded.
- Windows ZIP: 964,754,927 bytes; SHA-256 `2f2fa58c7c727ba2be90c40fe8d6df2efbac1ff267c844767b77ea99713ac167`.
- PCK SHA-256: `ed68705efecd1b7148719b11937b6acfdb5d3be39c101822b0297a24e3641b78`.

The published build.json and release-summary.json were retrieved directly after upload. Version, source, PCK/ZIP hashes and passed receipt agree; ZIP size/hash agree with the GitHub release asset. Both retrieved JSON file hashes also match GitHub's asset digests. The full ZIP was verified by the publication gate, not independently downloaded again.

## Delivered scope

In the mine, **O → Plans** offers saved chamber/corridor guides, real excavation progress, reachable paid finishes and optional labels. Furnishings supply actual function; guides do not spend materials or grant ore. Removing a guide preserves excavation, physical rooms, finishes, furniture and stocked storage. Stair guides mark both landings on the original five depths; clear both through existing access, then fit from above. Existing manual stairs remain supported.

Surface room blueprints from 0.107.0 remain available on chartered holdings. See [underground notes](EXCAVATION154.md), [surface notes](BLUEPRINTS.md), [directive](BLUEPRINT_DIRECTIVE.md) and [playtest guide](PLAYTEST_GUIDE.md).

Focused local acceptance passed 233 native assertions: excavation154 60, navigation94 31, blueprints152 61, mineworks143 43, mining 38. Tooling passed 42 tests. Native planner, furnished chamber, stone-wall finishes and stair controls were visually reviewed. The read-only map regression is fixed.

## Next work and limits

Normal-speed Windows input, audio, performance and enjoyment still need player testing. Stage C connected surface/underground estates, unified worker/freight routing and provisional property-story integration remain deferred. This release adds no new mine depths or automated excavation workers.

Preserve previous releases and saves. Follow [release procedure](RELEASE_PIPELINE.md); documentation-only follow-up requires no rebuild. Prior delivery is in [history](history/CURRENT_STATUS-before-excavation154.md).

## Stage C first slice in progress

Branch `feature/connected-cellar` implements saved home/claim-mine stair connections for 0.109.0. The basic native case passed 40 checks; expanded acceptance and affected regressions are in progress. See [candidate notes](CELLAR156.md). 0.108.0 remains the published release until the new delivery gates pass.
