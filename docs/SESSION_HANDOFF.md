# Session handoff — 2026-11-13

Read CURRENT_STATUS.md and AGENTS.md. Published Windows remains 0.112.0 (release run 43538478196, source 0333a54554592847579b4e211798ce625da7e321). 0.113.0 delivery is now authorized and being prepared.

## Active work: Old Stonewright’s Rise

Local branch `feature/rise165`, based on master `864d68481012f028886ac0773fa6a8570af13ca8`. Implementation commits aff116d and 9ccc777; the final dialogue polish and checkpoint are in the branch’s latest local commit. Candidate version 0.113.0.

After the first paid shift, Ivar offers free provisional use of the existing copper_ridge household. The short saved scene is optional/skippable; no campaign credit is granted. Two civic projects/trade seals still grant permanent tenure. The upgrade preserves the same house, furniture, stocked chests, camp stage and property name. Legacy permanent owners keep their rights. Finished-home registration still needs permanent tenure. See RISE165.md.

Owners: frontier103 for tenure, claim_scene127 for the additional scene, main for reload, first_visit99 for opening presentation, surface for property label, ledger137 for guidance. Existing frontier103 test extended; no new test-suite member.

## Validation

Pinned /tmp/godot441/Godot_v4.4.1-stable_linux.x86_64. Use /tmp/freight-xvfb/run_native.py for rendered tests in this environment; all commands use bounded tools/capture_command.py.

42 tooling tests passed. Output policy passed. Final frontier103 passed 252 assertions in test-results/rise165-review4. Reviewed introduction and scrolled offer, provisional and permanent menus; Ivar appears once. Earlier test failures were a stored test chest in the later cottage footprint (moved), not a waived placement rule. Campaign scenes passed 383 assertions; opening passed 14; ledger passed 36 in test-results/rise165-final3. Loading passed 19 in test-results/rise165-loading. Firstvisit99 passed 23 assertions. All six focused game cases and 42 tooling tests passed; complete CI source/package gates remain pending publication approval.

## Authorized delivery

The user explicitly approved upload, checked merge and publication of 0.113.0 in this conversation. Earlier automatic-review publication blocks are resolved by that approval. Local Git has no credentials; use the connected GitHub blob/tree/commit tools and require the uploaded tree to equal the tested local tree before opening the PR.

Follow RELEASE_PIPELINE.md. Plan requires all 87 source cases; release also requires complete exact-package coverage. Preserve existing source, saves, backups and releases. Update current status after verified publication. No sub-agents unless requested.
