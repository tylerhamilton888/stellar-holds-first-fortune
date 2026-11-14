# Current status — 0.114.0 delivered

## Published Windows build

**[0.114.0 — A clearer building grid](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.114.0)** is published. [PR #167](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/167) merged after required checks passed.

- Release source: `a4a4d755f39335a67f74d4341ea55d10a0e42661`; tree: `43ff6afd5d3c89c9245ab6f433d7d92bd0061f6c`.
- Source merge: `91d01623fe32226a524aa2ef35d4f633ad2ac5e3`.
- [Release run](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43628793692): all 11 jobs passed, including 87 source cases, 77 exact-package cases / 14,561 assertions, aggregate verification and publication.
- [PR validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43628794197): all four gameplay groups and final validation passed.
- Public assets: Windows ZIP, build.json, release-summary.json and verification-evidence.tar.gz.
- Windows ZIP: 964,804,952 bytes; SHA-256 `da2f1bc32a5e3b639612c35afbeb7475bcce049be409fe704ebf6e2c73f6e2b8`.
- PCK SHA-256: `a13a34752b46e3a0ccfae519fb0965f36cd3356857227d7e3491d8fac05186b5`.

Downloaded both public JSON documents, verified their GitHub asset digests, and matched clean source, version, PCK/ZIP hashes and ZIP size. The publication gate verified the complete ZIP; it was not independently downloaded again.

## Delivered scope

Fine construction, catalogue buildings and furnishings share a visible structural grid over the full L-shaped holding and editable interiors. Existing 40-unit structural, 20-unit building and 10-unit furniture snapping is unchanged. Gold guides follow the placement anchor. The Blueprint Book shows live and selected room dimensions, including outer walls, with exact edge/center alignment guides on the selected floor. Costs, placement validity, saved coordinates and ownership are unchanged.

Five local native cases passed 537 assertions; 42 tooling tests and output policy passed. Reviewed all three world modes, selected/dragged room dimensions and adjacent-room alignment. See [grid notes](GRID167.md) and [playtest guide](PLAYTEST_GUIDE.md).

## Next work and limits

Follow [A Home and a Fortune](HOME_AND_FORTUNE_ROADMAP.md): the family-purchased Rise, early modest cottage, optional first shift, civic registration distinct from ownership, and migration preserving all existing possessions and rights. Candidate 0.115.0 implements this story revision; validation and publication are pending. The published 0.114.0 opening still retains provisional use after the first paid shift and permanent tenure after two contributions. See HOME169.md.

Then extend tools/materials, cross-craft components, specialist commissions and reliable buying alternatives, Ledger/sandbox integration and environmental polish. Keep delivered blueprinting, connected floors, workers and freight. Normal Windows input, performance, audio and pacing still need ordinary playtesting. Preserve releases and saves. [Previous delivery](history/CURRENT_STATUS-before-grid167.md).
