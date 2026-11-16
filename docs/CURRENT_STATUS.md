# Current status — 0.121.0 delivered; 0.122.0 candidate

## Published Windows build

**[0.121.0 — Faces and first deeds](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.121.0)** is published. [PR #181](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/181) is merged after required checks and native visual review.

- Release source: `4ef70080086afac185fc507640851296e4026e32`; tree: `c7e77d4c4117a41c7f78077b56bbb9ad84fd3157`.
- Source merge: `4fe32550fedf3502e4938232771fd711185979fb`.
- [Release validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43781555374): all 11 jobs passed, including 87 native source cases and 77 exact-package cases / 14827 assertions, aggregate verification and publication.
- [PR validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43781385001): all 6 jobs passed.
- Public assets: Windows ZIP, build.json, release-summary.json and verification-evidence.tar.gz.
- Windows ZIP: 964,832,037 bytes; SHA-256 `b64eef26735bbaf1199de04680b51d0e4e6fb2c67e67f2cf4e55886bbb4fd70a`.
- PCK SHA-256: `d2ed29092d887e879ca27607145a012b42946ae55204a2ffc2a5f08c4609b2d4`.

Downloaded both public JSON documents, verified their GitHub asset digests and matched version, clean source, PCK/ZIP hashes and ZIP size. The ZIP digest matches GitHub's asset digest. The publication gate verified the complete archive; it was not independently downloaded again. Source was merged after publication; the download already contains that reviewed source.

## Delivered scope

Rurik and Sigrid join the opening introductions; Borin has an optional local introduction. First forge firing, Winter Stores opening and rescue dispatch receive short, skippable scenes in their actual locations. Quest owners commit their transactions before presentation. Saved scenes resume at the current beat; skipping never repeats rewards and completed older quests do not replay.

Six focused native cases passed 727 assertions; 42 tooling tests passed. Native views checked portraits, captions, controls and hidden interaction prompts. Two older forge interaction tests were updated to close the new scene before continuing their existing checks. The corrected source passed the complete release pipeline. See [implementation](SCENES181.md) and [playtest guide](PLAYTEST_GUIDE.md).

## Candidate

0.122.0 adds Borin’s optional repair and early discovery/people scenes (STORY183.md). Local checks and native review are underway. No new release has been published yet.

## Next work and limits

Playtest opening pace, scene discoverability and repeat visits before expanding optional specialist stories. Normal Windows input, audio, performance and progression economy remain human playtests. The intermittent freight-route failure from 0.116.0 remains a follow-up; capture seed and worker/route state if it recurs.

[Previous delivery](history/CURRENT_STATUS-before-scenes181.md).
