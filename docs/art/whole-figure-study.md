# Complete figures — first art checkpoint, 2026-10-19

The user requested characters drawn as one piece. The .57 renderer has independent head/body/leg artwork. Its face recoloring includes an oval mask that visibly crosses the painting, and some saturated skin shadows are recolored as hair. Reducing the body without reducing the head compounded the proportions problem. These are confirmed code causes, not a diagnosis of the user's particular screenshot (none was supplied this turn).

## Work completed

Built-in ImageGen produced original male/female 24-frame core sheets using the user's October 19 concept board: four idle facings, four walk keys per facing, and four side pickaxe keys. Head, body, hands, tool and boots share one drawing. A separate eight-frame front-walk correction study is retained, but its repeated keys do not meet the animation threshold. Source alpha is preserved. Exact prompts are in assets/folk-v58/PROMPTS.md.

HoldWholeFolk in scripts/whole_folk.gd draws a single atlas region per figure. It never assembles an independent head or legs, and it does not use the old circular skin mask. Source pixels have not been repainted by a script. tools/measure_whole58.py only reads alpha/color positions to write frame rectangles and whole-body registration metadata.

tests/whole58.gd ran in native Godot 4.4.1/OpenGL with isolated data and captured the art at enlarged and gameplay sizes. All 32 walk registrations were inside their source atlas. Eight work keys rendered. The run ended with `WHOLE FIGURE STUDY COMPLETE` and no script errors. Captures are in testing/whole-figure-study. This is a development test, not a separate game launcher or player-facing mode.

## Visual findings and release gate

The connected neck/shoulder silhouette and unified skin painting are clearly better. Pick anticipation and contact contain complete gripping hands. This is not yet polished animation: the original front walk turns partly sideways; one rear-quarter key faces straight back; some keys repeat; the correction sheet fixes the front facing but repeats the same two leg poses. Side strides and planted-foot registration need a moving review, not only static inspection. The female face also needs continued comparison with the adult, non-anime reference.

The production HoldFolk renderer remains unchanged. No .58 Windows release was built. Do not describe this checkpoint as a fixed game, a finished replacement, or an accepted art style. The .57 playable and its recovery chain remain intact. No save schema, progression, collision, mining balance or inventory was changed.

Before activation: finish coherent contact/passing cycles; draw every saved male/female identity consistently across work, carry, double-load, push, held tools, drink, saw, farming/fishing and combat states; use whole-figure palette masks; update portraits and warm-up caches; preserve all current action/foreground/equipment interfaces. Check actual settlement, mine, Pinewood and interiors in motion. Switching between new whole figures and old assembled work poses is not an acceptable shortcut.
