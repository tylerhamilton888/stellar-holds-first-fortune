# Foundation 0.61.1 — complete

2026-10-20. GitHub **main now contains the complete editable game**, original assets and source history. Source import PR #2 merged at `5955e2e754a1545742e7ffc3f66dacc253ddc446`; its import commit `3f97736cbc02ee1b46bbbbd4cbfb00d633593215` joins the source and delivery histories without rewriting existing tags. The core asset/audio/script/test/tool/project Git hashes match the verified local source.

Implemented: shared menu presentation (`HoldMenuView`), one version/engine metadata source (`HoldBuild`), canonical native test fixture, current suite manifest, checked packaging, GitHub validation, PR template and concise contributor documentation. No gameplay balance, art, movement or save-schema changes.

Verification: **201 passing local checks**, including 11 against the exact exported PCK; all 3,132 entries audited. A separate full-bundle clone imported without existing caches, passed all 190 source checks, exported, and passed the 11 standalone pack checks. Fresh export content matches the delivered pack except Godot's generated UID cache; byte-identical PCK output across machines is not claimed. GitHub importer and PR validation both passed on hosted runners.

[0.61.1 build and complete recovery](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/foundation-0.61.1). Download only the Windows ZIP to play. Its SHA-256 is `6867fd2c76c20171b2c12daf6dc0e379f7b70f1f04efde38390470e2f589b837`. The optional full source bundle restores independently; older backups/releases remain intact. Windows execution, audio and player-device performance still require playtesting.

Use `tools/check.py`, `tests/suites.json`, and `tools/build.py`; see DEVELOPMENT.md and TESTING.md. Broader session extraction, actor orchestration and legacy dependency cleanup remain incremental future work, with regression evidence required.
