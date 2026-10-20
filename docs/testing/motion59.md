# Whole-character motion verification — whole-motion59

2026-10-20. Existing Godot game, branch `integrate/whole-0.58.0`, following `folk-quality58`. Focused equipment and shoulder-cargo integration; no new Windows package.

## Result

**158/158 native gameplay checks passed.** Separately, **2,576/2,576 new-motion palette cases passed**, with 61,093,053 visible source-resolution pixels examined and 106,059 protected skin/cloth/leather/tool pixels unchanged by hair selection. Final palette audit: `motion59/palette/audit.json`.

| Native harness | Passed | Coverage |
| --- | ---: | --- |
| motion_play59 | 68 | All fourteen identities, eleven states, eight movement directions, four keys, stops, prepared textures; real single/double/mixed pickup, movement, exact material IDs across reload and put-down |
| grips58 | 20 | Numbered tool selection while moving, supply visibility/ownership, load priority, reload, rifle selection, equipment and existing log-lift preparation |
| handworks55, male sculpt 5 | 32 | Craft/place stations and stockpiles, one-owner transfers, partial processing/reload, output into real house construction, handcart, two-shoulder unlock, actual Pinewood felling and physical mine extraction |
| mining55, male sculpt 5 | 38 | Held excavation resistance and strokes, physical ore, stockpiles/processing/forge, logistics/mastery, connected lodes, save migration, same-location stairs and landing priorities |

These are current reruns, not historical totals. Logs are under `motion59/logs/`. The first motion ownership assertion compared integer IDs with JSON-reloaded floats as arrays; normalizing numeric IDs fixed the test comparison. Material records were intact; no game save code was changed to mask the assertion.

## Native visual review

The active selection contains **2,464 complete figure keys from 112 PNG sources**. All fourteen identities retain their existing saved indices and natural palettes. Male beards cover the chin/jaw. Equipped idle and walk use the same family; the gait includes passing frames. Hands and tools/cargo are painted into each complete figure. There is no new head/limb assembly.

`motion59/art/` contains four-view, four-key state boards for all fourteen identities. `motion59/supply/` shows actual pack contents behind the painted tray rim/fingers. Reviewed source and native corrections cover male1 braid/beard continuity, male3 short nape and full topknots, female1 low bun, male6 mixed-load order, and thirteen opposite-passing-foot keys for male2/male3 front equipment and male3 single loads. Dense atlas clipping/repeated-foot candidates were not treated as finished merely because they parsed. The last seventeen art-key replacements were followed by affected native board/tray review and the complete palette audit; gameplay logic stayed unchanged.

`Stellar-Holds-Whole-Motion59.mp4` is **12 seconds, 360 native frames at 30 fps, 1280 × 720**. It records real right/left movement and stops with pick, axe, supply tray, one stone, mixed cargo and two logs. It has no audio. Native gameplay sequences and enlarged keys were inspected for connected anatomy, grips, foot separation, load count/order and palette consistency. Representative mining, Pinewood and workstation captures are retained alongside the state boards.

## Environment and reproducibility

Godot 4.4.1 stable, native X display, software OpenGL (Mesa llvmpipe), Dummy audio; 960 × 540 logical viewport displayed at 1280 × 720. Every save-writing harness uses isolated XDG userdata. Native runs were strictly sequential and required both exit zero and an explicit completion marker. The renderer/import finished without script errors. The software driver reports unsupported V-Sync; this is not a hardware performance benchmark.

From a Godot 4.4.1 checkout after import, use `--script res://tests/motion_play59.gd -- <output-directory>` for the motion workflow. The other named harnesses accept an output directory; handworks55/mining55 accept an optional male sculpt after it. `palette_audit58.gd -- <output-directory> motion` audits this new collection. `motion_art59.gd` and `supply_art59.gd` optionally accept comma-separated identities after the output path. Use a graphics display and isolated save locations; do not run these against a player's live data.

Selection/rebuild metadata: `assets/whole-motion59/selection.json`, `refinements.json`, `frames.json`, `runtime.json`. Exact built-in image-generation briefs, source hashes and correction decisions: `production59.json`, `tray-repair-production.json`, `passing-repair-production.json`. `tools/build_motion59.py` resolves row and individual complete-key overrides. `tools/measure_whole_frames.py` measures alpha bounds/registration without repainting the source. Native packing copies complete drawings. Runtime JSON is included in export settings; unused new candidate/template paintings are excluded from export but retained in recovery.

## Limits

This verifies the focused equipped-walking and sustained shoulder-cargo pass. It does not certify the whole world-art overhaul. Older log lift/put-down and cart push art, further directional work/contact frames, tattoos and distinctive ore/material markings remain separate work. Whole-figure mirroring can reverse apparent anatomical shoulder assignment across left/right turns; it preserves load count and ownership. No new Windows export, live audio, Defender verdict or hardware performance acceptance is claimed. Original artwork, prior checkpoints, saved progression and save schema are preserved.
