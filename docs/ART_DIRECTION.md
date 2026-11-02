# Named character continuity gate — quality115

Before accepting a new or replacement pose, compare it beside the same character's resting front, side, rear-quarter and back views. A passing gameplay test does not grant visual acceptance. Inspect at gameplay size and enlarged: head-to-torso ratio, shoulder/hip width, limb length, braid/bun silhouette, shirt/neckline, apron front versus back, belt/pouch side, cuffs and boot design. Preserve the character's own stature; do not normalize different characters to one build. Review the full ordered stride for opposite physical feet and arm swing, plus rest/walk transitions. Repeated contact poses and a missing costume layer fail review even if the importer and route tests pass.

Brynja: compact square shoulders, flaxen braid, ochre sleeveless collared shirt, brown bib/front apron, crossed rear straps, short split rear waist tails, charcoal trousers and one right-hip pouch. Ragnhild: pine-green sleeveless dress with low square back neckline, above-knee hem with shallow notches, copper crown braid. Dagna: loose chestnut waves, red/white host outfit and rear apron bow. Edda: glasses, silver-streaked braided bun, cream rolled sleeves, blue vest and charcoal trousers. Current view sheets and findings: art/quality115/REVIEW.md. Whole-frame replacements only; preserve historical sources.

---

# Romance candidates — owner direction, 2026-11-01

Every romance candidate must be conventionally attractive for their gender: handsome, masculine, fully bearded men and pretty, feminine, unbearded women, all unmistakably adult Dwarfs. Preserve the established whole-character style and identity across portraits and animation. Personalities should have individual romantic appeal grounded in Dwarven kinship, craft, loyalty and tradition. Story characters may use bespoke faces, outfits, silhouettes, portraits, expressions and key animations beyond the shared background-cast variations; recolored common designs are a baseline, not their final target. See [ROMANCE_CAST.md](ROMANCE_CAST.md) for the cast, specific visual targets and production acceptance criteria.

# Compatible architecture — 0.77.0

Hearthstone, Forgehold and Oathhall share module scale, light direction and placement rules. Use original fronts intact, full-size wall/window bays and cropped partial masonry tiles; never squeeze an entire forge into a small extension or slice an arbitrary strip through a roof. Add storeys as a coherent set-back upper structure. Mix masonry, roof and trim independently; a material study must be labelled as an example if it includes unbuilt additions. Painted room materials and coping must align with the existing walkable bounds. Judge additions and furniture beside the approved Dwarf at gameplay scale. Exact original image-generation prompts and source policy are in assets/architecture87/PRODUCTION.md.

# Portrait parity — 0.60.0
Dedicated whole portraits must match the current whole-character identities. All male chins/jaws are fully bearded; preserve each braid, fork, topknot, bare crown, bun, bob and ponytail. `assets/portraits60/production.json` records briefs and repaired selections. The Lord's fixed portrait matches his seated throne sprite. Do not use a different legacy face in dialogue or an older actor renderer in the audience.

Source violet is a reserved hair pigment, resolved to saved natural colours by `portrait_palette60.gdshader` before filtering. Keep fringe correction restricted to source-hair samples; intentional heather/night-violet clothes are valid. Run `tests/portraits60.gd`, inspect native identity boards and actual menus. Portraits are complete paintings, never assembled heads and bodies. Story plates may be more cinematic, but speaking portraits retain the same identity.

# Equipped and shoulder-cargo motion — whole-motion59

The active motion collection has four complete painted keys per view for all fourteen identities and eleven equipped/load states. Feet pass visibly between contacts; stop and walk share a source family. Keep head, beard, torso, arms, gripping hands, tool/load and boots in one drawing. Do not replace this with rotating parts or a floating tool icon. Male chins/jaws remain fully bearded.

Review all views and transitions at gameplay scale, plus larger frame sequences for anatomy and hair continuity. Single loads must remain single; two-load rows must stay two; mixed cargo must keep its ordering through the gait. Horizontal mirroring currently affects apparent anatomical handedness across turns. Tray contents come from real inventory and sit behind the original painted rim/hands; empty selections must not invent supplies. See `testing/motion59.md` and `assets/whole-motion59/production59.json`. Remaining log-lift, directional work and material-marking limitations are explicit in the handoff.

# Male Dwarf quality rule — folk-quality58

**Every male Dwarf has a full beard covering the chin and jaw.** A moustache alone is not acceptable. Preserve this identity through all views, work, drinking, equipment and hauling; the beard is part of the complete painting, behind gripping hands and props. Never substitute a clean-shaven version in an animation key. Saved sculpt indices and natural palettes remain stable.

