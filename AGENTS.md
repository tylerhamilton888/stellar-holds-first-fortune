# Development instructions
Read docs/SESSION_HANDOFF.md and docs/CURRENT_STATUS.md first. They point to the current checkpoint. Read only task-relevant files next. Code/assets/test results override historical documentation.

No unrelated gameplay changes, file moves or refactoring. Preserve resource paths, UIDs, original assets and save compatibility. Use docs/TESTING.md and isolated test data. Verify affected visuals for graphic/UI/animation edits. Update status/changelog/backlog after meaningful work; keep documents concise. Maintain a recoverable local checkpoint and confirmed persistent backup. Never push/change remotes or delete backups without explicit authorization. Do not spawn sub-agents unless the user requests delegation.

For in-world art and animation, follow docs/ART_DIRECTION.md: the existing in-world Dwarf models are the gold standard. Portrait/cutscene treatment may vary. Judge props and environments beside the character at gameplay scale.
