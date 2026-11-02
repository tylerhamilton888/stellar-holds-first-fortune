# Named character quality review — 115

Scope: all four currently enabled named world bundles, 84 authored poses in total (20 each plus Dagna's four drinking keys). Compared resting stances with all four walking directions, enlarged complete figures, native gameplay size and ordered animation captures. This is not an audit of every generic player equipment animation, portrait or the 20 unfinished named bundles.

| Character | Finding | Correction |
| --- | --- | --- |
| Brynja | Opposite side contact enlarged head/hair and lost the ochre shirt. Rear-quarter contact changed head/hip proportions. Rear walking apron invented a front-style seat flap; pouch moved sides. Apron, cuffs and waist details drifted. | Replaced twenty whole resting/walking poses using the existing compact, square-shouldered identity. Restored ochre shirt, consistent braid/head scale, apron front and split rear tails, right-hip pouch and matching boots. Rejected an intermediate repeated arm swing and repaired the opposite contact. |
| Dagna | Rear passing frames changed loose waves into heavy symmetrical hair clumps. | Replaced rear rest/walk row with more consistent loose-wave shape and volume. Preserved red/white outfit, aligned legs and existing drinking sequence. |
| Ragnhild | Back and rear-quarter walking neckline was high and closed while resting neckline was low and square. Belt keeper vanished. | Matched square neckline and keeper in rear rest/walk rows; retained gait114's longer skirt, hidden far hand and smooth thigh contour. |
| Edda | No comparable costume discontinuity or abrupt head-size jump found. | Preserved artwork; included in fresh native capture and regression checks. |

Native heights remain Brynja 58px, Dagna 62px, Edda 63px and Ragnhild 64px. Walking poses naturally change silhouette width; they are not stretched to match a standing bounding box. Named cache revision 15 invalidates stale textures.

Whole-frame edits use the built-in imagegen skill. Exact prompts and accepted/intermediate sources are recorded in production.json. Python only extracts complete reference figures, imports complete paintings, and packages review images; no heads, limbs or costume pieces are assembled.

Visual review and assertion tests are separate. See ../../testing/quality115/acceptance.json for final checks and the neighboring boards/GIFs. Remaining limitations: four-key gait cadence; left-facing runtime mirroring reverses apparent accessory handedness; no new Windows playtest or release. Tiny painted folds vary between frames. Future activity assignments still require authored matching art rather than reusing a walking pose.
