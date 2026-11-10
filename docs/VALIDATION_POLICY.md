# Development validation and release gates

Routine PRs run tooling safety tests and a reviewed selection of native cases.
`tools/plan_validation.py` saves the selection and reasons to `test-results/validation-plan.json` and prints only mode/count metadata
into the Actions summary. Every selected case runs once in up to four workers.
The stable `validation` job fails if planning or any required worker fails.
There is no duplicate people-preview job and no second automatic run on merge.

- Agent instructions (AGENTS.md) are documentation; they do not suppress tests for accompanying runtime changes.
- Documentation and release-tooling changes run Python safety tests, without a game export.
- Registered test changes run those cases plus startup and first-visit save/load.
- Ledger/campaign/restoration changes use the restoration integration group plus startup/save checks. Work/production changes include both the work and restoration groups.
- Other explicitly mapped subsystem files use their existing integration suites.
- Shared owners, assets, test fixtures, manifest edits, unmapped files, and unavailable diffs use the full source suite. Deletions and both sides of renames count.
- A manual Game validation run always runs the full source suite.

This deliberately starts with a small reviewed map. Do not add a narrow mapping
without considering all consumers and saved-state migrations. Changing shared
state, surface orchestration or character rendering is not a narrow change.
Named character tests are retained for full/art coverage; an isolated test edit
no longer boots every other character scenario. Further consolidation can follow
measured profiling without discarding unique gait, identity and rescue coverage.

## Local iteration

Use the existing focused/integration suites, or select cases directly:

```sh
python3 tools/check.py --godot /path/to/godot --case loading --case firstvisit99 --output /new/evidence/directory
python3 -m unittest discover -s tools -p 'test_*.py' -v
python3 tools/plan_validation.py --base BASE_COMMIT
```

The same isolated saves, error detection and explicit completion markers apply.
A new runtime change with no reviewed map falls back to full testing. Focused
success must never be described as full release acceptance.

## Releases and deliberate rehearsals

Editing `tools/check_pack.py` no longer starts a Windows build. Run Verified
Windows release manually for a non-publishing full rehearsal of the selected
ref. Only a push to `release/<version>` publishes; manual runs never publish,
even if the selected ref is a release branch.

Each release/rehearsal runs all four source groups against its own exact source
alongside the Windows build. The four package workers test every registered
exported case, and the verifier requires every case once against matching
source/package/archive hashes. Publication depends on both complete gates.
It never treats a focused PR pass as full coverage and never waits for an
unrelated PR workflow. The old `verify_source_gate.sh` now rejects use instead
of accidentally trusting focused evidence.

No gameplay, artwork, saves, release number or already-running workflows change.
Wall-clock savings must be measured on hosted runs; selected case counts are not
a claim about player-device performance or guaranteed elapsed time.
