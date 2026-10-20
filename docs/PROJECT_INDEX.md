**Single-download delivery — 2026-10-20:** Version 0.60.0 is now published as one complete Windows ZIP in the private GitHub repository `tylerhamilton888/stellar-holds-first-fortune`.

- Release: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.60.0
- Game download: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/download/v0.60.0/Stellar-Holds-First-Fortune-0.60.0-Windows.zip
- Sign in as the repository owner to access it. Extract the entire ZIP, then run `FirstFortune.exe` beside `FirstFortune.pck`.
- GitHub confirmed the uploaded asset is 698,756,907 bytes, with SHA-256 `0b531ef5957fee4af2af8ed384f551b0aae5a64b524fea62fda482748e15f523`, exactly matching the original verified archive. Release ID 418647518; asset ID 659921980.
- The repository is private and starts as build-delivery documentation only. Its release tag points to delivery commit `a42c307f87f582914356469fbdeae72a770ebe94`, not the original source history. The original game checkpoints and full recovery bundle chain remain authoritative and preserved separately. No runtime, artwork, save, or gameplay content changed during delivery repair.
- The older two-part downloads remain as fallback backups. They are no longer the recommended download route.

Latest packaged release: **0.60.0 — Faces of the Hold**, recovery tag **portraits-0.60.0**, after whole-motion59. Fifteen matching painted portraits, natural saved palettes and current audience actors; includes all previously integrated whole-character motion. Read `SESSION_HANDOFF.md`, `CURRENT_STATUS.md`, `testing/portraits60.md` and `PLAYTEST_GUIDE.md`. Runtime: `scripts/painted_portraits60.gd`, `portrait_palette60.gdshader`, `portrait.gd`; artwork/prompts: `assets/portraits60`. Delivery: `Stellar-Holds-First-Fortune-0.60.0-Windows.zip`, `Stellar-Holds-0.60.0-Recovery.bundle` and companion Recovery/Verification files. All previous releases remain. Older status sections below are historical.

Latest source checkpoint: **whole-motion59**, following folk-quality58. Equipped walking and one-/two-shoulder cargo now use 2,464 whole painted keys across all fourteen identities. Read `CURRENT_STATUS.md`, `SESSION_HANDOFF.md` and `testing/motion59.md`. Sources and selection: `assets/whole-motion59`; runtime: `scripts/whole_frames.gd`. Recovery: `Stellar-Holds-Whole-Motion59.bundle` plus companion Recovery.txt. Focused motion pass integrated; broader art backlog and Windows packaging remain separate.

Previous source checkpoint: **folk-quality58**, an unreleased beard and character quality pass after animation-refinement58. Read `testing/quality58.md`, `CURRENT_STATUS.md` and `SESSION_HANDOFF.md`. Thirteen source paintings, 356 selected keys; all male Dwarfs fully bearded, corrected male axe strokes and selected hair continuity. 97 focused native gameplay checks passed. Recovery: `Stellar-Holds-Folk-Quality58.bundle` and companion Recovery.txt. Carry/gait work remains; no new Windows package.

Previous source checkpoint: **animation-refinement58**, an unreleased repair batch after palette-fix58. Read `testing/refinement58.md` and the updated handoff. Recovery: `Stellar-Holds-Animation-Refinement58.bundle` plus companion Recovery.txt. Forty-two selected key fixes, reviewed atlas extraction and drawn tool endpoints; full carry/gait acceptance remains blocked. No new Windows package.

# Authoritative project index

Previous source checkpoint: **palette-fix58**, a focused renderer correction for residual purple hair, after `whole-integration-wip-58`. Read `testing/palette-fix58.md`. Updated `Stellar-Holds-Whole-Character-Hair-Colors.png` replaces the earlier faulty preview; all original paintings and previous checkpoints remain. Recovery: `Stellar-Holds-Palette-Fix-58.bundle` and `Stellar-Holds-Palette-Fix-58-Recovery.txt`, incremental after the whole-character integration. No new Windows release.

Previous integration checkpoint: **whole-integration-wip-58**, an active whole-character integration with unresolved visual release blockers. This is not a new Windows release. Read `SESSION_HANDOFF.md`, `CURRENT_STATUS.md`, `art/whole-integration-58.md` and `testing/whole-0.58.0.md`. Source: `scripts/whole_frames.gd`, `assets/whole-v58`, `tools/measure_whole_frames.py`; native evidence: `docs/testing/whole-0.58.0`. The original approved study and all prior releases remain.

Recovery: `Stellar-Holds-Whole-Integration-WIP-58.bundle` is incremental after `whole-figure-study-58`; its companion Recovery.txt contains exact restore instructions and hashes. `Stellar-Holds-Whole-Integration-WIP-58-Motion.mp4` is native development evidence, not an acceptance trailer. `Stellar-Holds-Whole-Character-Hair-Colors.png` shows the actual palette replacement.

## Previous packaged release — visuals rejected

Updated 2026-10-19 UTC. Build **0.57.0**, checkpoint **grips-0.57.0**. The October 19 user concept remains the art authority; shipped assets are not automatically accepted.

| Artifact | Purpose |
|---|---|
| Stellar-Holds-First-Fortune-0.57.0-Windows.zip | Standalone game; extract fully, run FirstFortune.exe beside its PCK. |
| Stellar-Holds-0.57.0-Motion.mp4 | Real captured walking with pick, axe, supply tray and shoulder load, left/right. |
| Stellar-Holds-0.57.0-Source-Update.zip | Changed files to overlay on complete .56 source. |
| Stellar-Holds-0.57.0-Incremental.bundle | Git update after art-0.56.0. |
| Stellar-Holds-0.57.0-Recovery.txt | Exact commit/tree, restoration commands and artifact hashes. |
| Stellar-Holds-0.57.0-Verification.txt | Actual gameplay, visual and package evidence and limits. |
| SESSION_HANDOFF.md / CURRENT_STATUS.md | Current implementation and remaining work. |
| testing/grips-0.57.0.md | Current test results and native captures. |
| ART_DIRECTION.md / art/production-0.57.0.md | Visual authority, holding/proportion rules, exact production briefs. |
| PLAYTEST_GUIDE.md | Focused grip/movement acceptance and established mining route. |

Preserve the full .51 baseline and .52/.53/.53.1/.54/.55/.55.1/.56 update chain. Restore through `art-0.56.0` using its retained recovery instructions before applying .57. All prior releases and backups remain. No remote changed or pushed. Current .56 base commit: `bbf977acbf60d58fd30b22b124f77f7d7cec8f6f`.

Historical .57 source: scripts/folk.gd; assets/folk-v57; hotbar.gd; surface.gd; deepworks_play.gd; skirmish.gd. Historical checkpoint evidence remains in docs/testing. The .55 mining and .55.1 landmark work are preserved, not superseded by new generation.
