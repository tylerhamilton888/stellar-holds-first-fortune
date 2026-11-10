# Current status — 2026-11-10

## Windows 0.105.0 delivered

[Download and release notes](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.105.0).

NPC conversation work merged in PR #144. A lower-screen dialogue panel keeps the speaker visible while conversation and friendship-errand choices scroll. Introductions, preferences and favors read more naturally. Relationship progress and reward details remain in the People book/journal, and consequential costs and commitments stay explicit. Existing saves, quests, relationship progression, choices and rewards are preserved.

Validation is complete: 80 source scenarios passed before merge; the exact release then passed 80 native and 70 exported-package scenarios (14,154 package assertions), integrity verification and publication. Run 42755883367 succeeded on source `9e480bd5666f76b3fc6f485cf0623ad693ca86ad`. Published build metadata and the verification receipt agree on source, PCK and ZIP hashes.

Nine focused local scenarios / 2,845 assertions and 42 tooling tests passed. Reviewed native captures include ordinary and scrolled dialogue, gifts, favors, accepted courtship and a friendship errand. Windows rendering, keyboard/mouse feel, character voice and discoverability remain human playtest feedback.

## Conversation-size safeguards

PR #141–143 enforce bounded production output, file-only capture, safe diagnostic excerpts, CI evidence artifacts and active-document budgets. History is archived. The reported HTTP 413 / conversation_too_large is established, but its precise trigger and platform threshold remain unknown. These controls block known repository regressions; they cannot guarantee ChatGPT backend reliability. See CONVERSATION_OUTPUT.md.

## Dialogue state follow-up

PR #146 (`fix/dialogue-state-truth`) corrects completed favors/projects, forge hints, reply visibility and courtship requirements. See DIALOGUE_AUDIT.md and the live PR checks for acceptance and merge state. Windows 0.105.0 remains the published build; these follow-up corrections require a later release.
