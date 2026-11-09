# Development instructions
Read only the current docs/SESSION_HANDOFF.md and docs/CURRENT_STATUS.md first; do not read their history archives by default. They point to the current checkpoint. Read only task-relevant files next. Code/assets/test results override historical documentation.

## Conversation and evidence size

For import, tests, export and other potentially noisy commands, use `python3 tools/capture_command.py --log test-results/<unique-task>/runner.log --timeout 1800 -- <command>`. It writes full output to a new file and prints metadata only, including on failure. Inspect selected short diagnostic lines afterward. Do not dump logs/results JSON merely because a check failed.

The size rule covers tool INPUTS as well as OUTPUTS: transfer source/assets through local Git or file uploads, never large encoded-content tool arguments. Inspect API responses inside code and return selected metadata; avoid printing full diffs/trees or both text and structured copies. Edit current status/handoff in place; keep each below 4,000 UTF-8 bytes and archive superseded history. See docs/CONVERSATION_OUTPUT.md for measured hazards and limits of this mitigation.

Never print encoded images, base64/data URLs, binary payloads or archives into command logs or chat/tool output. Use image viewers for inspection and file/artifact uploads for transfer. If an API needs base64, encode and pass it inside the execution environment without echoing the request or response body. Artifact quota or upload failure is not permission to dump bytes into logs.

Keep routine tool summaries under 8,000 characters; save full logs in files and return only selected errors, counts, paths and hashes. Inspect response structure before printing API results. Read the latest status sections and task-relevant excerpts instead of whole historical documents. Keep a concise checkpoint with commit/branch, completed checks, pending work and run/PR links; do not copy old transcripts or base64 log chunks into recovery chats. Preserve original image files and full local evidence.

If output is unexpectedly large, stop repeating that operation, report the observed problem, and switch to file-based transfer or narrower reads. Report actual tool failures and stalled jobs with the step and error; do not claim a known ChatGPT size threshold, predict an unseen platform failure, or promise this prevents every conversation_too_large rejection. See docs/DEVELOPMENT.md for the image-evidence workflow.

No unrelated gameplay changes, file moves or refactoring. Preserve resource paths, UIDs, original assets and save compatibility. Use docs/TESTING.md and isolated test data. Verify affected visuals for graphic/UI/animation edits. Update status/changelog/backlog after meaningful work; keep documents concise. Maintain a recoverable local checkpoint and confirmed persistent backup. Never push/change remotes or delete backups without explicit authorization. Do not spawn sub-agents unless the user requests delegation.

For in-world art and animation, follow docs/ART_DIRECTION.md: the existing in-world Dwarf models are the gold standard. Portrait/cutscene treatment may vary. Judge props and environments beside the character at gameplay scale.

Current shared workflow: docs/DEVELOPMENT.md. Run the relevant cases from tests/suites.json via tools/check.py; new tests use tests/support/game_fixture.gd. Version/title/build metadata belongs in scripts/build_info.gd. Keep refactors behavior-preserving and reviewable.

Owner authorization (2026-10-23): when the owner directs work, that authorization includes merging the completed work and its delivery documentation after required checks and visual review pass. Do not ask for separate routine merge confirmation. Keep changes within the directed scope and preserve the backup/release procedures above.

Owner authorization (2026-11-08): the owner explicitly approved uploading the completed giant-ledger source and original artwork to the public tylerhamilton888/stellar-holds-first-fortune repository, merging after required checks, and publishing the verified Windows update. When the owner requests implementation or says to proceed, routine delivery of that requested work includes source/artwork uploads to this existing repository, the PR, merge after required checks and visual review, and the requested verified release. Do not request repeated routine confirmation after chat recovery. Preserve older releases and backups; this does not authorize unrelated publication, credential disclosure, destructive history changes, or bypassing platform approval review.
