# Standard Windows release — 0.53.1
Updated 2026-10-19 UTC. Checkpoint `packaging-0.53.1`; baseline `pre-packaging-0.53.1` preserves `playability-0.53.0` (40185112021128584cdba21fc58ad914ca3c0b79). Prior archives and recovery files remain intact.

Packaging-only update after a reported Defender `Trojan:Win32/MalUri.A!cl` detection on the .53.0 ZIP during download. The trigger is unresolved; do not label it a confirmed false positive. The new build uses `FirstFortune.exe` plus `FirstFortune.pck`, removing the editor and batch launcher. Extract completely and open FirstFortune.exe. Gameplay, art, save paths and save format remain unchanged; only the displayed version changed in runtime code.

The official Godot 4.4.1 export-template archive and Linux build tool were verified against published SHA-512 sums. The shipped Windows executable matches the official release template byte for byte. A fresh source copy was imported/exported with no previous import cache. All 2,639 PCK entries passed path/bounds/checksum validation and were unpacked for local antivirus inspection. Source review found no process execution, shell launch, network API calls or native extensions. These checks are evidence, not a malware-free guarantee.

ClamAV 1.5.3 reported zero detections in 2,796 component/source/original-archive files and in a separate scan of the final download. Official daily signatures are dated October 11, 2026; they are over seven days old. This is not a current Defender clearance.

Native Linux **release runtime** checks passed title rendering, combat poses, working rest, new game, mine travel, exact stairs down/up, and depth/resource save-reload. Windows execution and Defender detection are not tested here. See `testing/packaging-0.53.1.md` for antivirus results, definition dates and the retained shutdown-warning boundary.

Recovery: standalone Windows ZIP, small source update and incremental Git bundle relative to .53.0. Source/Git recovery requires .51 baseline, .52, .53.0, then .53.1. No Git remote was changed or pushed.

## Previous gameplay milestone

# Connected work, clear footing — 0.53.0
Updated 2026-10-19 UTC. Recovery tag `playability-0.53.0`; pre-edit checkpoint `pre-playability-0.53.0` preserves `labor-0.52.0` (9762ca65e9e82608ec545b52b4c3c6dd97063ac6). The existing incremental bundle was verified before edits. Previous archives, tags, original art and saves remain. No remote was changed or pushed.

General handcarts and freight wagons now retain their identity, raw loads, processed cargo and hitch through connected outdoor routes and mine stairs. C parks/takes the handles; E remains usable at doors and landings. An empty-handed player can use a doorway beside a parked cart. Wagons park outside interiors; handcarts enter ordinary rooms but park before sparring. House stairs require parking; mine ladders reject attached carts. Handcarts move at 175 units/s, wagons at 155, unladen Dwarfs at 185. Existing mine wheelbarrows and their stair handling remain.

Settling-in keeps Ivar's actual street/quarters escort and the two practical tasks. The objective names the unfinished bed/chest step. Rest takes 1.1 seconds with a warm fade; moving cancels without healing or credit. Completion restores health, saves and advances the existing introduction sequence. Either task order, skipped/interrupted escort and progressed saves remain supported.

Borin's practice is now part of the ordinary top-down interior renderer, with the current drawn Dwarf, a marked sparring floor and a report bench. WASD moves in eight normalized directions; the mouse faces, held LMB repeats attacks, RMB guards in front, a short timed guard parries, and Q dodges in the chosen movement direction. Dodge uses normal collision. Amber arcs show locked enemy attack direction before contact. No stamina or practice injuries. Training requires three hits, a guard/parry and evasion of an actual telegraphed attack. E at the bench reports the lesson and unlocks the existing deeper encounter progression.

The same controller handles sparse persistent encounters below the first mine layer. Axe, hammer, carbine, ammunition, armor reduction, salvage and rescue use existing equipment/economy data. Walls stop attacks; rear attacks bypass guard; hammer/riposte stagger; menus pause combat; rapid guard tapping cannot continually reopen parry. Wounds and cleared IDs persist, and cleared encounters do not respawn. Enemy sites are deterministic and stored per geological layer. Legacy combat progress is retained under its original IDs. The hotbar names the drawn weapon and gun ammunition without falsely highlighting a tool. Combat advice has a contrasting background. Existing enemy frames now use measured sprite bounds, removing adjacent-frame fragments.

Validation: 142 unique gameplay/model assertions across focused loops (32), intro (20), weapon edges (10), complete world journey (35), and existing Deepworks/crew regression (45). Native Linux Godot 4.4.1 input/rendering, real save/reload, screenshot review and exported-pack boot. See `testing/playability-0.53.0.md`. Windows execution, audio balance and subjective feel remain player acceptance checks.

Recovery: standalone Windows ZIP; incremental source ZIP and Git bundle relative to .52. Source/Git restoration requires the preserved .51 baseline plus .52 update, then .53. Exact restoration and hashes are in `Stellar-Holds-0.53.0-Recovery.txt`; previous versions are not overwritten.

Boundaries: transport uses existing player collision and authored passages, not full wheelbase/turning-radius physics. House stairs do not carry carts. Guard/gun ready poses and hostile creatures reuse existing art; this is not a new eight-direction combat animation set. New raw-station/farm NPC jobs, convoy routing and additional enemy types remain deferred. Existing automation and unrelated labor systems remain intact.

## Resume here
Read AGENTS.md, ART_DIRECTION.md and the .53 test report. `skirmish.gd` owns top-down encounter movement/attacks and rendering; `combat.gd` remains the equipment/stat/save service and preserves legacy code. `handworks.gd` owns attached/arrival/passage transfer; surface, mine stairs and house stairs call those boundaries. `surface.gd` owns short cancellable rest. No original assets were replaced.

Do not delete older archives or treat incremental recovery files as standalone. Native test saves are isolated. Release source excludes generated imports and temporary packaging files.
