# 0.53.0 native validation
Godot 4.4.1, native X11/llvmpipe, 1280×720 presentation of the 960×540 game. Isolated test save directories; no player save used. Source fixtures grant progression or position the player when needed; interaction checks use actual input/controller paths. Tests do not substitute for player judgement of feel or sound.

| Suite | Assertions | Coverage |
|---|---:|---|
| playability53.gd | 32 | Rest cancel/finish; tutorial next step; gate/mine/stairs/ladder cart cargo; wagon parking/return; reload; top-down practice, held strikes, parry, dodge, collision, quest report; persistent deep encounters and salvage |
| intro53.gd | 20 | Real escort, route, interrupted/skip recovery, either settling order, introductions and progressed saves |
| combat_edges53.gd | 10 | Front/rear guard, mail, invulnerability, anti-spam parry cooldown, gun wall/ammo, hammer stagger and modal pause |
| input_world53.gd | 35 | Hold/trail/interiors/Pinewood/mine/home journey, crafting/trading, chest, construction, migration and reload |
| test_deepworks41.gd | 45 | Geological persistence/migration, real worker and automaton excavation, connected depth assignments and save/reload |

142 unique passing assertions. Evidence and native logs: `playability-0.53.0/`. Visual review covers cart return, rest/intro, practice guard, carbine, hammer contact and enemy telegraphs; measured enemy bounds corrected fragments found during review. Final exported-pack boot passed: top-down practice, guard equipment, strike pose and completed rest rendered from FirstFortune.pck. See pack.log and pack/*.png.

The first focused pass found a parked cart consuming a mine-door interaction; doorway priority was fixed. A wound comparison used exact float equality and was corrected to approximate numeric equality after confirming identical stored IDs/values. Input-edge tests allow native events to flush before evaluating parry state. An early instrumented run timed out; clean isolated reruns completed. Existing teardown resource-in-use warnings remain separate from gameplay failures. Windows execution and audible mixing were not run.
