# Current backlog — 2026-11-16

## Current work and next milestone

Delivered through 0.123.0: building-grid clarity, family-owned Rise and cottage, tools/materials, cross-craft components, Borin's commissions, civic livelihood routes and first presentation polish. See the [Home and Fortune roadmap](HOME_AND_FORTUNE_ROADMAP.md) and [previous backlog](history/BACKLOG-before-scenes181.md). Preserve existing building, navigation, household and freight owners.

0.122.0 delivers Borin’s optional repair and early discovery/people scenes (STORY183.md). Source PR #183 is merged; full source/package acceptance and publication passed. Respect the owner’s dwarven craft standards; playtest pacing before extending the story batch.

0.123.0 delivers room framing and selective tall-prop cutaways. PR #185 merged; full source/package acceptance and public asset verification passed. See VISIBILITY185.md.

## Playtest the current published build

Use [CURRENT_STATUS.md](CURRENT_STATUS.md) for the verified release and [PLAYTEST_GUIDE.md](PLAYTEST_GUIDE.md) for installation and the current route. Living Forges, NPC conversation presentation, dialogue-state corrections and the first-hour guidance pass are delivered. See [FIRST_HOUR.md](FIRST_HOUR.md) for the staged welcome, optional routes and forge handoff.

Review the first hour: arrival, meeting Ivar, the cottage, bed/chest interaction, parent letter, chosen ambition and optional paid work/forge/civic contributions. Watch unclear directions, excessive text, rushed reveals, ledger visibility, mine doorways, workshop purpose and awkward interaction approaches. Use an empty fortune slot for opening tests; separately check continued progress in existing saves.

Revisit completed favors and projects, restored forges, learned research and relationship responses. Check reply scrolling, keyboard/mouse navigation, readable costs and character voice. New compact forge layouts apply to newly created rooms; existing rooms retain their saved layout, furniture and storage. See [Living Forges notes](LIVING_FORGES148.md).

Continue through the Thane homecoming when testing campaign pacing. Record confusing next steps, repetitive trips and resource bottlenecks before expanding systems. Windows performance, input feel and audio still need ordinary playtesting.

## Maintain delivery safeguards

Follow [RELEASE_PIPELINE.md](RELEASE_PIPELINE.md) for release preparation and post-publication documentation. Keep gameplay and package gates intact. Documentation-only corrections do not require a new game version or Windows rebuild.

Keep detailed evidence in files, bound conversational output, and preserve original assets and previous builds. Repository safeguards reduce known hazards; they do not guarantee ChatGPT backend reliability.

[Earlier backlog](history/BACKLOG-before-doc-consolidation-2026-11-10.md) preserves superseded version-specific playtest headings. Use current status and live release metadata for delivery state.

## Surface room blueprint playtest

Test [room plans](BLUEPRINTS.md) on the family-owned holding: connected rooms, doorways, costs, furnishing, renovation and save/reload. Check [underground excavation](EXCAVATION154.md), [cellar stairs](CELLAR156.md) and [upper floors](UPPER158.md) with a cellar workshop/store, ground kitchen/hall and upper bedroom. Check [household-worker routes](WORKERS160.md) and [freight](FREIGHT162.md) in both directions, stopped/returned loads, blocked stairs and saving mid-trip. The 0.115.0 family-owned opening supersedes provisional property-story integration in RISE165.md.

## Freight validation follow-up

One PR freight162 lower-level route check failed once, then passed on targeted retry, in the package and in an isolated local case plus eight fixed-seed trials. The cause was not reproduced. The case now records a replay seed and writes map/carrier/route/cargo snapshots at each failure; see TESTING.md. Preserve those files if it recurs; do not treat a retry as a root-cause fix.

PR #187 separately reproduces a mid-step reassignment corner trap with seed 162 and adds centring before a new freight route. Check its validation and 0.123.1 delivery before calling that fix released.
