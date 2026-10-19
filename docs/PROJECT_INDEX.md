# Authoritative project index
Updated 2026-10-19 UTC. Build **0.53.1**, checkpoint **packaging-0.53.1**. Art authority: ART_DIRECTION.md.

Collection: The Stellar Holds - Development.

| Artifact | Purpose |
|---|---|
| Stellar-Holds-First-Fortune-0.53.1-Windows.zip | Standalone standard Windows export. Extract fully and run FirstFortune.exe. |
| Stellar-Holds-0.53.1-Source-Update.zip | Changes since .53.0; apply after the .51 baseline and .52/.53.0 updates. |
| Stellar-Holds-0.53.1-Incremental.bundle | Git checkpoint since playability-0.53.0; requires the preserved earlier chain. |
| Stellar-Holds-0.53.1-Verification.txt | Exact package hash, malware-check results and limitations. |
| Stellar-Holds-0.53.1-Recovery.txt | Restore commands, checksums and checkpoint identity. |
| SESSION_HANDOFF.md | Current packaging/security status and existing gameplay implementation. |
| PLAYTEST_GUIDE.md | Current launch instructions and gameplay acceptance route. |

This update changes packaging, not the .53.0 transport/tutorial/combat behavior. The .53.0 ZIP was flagged by Defender during download; it is retained as evidence/recovery, not recommended for execution. The exact detection trigger remains unknown. See CURRENT_STATUS.md and testing/packaging-0.53.1.md for measured checks and antivirus limitations.

Preserved recovery chain: .51 full source/bundle (or split parts), .52 update, .53.0 update, then .53.1. No remote was changed or pushed.
