# Current status — 0.120.0 delivered; 0.121.0 candidate

## Published Windows build

**[0.120.0 — A place to come home to](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.120.0)** is published. [PR #179](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/179) merged after required checks and native visual review.

- Release source: `43d944f9928e34fc88e38798fe954e00f0d44cb8`; tree: `81653df88af8683b055620748b8ad950cfca3cfe`.
- Source merge: `b6771d9b11542e6161e28e9f14a38a81f6e441ab`.
- [Release validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43767707547): all 11 jobs passed, including 87 native source cases and 77 exact-package cases / 14810 assertions, aggregate verification and publication.
- [PR validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43767565159): all 6 jobs passed.
- Public assets: Windows ZIP, build.json, release-summary.json and verification-evidence.tar.gz.
- Windows ZIP: 964,779,371 bytes; SHA-256 `d44edd38f8187d7c057ce7494753c0f6f616530003e0eac4dbbe372cff491a2c`.
- PCK SHA-256: `656f85b169b9359be59764aea8c6149196fa4724264673b15878dab27cbd6efe`.

Downloaded both public JSON documents, verified their GitHub asset digests and matched version, clean source, PCK/ZIP hashes and ZIP size. The ZIP digest also matches GitHub's asset digest. The publication gate verified the complete archive; it was not independently downloaded again.

## Delivered scope

A stone approach connects the seeded cottage to the masonry lane. The arrival scene and home guidance give the player room to settle in. Lodge greetings acknowledge household and home registrations, with rescue, homecoming and memorial priorities. Two optional family letters use existing registrations; no new chores or rewards. The journal respects non-work ambitions instead of promoting the default ore lesson.

Six focused native cases passed 682 assertions; 42 tooling tests passed. Reviewed the cottage, final tour beat, Ivar's milestone/pay replies and both scrolled letters. A paid-greeting priority regression was caught, corrected and verified. See [implementation](RISE179.md) and [playtest guide](PLAYTEST_GUIDE.md).

## Candidate

0.121.0 adds character introductions and short quest scenes (SCENES181.md). Focused tests and visual review are underway; publication is pending.

## Next work and limits

The first environmental/experiential polish slice is delivered. Review normal-speed arrival pacing, letter discoverability and repeat visits before choosing further interior/environment work. Broader specialist stories and advanced equipment remain extensions; preserve existing property and the authored campaign.

Normal Windows input, audio, performance and progression economy remain human playtests. The intermittent freight-route failure from 0.116.0 is still a follow-up, not fixed here; capture seed and worker/route state if it recurs.

[Previous delivery](history/CURRENT_STATUS-before-rise179.md).
