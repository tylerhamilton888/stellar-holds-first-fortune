# Current status — 2026-11-10

## Windows 0.104.0 delivered

[Download and release notes](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.104.0).

Living Forges source merged in PR #140. New communal/player workshops have distinct practical layouts and physical furnace/anvil/bench services. Cold Forge restoration controls heat, bellows, smith activity and ambience. Existing saved dimensions, placed objects and storage are preserved. Sten's exterior patrol is clear, and visible anvils have one rendering owner.

Validation is complete: 80 source scenarios passed before merge; the exact release then passed 80 native and 70 exported-package scenarios (14,145 package assertions), integrity verification and publication. Run 42731501280 succeeded on source `1b3d34ee4703834b5107998529013a8f04915b0a`. Published build metadata and verification receipt agree on all release hashes. The ZIP and permanent evidence are uploaded.

Local acceptance also passed 9 scenarios / 858 assertions and 42 tooling tests. Twelve captures were recorded, with cold/restored communal, starter/industry player and Keldrath views inspected alongside collision overlays. Windows performance, sound balance and normal-play feel remain human playtest feedback.

## Conversation-size safeguards

PR #141/#142 enforce bounded output, file-only capture, safe diagnostics and CI evidence artifacts. PR #143 adds active backlog/release-note budgets and final delivery records. Historical text is preserved separately; current recovery reading stays compact.

The reported HTTP 413 / conversation_too_large is established, but the exact triggering payload and platform threshold remain unknown. These controls block known repository regressions; they cannot guarantee ChatGPT backend reliability. See CONVERSATION_OUTPUT.md.
