# 0.71.1 — A Clearer Path: published and verified

Quest journal hierarchy, status-grouped lessons, correct introduction targets, ancestral contact markers, paused quest browsing and readable footer are implemented. Existing saves/rewards and original artwork are preserved. Local final focused verification passed 117 assertions; journal, pack and settings screenshots reviewed at 1280×720. Hosted source run 40046866977 passed all 25 gameplay cases; release run 40046874975 passed the 3,263-entry PCK audit and all 15 exact-export cases.

Published: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.71.1
PR #31 merged as d88ff6fb236d8817ccc59d70329366668bdac852. Its tree c9bd0fd80b0e0fbce51fe67fbb04a425caf852fa matches tested release source e610b426b81642f778094e10a037a13a97f9c162. Windows ZIP: 725,124,683 bytes; SHA256 794ef4d6ca5f1810319f2f40198b0041639bbf9990ace12cac01ca9ff4099a75, matching clean build report and uploaded digest. Release includes verification evidence. Local menu80-final.bundle preserves the runtime checkpoint; prior releases/backups remain intact. Windows device performance and audio remain player testing.

Behavior verified: introduction target advancement, settling marker suppression, side-quest gating, local-only/idempotent rewards, ancestral marker advancement, quest pause behavior and panel bounds. Source and release pipelines retain mandatory checks. The display failure was resolved by running Xvfb and Godot in the same execution network namespace using TCP.
