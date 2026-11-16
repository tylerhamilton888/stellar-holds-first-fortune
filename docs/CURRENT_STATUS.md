# Current status — 0.123.0 A clearer view

**[0.123.0 — A clearer view](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.123.0)** is public. [PR #185](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/185) merged after required checks and native visual review.

## Verified delivery

- Release source: `78394c0fce379bfbf76e7498741b1f59a39dc346`; tree: `898ae1ab42bc1b93a4e647cd19a29afcacf33d09`.
- Source merge: `880d847ed4bea7d0537d3fca8c78c96e771ab61b`.
- [Release validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43922798661): all 11 jobs passed, including 87 native source cases and 77 exact-package cases / 14848 assertions, aggregate verification and publication.
- [PR validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43921480366): all 6 jobs passed.
- Public assets: Windows ZIP, build.json, release-summary.json and verification-evidence.tar.gz.
- Windows ZIP: 964,832,843 bytes; SHA-256 `069379fe017aa179d3a332259cc9490673de3c025bfca50ec9af385ea8455f13`.
- PCK SHA-256: `9f59473c20f99b90ed9c23a95fbea8edf84b4b49cfc9f2bb3f5549ae37858341`.

Downloaded both public JSON documents, verified their GitHub asset digests and matched version, clean source, PCK/ZIP hashes and ZIP size. The ZIP digest matches GitHub's asset digest. Publication verified the complete archive; it was not independently downloaded again.

## Delivered scope

The bunkhouse and starter quarters follow the player to reveal upper furnishings and southern exits. Ivar stays visible at the opening spawn. Standard rooms can show more of their north wall; established southern exit framing and the throne camera are preserved. Tall foreground furnishings fade when they obscure the player, while their physical bases remain unchanged.

Reviewed the compact communal/starter workshops, legacy forge, cottage roof cutaway, hold wards and entrances. Existing room sizes, saved belongings, storage, costs and story are preserved. This was a targeted visibility review, not an exhaustive visual review of every game area.

Five focused native cases passed 256 assertions; the final civic/lodge replay passed 124 after the exit correction. The 42 Python tooling tests passed. See [review](VISIBILITY185.md) and [playtest guide](PLAYTEST_GUIDE.md).

## Next work and limits

Playtest the first few hours for pacing, discoverability, movement, Windows input/audio and performance before expanding the feature batch. Use a new fortune for the opening and an older save to check belongings and room entrances. Preserve dwarven craft standards: approval follows sound workmanship.

The older intermittent freight-route issue remains a follow-up; capture seed and worker/route state if it recurs.

[Previous delivery](history/CURRENT_STATUS-before-visibility185.md).
