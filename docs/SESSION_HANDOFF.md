**Download update:** the complete ZIP could not be saved by the file service. The exact tested archive is delivered as `Stellar-Holds-First-Fortune-0.60.0-Windows.zip.001` and `.zip.002`. Download both into one folder and extract `.001` with 7-Zip; `testing/portraits60/download.txt` also gives a Windows Command Prompt rejoin option. Their concatenated SHA-256 exactly matches the verified ZIP. No game/runtime content changed. Documentation-only recovery tag: `portraits-0.60.0-delivery`, with `Stellar-Holds-0.60.0-Delivery.bundle` after the existing 0.60.0 Recovery.bundle.

# 0.60.0 — Faces of the Hold

2026-10-20 UTC · **portraits-0.60.0**, following **whole-motion59**, on `integrate/whole-0.58.0`. A new standalone Windows playtest build includes all current whole-character art and fifteen matching painted portraits.

## Current implementation
Fourteen whole portrait paintings match the seven male/seven female saved identities; Lord Eirik has a dedicated crowned throne portrait. Saved natural hair, complexion, clothes and metal colours remain. `scripts/portrait.gd` uses `painted_portraits60.gd` and `portrait_palette60.gdshader`; the GPU resolves source pigment before filtering and preserves intentional clothing colours. Portraits update only when the profile changes. Source purple is a reserved hair marker, never an intended in-game hair colour. The native colour audit is mandatory after artwork changes.

The royal audience now uses current whole-character player/Ivar actors instead of the retired side-view draw call. Creator, dialogue, roster and story captions use the new portraits. All male Dwarfs remain fully bearded. Source images, exact prompts, repairs and hashes: `assets/portraits60/production.json`; rejected first candidates remain for provenance. Existing whole-motion59 selection/runtime metadata is unchanged.

## Validation and playtest
See `testing/portraits60.md` for final test counts, native captures, package identity and limits. 189 portrait checks passed, including all eight natural hair palettes and 13,073,656 unchanged non-hair pixels. 158 focused current-game motion/material/Pinewood/Deepworks checks passed. The exact Windows-exported PCK passed 86 further UI/hotbar/mining checks from external harnesses and an empty working directory. No gameplay/script errors occurred in completed final runs. Native execution is Linux/Xvfb/software OpenGL with Dummy audio; Windows, audible balance and the user's hardware performance are not certified.

Extract the entire `Stellar-Holds-First-Fortune-0.60.0-Windows.zip` and run FirstFortune.exe beside FirstFortune.pck. Continue uses the existing save location. Start with the creator and local conversations, then walk/work/carry, revisit Pinewood and connected mine levels, and save/reload. Read `PLAYTEST_GUIDE.md`.

## Boundaries
No save schema/location, terrain generation, inventory, quest, automation or mining-balance change. Older log lift/put-down, cart push, wider directional work/combat, tattoos, material markings and broader world architecture remain follow-up work. Mirrored facings still affect apparent anatomical shoulder handedness. Romance story plates remain their existing style; speaking portraits are updated. This is a playable art release, not acceptance of every world asset.

## Recovery
`pre-portraits60` preserves whole-motion59 (`630291f38c94bc6cc134236ffde9ec58b504791e`, tree `cbca1e30c820adc15d13d21fee692b622c01ea68`). Its existing bundle was verified before editing and its SHA-256 rechecked. The new `Stellar-Holds-0.60.0-Recovery.bundle` is incremental after that commit; the companion Recovery.txt records exact new commit/tree/hash and independent restore verification. Keep the .51 full baseline and every intermediate bundle through whole-motion59. No previous backup or original asset was overwritten, and no remote changed or pushed.
