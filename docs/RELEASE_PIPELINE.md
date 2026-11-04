# Parallel Windows release checks

The 0.97.2 release spent **66m 50s** running all 61 exported-game cases sequentially. The verified four-runner trial completed the same case catalogue in **14m 59s elapsed test time**, a **77.6% reduction**. All **13,706 assertions** passed, and the aggregate gate confirmed every case exactly once against one source/PCK/ZIP identity. The 13 local pipeline safety tests also passed.

The full non-publishing trial took **30m 29s**, including a fresh build and waiting for the native gate. Its final publication step was deliberately skipped because it was a PR rehearsal. Future elapsed time depends on native validation readiness, GitHub queues and runner performance; the 15-minute measurement covers the package test stage only. No gameplay test or completion/error check was removed.

Evidence: [benchmark.json](testing/release136/benchmark.json), [parallel trial](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41769966860), [native gate](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41769967228). [PR #119](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/119) merged as `a398cb54ea0d5a1fa8ca9a638666f3bf102c0051`; its tree matches the tested PR merge. The game version remains 0.97.2.

## Workflow

1. Build one clean Windows ZIP and upload it with `build.json` as a one-day candidate artifact. Already-compressed files use artifact compression level zero.
2. Independently require the full passing native gate for identical source. Search 64 ancestors instead of eight to tolerate delivery-only commits. If none exists, fail with an actionable error rather than silently launching another long sequential suite.
3. Four test runners download the identical candidate, verify ZIP and member hashes, extract its PCK, and run their assigned cases. They check out only tools/tests, without importing the game's historical art.
4. A read-only aggregation job requires all four jobs plus the native gate to succeed. It rejects missing/extra shards, focused runs, incomplete results, wrong source/package hashes, failures, missing cases and duplicates. Every current exported case must appear exactly once.
5. Only an explicit `release/<version>` branch can publish. The publishing job rechecks the candidate against the aggregate proof and retains the existing release instead of replacing it. PR runs exercise the full pipeline but never publish.

## Starting a requested release

After local checks and review, open the source PR first. If the owner requested a release, create `release/<version>` from that exact reviewed source (or a documentation-only descendant) once its native validation run exists. Let package checks and native validation overlap; do not wait for the native PR run to finish before starting the release build. Merge the source once its required gates pass. Publication remains blocked until both complete gates succeed. Do not create a release branch when the owner requested source changes only.

## Evidence and retries

Each shard saves `report.json`, `results.json`, logs, timings and screenshots. Publication includes the complete evidence archive and `release-summary.json`. Candidate/shard transfer artifacts expire after one day; the aggregated evidence lasts seven days and is also preserved as a release asset. Required artifact transfers fail closed if storage/download fails.

Rerun failed jobs within the same run while its candidate is retained. If the candidate expires, rerun the complete workflow. A rebuilt candidate with different bytes cannot reuse old shard proof. Do not edit or restart an unrelated release already in progress.

`python3 -m unittest discover -s tools -p test_release_pipeline.py -v` exercises orchestration failure paths. `python3 tools/check_pack.py --list-cases --shard-count 4 --shard-index 0` lists a group's membership. Omitting shard arguments retains sequential local behavior; `--case` remains available for focused development but cannot satisfy release coverage.

Native visual review and normal-speed Windows/audio playtesting retain their existing roles. This change affects delivery tooling only.
