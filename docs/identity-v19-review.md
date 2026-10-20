# Character identity review — 0.19.0

The normal sprite is the identity reference. Each design owns normal, combat, armed-walk and guard sources through `HoldCharacterDesigns`; animation selection must not choose independently generated lookalikes. Portraits are unchanged.

## Review coverage

`tests/test_identity19.gd` captures all 320 distinct poses in two palettes (640 rendered examples). Review the hairline, silhouette, braid count, beard root, facial attachment, foot contact and transitions between rows. `test_motion19.gd` captures gameplay with armor and alternating facings. Visual review is manual; these captures are not an automated assertion that art is perfect.

## Corrections

- Swept greatbeard: removed long rear hair from armed poses; compact swept crest and rounded beard on guards. Removed erroneous attack-sheet glow.
- Twin braids: matched the paired beard plaits across armed states.
- King's mantle: matched the loose mane and broad beard.
- High-knot forkbeard: retained one topknot and two unbraided lobes.
- Royal triple plait: retained bald crown and three plaits (shield/arm can occlude the far plait); protected scalp from hair recoloring.
- Crown braids: one near-side front braid and one rear braid, removing the extra shield-side front braid.
- High knot: retained bun and one near-side lock, removed extra shield-side braid.
- Long waves: one near temple braid and loose rear waves, no extra shield-side braid; expanded rear-hair tint coverage.
- Side braid: one near-side braid throughout.
- Braided bob: removed accidental rear tail and hanging chest braids from armed sprites.

Art was edited with built-in image generation, then inspected in the runtime. Initial prompts and references are in identity-v19-jobs.json; canonical design descriptions are in identity-v19-reference.json. Only selected revisions listed by character_designs.gd are used. Generated intermediate sheets remain in source for provenance.

No gameplay or save-format migration in this patch. Windows distribution is packaged here; runtime verification uses Linux Godot 4.4.1.
