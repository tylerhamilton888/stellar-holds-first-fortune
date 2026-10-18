# Native verification — 0.52.0
Godot 4.4.1, Linux native OpenGL/llvmpipe at 1280×720, isolated test save directory. Baseline .51 bundle verified before edits. Existing gameplay is exercised through main.tscn; no separate player prototype.

| Test | Result | Coverage |
|---|---|---|
| intro52.gd | 20 / 0 | Illustrated arrival → Ivar escort → real doorway → furnished quarters; full collision-checked route; guided spacing; mid-walk save/reload; bed/chest in both orders; local Ivar reminder; chest conservation; return doorway; existing introductions/coal job; old-save stage retained; skip. |
| motion52.gd | 6 / 0 | Gait equals actual travel; blocked movement plants feet; directional cargo conservation; save/reload; one-load and final-load set-down transitions. |
| contacts52.gd | 5 / 0 | Four cardinal pick contacts and Pinewood axe impact. Actual stonebreaker/saw contact captures also reviewed. |
| regression_hands52.gd | 32 / 0 | Physical hauling/facilities, single ownership, production, Strong Shoulders/wagon and save/reload. |
| input_world52.gd | 35 / 0 | Existing hold/ward/interior/royal/trail/mine/claim flow, stairs, gathering, selling, smelting, home/storage/building, migration and reload. |
| test_deepworks41.gd | 45 / 0 | Persistent layered geology, deterministic seams, passages, worker routes and automated excavation/save integrity. |

Total: 143 assertions. Native review additionally captures ten customized character sculpts in four views, walking phases, tavern sipping, forge work and the seated Lord. Source images are reviewed beside the player at gameplay scale. The final introduction captures show unobstructed readable dialogue and the actual room props. `animation-0.52.0/gait-review.mp4` is native renderer output, repeated for playback inspection.

Evidence: sibling `animation-0.52.0/` holds the per-suite logs and screenshots. Previous .51 evidence remains unchanged. The final exported PCK passed a native render/boot check: `tests/pack52.gd` loaded the packed main scene, played the real escort and rendered the new walking/mixed-cargo atlases and bounds metadata. Use this test by absolute path with `--main-pack` (tests are excluded from the release pack). Release ZIP CRC, incremental bundle baseline restoration, commit/tree comparison and git fsck are recorded with the release recovery package.

The tests do not certify Windows execution or subjective sound/feel. Some work/pushing stances still use side-view drawings; further directional refinement is explicitly deferred. No new NPC jobs or cross-zone wagon transport are claimed. Some test harness shutdowns report remaining cached ObjectDB resources after all checks and captures complete; there were no runtime script failures during gameplay.
