# 0.64.0 — Published and verified

One complete [Windows ZIP](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/download/v0.64.0/Stellar-Holds-First-Fortune-0.64.0-Windows.zip) is published. Size: 705,278,506 bytes; SHA-256 `717d5ba55b3bf01be61731b247901b51157601db8b630b45e9979ace35b79f46` matches the clean hosted build report. Release tag v0.64.0 points to verified source c9958797c2a453bbc26934c5832d1db3d36c0f3d. All fifteen hosted gameplay cases and all six exact-export cases passed. Source run 39679087059; release run 39679089395. PR #11 merged at 3bb211b335c940ddd877c8103e788fbf320af9da with an identical tree. Earlier releases remain intact.

Includes the Three Hearths civic refinement, the practical mine worksite with protected hold stock, and The Stone Remembers: physical rescue, Eldric's evidence-based charter research, Overseer appointment and development-gated investiture as Thane. Existing purchased mountains, excavation and other progress remain preserved. Research and appointment use the existing conversations and journal. Local verification included 239 related source checks, 23 quest/UI checks and 203 exact-package checks. Windows hardware performance/audio and artistic acceptance still require the player's device.

Next: discuss experience gains and readable personal development trees/charts. Current work counters and nine research methods are preserved; no full skill-tree redesign is implemented. See PROGRESSION_NEXT.md, PLAYTEST_GUIDE.md and testing/ancestral70.

# Ancestral charter — Overseer to Thane

The Stone Remembers is an additive quest stored in outpost.ancestral_claim. Ivar offers a rescue after the first paid shift and initial audience/next-work conversation. The quest uses an existing depth-1 hold cavern and never overwrites excavated terrain. Open a continuous walkable bypass, speak to the miners with E, and keep their route clear until both reach the entrance. Saved positions/path progress support mid-rescue reloads. The recovered slab then goes to Eldric.

Eldric preserves the tablet; the Lord supplies an archive comparison and Ivar the family registration. Eldric authenticates the ancestral reclamation right to nearby Old Delving, not Keldrath. The Lord appoints an Overseer without a charter purchase. Existing saves keep their selected claim and camp stage. Commercial charters remain an alternative. Complete the workshop/beacon, recruit two Folk and hold 12 food plus 12 water to petition for investiture as Thane. Recognition grants no access to communal stock. This is a playable staged conversation and fieldwork quest, not a bespoke cinematic or a new political simulation.

Personal progression audit: Handworks saves miner/mason/forester/smith counters. Mining awards productive faces; processing awards masonry/forestry jobs. Strong shoulders unlock at 12 miner faces or 8 masonry/forestry jobs; Miner 40 adds controlled section work and cart capacity. The smith counter has no comparable developed branch yet. Technology has nine existing prerequisite-linked methods. Neither is currently a comprehensive personal skill tree. Preserve counters when designing the next progression pass.

New test: ancestral70 in the full gameplay and exact-pack gates. It exercises actual excavation/path connectivity, walking evacuation, mid-rescue saves, evidence prerequisites, local-only interactions, appointment, investiture and old-claim preservation. Verification results must be recorded before release.


Native ancestral70-final: 21 checks passed, exit zero, no script errors. Rendered refuge, evacuation, research and investiture inspected. The previous run exposed an invalid E-cue drawing call and overfull conversation; both were corrected and verified in this run. Existing firstshift/handworks/mining/world/civic/living suite: 239 checks passed. Exact-package and hosted publication remain pending.

Final UI correction: ancestral70-ui passed 23 checks with zero script errors. Conversation responses now belong to the scrollable body; the panel is resized after rebuilding so previous content cannot leave its controls below the viewport. Both research and investiture bounds are asserted and captures inspected.

Exact local export: 203 checks passed across ambient, continuity, living, civic, firstshift and ancestral cases. The first attempt found a duplicate test helper when the fixture was inlined; renaming the first-shift helper fixed the harness. The four already-passing package cases were retained and the two remaining cases passed separately. No runtime source changed for this correction. Hosted gates now target c9958797c2a453bbc26934c5832d1db3d36c0f3d; earlier candidate runs were cancelled after the harness correction.
