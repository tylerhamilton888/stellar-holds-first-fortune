# Countryside cast and future relationships

Implemented in the pending 0.72.0 branch, not yet released. The six road residents now have authored motives, worries, confidences, gift preferences, useful favors and two local conversation topics each. Stable actor IDs, generated surnames, approved appearances and current routes remain unchanged. Their stories describe a connected community; musical gatherings, a bakehouse and a seed collection are character ambitions, not advertised playable features.

| Character | Place and personality | Connections and future story direction |
| --- | --- | --- |
| Dagna | Wayfarer's Hearth host; warm, sharp-tongued, generous to everyone except herself | Inherited her mother's roadside welcome; trades recipe corrections with Hedrik; quietly supported by Bram. Wants a proper bakehouse. Her growth is learning to accept care without surrendering her independence. |
| Bram | Stonebridge road keeper; gruff, careful, sentimental about family | Married; keeps his grown child's bridge drawings. Looks out for Dagna and works alongside Sten. Wants work that outlasts his name. |
| Torvik | Pinewood timber worker; reserved, patient, playful when comfortable | Makes fiddles from offcuts; Borin recognizes his craft; accompanies Ketil. Wants his music heard without becoming somebody else's idea of impressive. |
| Ragnhild | Greenhearth smallholder; direct, inventive, protective of inherited knowledge | Keeps her grandmother's seed labels and trials alongside old methods. Respects Ketil despite their teasing. Wants to preserve variety while trying new things. |
| Ketil | Greenhearth field hand; sociable singer with private self-doubt | Works with Ragnhild, rehearses with Torvik, hopes to perform at Dagna's Hearth. Wants to be taken seriously without losing his humor. |
| Sten | Mine porter; methodical, gentle, quietly funny | Married with a daughter; learned safety from Ivar. Keeps her homecoming tally stick. Values returning safely over impressive loads. |

## Character tiers

Principals carry authored stories and major services. The six countryside regulars now receive the same deliberate characterization without replacing their useful jobs. Other household residents retain stable generated personalities and preferences. Later promotion of a background resident should preserve identity and history rather than reroll them.

## Romance groundwork — dormant

`HoldRoadCharacters.CAST` records adult status, relationship status and deliberately chosen future candidates. `ROMANCE_ENABLED` is false. `future_candidate` is an authoring query only; no gameplay uses it to unlock dating. No romance meter, flirting, proposal, spouse behavior or romantic gift response is implemented or shown to players.

Initial candidates: Dagna and Ragnhild for male players; Torvik and Ketil for female players. Each already has a life and ambition independent of a future partner. Bram and Sten are married and excluded. Orla and Hedrik's existing marriage and anniversary stories remain unchanged. All unreviewed NPCs default to ineligible; procedural generation does not silently make someone romanceable.

Future implementation contract:

- Keep courtship state separate from the existing friendship `bond`. Gifts, help and friendly confidences never imply romantic intent or consent.
- Use stable actor IDs and additive saved records, with stages such as none, courting, partnered and married. Add fields only when their behavior exists.
- Offer courtship only through an explicit player choice and an authored, reciprocal response from an eligible adult. Declining preserves friendship, services and work access.
- Gate personal scenes through shared experiences and mutual interest, not an endlessly purchasable gift threshold. No friendship decay, missed-date punishment or daily romantic chores.
- Respect the candidate's work, home and ambitions. Partnership should not erase their personality or turn them into a generic worker.
- Decide exclusivity, breakups, household occupancy, shared beds and save migration before implementing marriage. Children and dynasty succession are later systems.

Possible scenes, not implemented: help Dagna accept an evening off; hear Torvik play an unfinished tune; compare Ragnhild's new seedlings with her grandmother's notes; listen when Ketil chooses a song without a joke in it. Every premise can first support friendship; a romantic variant must require explicit courtship.

## Compatibility and acceptance

First meetings use authored preferences and favor reasons. Existing road acquaintances receive a versioned narrative-only upgrade: their names, appearance, discovered tastes, current material request, bond, daily limits and memories remain intact. Returning saves never lose earned familiarity.

Local GDScript syntax and content consistency checks pass. Added native regression coverage for all six conversations, migration preservation/idempotence, candidate directions, exclusions and dormant romance. These native checks and the Dagna dialogue screenshot have not run: the existing Actions budget blocker still prevents release acceptance. Full gameplay, focused visual and exact-export gates remain required. The last published build remains 0.71.2.
