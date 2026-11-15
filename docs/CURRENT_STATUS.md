# Current status — 0.118.0 delivered; 0.119.0 candidate

## Published Windows build

**[0.118.0 — A smith’s skilled hands](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.118.0)** is published. [PR #175](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/175) merged after all required checks and visual review.

- Release source: `bfd8d05f8b920979f142ebda73d53710c8b91dfd`; tree: `0f80df2fa2163449aa224a5eba7397bbb67968ff`.
- Source merge: `556d9f0dfb65a78a81642b27101391c3d09b93e6`.
- [Release validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43738808555): all 11 jobs passed, including 87 native source cases and 77 exact-package cases / 14654 assertions, aggregate verification and publication.
- [PR validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43738155925): all 6 jobs passed.
- Public assets: Windows ZIP, build.json, release-summary.json and verification-evidence.tar.gz.
- Windows ZIP: 964,818,305 bytes; SHA-256 `a78e37d8a9293995dbcd45daa1fdb3848175b562a3c8a149366ba9afcc89eae2`.
- PCK SHA-256: `07965e6e75ceaa0e9ae16c49c2d5d72ae9c818c35d86ef48a65a369c0e83a3d1`.

Downloaded both public JSON documents, verified their GitHub asset digests and matched version, clean source, PCK/ZIP hashes and ZIP size. The ZIP digest also matches GitHub’s published asset digest. The publication gate verified the complete archive; it was not independently downloaded again.

## Delivered scope

Borin accepts material-plus-fee orders for steel picks, reinforced-pick assembly and individual hafts, heads and fittings. His expertise replaces player research for these orders, with no friendship requirement. Work completes immediately, without personal manufacturing credit or research grants. Self-crafting, market purchases, existing tools and saves are preserved.

Three focused native cases passed 855 assertions without errors; 42 tooling tests passed. Reviewed both conversation pages, quoted costs, blocked/completed orders and scrolled closing responses. See [implementation](COMMISSIONS175.md) and [playtest guide](PLAYTEST_GUIDE.md).

## Candidate

0.119.0 implements the first civic-livelihood integration slice (LIVELIHOOD177.md). Validation and publication are pending; 0.118.0 remains the delivered build.

## Next work and limits

Continue the Home and Fortune roadmap with Ledger/sandbox integration, then environmental polish. Broader specialist stories and advanced equipment remain extensions. Preserve existing estates, tools, inventories, workers and saves.

The intermittent freight-route failure recorded in 0.116.0 remains an unresolved follow-up; this release does not claim a root-cause fix. Capture seed and worker/route state if it recurs. Normal Windows input, audio, performance and progression balance still need playtesting.

[Previous delivery](history/CURRENT_STATUS-before-commissions175.md).
