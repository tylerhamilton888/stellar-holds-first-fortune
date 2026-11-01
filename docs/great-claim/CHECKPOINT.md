# Delivery checkpoint — town/home source backed up

Source local 5526377056d4b8d9f874bb552880b8f903c96756 / hosted cf3daf6c07b8b1f093db2018b859fd84c69e8aed; verified identical tree b6212292baade453f7d1ed5696111e7adb9e5f69. PR #74: https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/74. Full source run 41339237563 and Windows release run 41339241566 are in progress, not yet verified. release/0.91.0 points at that exact source. Do not overwrite older releases or restart unchanged source checks.

Local exported PCK acceptance additionally passed frontier103 (224) and lodge100 (47) from empty working/save directories; town capture reviewed. Native source coverage remains 1,342 distinct assertions. Source/export results are in ../testing/frontier103/acceptance.json. The local pack is not the published Windows ZIP.

Next: inspect both hosted runs, fix actual failures if any, merge PR #74 only after the full source gate succeeds, verify Windows release assets and record final delivery. Documentation-only checkpoint lives separately so it does not restart runtime validation. Later story milestones remain queued; begin with 03-rescue-ancestry only after finishing this delivery checkpoint.

---

# Active frontier checkpoint — 2026-11-01

Branch story/frontier-town; version 0.91.0. Town/home implementation complete for the scoped slice. Native acceptance passed 1,342 assertions across eight cases; see ../testing/frontier103/acceptance.json. Final frontier103 repeated with 224 passing assertions after archive/trade/menu refinements. All public entrance paths and NPC routes pass before and after storehouse construction. Every new public plan can be constructed and entered by the player. Reviewed final captures. Source commit/hosted PR and Windows gates are the next delivery step; do not repeat native checks without changed source or new evidence.

Read 02-frontier-ledger.md and 02b-player-home.md. Main owner frontier103.gd; construction stays with architecture/hearthcraft and existing Z data. New fortunes only; old saves retain legacy geography. Public property is protected; private upstairs quarters and player home remain editable. Plot is permanent and must survive later appointment. No free cottage/workshop. Full narrative milestones and bespoke story art remain queued.

Prior source PR #73 passed and merged as 12208d1c632fa77d7d253b1c75f867f823a1a060. Prior release run 41336685688 is still executing exact-pack checks. Do not overwrite release/0.90.0; use release/0.91.0 for this source. Once the new hosted source/export gates pass, merge the runtime PR and record delivery evidence separately without restarting its checks.

---

# Active checkpoint

Active: 02-frontier-ledger. Ledger foundation implemented; full milestone NOT complete.

01-cast-relationships: six adults (3 women / 3 men), individual errands and keepsakes, eighteen date scenes, explicit courtship and betrothal, confirmed breakup. Native cast101 passed all 813 assertions. Reviewed all six final dialogue portraits. Existing acquaintance identities and married couples preserved. surface.courtship101 is additive; nested date integers normalize on read.

02 foundation: surface.great_claim102 initialized only in HoldFirstVisit99.begin. HoldDisciplines.award credits actual work, capped at eight per discipline. Three one-time local pack donations construct eight physical trail furnishings. Competitor scores follow civic milestones, not elapsed time. Hereditary law introduced in ledger. Native greatclaim102 passed 79 assertions; disciplines (38), firstvisit99 (23) and lodge100 (48) also passed. Combined focused suites: 1,001 distinct assertions. Final ledger case repeated successfully after pause/title/capture refinements; reviewed ledger, bridge/table and stores captures. No frontier relocation or new story NPC interaction is claimed complete.

Next exact implementation: read PLAN.md, 02-frontier-ledger.md, OWNER_DIRECTIVE.md and current status; finish regression/delivery gates, then move new fortunes' lodge entrance onto the frontier without changing old-save geography. Add local services before restricting Keldrath travel, and author Skarrin plus the remaining narrative cast. Keep the real mining and furnishing opening reachable. Do not lock existing progression behind unfinished chapters.

Milestones 03–06 remain queued. Marriage, household life, bespoke faces/outfits/expressions and key character animation are not completed by the shared-family baseline. Do not mark full directive complete because planning files or flags exist.

Source branch: polish/romance-cast, PR #73. Baseline hosted fefdc5e (local 7272a91), same tree 6ba1debe64c352e228f6d12f19fe6114594a9156. Append delivery evidence here once verified. Previous public build v0.89.0 remains intact.

Delivery checkpoint: source local 881483c / hosted f34e826b75fff7ca98505f3b92444c74a54851bf, identical tree 1040947605bd02d5a794a1284eb432792b2dfad6. PR #73 full run 41336534776 in progress. release/0.90.0 queued at the same source; do not call it published until verified. Native evidence: ../testing/great-claim101/acceptance.json.
