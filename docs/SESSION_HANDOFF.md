# Current handoff — 2026-11-10

Read this and CURRENT_STATUS.md first; follow AGENTS.md. Keep current files under their byte budgets and preserve history.

## Completed delivery

The NPC conversation presentation and writing pass is merged in PR #144 (`de4ad55f7ef4beab6085bc5f8246c5494e916569`). Feature head `9e480bd5666f76b3fc6f485cf0623ad693ca86ad` passed all 80 native source scenarios in run 42755885469.

Windows 0.105.0 is published: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.105.0

Release run 42755883367 succeeded on that exact source: 80 native scenarios, 70 exported-package scenarios / 14,154 assertions, integrity verification and publication. Published build metadata and receipt agree on source, PCK and ZIP hashes. The ZIP is 964,649,141 bytes. Local focused checks covered 9 scenarios / 2,845 assertions plus 42 tooling tests; normal and scrolled conversations, favors, gifts, courtship and Maren's errand were visually reviewed. See testing/npc-conversation-acceptance.json and the permanent release evidence.

Conversation and friendship-errand panels keep the speaker visible while choices scroll. Relationship bookkeeping is in the People book/journal; costs and commitments remain clear. Existing state, progress, choices and rewards are preserved. Next: Windows playtesting of readability, character voice, quest discoverability and accessibility. Do not rebuild without a new change or concrete failure. Preserve older releases and backups.

## Output discipline

Use file-only capture and bounded diagnostics. Never dump image bytes, encoded binaries, full API results or old logs into conversations. Keep current status, handoff and backlog below 4,000 bytes; release notes and changelog below 8,000. History is preserved separately. These safeguards reduce known repository hazards; they cannot guarantee ChatGPT backend reliability.

## Dialogue state follow-up

A focused correction is in progress on `review/day-quality`: completed favors/projects, forge hints, reply visibility and courtship requirements. See DIALOGUE_AUDIT.md. Native validation is pending; Windows 0.105.0 remains the published build.
