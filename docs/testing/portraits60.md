# 0.60.0 — Portraits and whole-character release verification
2026-10-20 UTC. Source checkpoint follows whole-motion59. The latest Windows release includes the previously integrated whole-character animation work and fifteen new painted portraits.

## Portrait implementation
Fourteen complete chest-up paintings match all seven male and seven female saved identities. A separate fixed-colour Lord Eirik portrait matches his crowned, seated throne sprite. Full male beards, compact adult faces, braid/topknot/bob/ponytail silhouettes, natural saved hair, complexion, clothing and metal palettes are preserved. Native sources and exact built-in image-generation briefs/hashes are in `assets/portraits60/production.json`; original candidates remain under `docs/art/portraits60/rejected`.

`HoldPortrait` now draws a dedicated painting through `HoldPaintedPortraits` and `portrait_palette60.gdshader`. Recolouring happens before bilinear filtering; transparent RGB is cleared, and hair/skin blends cannot recreate a mauve fringe. Only source-hair samples receive that last correction. Intentional heather clothing remains independent. Static SubViewports update only when a profile changes; no CPU image repaint or per-frame portrait animation was introduced. The Lord uses the same framed portrait control in dialogue, roster and audience captions.

The royal audience still called the retired side-view actor renderer. Its two staged actors now use the complete current figures, with required idle/walk keys prepared before the scene. Quest and scene timing are unchanged. The illustrated romance plates are unchanged; their speaking portraits use the new cast artwork.

## Completed final checks
All checks below completed with explicit pass markers and isolated userdata. Graphical runs use Linux Godot 4.4.1, Xvfb, software OpenGL/Mesa llvmpipe and Dummy audio.

| Check | Passed | Evidence |
|---|---:|---|
| Portrait render/palette audit | 189 | All 14 identities × 8 hair colours; 14 grey-hair/heather-cloth controls; 56 complexion updates; seven canonical cast identities |
| Whole-character motion/ownership | 68 | Eleven states, four views/four gait keys, eight-direction pickup/movement/stop/reload/put-down |
| Real hotbar and holding | 20 | Numbered controls, actual/empty supply tray, load priority, inventory reload and prewarmed views |
| Material handling and Pinewood | 32 | Actual axe felling, logs, carried rock, craft/place stockpiles and stations, partial work reload, processed output, cart, house costs and shoulder upgrade |
| Deepworks | 38 | Held resistance, physical yields, logistics, crafting, lamp/support/mastery benefits, multi-Z lodes and exact matching passages/save data |
| Exported PCK portrait/UI flow | 28 | Creator refresh and identity, six local conversations, Lord/audience, story speaker, roster, exact reloaded player portrait and inventory |
| Exported PCK hotbar/material ownership | 20 | Independent external repetition of tool/supply/physical-load/save checks |
| Exported PCK mining flow | 38 | Independent external repetition of held excavation, material/logistics/crafting, depth and save checks |
| **Total final checks** | **433** | No failures in completed final runs |

The palette audit compared 13,073,656 protected non-hair pixels without changes and found no remaining source-violet failures. Native galleries compare every portrait with its in-world identity. Creator, real conversations, roster, royal audience, romance captions and reloaded-player cards were visually inspected. Gameplay captures cover load support, mining contact/fracture, station work and Pinewood. This is native rendered/mechanical verification, not manual Windows or audio testing.

Initial audit failures exposed a real Raven/skin interpolation fringe, corrected in the shader. The audit's first downsampled mask also missed low-contrast source hair; it now classifies original source samples and uses fully hair-covered samples for the cloth-independence control. The first UI fixture tried the royal door before earning the audience; the fixture now establishes the existing quest prerequisite. No quest gate was removed. An initial exported fixture looked for the player on the NPC-only roster; it now checks the existing quarters player card. Intermediate failure logs are retained. A preliminary 27-check source UI run also passed; its final exported repetition adds the actual reloaded player-card check and is the row counted above.

## Packaging
A fresh checkout of committed source was imported and exported with Godot 4.4.1. The Windows executable is byte-identical to the official unmodified `windows_release_x86_64.exe`, SHA-256 `b493c1d53fb915f7805f360cfe42d1c3126e720dfc234a4b0f2feb99200f9a4b`. The game PCK is separate. There is no installer, batch launcher, editor or added native extension. All 3,126 PCK paths, bounds, entry MD5s and SHA-256s are verified, along with all fifteen portraits, all 112 selected motion sources and all 200 resolved current whole-character/portrait texture resources. ZIP membership, CRC and every staged-file hash are verified. Exact package identity is recorded in `package-identity.json` and the external Recovery.txt.

The exact Windows-exported PCK was tested from an empty working directory using external self-contained harnesses and the Linux editor runtime, so source-tree assets could not mask omitted pack resources. No Windows execution, audible balance or hardware performance result is claimed. No new antivirus/Defender verdict is available: this environment has no installed signature databases. Provenance/content/hash checks are not an antivirus certification.

## Scope and recovery
No save schema, save location, terrain generator, mining balance, inventory, resource, quest or automation logic changed. Existing migration backups remain active. The release includes whole-motion59's whole-character art and all earlier integrated systems, not only portraits.

Remaining broader work includes dedicated log lift/put-down and cart-pushing art, additional directional work/combat contacts, tattoos, distinctive material markings, mirrored shoulder handedness and world architecture. The user remains the final judge of art/feel. This release does not certify every historical asset.

Pre-edit tag `pre-portraits60` preserves verified whole-motion59. Final recovery tag is `portraits-0.60.0`; its incremental bundle requires whole-motion59 and all preceding recovery history. The companion Recovery.txt records independent verify/fetch/fsck results and the exact restored commit/tree. Previous versions/backups are retained, and no remote changed or pushed.

## Final download packaging
The original 698,756,907-byte ZIP could not be saved. It was split into two standard numbered pieces, 350,000,000 and 348,756,907 bytes, whose concatenated hash exactly matches the tested archive. Both parts saved successfully; all eight archived files and original package verification are unchanged. See `portraits60/download.txt` and `portraits60/split-delivery.json`. The TAR/XZ compression experiment did not complete and is not a deliverable. No new runtime test is necessary because runtime bytes are unchanged.
