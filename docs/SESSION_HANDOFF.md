# Current handoff — 2026-11-13

## Published Windows build

**[0.110.0 — Plan a home across floors](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.110.0)** is published. [Source PR #158](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/158) merged after all required checks passed.

- Release source: `088f3d75cf0d4b00369503eae8695e30a43638bd`; tree: `a22f2822cc4a10d0c35c702020bdb8436d123a1e`.
- Source merge: `8439f92de53c9f59f378121cca4ebcb6bb792ad8`.
- [Release run](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43441360497): all 11 jobs passed, including 85 native source cases, 75 exact-package cases (14,452 assertions), aggregate verification and publication.
- [PR validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43441172297): all four gameplay groups and aggregate gate passed.
- Uploaded assets: Windows ZIP, build.json, release-summary.json and verification-evidence.tar.gz.
- Windows ZIP: 964,715,080 bytes; SHA-256 `4bd1e3dfa3a26e6a3173bfd434312d1e9280f9d84e568a213262883b94ef5dc2`.
- PCK SHA-256: `06af58d0d36a29d430dd41ed957b48dbe0f354f3eeede765ddfe6048853cd333`.

Public metadata and receipt were retrieved directly. Version, clean source and PCK/ZIP hashes agree; ZIP size/hash agree with GitHub's asset record. Both downloaded JSON hashes match their asset digests. The publication gate verified the full ZIP; it was not independently downloaded again.

## Delivered scope

This is **the second Stage C slice, not the whole stage**. In **O → Plan Your Holding**, select ground or upper floors 1–4, draw rooms and review missing supports or stair access. Planning leaves the player in place and spends nothing. Build below, fit an aligned stair locally for **4 timber / 2 stone**, then use **E up / Shift+E down**. Visit the selected floor to build; paid roof decks are reused without duplicate floor charges.

Room plans, shared boundaries, quotes and finishes follow their floor. Existing saves default older plans to ground. Furnish, stock storage and renovate upstairs; deleting a guide preserves the physical building and possessions. Existing cellar stairs connect a three-level home to its original claim mine. See [upper-floor notes](UPPER158.md), [surface notes](BLUEPRINTS.md), [cellar notes](CELLAR156.md) and [playtest guide](PLAYTEST_GUIDE.md).

Focused acceptance passed 208 native assertions: upper158 51, blueprints152 61, cellar156 49 and blueprint_manor152 47. Tooling passed 42 tests. Native floor-picker and furnished-room images were reviewed. The upstairs scenario covers exact spending, actual storage deposits, renovation, cold reload, old-save format and a ground kitchen/cellar workshop-storage connection.

## Next work and limits

Next: explicit household-worker routes and automated freight across the surface/mine boundary. Current household and mine routes retain their owners; carts stay parked for household stairs. No new mine depths, automated excavation or property-story integration were added.

Normal-speed Windows input, audio, performance and enjoyment still need player testing. Preserve previous releases and saves. Follow [release procedure](RELEASE_PIPELINE.md); delivery-document updates need no rebuild. Previous delivery is retained in [history](history/CURRENT_STATUS-before-upper158.md).
