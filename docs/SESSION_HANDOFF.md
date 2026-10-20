# Whole-character motion — integrated source checkpoint

2026-10-20 · **whole-motion59**, following **folk-quality58**, on `integrate/whole-0.58.0`. This finishes the focused equipped-walking and shoulder-cargo pass in the existing game. It is a source checkpoint, not a new Windows release or acceptance of every world asset.

## Integrated work

All fourteen saved identities now use 2,464 whole painted motion keys: eleven states × four camera views × four gait keys. States are pick, axe, hammer, shovel, supported inventory tray, rifle, one stone, one log, two stones, two logs and mixed stone/log. Leftward movement mirrors the complete figure. Passing poses alternate with contact poses; stopping retains the same source family. Full male beards, compact connected figures, painted gripping hands and saved natural hair/skin/cloth/jewelry palettes remain.

The active selection is `assets/whole-motion59/runtime.json` (112 source PNGs). `selection.json`, `refinements.json` and `production59.json` record source choices, corrections, briefs and hashes. Native packing copies complete figures only. Original assets, rejected candidates and previous checkpoints remain; do not revive a candidate simply because it is still present. Corrections include male1 rear braid/beard continuity, male3 short-nape two-log poses, female1 low-bun two-log poses male6 front mixed-load order, male3 complete front-tray topknots and opposite passing feet for the remaining male2/male3 front keys.

`scripts/whole_frames.gd` selects the new states in ordinary surface and underground play. Actual pack contents sit behind the supply tray's painted rim and hands; rear contents are naturally occluded. Physical cargo continues to use the established one-owner material records. Movement, mining balance, yield, progression and save schema are unchanged. Runtime metadata is included in the export preset. Source purple is only reserved hair pigment; always run the palette audit after artwork changes.

## Validation

See `testing/motion59.md` and its evidence directory for current results, native screenshots and limitations. 158/158 focused native gameplay checks passed (motion/ownership 68, equipped-input continuity 20, Pinewood/material workflows 32, Deepworks 38). The new-motion palette audit passed 2,576 frame/palette cases with no residual source-purple failures; 106,059 protected non-hair pixels were unchanged. Native displays use Godot 4.4.1, isolated saves, software OpenGL and Dummy audio. Wait for runner completion **and** the explicit completion marker before starting another native test or changing runtime data. Do not count historical checks as current reruns.

## Boundaries and next work

This closes the focused four-key equipped/shoulder-cargo work, not every animation gate. The older log lift/put-down, cart push, broader directional work contacts, tattoos and distinctive ore/material markings still need dedicated art. Mirrored left facings can change the apparent shoulder assignment; strict anatomical handedness across turns is not implemented. Broader Keldrath architecture, interiors, audio and Windows/hardware performance are outside these checks. Preserve this distinction when reporting completion. No new Windows package was produced.

## Recovery

Pre-edit tag `pre-motion-finish59` preserves folk-quality58 (`080951bfd2bdb2551a7655f92be0103ea76bf4d5`, tree `924dae578ecaa24ebf25aa275146590855ba1660`). Its recovery bundle was verified before edits. The new `Stellar-Holds-Whole-Motion59.bundle` is incremental after folk-quality58; its companion Recovery.txt contains exact commit/tree/hash and independent restore verification. Retain the .51 full baseline and every intermediate recovery, including the whole-character study, integration, palette, refinement and beard-quality checkpoints. No remote changed or pushed.
