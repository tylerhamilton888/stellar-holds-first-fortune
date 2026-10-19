# 0.54.0 — reference art, weight and hold rendering
2026-10-19. Source checkpoint `reference-0.54.0`; pre-edit checkpoint `pre-reference-0.54.0` = `packaging-0.53.1` (`5ac23fed34c03ac4f3a224bd158fbec9c54edd65`). Existing bundle verification and Git object checks preceded edits. Earlier backups are retained.

## Gameplay evidence
Native Linux Godot 4.4.1, Xvfb 1280×720, Compatibility renderer, Mesa llvmpipe; isolated XDG save roots under art54. Real Godot mouse/key input, game update/rendering, UI button actions and filesystem save/reload were exercised. Tests use controlled starting positions/data to isolate encounters and work surfaces; this is not a claim that every route was manually walked. The collision suite additionally uses path searches and the actual movement controller. The escort follows its real street/room route.

| Script | Passed | What it establishes |
|---|---:|---|
| input_reference54.gd | 35 | Existing new-game/NPC introductions, hold districts/doors/lift, trail/mine, stairs, Pinewood harvest, smelt/sell, claim home/chests, rest and legacy homestead migration |
| collision_reference54.gd | 121 | Door centres versus sidewalls, route reachability, bridge ends/rails, interiors, NPC routes, stairs and reciprocal landings; rerun after Lord footprint adjustment |
| mining_reference54.gd | 65 | Actual held input/impact timing, partial damage, no automatic tunnelling, south/north contacts, reload and 56 identity-view registrations |
| handworks54.gd | 32 | Craft/place station/racks/transport, one-owner raw materials, partial job reload, output conservation, physical tree/raw-rock extraction, two-shoulder progression |
| playability54.gd | 32 | Carts through real doors/stairs, wagon parking, rest cancellation, practice/guard/dodge/report, persistent mine encounters and salvage |
| intro54.gd | 20 | Arrival → Ivar street/quarters walk, interruption/reload, skipping, bed/chest either order and progression preservation |
| save_reference54.gd | 5 | Synthetic pre-.54 save preserves inventory, charter, quest stage, appearance selector and stations; exact byte backup; no redundant backup on later reload |
| test_deepworks54.gd | 45 | Five deterministic levels/veins/caverns, actual stair chain, partial terrain/fixtures, old terrain backup, industrial economy, Pinewood and existing crew/automation persistence |
| Total source checks | **355** | No failing assertions |

creator54.gd also passed its two palette-refresh/normalization assertions and captured creator, clothing/details and dialogue. Native complete 48-key walk and 32-key pick contact plates were reviewed alongside single/double/mixed carrying, drinking, sawing, station contact, town scale, seated Lord, UI and transitions. A clipped tip, a north-facing strike, a tiny adjacent-frame fragment, blurred enlarged torso and mine depth-bar overlap were corrected during review. Source artwork remains unmodified; measured metadata/code controls cropping and registration.

## Exported pack
Fresh source directory and fresh import cache; standard Windows export with EXE/PCK separate. The final PCK contains **2,670** validated entries. Relative paths, entry bounds, MD5 checksums and extracted file SHA-256 values were verified. No executable, DLL, native extension, shell script or JavaScript payload appears inside the pack. `assets/folk-v54/frames.json` is explicitly exported.

The final pack passed **12** native checks: existing title/new game, real clear street for vault view, authored NPC pigment versus player cache, new metadata, actual held mining/fractures/no forward drag, stairs down/up at matching XY, generated cavern discovery, depth/resource/new-identity save/reload and return to the surface. Native rendered screenshots accompany the evidence. This used the available Linux Godot 4.4.1 engine with `--main-pack`; **the Windows executable was not executed here**. Windows/audio/subjective feel remain acceptance checks.

Windows EXE SHA-256: `b493c1d53fb915f7805f360cfe42d1c3126e720dfc234a4b0f2feb99200f9a4b`. This matches the official 4.4.1 release template verified in .53.1, byte for byte. No editor, batch launcher, installer or updater is shipped.
PCK SHA-256: `c7fbbfa3c0d4cf3fa8afa93a7ef84a910e97c0d32e421c7ee54921028a4821af`.
Windows ZIP SHA-256: `c8c633529ed30ec4dc8304f7cdefc2d80ccb8366dce09a9f520e1ee42e464595` (376,006,520 bytes). ZIP CRCs and every member's SHA-256 match the staged files.

## Measured Keldrath rendering
Same native renderer/display, two 420-frame traversals along the Hearthward street, no screenshot capture inside timings. The final pack was compared to the retained actual .53.1 pack. These are software-renderer measurements, not predicted Windows GPU performance. Camera/player position is controlled for repeatability; no other native game runs during these measurements.

| Metric | .53.1 pack | .54.0 pack |
|---|---:|---:|
| First traversal median | 20.744 ms | 13.735 ms |
| First traversal 95th percentile | 77.011 ms | 17.309 ms |
| First traversal 99th percentile | 308.574 ms | 20.756 ms |
| First traversal worst | 384.294 ms | 23.764 ms |
| Return traversal 95th percentile | 35.514 ms | 16.957 ms |
| Return traversal worst | 93.177 ms | 53.178 ms |
| Initial load/preparation | 6,444.854 ms | 7,280.939 ms |

The tradeoff is explicit pose preparation before controls resume. Texture recoloring is cached, visible floor/citizen rendering is culled, collision data and per-frame routes are cached, and the citizen wrap-time mismatch is fixed. The final measurements include cosmetic detailing; the subsequent tiny crop/pigment-cache correction does not change the traversal workload. The remaining 53 ms outlier means this is not a guarantee of hitch-free play. Earlier screenshot-inclusive profiles are discarded as performance evidence.

## Package inspection and antivirus
Source API review found no process execution, shell launch, networking or native extension use in game scripts. ClamAV 1.5.3 scanned **2,825** initial component/source files with **zero detections**. Three final packed entries (frame metadata, Folk renderer and main script) changed after that scan; those and all source scripts were rescanned with zero detections. Every other final packed entry was checked byte-identical to its scanned counterpart. The final ZIP scan completed with **zero detections** (one archive, 1.30 GiB scanned), using the same dated signatures.

Definitions: main v63, 2025-12-16; daily v28150, **2026-10-11**; bytecode v339, 2025-09-11. ClamAV warns that daily signatures are over seven days old. These are local checks with dated signatures, not current Defender clearance or a malware-free guarantee. The earlier .53.0 MalUri detection's exact trigger remains unresolved. One initial scanner invocation failed because its default certificate directory was absent; it scanned zero files. The successful runs use the packaged ClamAV root-certificate directory and retain signature verification.

## Limits and retained warnings
Test teardown reports ObjectDB/resource-retention warnings (2–8 resources depending on harness). No gameplay/script errors or failing assertions occurred in the final native checks. Xvfb reports unsupported V-Sync control. These warnings are retained in evidence, not silently counted as passes.

Four authored view families are mirrored for eight-way travel. Some station/pushing actions share side views. Equipped armor statistics persist; a complete new armor wardrobe is pending. Keldrath's new architecture is integrated at existing tested door locations; the larger connected overworld, richer NPC schedules/jobs and remaining older interior props are not completed by this release. Subjective reference acceptance remains the user's judgement.

## Recovery
Incremental source/Git updates follow .53.1 and require the preserved .51/.52/.53/.53.1 chain. The Windows ZIP is standalone. The final recovery note records exact commit/tree identities, all hashes and verified restoration. New save migration uses a unique `.pre-folk-54-*.bak` and retains exact bytes before autosave. No prior backup was overwritten and no remote changed.
