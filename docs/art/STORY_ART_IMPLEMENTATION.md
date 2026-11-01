# Story art implementation checkpoints

Owner authorized implementation after the silhouette/stance review. Keep the existing bold outlined style, readable color masses and whole painted frames. This authorization does not require another concept approval round.

## Checkpoint 1 — portraits and loading scenes

Implemented 24 distinct named dialogue portraits through the existing HoldPortrait widget; Lord Eirik retains his existing bespoke portrait. Explicit cast IDs route road, lodge, workplace and recruited-crew profiles. Unknown/background IDs retain their existing palette-driven portraits. Reading a named profile does not overwrite saved sculpt, colors or relationship data.

Four approved loading scenes rotate once per loading event: mine/haulage, forge, homebuilding, riverside life. Scenes stay fixed while hints rotate. Full artwork fits the canvas; shaded title and hint areas maintain readability. Existing progress, fade and input blocking remain intact. No artificial loading delay.

Production provenance: assets/story105/production.json. Focused native art checks: 92 passed, including 24 crops, color/shader transitions, saved identity preservation and loading selection. Native portrait boards and all four loading captures reviewed. Focused native suite passed 856 assertions (art 92, loading 19, people 446, courtship 299). Exported-pack art checks passed 92 from an empty working directory and isolated save. Evidence: ../testing/story105/acceptance.json. PR #77 retains the implementation; full hosted validation remains pending.

## Checkpoint 2 — world frames (not implemented)

The existing whole-character world animations remain active. Do not mistake the new portraits for completed bespoke world sprites. Previous four-key walking studies repeat extended-leg silhouettes and are rejected. New identity bundles must cover actual facing directions and required walking/work/carry/drink states before activation; no idle-to-generic identity swaps, static sliding, rotating limbs or fabricated animation claims.

Everyday stances must be sustainable resting postures. Dagna and Orla have relaxed open shoulders and resting hands; greeting palms are brief contextual gestures. Yrsa stands naturally with an alert gaze; her forward lean/coy tilt is reserved for an appropriate romantic scene. Ivar rests hands near his belt. Skarrin can rest with crossed arms, occasionally hands behind his back. Explanatory gestures belong to dialogue, never a permanent idle.

Women must differ in face and underlying shape as well as hair/clothes: Dagna softly curved medium build; Ragnhild athletic with stronger hips/legs; Brynja short, compact and square-shouldered; Orla mature hourglass and broad cheekbones; Edda narrower and upright; Sigrid broad muscular shoulders/strong arms; Yrsa petite athletic. All adult, attractive, sturdy Dwarfs; none obese. Keep distinctions visible at 62px world height. Use normal eyes and varied noses/jawlines, not anime faces.

## Checkpoint 3 — integration and delivery

Run the story_art105 suite and affected full-source gates, inspect native output, then verify exported resources before release. Current code is an incremental portrait/loading milestone, not completion of checkpoint 2. The provisional High King remains a concept until his story role is defined. Preserve prior releases, save identities, player-home/Z-level rules and construction parity.
