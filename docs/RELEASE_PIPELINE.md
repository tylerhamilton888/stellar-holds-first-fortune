# Parallel Windows release checks

The previous Windows release spent 65 minutes running 60 exported-game cases sequentially. The current catalogue has 61 cases. Four independent GitHub runners now process disjoint round-robin groups from the same catalogue; each runner still executes its cases sequentially with isolated saves. No gameplay test or completion/error check is removed.

The previous run's measured timings project roughly 15–18 minutes per group, plus build, transfer and verification time. This is an estimate until the first full hosted benchmark completes. Source validation can still dominate a release started before its native gate passes; runner queues and artifact transfer also affect elapsed time.

## Workflow

1. Build one clean Windows ZIP and upload it with `build.json` as a one-day candidate artifact. Already-compressed files use artifact compression level zero.
2. Independently require the full passing native gate for identical source. Search 64 ancestors instead of eight to tolerate delivery-only commits. If none exists, fail with an actionable error rather than silently launching another long sequential suite.
3. Four test runners download the identical candidate, verify ZIP and member hashes, extract its PCK, and run their assigned cases. They check out only tools/tests, without importing the game's historical art.
4. A read-only aggregation job requires all four jobs plus the native gate to succeed. It rejects missing/extra shards, focused runs, incomplete results, wrong source/package hashes, failures, missing cases and duplicates. Every current exported case must appear exactly once.
5. Only an explicit `release/<version>` branch can publish. The publishing job rechecks the candidate against the aggregate proof and retains the existing release instead of replacing it. PR runs exercise the full pipeline but never publish.

## Evidence and retries

Each shard saves `report.json`, `results.json`, logs, timings and screenshots. Publication includes the complete evidence archive and `release-summary.json`. Candidate/shard transfer artifacts expire after one day; the aggregated evidence lasts seven days and is also preserved as a release asset. Required artifact transfers fail closed if storage/download fails.

Rerun failed jobs within the same run while its candidate is retained. If the candidate expires, rerun the complete workflow. A rebuilt candidate with different bytes cannot reuse old shard proof. Do not edit or restart an unrelated release already in progress.

`python3 -m unittest discover -s tools -p test_release_pipeline.py -v` exercises orchestration failure paths. `python3 tools/check_pack.py --list-cases --shard-count 4 --shard-index 0` lists a group's membership. Omitting shard arguments retains sequential local behavior; `--case` remains available for focused development but cannot satisfy release coverage.

Native visual review and normal-speed Windows/audio playtesting retain their existing roles. This change affects delivery tooling only.
