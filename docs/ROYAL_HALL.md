# Beneath the Stone Crown — 0.71.0 candidate

The King's Hall now has a long nave, an ancestral relief, a raised throne dais, paired columns and braziers, a record desk and an astronomical display. Existing Crownward entry, quest IDs and commission rewards are retained. Lord Eirik's fixed white beard, crown, teal robes and fur mantle are shared by his new complete-body walking, standing and sitting drawings; his matching approved portrait remains intact.

The audience uses the actual top-down room and player appearance. Eirik rises, approaches the petitioner, speaks, returns and sits. Continue waits for the short entrance/return movements; Escape and Skip remain available throughout. Completion preserves the existing onboarding transition and cleans up Ivar's temporary visit. A saved additive royal_epoch prevents the free-play routine from snapping to an unrelated pose on return. Outside the scene, the King periodically rises and hears petitioners on the floor; his interaction point follows his position.

This pass establishes throne sit/stand staging, not generic lying-down poses for every player identity. No existing character designs are substituted or rotated into false resting animations. Existing optional bed recovery remains unchanged.

Keldrath's three wards and Great Stairs remain. King’s Gate moves to a bedrock opening on the north street; the same connection ID and reciprocal walking transition remain authoritative. Floating tavern text is replaced by a physically bracketed kettle sign; household nameplates become doorjamb seals. Nearby interaction text and directions still identify destinations. Other services have mounted trade symbols. The city background and outer abutments now read as continuous mountain rock; shaft, roof and vault image crops retain their aspect ratio instead of stretching to fit arbitrary rectangles.

Ownership: scripts/royal_stage.gd owns the royal actor and hall art; room_layout.gd owns bounds and entry; opening_scene.gd owns audience staging; hold_grounding.gd owns bedrock, fitted texture crops and mounted signs. Production prompts and original generated art are retained in assets/royal79/production.json. Previous art remains at its original paths.

Validation and release status: testing/royal79.md. Do not describe the candidate as released until the release gates complete.
