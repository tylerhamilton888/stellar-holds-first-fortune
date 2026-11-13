# Current status — 2026-11-13

## Published Windows build

**[0.111.1 — Crew berths and connected household routes](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.111.1)** is published. [Feature PR #160](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/160) and [legacy-site correction #161](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/161) merged after their required checks passed.

- Release source: `fdf56920468474950488aa3051e4b780754ace55`; tree: `89c980e85154f0b5d81f084aba280695e7e987ab`.
- Source merge: `ce1c022c6fdffd392ff2211e598cfa45afe69b73`.
- [Release run](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43501138113): all 11 jobs passed, including 86 native source cases, 76 exact-package cases (14,485 assertions), aggregate verification and publication.
- [PR validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43501138451): all four gameplay groups and aggregate gate passed.
- Assets: Windows ZIP, build.json, release-summary.json and verification-evidence.tar.gz.
- Windows ZIP: 964,793,762 bytes; SHA-256 `1a5d56c37345f5f01f48d0f667c82c27b686abfd9d8b7f65f352a1ecbb0fda40`.
- PCK SHA-256: `037886dbc8d0442c5c719ac7d729a2b652ebcbb47db489d46e3ec39bca29368b`.

[Post-upload verification](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43506857764) retrieved both public JSON documents, checked their asset digests and compared version, clean source, PCK/ZIP hashes and archive size with the published asset record. The publication gate verified the full ZIP; it was not independently downloaded again.

## Delivered scope

This is the household-worker slice of Stage C. In **O → Plan Your Holding → A bed for your crew**, choose a floor and actual bed, then **Assign selected bed** to a recruited miner. Room designation is optional. Provide a clear built route, household stairs, a fitted cellar stair and provisions.

The same worker walks from the claim mine to the bedside, rests and returns to the original assignment. Long commutes finish their rest; positions and berths survive reload. Obstructions stop travel. Missing beds cancel rest and return the worker through the remaining route. Rest requires actual arrival and provisions. Legacy workers at other worksites retain their prior behavior.

No duplicate roster or remote stock transfer is created. Masons return job cargo before commuting. Ground/upper plans and the existing cellar remain intact. See [crew routes](WORKERS160.md), [upper floors](UPPER158.md), [cellar notes](CELLAR156.md) and [playtest guide](PLAYTEST_GUIDE.md).

Preflight passed 31 worker assertions in headless/native Godot 4.4.1 and 42 tooling tests. The final case adds two legacy-worksite checks and passed full source/package gates. Native berth controls and upstairs resident rendering were reviewed; the legacy correction does not change presentation.

## Next work and limits

Next core blueprint piece: automated freight across the household/mine boundary. Carts stay parked at household stairs. New mine depths, automated excavation and provisional-property story integration remain deferred.

Normal-speed Windows input, audio, performance and enjoyment still need player testing. Preserve releases and saves. Follow [release procedure](RELEASE_PIPELINE.md); documentation-only updates need no rebuild. [Previous delivery](history/CURRENT_STATUS-before-workers160.md).
