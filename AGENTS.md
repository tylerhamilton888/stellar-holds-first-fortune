# Development instructions
Read docs/SESSION_HANDOFF.md and docs/CURRENT_STATUS.md first. They point to the current checkpoint. Read only task-relevant files next. Code/assets/test results override historical documentation.

No unrelated gameplay changes, file moves or refactoring. Preserve resource paths, UIDs, original assets and save compatibility. Use docs/TESTING.md and isolated test data. Verify affected visuals for graphic/UI/animation edits. Update status/changelog/backlog after meaningful work; keep documents concise. Maintain a recoverable local checkpoint and confirmed persistent backup. Never push/change remotes or delete backups without explicit authorization. Do not spawn sub-agents unless the user requests delegation.

For in-world art and animation, follow docs/ART_DIRECTION.md: the existing in-world Dwarf models are the gold standard. Portrait/cutscene treatment may vary. Judge props and environments beside the character at gameplay scale.

Current shared workflow: docs/DEVELOPMENT.md. Run the relevant cases from tests/suites.json via tools/check.py; new tests use tests/support/game_fixture.gd. Version/title/build metadata belongs in scripts/build_info.gd. Keep refactors behavior-preserving and reviewable.

Owner authorization (2026-10-23): when the owner directs work, that authorization includes merging the completed work and its delivery documentation after required checks and visual review pass. Do not ask for separate routine merge confirmation. Keep changes within the directed scope and preserve the backup/release procedures above.
