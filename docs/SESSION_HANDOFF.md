# Palette correction — source pigment coverage

2026-10-19 · checkpoint **palette-fix58**, following `whole-integration-wip-58`. The user correctly reported residual purple in the previous delivered preview. The earlier statement that the palette had been fully verified was too strong.

The source filter in `scripts/whole_frames.gd` used hue .67–.95 and saturation >.10, missing red-violet shadows and muted highlights. It also recolored after reducing the image, allowing source purple to mix into edge pixels. The correction recognizes the reserved pigment by red/blue excess over green, softly resolves mixed fringe pixels, prevents warm/grey fringe blends from producing mauve, and resolves source colors before resizing. Original painted PNGs and saved palettes are unchanged. This is a renderer correction, not a paint-over of the preview.

Native evidence: `testing/palette-fix58/hair-palette.png`, `all-colors-0.png`, `all-colors-1.png` and `animation/`. Automated native audit: 2,576 full-resolution frame/color combinations, no marker-color failures; all 2,464 active core/utility/handling/equipped frames across fourteen identities checked in iron grey, plus all eight natural palettes on each front idle. 103,482 skin/clothing/leather/metal control pixels remain identical when only hair color changes. Intentional Heather and Night violet outfits retain purple. The corrected renderer also passed 18/18 actual input/ownership/reload checks. See `testing/palette-fix58.md` for scope, criteria and limits.

The whole-character integration remains unreleased. Existing carry/facing/hairstyle/tool/source-crop and contact blockers remain in `art/whole-integration-58.md`. Palette verification is not animation acceptance. No terrain, mechanics, progression or save changes.

## Previous integration checkpoint

# Whole-character integration — unreleased development checkpoint

Updated 2026-10-19 UTC. Continue from **whole-integration-wip-58** on `integrate/whole-0.58.0`. This is a runnable source milestone, **not a new approved Windows build**. The last Windows package remains .57.0, whose visuals the user rejected. Do not present it as the repaired build.

The user approved the whole-figure study and said “Do it.” The later “Why is the hair purple” question concerns the reserved hair pigment in the source paintings. The original native preview still had residual purple; it is superseded by the correction described above. Purple is not a new art-direction choice.

## Active implementation

`scripts/whole_frames.gd` is the active complete-figure renderer through HoldFolk/HoldDrawnAnimation. Surface, Deepworks, ordinary NPCs, work/equipment/carry states and portraits use complete painted character keys. No separate head is composited in the new production paint path. Existing dedicated Lord/throne artwork remains. `folk.gd` retains dormant legacy helpers and the shared world cargo drawing used by ground materials, stations, stockpiles and carts.

`assets/whole-v58` holds all seven male/female identity families with core, utility, handling and equipped sources, correction sheets, exact prompts (`production.json`) and measured frame data. `tools/measure_whole_frames.py` regenerates metadata without editing PNGs. It uses connected alpha components, wider row-seam detection for touching figures, fragment exclusions, consistent sequence scale and whole-frame overrides. Native review corrected core clipped boots/stray pixels. Generation and successful extraction do not establish artistic acceptance.

Hair, skin, cloth and jewelry palettes remain data-driven; no circular face patch. Tattoo decoration remains unfinished. Scene prewarming caches whole colored frames and releases raw source images when finished. `export_presets.cfg` includes the new frame metadata. The title explicitly says development; no new versioned Windows export was made.

## Release gate — still failed

Read **art/whole-integration-58.md** before changing anything. Important observed blockers: carrying keys switch shoulders; mixed/double logs change configuration; some equipped keys change facing or hairstyle, including front faces in male 4/5 back keys and clipped female 4 rifle boots; female axe correction changes hair; a female shovel key is a saw and fishing recovery uses harvest contents. Two-key equipped gait needs passing poses. Mineral appearance, tray occlusion, tattoos, lift-log, some directional work and muzzle/contact alignment need completion. Do not hide these by collapsing saved identities to defaults or returning to the old head rig.

The next pass should correct small complete-frame sequences, review them at native size and normal speed, and rerun affected real-input checks. Avoid another large atlas-generation batch without per-sequence review. The requested polished integration remains unfinished.

## Verification and preservation

Native graphical checks: grips58 **18/18**, mining55 **38/38**, handworks55 **32/32**, combat_edges53 **10/10**. Total **98/98** mechanical checks. Core/equipment/interior captures completed; motion58 recorded 180 native frames of actual left/right movement with pick, axe, supply and physical load. See `testing/whole-0.58.0.md` for exact evidence and limits. Linux Godot 4.4.1, software OpenGL, Dummy audio and isolated saves were used. No Windows execution, audible balance, hardware-performance or complete artistic acceptance is claimed.

No movement speed, mining balance, generation, quests, inventory ownership, save schema or terrain was changed. Native tests verified physical materials, workstations, Pinewood, stairs, progression and reload. Previous release evidence overwritten by old test output was copied into the new evidence directory and restored to its previous committed bytes.

Pre-edit **pre-whole-0.58.0** preserves approved study commit `5378ea42703a439081a90603082db04d392302e4`, tree `7afd1b02a2e252563245814135435016b3b93b09`. That study and .57 recovery were verified before editing. Keep the .51 full baseline, .52/.53/.53.1/.54/.55/.55.1/.56/.57 chain and `whole-figure-study-58`. New incremental recovery follows the study; its Recovery.txt records exact commit/tree/hashes and independent restoration verification. No remote changed or pushed; previous backups remain.
