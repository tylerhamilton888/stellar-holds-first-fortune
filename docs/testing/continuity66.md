# 0.62.1 — physical continuity verification

Baseline: verified GitHub main a669d925f27f6f04b9bffdae88efafc72cf9ddac. Previous local checkpoint and source bundles were retained before edits.

Native Godot 4.4.1, OpenGL compatibility, Linux llvmpipe at 1280×720; isolated saves. The manifest continuity suite passed 198 checks (35 new continuity, 80 households/ward geometry, 20 orientation, 35 real world journey, 28 modular furnishing/building). The final locomotion suite passed 91 checks (35 continuity repeated after the final projection/art registration, 36 ambient and escort, 20 equipped/cargo regressions). Across suites this is 254 distinct checks, with 35 deliberately repeated. Exact exported-pack results are recorded separately when complete.

The first native pass caught residents grazing the fountain and the staircase painting covering a climbing Dwarf. Both were corrected; the collision suite then passed all 80 checks and the next capture showed the Dwarf on the treads. A fixed test timestamp incorrectly sampled a paused Forgeward resident; it now locates an actual moving interval before asserting distance-based gait. These failures were not suppressed.

User clarification: the player walk was acceptable. Player core/motion artwork, selection and ordinary 150-unit stride clock remain unchanged. Town and Ivar side passing poses are selected through an NPC-only action, using the same palette/render backend and distance clock. Tests cover separation for all 14 identities and native sequences place a resident beside an equipped player. Female5 repeats one accepted side-facing passing pose; its rejected front-facing drawing is never selected.

Visual inspection: complete figures, no detached heads, floating tools or pivoted limbs; passing feet visible at gameplay scale; stairs draw behind actors; bed approach at the side; writing desk matches its interaction; solid wall mass and open doorsteps; lower-floor architecture visible through bounded gallery openings.

Images: [town/player](continuity66/parity-03.jpg), [stair flight](continuity66/on-stair.jpg), [lower ward](continuity66/stacked-gallery.jpg), [bedside](continuity66/bedside.jpg), [letter](continuity66/letter-draft.jpg).

Limits: this is a clipped view of the actual lower ward, not an unrestricted seamless multi-floor renderer. Only the active ward runs its residents. No Windows execution, audible mix, player-device FPS or final subjective acceptance is claimed. Bed rest uses a fade rather than a new lying pose. Saves retain the existing schema; the letter adds surface facts and does not consume resources or regress quests.
