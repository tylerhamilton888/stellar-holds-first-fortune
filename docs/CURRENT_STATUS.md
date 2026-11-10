# Current status — 2026-11-10

## Living Forges

Draft PR #140 implements distinct new Stonebridge communal and player workshop layouts, physical smelting/anvil/bench services, cold/restored activity and single-owner anvil rendering. Keldrath and existing saved rooms/storage retain their established dimensions and contents.

Validation repairs address a real communal-building collision regression blocking Sten's patrol, two outdated catalogue/crafting expectations, and a grand-forge capture that had not opened the Keldrath story gate. Bellows and hot-coal readability are refined at gameplay scale. Tooling tests: 42 passed. All 9 local native scenarios / 858 assertions passed without engine errors; 12 captures were reviewed. Full remote source checks (run 42730685187) and verified release gates are pending. This work is not merged or released yet.

Latest live Windows release is v0.103.0; the forge candidate is 0.104.0. Check live metadata before delivery.

## Conversation-size safeguards

PR #141/#142 are merged and incorporated into the forge branch: bounded production output, file-only command capture, safe diagnostic excerpts, CI evidence artifacts, compact current docs and automated output-policy tests. Existing game and release gates remain enforced.

The reported HTTP 413 / `conversation_too_large` is established, but its exact triggering payload and platform threshold are unknown. These repository safeguards reduce observable hazards; they cannot guarantee that ChatGPT conversations never fail. See CONVERSATION_OUTPUT.md for evidence and limitations.
