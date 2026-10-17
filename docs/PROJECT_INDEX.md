# Authoritative project index
Updated 2026-10-17. Gameplay **0.39.1**; infrastructure checkpoint **continuity-1**.

Persistent Library folder: **The Stellar Holds - Development** (`6ad3ec25dfd4819190af2e824acdef98`). Local workspaces are temporary. Prefer this index and the versioned artifacts below over older same-project files elsewhere.

| Artifact | Purpose |
|---|---|
| `Stellar-Holds-0.39.1-continuity-1-Source.zip` | Ready-to-import Godot source, assets, tests and current docs; caches excluded. |
| `Stellar-Holds-0.39.1-continuity-1.bundle` | Self-contained Git recovery: original baseline plus organized checkpoint/history. Clone instructions in RECOVERY.md. |
| `Stellar-Holds-continuity-1-Docs.zip` | Small portable copy of current reference docs, verification records, handoff and resume prompt. |
| `NEW_SESSION_PROMPT.md` | Paste into a fresh Work session and append the next task. |
| `PROJECT_INDEX.md` | This entry point; update after a successful future checkpoint save. |

No separate unfinished development snapshot is needed: the organized source and Git checkpoint represent the same verified infrastructure state. Gameplay remains the original 0.39.1 release; its latest mining behavior still awaits user acceptance.

## Preserved earlier recovery points
- Original source: `Stellar-Holds-0.39.1-Source.zip`, Library `libfile_663631733a748191afb26b65f5486949`, version **8**.
- Playable Windows build: `Stellar-Holds-First-Fortune-0.39.1-Windows.zip`, Library `libfile_b2bd6ec7b5a88191af8e5138564dacbe`, version **55**. Unchanged; not rerun on Windows.
- Earlier standalone handoff identity: `libfile_3f792dab7c8081919d32143c1a4adf43`; updated to refer to this collection. The canonical handoff inside the project is `docs/SESSION_HANDOFF.md`.

All game source assets needed to rebuild are included in both source ZIP and Git bundle. Install Godot 4.4.1 separately. Original backups are not deleted or overwritten by this organization task. Check CURRENT_STATUS.md for actual verification and caveats.
