# 0.61.2 — Welcome to the Hold

2026-10-20. Implemented and merged via PR #3 (`d539cb535fad79fb2bd141ed73e5c3a848ad9bf0`). The title uses the current whole-character held-pick artwork. An illustrated overlay above HUD and cutscenes shows rotating hints and actual animation-preparation progress. Release-scoped disk caching reuses recolored frames across launches. New fortunes start with randomized editable Dwarven names and appearances; existing identities and save format are preserved.

**228 local checks passed**: 190 existing gameplay checks, 19 loading/identity checks, and 19 against the exact exported PCK. Native visuals inspected. Hosted full gameplay validation passed, run 39484028846. All 3,134 pack entries and the complete Windows ZIP passed integrity checks. GitHub's asset digest matches the local ZIP.

[Download 0.61.2](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.61.2): one Windows ZIP, 698,806,969 bytes; SHA-256 `7a3b83aaf213bc4681a9eaa211ae9f1015b8d7058d0bf91d554d76e05874f6a2`. Release tag points to complete source `4169069d9f80e6fae3dc33deee855c8b16a13916`. Prior releases and the full foundation source bundle remain intact.

First-time preparation still costs work; cached preparation was about 1.35 seconds for 488 frames on the Linux software renderer. This is not a Windows hardware performance guarantee. Windows execution/audio remain player-test limitations. Details, captures, logs and cache-invalidation rules: testing/loading63.md. Development workflow and foundation history: DEVELOPMENT.md and testing/foundation62.md.
