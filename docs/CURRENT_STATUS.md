# Current status — 0.115.0 delivered

## Published Windows build

**[0.115.0 — A gift from home](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.115.0)** is published. [PR #169](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/169) merged after required checks passed.

- Release source: `bafb91778234741e7f8bf5d264f96f66bce882d4`; tree: `3cf34d0fec0cd3bdecbe38098eb10cac18483e74`.
- Source merge: `76a8d66d773d7636f53623bc6cb061243e596aaf`.
- [Release run](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43639562812): all 11 jobs passed, including 87 source cases, 77 exact-package cases / 14,570 assertions, aggregate verification and publication.
- [PR validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43639563209): all four gameplay groups and final validation passed.
- Public assets: Windows ZIP, build.json, release-summary.json and verification-evidence.tar.gz.
- Windows ZIP: 964,809,219 bytes; SHA-256 `03fce333245c47223e513aac79d9ed132007c7f49560200d2df9f1e3af372152`.
- PCK SHA-256: `a20dc430a6d8f7d8398da4bbbfa3467f1ac94ae1ef707cbc0cdf60f11ca65114`.

Downloaded both public JSON documents, verified their GitHub asset digests, and matched clean source, version, PCK/ZIP hashes and ZIP size. The publication gate verified the complete ZIP; it was not independently downloaded again.

## Delivered scope

Parents have already bought Old Stonewright’s Rise. New fortunes receive a modest editable cottage with a usable bed and empty chest. Ivar offers a saved/skippable introduction before mining. The journal holds the parent letter and optional home, paid work, forge, trade and civic opportunities. Two contributions earn civic recognition instead of ownership. Adding paid light can qualify the starter home for recognition without rebuilding; the cottage grants no automatic improvement reward.

Existing frontier holdings retain property, names, structures, inventory, workers and progression without reseeding. Family purchase is independent of ancestry. Non-frontier fortunes retain their original opening. The building grid and blueprint, vertical travel, worker and freight systems remain available.

Eight focused local native cases passed 681 assertions; 42 tooling tests and output policy passed. Reviewed cottage/bedside interaction, introduction, parent letter and Ivar dialogue. See [implementation](HOME169.md) and [playtest guide](PLAYTEST_GUIDE.md).

## Next work and limits

Follow [A Home and a Fortune](HOME_AND_FORTUNE_ROADMAP.md): next audit and extend tool/material capabilities, then cross-craft components, specialist commissions and reliable buying alternatives, Ledger/sandbox integration and environmental polish. Normal Windows input, performance, audio and the 5–10 minute arrival target still need ordinary playtesting. Preserve releases and saves. [Previous delivery](history/CURRENT_STATUS-before-home169.md).
