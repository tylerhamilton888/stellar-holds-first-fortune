# Current status — 0.123.1 Clear corners

**[0.123.1 — Clear corners](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.123.1)** is public. [PR #187](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/187) merged after required checks and native review.

## Verified delivery

- Release source: `ff7d29c72c097845a043bad12f23761cb0f279cd`; source merge: `a3ecadfa639a20dfe180b6f621df5f3f12e255fd`.
- [Release validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43954597970): all 11 jobs passed, including full native source coverage, 77 exact-package cases / 14849 assertions, aggregate verification and publication.
- [PR validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43954606488): all 6 jobs passed.
- Public assets: Windows ZIP, build.json, release-summary.json and verification-evidence.tar.gz.
- Windows ZIP: 964,792,023 bytes; SHA-256 `bca4265260762827af65dcf0c36acc979ec08ccefa84e70270ed9fe5155ff445`.
- PCK SHA-256: `3de50a27e26d44ae5542cb043a59b7116bcf05bd1f4d36bf822689dc813bd7d6`.

Downloaded both public JSON documents, verified their GitHub asset digests and matched version, clean source, PCK/ZIP hashes and ZIP size. The ZIP digest matches GitHub's asset digest. Publication verified the complete archive; it was not independently downloaded again.

## Delivered scope and review

A miner reassigned between cell centres now centres before following a freight route, avoiding repeated collision at a tight tunnel corner. Cargo, storage, stairs, collision and saves retain their existing owners. The freight case records replay seeds and saves failure state outside temporary saves.

Seed 162 reproduced the baseline corner trap. Fixed freight passed 41 headless and 44 native assertions; opening, first visit and forge passed 113. The 42 tooling tests passed. Reviewed the carrier/cargo in the mine and upstairs, plus welcome, cottage and discovery captures. See [review](FREIGHT187.md).

The first candidate was blocked by a duplicate diagnostic function in the inlined package harness. That helper was corrected; the successful run above rebuilt and revalidated the complete candidate. No failed candidate was published.

## Next work and limits

Playtest the first few hours for pacing, discoverability, Windows input/audio and performance before another feature batch. Use a new fortune and an older save. The 0.123.0 visibility improvements remain included; see VISIBILITY185.md and PLAYTEST_GUIDE.md. Preserve dwarven craft standards: approval follows sound workmanship.

The older unrecorded lower-level freight failure is not claimed resolved by this distinct corner fix. Preserve seed and failure snapshots if it recurs.

[Previous delivery](history/CURRENT_STATUS-before-freight187.md).
