# Romance cast baseline verification

Godot 4.4.1 import passed. `tools/check.py --suite people-preview` passed 408 checks with native software rendering. Added checks exercise authored candidate defaults, portrait/world identity parity and a deliberately different saved identity through save/reload. Existing friendship, gifts, local dialogue, migration and future-candidate eligibility assertions passed. The first display attempts failed to connect; running Xvfb and the test together over local TCP resolved the environment issue.

Reviewed candidate-dagna, candidate-ragnhild, candidate-torvik and candidate-ketil dialogue captures. Natural hair and clothing palettes match the selected identities. This uses existing whole-character sources and does not claim bespoke face/expression production or new romance gameplay. No Windows package or full hosted suite has been verified for this change.
