# Folk quality verification

2026-10-19 · **folk-quality58** · Godot 4.4.1, Linux, native Xvfb/software OpenGL, Dummy audio, isolated user data. This is a runnable focused repair milestone, not a finished animation release or new Windows package.

## Implemented scope

All male Dwarf identities normalize to a full beard. Sculpt 5 retains its saved index, face, name, palette and other appearance fields, with a painted beard covering the chin/jaw in its visible poses. The creator calls it “Grand moustache & beard.” Female normalization and the legacy enum are preserved.

Thirteen new complete-figure PNGs provide 356 distinct active key substitutions. Exact selection: `assets/whole-v58/refinements.json`. Exact built-in imagegen prompts and selection decisions: `quality-production58.json`. Original paintings are unchanged; previous reviewed back-facing corrections are retained.

| Repair | Selected active keys |
|---|---:|
| Male5 bearded core / utility / handling / equipped | 28 / 32 / 64 / 42 |
| Male0, male1, male2, male3, male6 axe strokes | 4 each |
| Male3 equipped topknot | 48 |
| Male4 core (including axe) / utility / handling / equipped | 14 / 4 / 64 / 36 |
| Female2 loose-wave axe sequence | 4 |

Male axe sequences now retain a genuine single axe throughout the stroke. Male3 equipped topknot, male4 cropped rear/nape and female2 axe hair preserve the intended hairstyle. Male2 handling uses the existing contour extraction to exclude a neighboring rifle fragment. Native enlarged review found that a bottom-only crop did not fully remove the neighboring axe touching male5's raised-pick boot. That crop was discarded; a separately painted complete raised-pick pose is selected instead. No additional extractor code is retained from that attempt.

## Completed native checks

| Test | Result | Coverage |
|---|---:|---|
| `beard_quality58.gd` | 27 / 27 | Creator, all male beard normalization, female preservation, actual four-direction equipped movement, old moustache profile loaded from a real save, exact inventory/money/claim preservation. |
| `handworks55.gd`, sculpt 5 | 32 / 32 | Physical loads, stockpiles, stonebreaking, sawing, hauling equipment, save/reload, actual held-axe tree felling and recoverable Pinewood log, underground raw material ownership. |
| `mining55.gd`, sculpt 5 | 38 / 38 | Integrated mine doorway, held excavation resistance, physical ore, processing/crafting/cart logistics, mastery/infrastructure, multi-depth lode notes, exact persistence and real E/Shift+E stairs with loose cargo at the landing. |
| `palette_audit58.gd` | 2,576 cases; 0 failures | 48,159,308 visible pixels; 103,482 protected non-hair material pixels. All fourteen identities and eight saved natural hair palettes. |

Total gameplay checks: **97 passed, 0 failed**. Palette cases are separate, not added to the gameplay total. No historical suites are included in these counts. Gameplay checks completed before the final isolated anticipation-key substitution; that last visual-only key then passed final native art review and the complete palette audit. Strike timing, contact keys and mechanics did not change.

`quality_art58.gd` final run completed with the explicit marker. Native review includes all core/utility/handling/equipped keys for male2/3/4/5, male/female axe phases, enlarged male5 pick/axe/drink phases and 32 pose-motion frames. Creator, Keldrath, tavern, the retained Lord/throne and actual mining/Pinewood/workstation captures were inspected. The new raised pick retains complete boots without the neighboring silver fragment. Palette review shows natural hair, including brown, flaxen, grey and white.

Final evidence is in `quality58/art`, `play`, `handworks`, `mining`, `palette` and `logs`. Candidate captures and insufficient crop trials are not final evidence. Native displays ran sequentially; each counted test has both runner completion and its explicit success marker. The native V-Sync warning is a software-display limitation. Resource import and `git diff --check` also passed; they do not substitute for the native checks.

## Remaining limits

This identity repair preserves existing carry poses; shoulder swaps, mixed/double cargo configuration and material parity remain. Equipped pairs still need better passing poses. Tray occlusion, tattoos, lift-log and fuller directional work contacts remain open. Other hairstyle/work-facing edges may need review. Small source-edge imperfections and broader Keldrath/world asset quality are not certified by this pass. Pose-motion evidence is not a claim that all gait cycles are finished.

No mining-balance, input-speed, progression, resource-ownership, terrain or save-schema changes were made. No new Windows export, live audio assessment, hardware performance result or antivirus verdict is claimed. Recovery is incremental after animation-refinement58; the companion Recovery.txt records exact hashes and independent Git restore verification.
