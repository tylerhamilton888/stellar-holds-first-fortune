# Story art implementation checkpoints

Owner authorized implementation after the silhouette/stance review. Keep the existing bold outlined style, readable color masses and whole painted frames. This authorization does not require another concept approval round.

## Checkpoint 1 — portraits and loading scenes

Implemented 24 distinct named dialogue portraits through the existing HoldPortrait widget; Lord Eirik retains his existing bespoke portrait. Explicit cast IDs route road, lodge, workplace and recruited-crew profiles. Unknown/background IDs retain their existing palette-driven portraits. Reading a named profile does not overwrite saved sculpt, colors or relationship data.

Four approved loading scenes rotate once per loading event: mine/haulage, forge, homebuilding, riverside life. Scenes stay fixed while hints rotate. Full artwork fits the canvas; shaded title and hint areas maintain readability. Existing progress, fade and input blocking remain intact. No artificial loading delay.

Production provenance: assets/story105/production.json. Focused native art checks: 92 passed, including 24 crops, color/shader transitions, saved identity preservation and loading selection. Native portrait boards and all four loading captures reviewed. Focused native suite passed 856 assertions (art 92, loading 19, people 446, courtship 299). Exported-pack art checks passed 92 from an empty working directory and isolated save. Evidence: ../testing/story105/acceptance.json. PR #77 merged as 6c821675d1bf0994d5c8c48a370d15ad98a7d14f after full hosted validation run 41350992804 passed.

## Checkpoint 2 — Dagna implemented; remaining cast pending

Dagna now has an active, reviewed 24-frame world bundle: four relaxed idle views, sixteen walk keys with alternating physical contacts and distinct passing steps, and four drinking poses. Her existing route pauses include a short sip; partner-rescue and saved appearance continuity are verified. Measured atlas row boundaries restore complete crowns/boots. Native focused checks passed 1,282; exact-pack focused checks passed 1,158. See [gait108/README.md](gait108/README.md) and [acceptance evidence](../testing/gait108/acceptance.json).

The remaining 23 named world characters are unfinished. Nine other extracted candidates remain disabled; technical extraction tests do not approve them. Each complete bundle needs its own four-view foot/arm and body-proportion review, sustainable idles and all reachable activities before activation. Do not replace the varied cast with copies of Dagna's silhouette. Next: Ragnhild.

Historical correction: the earlier ten candidate sheets repeated leading feet and were quarantined. Dagna's repaired bundle is the first to leave that quarantine. A three-key ping-pong or changed arm alone does not establish an alternating gait. Preserve complete painted characters; no rotating/assembled limbs or idle-to-generic swaps in reachable activities.

Everyday stances must be sustainable resting postures. Dagna and Orla have relaxed open shoulders and resting hands; greeting palms are brief contextual gestures. Yrsa stands naturally with an alert gaze; her forward lean/coy tilt is reserved for an appropriate romantic scene. Ivar rests hands near his belt. Skarrin can rest with crossed arms, occasionally hands behind his back. Explanatory gestures belong to dialogue, never a permanent idle.

Women must differ in face and underlying shape as well as hair/clothes: Dagna softly curved medium build; Ragnhild athletic with stronger hips/legs; Brynja short, compact and square-shouldered; Orla mature hourglass and broad cheekbones; Edda narrower and upright; Sigrid broad muscular shoulders/strong arms; Yrsa petite athletic. All adult, attractive, sturdy Dwarfs; none obese. Keep distinctions visible at 62px world height. Use normal eyes and varied noses/jawlines, not anime faces.

## Checkpoint 3 — integration and delivery

Run the story_art105 suite and affected full-source gates, inspect native output, then verify exported resources before release. Current code includes portraits/loading plus Dagna’s world bundle; the rest of checkpoint 2 remains unfinished. The provisional High King remains a concept until his story role is defined. Preserve prior releases, save identities, player-home/Z-level rules and construction parity.

## Recovery 106

Source and native review details: [gait106/README.md](gait106/README.md). Dagna side diagnostic has corrected contact/passing and opposing arm keys; this does not approve a full world bundle. The other directions remain rejected.
