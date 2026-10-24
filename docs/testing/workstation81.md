# 0.71.2 — Your First Worksite: published and verified

Ivar offers an optional workstation quest before the first mine trip, with one-time starter timber. A saved checklist follows real lifting, stocking, processing/output and equipment construction. Guidance can be paused and resumed; a gold marker identifies the current load or station. Completed journals stay within the viewport. Existing saves, terrain, equipment, material ownership and original artwork are preserved.

Source run 40124472557 passed all 25 gameplay cases plus the focused worksite-preview job. Offer, briefing, marker and completed-journal screenshots were reviewed. Release run 40124470758 passed the 3,263-entry PCK audit and all 15 exact-export cases. Release source a663393419275d7e7410f960cec98f20ffb32972 and PR #33 merge d0813ded310c057a8bef60ae07b82fbc72b3e646 share tree 45743125c13397db767d75b6de2d4a51effac7ca.

Download: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.71.2
Windows ZIP: 725,127,977 bytes; SHA256 ec368d4e2b1038d5e4f1deba6a14406d005d17b0c1a4a387df6a966576acc276, matching the build report and uploaded digest. Verification evidence accompanies the release. Windows device performance/audio remain player testing. Prior releases and recovery branches remain intact.

## Recovery and review

The previous temporary full checkout expired before this task. Complete source/artwork were recovered through the connected GitHub repository. /workspace/scratch/f3b498fb214e/workstation81-edits is a local Git checkpoint of changed files, not a complete playable checkout. Use the complete remote source/tag or recovery/verified-workstation81 to resume.

The first focused run passed behavior checks but visual review identified a marker intruding into the top HUD and the completed journal growing beyond the viewport. The final candidate lowers the marker and defers journal size restoration after content layout. Focused job 120962890650 passed, including a completed-journal bounds assertion. Final full source job 120962890484 passed. Screenshots are retained in readable log chunks by tools/print_worksite_evidence.py, independently of Actions artifact quota.

No gameplay gate was skipped. No player saves, artwork, old tags or backups were removed.
