# Current status — 0.117.0 delivered

## Published Windows build

**[0.117.0 — A tool made by many hands](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.117.0)** is published. [PR #173](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/173) merged after required checks and visual review.

- Release source: `00d4441d0737b690834f92b13c9eef8371d11546`; tree: `12728bc4012a9de1a94f9401bcd2c6fa61f69c39`.
- Source merge: `0eb08949ec4a1e5e829d2b7f5f778014ab6d5946`.
- [Release validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43655244281): all 11 jobs passed, including 87 native source cases and 77 exact-package cases / 14631 assertions, aggregate verification and publication.
- [PR validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43654855151) passed.
- Public assets: Windows ZIP, build.json, release-summary.json and verification-evidence.tar.gz.
- Windows ZIP: 964,817,525 bytes; SHA-256 `3239c02692e3aaeacef3687e0bd1619c2a624331e8db27df711bcc8befed216a`.
- PCK SHA-256: `fb4e12a2f9076fecf434ca7dcae296fa8c3eec1d59f7d019fc2e9275511adcb8`.

Downloaded both public JSON documents, verified their GitHub asset digests and matched version, clean source, PCK/ZIP hashes and ZIP size. The publication gate verified the complete ZIP; it was not independently downloaded again.

## Delivered scope

Reinforced picks now assemble from one shaped haft, forged pickhead and fitting set. The existing queued recipes and market supply all parts; manufacturing the full set retains the former raw cost of 8 iron, 2 copper, 3 coal and 2 timber. Completed hafts credit Woodworking, while heads/fittings credit Smithing. Buying parts does not claim manufacturing credit. Ordinary steel crafting and all existing owned picks remain intact.

A compact Tool components page shows inputs, outputs and professions. The inventory item grid scrolls independently so the character summary stays visible as the catalogue grows. Five focused native cases passed 483 assertions and 42 tooling tests passed. Reviewed the component page, assembly costs/ownership and expanded inventory. See [implementation](COMPONENTS173.md) and [playtest guide](PLAYTEST_GUIDE.md).

## Next work and limits

Continue the Home and Fortune roadmap with specialist commissions and acquisition alternatives, then Ledger/sandbox integration and environmental polish. Broader advanced equipment and additional component uses remain future extensions. Preserve existing estates, tools, inventories, workers and saves.

The intermittent freight-route failure recorded in 0.116.0 remains an unresolved follow-up; this release does not claim a root-cause fix. Capture seed and worker/route state if it recurs. Normal Windows input, audio, performance and progression balance still need playtesting.

[Previous delivery](history/CURRENT_STATUS-before-components173.md).
