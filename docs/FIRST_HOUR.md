# First-hour presentation — 0.106.0 delivered

The opening now follows arrival, Ivar, the private room, the first practical load, first pay and an initial forge project. The journal and HUD derive their immediate lead from the same saved facts. At the shift book, this focused view remains the default while the player finds their feet; the rest of the book is available on request.

Ivar welcomes the player before listing worksite instructions. Once the room has been visited, he explains the borrowed western stations and exact pay. Lodge conversations use the existing lower-screen dialogue shell, fixed portrait/name and scrolling choices. Memorial replies replace previous text instead of accumulating it.

After first pay, the player can furnish the room, visit Borin first, or explicitly choose another trade. Later campaign text stays out of the default opening journal. Earned household eligibility, accepted rescue progress and chosen trade tracking take precedence over introductory guidance. No new save fields, completion requirements, payments or material costs are introduced.

Forge guidance reads actual inspection, processing proof, carried coal and saved deposits. It distinguishes needing to process a load, gathering the remaining coal, delivering at the physical Ledger, and returning for the first firing. Existing transactions own validation and once-only rewards.

## Acceptance

Extend the existing lodge100, polish135 and ledger137 cases. Cover first dialogue viewport bounds, staged instructions, replacing a reply, real first-load pay, optional room/alternate trade choices, partial delivery plus reload, missing carried fuel, practical processing requirements and completed forge guidance. Also run opening146, firstvisit99 and menu92 for saved introduction beats, legacy saves, paused guidance and general menu behavior. Review the native Ivar, first-wage and forge-lead captures.

Delivered in PR #150 and Windows 0.106.0. Six local native scenarios / 238 assertions and 42 tooling tests passed. After visual review caught a deferred dialogue-height issue, the corrected lodge/menu/opening cases passed again. The release passed all 80 native scenarios, 70 exact-package scenarios / 14,184 assertions, integrity verification and publication in run 42912965464. Human Windows input/audio review and actual first-hour pacing remain playtest feedback; automated checks do not establish enjoyment or completion time. Release state belongs in CURRENT_STATUS.md.
