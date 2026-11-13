# Current handoff — 2026-11-12

## Published Windows build

**[0.109.0 — A cellar beneath your home](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.109.0)** is published. [Source PR #156](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/156) merged after all required checks passed.

- Release source: `e979dca6ff9de52fc71b90c2d7b386e79ab7aaf6`; tree: `2cf8ff06709a069b65d6639be5e8a195f6f26b00`.
- Source merge: `a8549a9bea3f17e09153b6e856f10c17ef7509c6`.
- [Release run](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43366563551): all 11 jobs passed, including 84 native source cases, 74 exact-package cases (14,401 assertions), aggregate verification and publication.
- [PR validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43366007557): all gameplay groups and aggregate gate passed.
- Public assets: Windows ZIP, build.json, release-summary.json and verification-evidence.tar.gz, all uploaded.
- Windows ZIP: 964,705,858 bytes; SHA-256 `4b1c8641cd6e9711fa7c8ac79f8618578ab318e16bd986405537afb3f279de67`.
- PCK SHA-256: `1104979cb259803e61760c47c4e4f8a626308920d62880830028092d72f35203`.

The uploaded metadata and verification receipt were retrieved directly. Version, source and PCK/ZIP hashes agree; ZIP size/hash agree with GitHub's asset record. Both retrieved JSON hashes match their asset digests. The full ZIP was verified by the publication gate, not independently downloaded again.

## Delivered scope

This is **the first Stage C milestone, not the whole stage**. In **O → Plan Your Holding**, plan an aligned cellar stair at your feet. Build five clear upper floor tiles and excavate five lower landing tiles plus an approach through the existing claim mine. Fit from above for 4 timber / 2 stone. **Shift+E** at either landing crosses between home and cellar with carried supplies. Built landings are protected from destructive construction and obstructing furnishings/equipment. Carts must be parked.

Existing surface and underground plans, furniture, storage and mine-worker routes retain their owners. No duplicate world or inventory is introduced. See [cellar notes](CELLAR156.md), [surface notes](BLUEPRINTS.md), [underground notes](EXCAVATION154.md) and [playtest guide](PLAYTEST_GUIDE.md).

Focused native acceptance passed 201 assertions: cellar156 49, blueprints152 61, excavation154 60, navigation94 31. The final cellar case recreated the game before loading its underground save. Tooling passed 42 tests. Native furnished-home, cellar and book controls were visually reviewed. Landing input now takes priority over nearby raw-load dressing.

## Next work and limits

Next Stage C work: upper-floor blueprint editing and explicit household-worker/freight routes across the surface/mine boundary. Surface household routines and mine workers currently retain separate routing; carts do not use the new cellar stair. No new mine depths or automated excavation were added. Provisional property-story integration remains deferred.

Normal-speed Windows input, audio, performance and enjoyment still need player testing. Preserve previous releases and saves. Follow [release procedure](RELEASE_PIPELINE.md); documentation-only updates need no rebuild. Previous delivery is in [history](history/CURRENT_STATUS-before-cellar156.md).
