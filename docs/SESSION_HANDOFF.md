# Foundation 0.61.1 handoff

Continue from GitHub `main`, now a complete editable Godot project. Source import PR #2 merged at `5955e2e754a1545742e7ffc3f66dacc253ddc446`. The two-parent import commit is `3f97736cbc02ee1b46bbbbd4cbfb00d633593215`; its verified source parent is `6a153eff59e6e38dccf8e2bdd2d3b575703260ac`. Earlier delivery tags remain unchanged. `ambient-0.61.0` / `pre-foundation62` preserve source baseline `300ec660c3b66ee2dcf2c0866d8c52b0e872603f` in the complete bundle.

Read CURRENT_STATUS.md, DEVELOPMENT.md and testing/foundation62.md. No more incremental recovery chain is needed for normal development: clone GitHub and open project.godot in Godot 4.4.1. AGENTS.md applies to human and AI contributors. Do not rerun the one-time source-import workflow for routine edits; use focused branches and PRs.

Implemented: menu_view.gd owns widget factories, theme and panel shell; main.gd retains host facades and game decisions. build_info.gd owns version/chapter/engine. Current tests use tests/support/game_fixture.gd; physical keys now include physical_keycode. The historical world journey no longer assumes retired two-hit excavation; mining55 still validates actual deliberate timing. Resource paths, UIDs, original assets and save format are preserved.

Run `python tools/check.py --godot <engine> --suite gameplay --output <new-directory>` with a native display. Isolated saves, sequential cases, explicit completion markers and exit required. tools/build.py creates a complete Windows ZIP after runtime fingerprint and PCK audit. Exact-export tests remain standalone because tests are excluded from shipping packs. See testing/foundation62.md for 201-check source/export results, independent clean-clone rerun and hosted CI.

The Windows build uses clean runtime commit `1ee67e6993f8bbe24c49608419351b1a017b9f1b`; later changes are fixture/docs/workflow records only. Full recovery bundle at release foundation-0.61.1: SHA-256 `ac12981605de65ac5d085043e46f892040daba02fc08b1799bc9beeca1fd31c3`, 1,659,232,680 bytes. Source branch inside bundle: chore/foundation62. Independent clone and git fsck passed; GitHub digest matches. The foundation release tag itself records bootstrap delivery; use main for the latest editable project.

No gameplay/art rewrite was attempted. Further main.gd extraction, shared actor/geometry behavior and dead-code removal need focused evidence. Do not discard original artwork or force-push existing history. Windows/audio/hardware performance limitations remain.
