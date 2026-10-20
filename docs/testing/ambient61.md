# Life in the Hold — verification

2026-10-20. Godot 4.4.1 official Linux runtime SHA-512 verified against the vendor manifest; native Xvfb TCP display, software OpenGL, Dummy audio, isolated save directories. Native runs were sequential; every final run exited zero and printed its completion marker.

| Final run | Passed | Scope |
|---|---:|---|
| intro53 | 20 | Full illustrated intro → physical escort → correct room → bed/chest → introductions, skip/resume/reload and old progress |
| ambient61 | 36 | All 18 citizens across three wards; painted walk keys, fountain collision, rendered fire/water and pause, actual hearth construction/reload, legacy name/appearance/inventory, loading gate and both escort actors |
| grips58 | 20 | Numbered tool changes, whole held-tool movement, cargo pickup/putdown, supply ownership, reload, prepared male/female turns |
| pack_ambient61 | 11 | Exact exported PCK from empty working directory: water/fire, collision, real Orla dialogue, escort, audience movement, save/reload |
| **Total** | **87** | Current pass only |

`audit_release_pck.py --inventory-only` verified all 3,128 PCK entries, hashes, boundaries and relative paths; no embedded native binaries or shell-script extensions. Export uses the existing official, unmodified Windows EXE with a separate new PCK. ZIP CRC and SHA-256 are recorded in the release companion files. This is integrity checking, not an antivirus verdict.

Visual review: retained painted fire texture instead of the rejected flat polygon-flame trial; fixed stone/grate, contained sparks, water highlights registered to the two spouts, ripples on basin water, no plaza ring. Native walking contact/passing keys and in-world escort inspected. Screenshots, three short native motion clips and final logs are retained alongside this report.

Initial harness corrections: the old intro fixture did not drain the modern character-preparation queue; it now uses the existing current helper and writes to an explicit new output directory. The first citizen sample was shorter than their three-second rest, so it was extended to include walking. The first export dialogue check opened a nonexistent `npc` panel; it now uses the real conversation API. These initial failures are not counted as passes. No runtime failures remained in the final runs.

Limitations: native Windows execution, audible effects and player-hardware frame rate are untested here. Road story plates remain illustrations; stationary dialogue poses remain stationary. No claim of a complete world-art or crafting overhaul.