This pass repairs male axe strokes and selected topknot/cropped-nape/loose-wave continuity. Exact source selection and production briefs: `refinements.json` and `quality-production58.json`. Inspect native extraction, not only the generated sheets. The male5 raised pick uses a separate complete pose because a neighboring tool touched the original boot. Full carry/gait release gates remain; see `testing/quality58.md`.

# Refinement gate — animation-refinement58

Targeted corrections are recorded in `assets/whole-v58/refinements.json`; briefs and rejection decisions are in `refinements-production.json`. Generated tool duplication is an error, never intended equipment. Complete-frame drawings must preserve one physical tool, grips, body/identity, consistent footfalls and source margins. Inspect extracted native motion too: an attractive source can still fail atlas extraction or continuity. No full release acceptance is claimed.

# Whole-character direction — active development, not accepted release

The user approved whole painted Dwarfs and asked for integration. The active backend now draws complete frames; head, body, hands and feet share the painting. Preserve connected anatomy, compact adult proportions, readable planted/lifted feet and drawn tool grips. Never describe baking the old composite as a redraw. All seven male/female identities and their palettes must remain consistent through every state.

Purple in the original sheets is a reserved hair pigment, replaced by the saved hair color in-game. It is not the intended default hair color. The first preview missed muted highlights and red-violet shadows; `palette-fix58` corrects coverage and resolves pigment before resizing. Require the all-sheet palette audit and native review after source changes. Preserve intentional clothing colors. No geometric face-color patch is permitted.

Read **art/whole-integration-58.md** for current source layout and observed release blockers. The approved study is a direction reference, not acceptance of all generated sequences. Core crops now retain feet; carry continuity, hairstyle/tool identity, equipped gait, clipped keys and material/contact parity still fail the full release gate. Do not ship the milestone as finished or silently map identities to defaults.

# Historical implementation — 0.57.0 (rejected by the user)
Equipped tools must be drawn with their supporting forearms and wrapped fingers. Do not restore a generic item icon over a neutral hand in active top-down play. Dedicated front/side/rear-quarter/back bodies own the grip. Actual inventory supplies may sit inside the small supported tray, behind its rim/fingers; do not fabricate contents for empty stacks. Work/carry poses override equipment.

Body basis is 37 rather than 43 units with 1.14 horizontal build; head scale remains unchanged. Apply the same proportions to work, carry, NPC bodies and drawn footwork. Preserve anatomical collar overlap, planted/returning foot distinction and clear tool contact. Holding upper bodies currently remain steady above the drawn foot cycle; dedicated per-step upper-body artwork is a possible refinement, not a completed feature. See art/production-0.57.0.md and native grips-0.57.0 captures.

# Art direction — reference-led Folk
Updated 2026-10-19. The user's October 19 concept board is the authority. Existing assets are implementation, not proof of acceptance. The board is retained as `art/reference-oct19.png`; .54 originals remain for recovery.

Broad, sturdy adult Dwarfs: substantial brows/noses, compact powerful bodies, expressive faces, dense beards/braids, weighty boots, leather and restrained brass. Warm illustrated contours and readable painted volume. Avoid anime/chibi proportions, glossy plastic, photorealistic noise and tiny illegible ornament. Preserve seven male/female identity variants and chosen colors across every state.

Register the head at its anatomical collar, never the beard/braid bottom. Hair overlaps shoulders/chest; no gap or separate bob. Readable walking requires different contact AND passing silhouettes, a planted weight-bearing boot and a visibly lifted returning boot. Match boot width, material and height to idle/work. Keep fingertips when cropping an upper body. Cached footwork prepares before play, not during the first step. No rotated limb substitutes.

Work uses drawn anticipation/contact/recovery keys with hands gripping the tool. The mug/hand foreground must remain whole across the beard, with the vessel reaching the mouth. Held tools retain the same supporting hand when movement starts. Creator/dialogue should show the same identity, without cutting off a topknot.

Props must pass a side-by-side gameplay-scale check. Use one shared furnishing catalogue for town appearance, player construction, preview, recipes and full physical bases. Separate cups/kettles from furniture so they stay hand-sized. Art has transparent surroundings; no baked enormous floor/glow patches. Depth-sort upright props with actors; the base blocks feet but tall art permits walking behind. Preserve a clear approach to every service and doorway.

Use one recognizable raw rock/log on ground, shoulders, station, stockpile and cart. Quantity comes from actual records. Keldrath still needs richer districts and coherent architecture; this repair does not certify the entire world as complete. Portraits/cutscenes may be more cinematic but must preserve identity.

Review native movement at normal speed and game scale, enlarged contact sheets, work/carry states, NPC activity, creator and actual placement/collision. Repeated-pose sheets fail walking acceptance even if attractive in isolation. See `art/production-0.56.0.md`. User acceptance remains the final visual standard.
