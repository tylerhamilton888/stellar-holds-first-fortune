# Current status — 2026-11-13

## Published Windows build

**[0.112.0 — Freight through the holding](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.112.0)** is published. [PR #163](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/163) merged after its full validation passed.

- Release source: `0333a54554592847579b4e211798ce625da7e321`; tree: `25f92aa50fd96396c23a73bd2acdc5c8ad76fbc8`.
- Source merge: `94486969f7da5b9920b42afa49bd6657dc6bc73f`.
- [Release run](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43538478196): all 11 jobs passed, including 87 native source cases, 77 exact-package cases / 14,528 assertions, aggregate verification and publication.
- [PR validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43538483052): all four gameplay groups and the final gate passed.
- Public assets: Windows ZIP, build.json, release-summary.json and verification-evidence.tar.gz.
- Windows ZIP: 964,793,495 bytes; SHA-256 `facfad92ed80fb7a249daca6aff0be5f08684030152a1943809a1868971a67b4`.
- PCK SHA-256: `f7eae9034773d52a0f70278d491004c56c5bd557a89cae7178dd5f2fdfacc5a5`.

Post-publication checks downloaded both public JSON documents, verified their asset digests and matched version, clean source, PCK/ZIP hashes and ZIP size to the uploaded asset record. The publication gate verified the full ZIP; it was not independently downloaded again.

## Delivered scope

In **O → Plan Your Holding → Freight for the household**, choose a recruited miner, material, direction, marked mine stockpile and chest on the selected floor. The same worker carries up to 32 units through actual mine passages, stairs/ladders, cellar stairs and built household floors. Goods stay in their existing stores or in one carried load; crafting still requires chest withdrawal.

Stops finish the current delivery. Return controls bring cargo physically back to its source; a returning load can instead finish delivery if its source is gone. Blocked routes and missing chests retain cargo. Order, floor, position and load survive reload. Freight yields to masonry cargo and unladen rest, uses ordinary crew provisions and preserves mine assignments and berths. A reassigned carrier waits until assigned as a miner again. Wheelbarrows stay underground.

Reviewed native book controls, upstairs carrier and perspective-mine crate rendering. The perspective mine view excludes upstairs crew. Preflight passed 43 freight, 33 worker and 49 cellar assertions plus all 42 tooling tests. See [freight](FREIGHT162.md), [crew](WORKERS160.md) and [playtest guide](PLAYTEST_GUIDE.md).

## Next work and limits

The remaining blueprint follow-up is provisional property-story integration, followed by normal player testing and polish. New mine depths, automated excavation and Handworks raw-load freight are separate work. Normal-speed Windows input, audio, performance and enjoyment still need player testing.

Preserve releases and saves. Documentation-only corrections need no rebuild. [Previous delivery](history/CURRENT_STATUS-before-freight162.md).
