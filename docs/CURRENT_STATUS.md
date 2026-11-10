# Current status — 2026-11-10

## Windows 0.105.1 delivered

[Download and release notes](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.105.1).

Dialogue corrections from PR #146 are now in the published Windows build. Completed favors and civic projects stop requesting deliveries; restored forges and learned steel research receive accurate hints. Legacy lodge directions stay local. Gift/favor refusals reflect play-time waiting, betrothal distinguishes delay from trust, and replies return to the top. Includes the NPC conversation presentation from 0.105.0. Saves, costs, rewards, progression and timing rules are unchanged.

Version/notes PR #147 passed all hosted source checks and merged as 7bcbb33ad2d4c70078d0c48f67b401858a52907c. The exact release source is dc9a569e864b850b89b95ddabaeba034bf6e32bb. [Release run 42902069734](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/42902069734) passed all 80 native source scenarios, 70 exported-package scenarios / 14,170 assertions, integrity verification and publication. Published build.json and release-summary.json agree on version, source, PCK and ZIP hashes. ZIP size: 964,648,066 bytes. Permanent verification evidence is attached to the release.

Next: Windows playtesting of dialogue readability, completed/revisited tasks, forge guidance and relationship responses. Player-device rendering/input remain human playtest feedback. Preserve previous builds and saves; no rebuild without a new change or concrete failure.

## Conversation-size safeguards

PR #141–143 enforce bounded production output, file-only capture, safe diagnostic excerpts, CI evidence artifacts and active-document budgets. History is archived. The reported HTTP 413 / conversation_too_large is established, but its precise trigger and platform threshold remain unknown. These controls block known repository regressions; they cannot guarantee ChatGPT backend reliability. See CONVERSATION_OUTPUT.md.
