# Foundation 0.61.1 handoff

Read CURRENT_STATUS.md, DEVELOPMENT.md and testing/foundation62.md. Source branch: `chore/foundation62`. Baseline `ambient-0.61.0` and `pre-foundation62` both preserve `300ec660c3b66ee2dcf2c0866d8c52b0e872603f`. All previous backups remain intact.

Implemented: `menu_view.gd` owns widget factories, theme and menu shell; `main.gd` retains compatible facades and game logic. `build_info.gd` owns version/chapter/engine metadata. Current tests use the dedicated prewarm-aware fixture; physical key events include physical_keycode. The historical world test's two-hit assertion was updated to current resistance, without changing gameplay. Original resource paths, UIDs, assets and save schema are preserved.

Run `tools/check.py --godot <engine> --suite gameplay --output <new-directory>` with native display; each case has isolated saves and requires explicit completion plus exit. Build with `tools/build.py` and the pinned unchanged official Windows template. Exact PCK tests remain standalone by design. 201 current passing local checks; all 3,132 exported entries verified. Details and limitations in testing/foundation62.md.

GitHub PR #1 prepared workflows. The complete source migration is not finished at this checkpoint: attach `Stellar-Holds-Foundation-Source.bundle` to release `foundation-0.61.1`, verify server digest, dispatch Import verified source history with exact bundle SHA-256 and source commit, inspect native verification, then merge foundation/source-import. Importer joins both histories with two parents; never force-push existing tags/main. Confirm a real Godot project and original runtime assets exist remotely before updating status to complete.

Do not expand this work into a gameplay/art rewrite. Broader legacy removal and actor/geometry consolidation require focused regression evidence. AGENTS.md applies equally to Codex, Claude and human contributors.
