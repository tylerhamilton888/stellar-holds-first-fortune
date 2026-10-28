# Equipment foundation and combat energy — delivered in 0.83.0

The new equipment93 acceptance case covers legacy ownership and exact backup, stable instances/reload, effective damage/protection, comparison deltas, forge locality/material/research rejection, independent repeated commissions, and compact weapon/armor/forge views. Live attack, shield, parry, dodge, shove and gunfire are exercised at full and zero work energy, including background carry update. The existing combat case retains real equipment-button cancellation checks and verifies that three weapon choices fit without scrolling.

Native Godot 4.4.1 focused verification passed equipment93 (43), combat (44), energy (24) and menus (35): 146 assertions. A clean local export from the identical runtime tree passed all 43 new checks externally with isolated saves. Equipment, all five recipe layouts and energy UI were reviewed. Both forge grades and actions fit without scrolling at 960×540. See equipment93/local-export.json.

Source run 40760152166 passed all 36 gameplay cases plus people-preview. Release run 40760151380 passed all 26 exact-export cases / 1,893 assertions. Release: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.83.0 . Runtime source/tag 621b54bbebae0b05a95ab6ca3a0a8ca870f37a37 and PR #57 merge 50422c0001528b69abab33837c026b3f2f3496b0 share tree ed01948e715d742b9fb777d5168cefe421f4cd8f.

Downloaded build report and exact-export evidence match their published SHA256 digests. Uploaded ZIP metadata matches the clean report; the full ZIP was not independently redownloaded. Hosted exported weapon/armor/forge menu pixels match reviewed source; whole images differ only in background forge animation. See equipment93/delivery.json for hashes and bounds. Windows hardware/audio and subjective balance remain hands-on checks.

Recovery branches equipment/forge93, recovery/equipment93-hosted and release/0.83.0 preserve runtime. Verified equipment93-hosted.bundle requires ce6d79f9ad22a61a6c10489aeeec696d256afa5f, retained in master history. Keep older bundles/releases. Delivery documentation is separate from tested runtime.
