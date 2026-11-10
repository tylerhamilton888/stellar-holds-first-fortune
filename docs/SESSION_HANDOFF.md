# Current handoff — 2026-11-10

Read this and CURRENT_STATUS.md first; follow AGENTS.md. Keep current files under their byte budgets and preserve history.

## Active work

The owner directed the NPC conversation presentation/writing pass. Source is on `feature/npc-conversation-polish`, based on master `b7a50583cecfdc126353584e2fe1d0a73465d9d7`; fetch current branch/head and GitHub checks before continuing. Windows version candidate: 0.105.0. Do not claim merge or publication before source and release gates pass.

The conversation panel now keeps its portrait/name in a fixed sidebar and scrolls speech/choices independently. Topic transitions return to the beginning; controls, clear costs and deliberate courtship choices remain. Trait labels, relationship thresholds and rewards are moved out of character speech into the existing People book/journal. Character introductions, preferences and favor dialogue are softened. Existing state, item transfers, quests, relationship thresholds and rewards remain authoritative.

Native focused/integration checks and visual review are in progress. Use the pinned Godot 4.4.1, file-only command capture and `tools/read_diagnostics.py`; do not dump logs, encoded images or API payloads. Full hosted validation and verified release gates remain mandatory. Record actual results and any failures before delivery.

## Baseline

Living Forges PR #140 is merged; verified Windows 0.104.0 is published. Preserve earlier releases and backups. Existing output safeguards in PR #141–143 cap known console/document hazards, but do not establish or guarantee a fix for ChatGPT server-side conversation errors.
