# Current status — 2026-11-10

## NPC conversation work

0.105.0 is a source candidate on `feature/npc-conversation-polish`. A compact dialogue panel keeps the speaker visible while choices scroll. Character-led introductions, favors, gifts, friendship and courtship replace several intrusive system readouts; useful details remain available in the People book and journal, with clear costs and commitments. Existing saves, quests, relationship progression, rewards and choices are preserved.

Local native integration, visual review and hosted validation are in progress. The candidate is not merged or published; required source and exact-package release gates have not yet completed. See the current handoff and live GitHub status.

## Published baseline

Windows 0.104.0 (Living Forges) is the latest confirmed published release. PR #140 is merged and its source/native/package gates passed. Preserve older releases and saved data.

## Conversation-size safeguards

PR #141–143 enforce bounded production output, file-only capture, safe diagnostic excerpts, CI evidence artifacts and active-document budgets. Historical text is archived. The reported HTTP 413 / conversation_too_large is established, but its precise trigger and platform threshold remain unknown. These controls block known repository regressions; they cannot guarantee ChatGPT backend reliability. See CONVERSATION_OUTPUT.md.
