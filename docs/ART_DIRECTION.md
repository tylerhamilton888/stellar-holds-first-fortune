# Whole-character direction — unreleased 0.58 study

The user rejected .57's oversized separate heads, skin-circle recoloring, lanky assembled bodies and floating-looking grips, then explicitly requested characters drawn as one piece. This supersedes the separated-head guidance below. Every accepted animation key must be a complete painted Dwarf: naturally connected head/neck/shoulders, matching face/arm skin, compact adult proportions, readable planted and lifted feet, and fingers drawn around the actual tool. Do not bake the old composite and describe it as a redraw. Palette customization may use material masks on a whole figure; it must not introduce geometric face patches or recolor skin shadows as hair.

The first two complete-figure sheets and native review are retained under assets/folk-v58 and docs/testing/whole-figure-study. They are an ART CHECKPOINT, not a finished animation library or an active production renderer. Front-walk turning, repeated keys and rear-quarter drift remain. Preserve all seven male/female saved identities and palette choices during the eventual replacement; never silently collapse them to two defaults. See art/whole-figure-study.md.

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
