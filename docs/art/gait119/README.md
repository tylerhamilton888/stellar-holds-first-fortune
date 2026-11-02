# Hakon world locomotion — 119

Twenty complete walking/resting poses for Hakon Ironroot at his existing 62px stature. Copper half-tied hair, full copper beard gathered with one brass ring, slate-blue guard tunic with a folded hood and silver mail trim, round front brooches, two hip pouches, matching brown bracers and boots. The original atlas remains intact. Current reachable activities are walking/resting on the High Trail; no combat, worker or drinking assignment was invented.

Generation used the built-in image tool. Exact prompts are in prompts.json; source/runtime hashes and selected frame keys are in production.json. Images are complete paintings, never assembled limbs. The first sheets repeated contacts and physical feet; only selected keys enter runtime. Targeted replacements corrected the opposite rear-quarter half-step, passing feet, boot hardware, rear straps and the overly tall proportions visible in native review.

Review included full-resolution anatomy (two shoulder/elbow/wrist/hand chains and one bracer per forearm), twenty-pose native board, all four ordered loop captures at 2x and 62px samples. Preserved the existing route, first-interaction name, conversation, save/load, inventory and partner-rescue identity. New validation also requires every Hakon logical pose to select an existing source atlas, preventing silent whole-sheet fallback.

Evidence: ../../testing/gait119/whole-frame-board.png, hakon-walk.gif and acceptance.json. Automated tests validate integration and do not confer visual acceptance. Owner visual feedback and full hosted validation remain open. No Windows release is claimed.
