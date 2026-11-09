# Conversation output investigation — 2026-11-09

## Observed versus unproven

Earlier screenshots show a rejected conversation request: HTTP 413, `conversation_too_large`. One screenshot also shows an image-encoding operation during a handoff. The user reports recurrence after PR #139. That PR removed three base64-printing scripts; it did not establish that those scripts caused the failure.

The failed thread's complete tool transcript, rejected request body and server-side size accounting are unavailable here. There is no measured ChatGPT threshold and no proven largest message for the recurrence. Repository file sizes are potential payloads, not proof those bytes entered that thread. A small new message does not by itself measure the conversation data processed with it. The repository changes cannot remove already-recorded conversation content or repair server-side state.

## Measurements

| Item | Bytes | Interpretation |
| --- | ---: | --- |
| `assets/forge147/cold-forge.png` at PR #140 checkpoint | 2,180,764 | 2,907,688 bytes if base64-encoded, before JSON overhead |
| `scripts/main.gd` at that checkpoint | 128,227 | Whole-file reads/writes can add substantial text; use targeted edits and Git |
| Master handoff + status before this change | 40,165 | Mandatory startup reads repeated old history and stale delivery instructions |
| PR #140 files API response in this investigation | 161,852 serialized characters | Response wrappers and patches can be much larger than a status summary; inspected in code and only metadata returned |

The original PR #139 acceptance records measured 3,953,476 bytes of PNG evidence and 81 bytes of replacement stdout. That protection remains in place. Neither those measurements nor the additional hazards above prove which message caused a rejection.

## Required operating procedure

1. Read only current handoff/status at recovery. Maintain them in place, below 4,000 UTF-8 bytes each. Preserve historical evidence in history; retrieve excerpts only as needed.
2. Run commands that may produce large output through the capture wrapper, using a fresh log path:

   `python3 tools/capture_command.py --log test-results/task-unique/runner.log --timeout 1800 -- python3 tools/check.py ...`

   The wrapper streams stdout/stderr directly to the file, never echoes them (including failures), returns exit status and byte count, and refuses to overwrite evidence. It does not print command arguments. Timeout returns 124; log creation failure 125; launch failure 127. On POSIX it kills the command process group on timeout/interruption. Full logs remain available. Inspect only selected, bounded diagnostic lines after failure; do not blindly print a long encoded line.
3. Transfer large source/assets via local Git or supported file uploads. Base64 in a tool argument still puts bytes into the conversation even if stdout is quiet. Do not generate a huge tool call containing file bytes, a whole archive, or a whole large source file. Do not echo credentials or credential-bearing URLs. Lack of a working transfer path is a blocker to report, not permission for a text payload fallback.
4. For API/tool calls, inspect results inside code and return selected fields, counts, and URLs. Do not print whole PR diffs, trees, job logs, image responses, or duplicated structured/text results. Use file-level patches and line ranges for code review. Keep each routine summary below 8,000 characters; this is a project budget, not a platform limit.
5. Inspect images through supported image viewers. Do not encode them as conversational text. Keep original assets and full evidence intact.
6. Persist a compact commit/branch/check/next-step checkpoint before lengthy validation or transfer. If a thread fails, recover the checkpoint without copying its old tool transcript. Do not rerun completed checks or create speculative repetitive tests.

## Follow-up acceptance

All 32 Python tooling tests pass locally. The existing validation planner selects tooling/docs only; no native cases are required for these changes. Current handoff/status total 3,388 bytes versus 40,165 before (91.6% less startup text); both historical files are preserved byte-for-byte. The 124 KB changelog is also preserved in history so a small changelog update no longer requires resending its entire contents through the fallback GitHub connector. Direct Git push was unavailable because the local checkout has no GitHub credential; the connector reuses existing blob references for archives and uploads only the changed small text files.

## Verification scope

The capture tests exercise real subprocesses with multi-megabyte binary/error output, nonzero exit, timeout, launch failure and collision with an existing log. They verify byte preservation and small stdout. Python tooling tests are required. No runtime, artwork, save data, native test selection or release gates change in this patch. These checks demonstrate repository behavior only; platform resolution requires evidence from a subsequent failure or successful continued use.

## Follow-up sweep and enforcement

Audited production Python console sinks and all four existing workflow definitions. Additional weaknesses were raw failure tails in native/package runners; repeated errors copied into JSON reports; whole-plan/report stdout; CI commands bypassing the wrapper; missing failure artifacts; smoke evidence overwrite; build timeout diagnostics discarded; and non-finite wrapper timeouts.

Fixes: a shared human-output emitter caps each message at 2,048 UTF-8 bytes and cumulative output at 8,000 bytes, omitting data URLs and oversized tokens. Native/package/smoke reports retain up to five short error samples plus the exact error count; complete diagnostics remain in logs. The planner saves full reasons/matrix in a file, retains GitHub machine outputs, and emits only mode/count. The case-list CLI refuses oversized stdout rather than silently corrupting machine JSON; `--list-output` retains the full list. The safe log reader returns at most 12 short lines and scans at most 8 MiB per invocation. Smoke runs use separate directories; build timeouts retain partial bytes; invalid infinite/NaN timeouts fail before launching a process.

All existing CI Python tool/test/install invocations are captured, with diagnostic artifacts on failure. The historical importer preserves the wrapper outside its old checkout. The existing Python test suite includes a policy gate for current document byte budgets, direct print/encoding/console patterns, and workflow commands bypassing capture. Flood tests exercise megabyte lines, repeated errors, Unicode output and 10,000 changed paths while checking intact files and failure detection. These checks are code controls, not merely instructions.

Limits: this is a repository policy check, not complete static analysis or a ChatGPT payload inspector. It cannot enforce external connectors, arbitrary agent-created shell commands, platform serialization, or an older branch that has not incorporated the fixes. Capture still keeps full logs on disk. Do not claim a platform-wide recurrence guarantee. Before resuming an older feature branch, bring forward the current safety helpers and instructions without dropping that branch's work.
