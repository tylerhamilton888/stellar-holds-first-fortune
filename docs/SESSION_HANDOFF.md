**Single-download delivery — 2026-10-20:** Version 0.60.0 is now published as one complete Windows ZIP in the private GitHub repository `tylerhamilton888/stellar-holds-first-fortune`.

- Release: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.60.0
- Game download: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/download/v0.60.0/Stellar-Holds-First-Fortune-0.60.0-Windows.zip
- Sign in as the repository owner to access it. Extract the entire ZIP, then run `FirstFortune.exe` beside `FirstFortune.pck`.
- GitHub confirmed the uploaded asset is 698,756,907 bytes, with SHA-256 `0b531ef5957fee4af2af8ed384f551b0aae5a64b524fea62fda482748e15f523`, exactly matching the original verified archive. Release ID 418647518; asset ID 659921980.
- The repository is private and starts as build-delivery documentation only. Its release tag points to delivery commit `a42c307f87f582914356469fbdeae72a770ebe94`, not the original source history. The original game checkpoints and full recovery bundle chain remain authoritative and preserved separately. No runtime, artwork, save, or gameplay content changed during delivery repair.
- The older two-part downloads remain as fallback backups. They are no longer the recommended download route.

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
