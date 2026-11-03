# Dwarven religion and everyday culture

Owner direction, 2026-11-03. Canon for The Stellar Holds, including future Great Claim quests. Religion should **flavor sensible moments without overwhelming the world**. Keep ordinary work, relationships, exploration and existing development priorities central. A selected place, holiday or personal concern gives a reference its reason to exist; frequent generic religious dialogue does not.

## The Eight Elder Gods

Dwarves were created in the image of the Eight. The gods are genuinely supernatural, non-jealous and complementary. Dwarves honor each as circumstances warrant; they do not select an exclusive patron. Living well as a Dwarf is itself devotion: the miner supplies the craft, the craft arms the defender, and all return to hearth and family.

| God | Domains | Weekday |
| --- | --- | --- |
| Keldran | Mining, stone, masonry, endurance | Stoneday |
| Borund | Smithing, craftsmanship, invention | Hammerday |
| Hadrun | Travel, trade, exploration | Roadday |
| Haldra | Warfare, courage, protection | Shieldday |
| Thorek | Oaths, honor, justice, kingship | Oathday |
| Brenna | Hearth, family, marriage, hospitality | Hearthday |
| Bromund | Brewing, feasting, friendship, celebration | Cupday |
| Nyrda | Ancestors, memory, history, death | Namesday |

The week repeats continuously in this order. Retain the established 28-day seasons and 112-day year; season boundaries need not start on Stoneday. Existing absolute day numbers, minutes, holiday dates, invitations and completed celebrations retain their meanings. Do not convert elapsed days, relationship timers or production time into longer units. Calendar browsing never advances time; ordinary services remain open.

## Worthy ancestors and ascension

Worthy ancestors live in celestial halls and are venerated through names, memorials, inherited tools and family histories. Exceptional ancestors can sometimes truly manifest to guide or protect descendants. Extraordinary Dwarves may ascend to genuine lesser godhood, becoming patrons of particular families, crafts, professions or communities. This is distinct from ordinary ancestor remembrance.

Unmistakable divine intervention must be rare and consequential. Do not add routine apparition effects, daily blessings with stat rewards, or ghost appearances merely to prove the lore. No worship meters, patron selection, penalties for ignoring observances, repetitive prayer tasks or required religious errands.

## Integration delivered in traditions126

- The calendar shows eight named columns, continuous weekday offsets, and occasional lodge activities when a relevant day is selected. Existing seasonal and day/night mechanics remain intact.
- The shared workers' memorial uses the existing carved plinth artwork. Both the legacy lodge and current Stonebridge opening have a reachable memorial. Existing frontier rooms receive one fixed addition without reseeding their possessions.
- **Names in the stone** is an optional, deadline-free errand found by inspecting the memorial. Accept, bring two dressed stones, and receive two meals once. It restores name tablets and records the act in the existing chronicle; it grants no faith currency or main-quest progress.
- An **Ancestral hearthstone** can be built through ordinary furnishing plans for four dressed stones and two timber. Inspecting one's placed stone offers a single family remembrance in the chronicle. It can be moved and recovered through the normal furnishing system. Surrounding decorative choices remain the existing furniture catalogue.
- Rurik and Sigrid have one optional memorial topic each. Rurik is practical and brief; Sigrid cares about family names. Their default greetings and Ivar's required opening instructions are unchanged.
- Sigrid joins Cupday company and Namesday remembrance at the lodge from 18:00 to 20:00. She walks to and from the activity within the room. This replaces her usual pose for those periods; it never creates another instance, closes services or changes her stable identity.
- First Hearth includes Brenna's hospitality, Forgefire includes Borund's craft, and Ancestor's Vigil includes Nyrda and inherited tools. Barleywake keeps its existing harvest emphasis. Festival dates, food benefits, journal keys and late participation remain unchanged.
- The existing Oath Stone receives an optional Thorek inscription. Existing Hearthward, Forgeward and Works Below notices include a short relevant custom or mason's mark. These are inspected deliberately, never broadcast as repeated ambient speech.
- The full cultural reference is optional reading from a memorial or household stone. No theology is required to finish the opening.

## Later story opportunities, not completed gameplay

Use this reference while completing the contest/Keldrath, invasion/trial and Thaneship/household milestones. An oath's consequence can draw on Thorek; protective courage on Haldra; family and marriage customs on Brenna; a journey or market on Hadrun; friendship and feasting on Bromund. Existing ancestry research can distinguish documentary evidence, veneration and an exceptional supernatural encounter.

Future ceremonies, markets, household conversations and manifestations must earn their place in those stories. This pass does not complete those milestones, add marriage gameplay, implement an apparition, or introduce a general religious simulation. Do not replace established NPC personalities with uniform piety. Keep most everyday dialogue about ordinary life.

## Ownership and verification

`scripts/calendar.gd` owns time and the weekday calculation. `scripts/traditions126.gd` owns the two opt-in remembrance outcomes, reference text, guarded memorial transaction and Sigrid's small weekly activity. Additive state lives under `surface.traditions126`; ordinary furniture lives under `surface.decor`.

Run the `traditions126` source suite and its standalone exact-export case. Cover old/new lodges, idempotent furniture addition, local interaction and stale callbacks, one-time payment/reward, real shrine placement, calendar alignment and rollover, save/reload, single-character identity and clear weekly routes. Review the native calendar, memorial, household stone and both gatherings beside the established Dwarf art.
