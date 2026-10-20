# The Stellar Holds: The First Fortune

Private Windows playtest builds and recovery records.

## Download and play

Open **Releases** and download `Stellar-Holds-First-Fortune-0.61.0-Windows.zip`. It is one complete game download.

1. Extract the entire ZIP into a new folder.
2. Run `FirstFortune.exe`, keeping `FirstFortune.pck` beside it.
3. Continue loads your existing saves; use a spare slot to replay the opening.

Sign into the GitHub account that owns this private repository. The Developer-Recovery attachment is optional development backup; GitHub's automatic Source code archives are not the playable game.

## 0.61.0 — Life in the Hold

- Prepared opening escort actors and clearer town walking cadence.
- Painted animated hearths, including player-built ones.
- Moving fountain water and removal of the oversized paving circle.
- Orla and Hedrik Copperkettle, including existing saves.

87 current checks passed, including 11 against the exact exported PCK. All 3,128 PCK entries and ZIP integrity verified. Tests used Linux Godot 4.4.1, software rendering and Dummy audio; Windows execution, audio and player-device performance still need playtesting. No fresh antivirus verdict is claimed.

ZIP: 698,805,507 bytes  
SHA-256: `2b4bc12d30ab39df67c60860498ba0d50b97516c1ddfb8299bcd5f76c1198e8b`

The .60.0 release remains available. No save schema, mining balance or character artwork changed.

## Recovery and development

Source checkpoint: `300ec660c3b66ee2dcf2c0866d8c52b0e872603f`, tag `ambient-0.61.0`.
The recovery attachment includes the incremental source bundle, restoration instructions and verification logs. Its restoration was independently checked against the exact .60 delivery baseline.

This repository's main branch remains delivery documentation, not the complete editable game source history. Release tags identify delivery records; source checkpoint tags live in the recovery bundles. Keep all earlier source backups until a complete source migration is restored and verified.

Read `docs/SESSION_HANDOFF.md`, `docs/CURRENT_STATUS.md` and `docs/PROJECT_INDEX.md`.
