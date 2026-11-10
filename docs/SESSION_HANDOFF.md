# Current handoff — 2026-11-10

Read this file and CURRENT_STATUS.md at recovery; follow AGENTS.md. Current checkpoints stay below 4,000 bytes. Historical files are not startup reading.

## Source accepted and merged

Living Forges PR #140 merged as `a009d0e363a318360b349620a06e226904bfe8ca`. Exact feature head `831c1abda29bba9aa72a37aaa41288ccdd0a8b6f` passed all 80 native source scenarios and the final gate in run 42730685187. Local focused checks: 9 scenarios / 858 assertions, no engine errors; tooling: 42 tests passed. Twelve native captures were recorded; representative cold/restored, starter/industry and Keldrath views with collision overlays were reviewed. See testing/living-forges148-acceptance.json.

The update provides distinct new communal/player layouts and physical production stations while preserving existing rooms, furniture and stores. The repair restores Sten's exterior patrol, corrects stale catalogue/crafting fixtures and captures Keldrath through its story gate. Bellows and hot coals have clearer depth/heat at gameplay size.

## Delivery in progress

Windows 0.104.0 candidate is built on branch `release/0.104.0`, commit `1b3d34ee4703834b5107998529013a8f04915b0a`. Verified release run 42731501280 is still running its own 80 native and 70 exact-package scenarios. Publication requires every gate; do not describe it as published until live release metadata confirms it. Existing published baseline is v0.103.0. Preserve older releases and backups.

The candidate also contains concise release notes, an archived historical backlog/release log and enforced active-document budgets. Final delivery documentation is on `docs/living-forges148-delivery`; update it after release verification without modifying the running candidate.

Capture noisy commands to files; return bounded summaries only. Never dump images, encoded binaries, full API results or historical logs. PR #141/#142 plus active-document budgets reduce observed payload hazards; they cannot guarantee repair of ChatGPT's server-side conversation failures.
