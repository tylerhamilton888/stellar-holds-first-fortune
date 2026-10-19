# Folk and furnishings repair — 0.56.0
Updated 2026-10-19 UTC. Checkpoint `art-0.56.0`; pre-edit `pre-art-0.56.0` preserves verified .55.1 commit `c206cf5d0d901634e8c9a991cb60649fa322a791`. Earlier recovery bundles, source assets and releases remain intact. No remote changed or pushed.

## Current result
The October 19 user concept was recovered and reviewed. The .54 head registration incorrectly treated the bottom of beards/braids as the collar, separating heads from bodies. `folk.gd` now registers anatomical head anchors, overlaps hair with shoulders, restores face shading and keeps the same tool hand between idle and movement. Complete sip hand/mug silhouettes replace the clipped foreground strip. Creator portraits use the actual head bounds, including topknots.

Walking now uses four drawn contact/passing keys with visibly lifted boots, front/back weight transfer and corresponding upper-body keys. The same lower-body cycle serves empty, loaded, double-loaded and pushing states. There is no rotating-leg substitute. These are registered head/body/footwork layers, not a newly redrawn monolithic sheet for every action. Boot dimensions/materials are matched at gameplay scale; hands are preserved below the upper-body crop. Stride textures warm during scene transitions and remain cached. Female/male identity and palette controls remain.

`furnishings.gd` owns a new transparent sprite catalogue, dimensions, collision bases and recipes. Town counters, tables, chairs, desks, bookcases, beds, hearths, lamps and storage share it with claim/home construction, placement previews, recovery and building occupancy. Cups/kettles are separately scaled tabletop objects. Tavern approaches and conversation across its solid counter work. Street lamps and outdoor workshop desks now sort with actors and have real bases. Names focus on the active interlocutor; redundant floating interaction captions no longer hide the character.

## Persistence and scope
Old fortunes get a unique byte-exact `.pre-art-560-*.bak` before loading; failure to make it aborts the load. No mine regeneration or inventory/quest reset. Existing decor kinds and positions are retained. Larger bases may require locally moving old decorations; retain the backup if a dense old arrangement obstructs access. The existing save/landmark recovery remains.

This repairs the rejected head attachment, sliding feet and major oversized interior furniture. It does not claim all historical environment art or every work/combat direction has been redrawn. Mine primitive furnishings, some exterior ornaments, broader Keldrath architecture/district activity and dedicated industrial hauling/workstation jobs remain follow-up. Pinewood’s remaining trunk now appears only after the fall, uses the shared log sprite at a grounded scale, and shrinks with remaining cuts; rooted bark replaces the flat stump rectangle. The .55 excavation balance and .55.1 landmark fixes are preserved.

## Verification / next entry points
Read `testing/art-0.56.0.md` for completed checks, native captures, motion preview and package evidence. Require test completion markers; shutdown retained-resource warnings are separately recorded. Native tests use Godot 4.4.1, Linux software OpenGL and Dummy audio. Windows execution, sound and user visual acceptance remain unverified. No fresh antivirus verdict is claimed.

Active renderer: `scripts/folk.gd`; original registration metadata: `assets/folk-v54/frames.json`; new footwork: `assets/folk-v56`; catalogue: `scripts/furnishings.gd` / `assets/furnishings-v56`. `surface.gd`, `world_zones.gd`, `hearthcraft.gd` share prop ownership/footprints. Tests: `art56.gd`, `integration56.gd`, `motion56.gd`, external `pack56.gd`. Use isolated saves and sequential native displays. Never replace previous recovery artifacts.

Standalone Windows ZIP plus incremental source/Git update after .55.1. Keep the .51 full baseline and .52/.53/.53.1/.54/.55/.55.1 chain. New Recovery.txt records exact commit/tree, hashes and restore commands. Scratch workspace: `/workspace/scratch/a447fc5d46ab/stellar-holds`; durable recovery is authoritative if scratch expires.
