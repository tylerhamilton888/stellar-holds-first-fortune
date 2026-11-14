# A gift from home — 0.115.0

New fortunes own Old Stonewright’s Rise from arrival. The parents’ purchase is independent of ancestry. Ivar offers a brief saved/skippable introduction before paid mining, with a direct route to the holding. The journal keeps the parent letter available and offers home improvement, paid work, the forge, local trades and civic projects as choices.

## Implementation

- `frontier103`: owns additive `home169` migration and first-time cottage seeding. The existing `permit` flag now records civic recognition after two contributions. It never buys or replaces property. The older `rise165` record remains the introduction’s saved scene state.
- `first_visit99`, `opening_scene`, `claim_scene127`, `worker_lodge100`: arrival, chosen ambition, letter and local Ivar introduction. The first shift retains its practical lesson and once-only pay; it no longer gates the holding or civic contributions.
- `main` load reconciliation: migrate old frontier saves before restoring the surface. Existing claim IDs, custom names, homes, storage, crew and story flags remain authoritative. No existing holding is reseeded, whether previously provisional or permanent. A frontier save without a claim receives the same Rise; preexisting structures/storage block starter seeding.
- `surface`, `hearthcraft`: the cottage consists of ordinary editable stone floors, walls, windows, door and roof, plus a bed and empty chest. No special immutable building, industrial stations, free resource stock or second estate. Its placement leaves the existing eastern paths clear.
- `ledger137`, `work132`, `work_view132`, `campaign138`, `great_claim102`: ownership/recognition wording and opportunity access. Exact costs, local delivery checks, skill proofs, authored campaign foundations and once-only rewards remain in place.

## Improvement and compatibility

The cottage starts without a lamp/hearth. Adding light to its usable bedroom satisfies the existing finished-home checks after civic recognition; no demolition is required and the starter dwelling cannot immediately award improvement marks. Existing finished-home rewards remain recorded. Old empty holdings receive accurate building guidance rather than a promise of a newly seeded bed.

Legacy non-frontier fortunes retain their original geography and arrival. Loaded frontier saves retain recognition, possessions and active story progression. The new introduction does not authenticate ancestry, grant campaign rewards or complete mining work. Ordinary walking, construction, furnishing, sleeping and storage interactions are retained.

## Validation

Existing frontier103, opening146, firstvisit99, polish135, lodge100, ledger137, work132 and campaign138 cases cover affected paths. Extended coverage includes immediate ownership, scene reload/skip before mining, physical bed/chest interaction, persistent letter, real civic contributions without a paid shift, paid starter-cottage improvement, and both legacy tenure migrations with stocked storage and a recruited worker. Review native screenshots of the cottage, introduction, letter and state-dependent dialogue. All eight focused native cases passed 681 assertions; 42 tooling tests and output policy passed. Reviewed the cottage/bedside, saved property introduction, initial/scrolled parent letter and state-dependent Ivar dialogue. Full source/package release gates and publication remain pending.

The 5–10 minute arrival target still needs normal-speed human pacing review. Later tool/material, cross-craft, specialist commission, Ledger/sandbox and environmental milestones remain in [the roadmap](HOME_AND_FORTUNE_ROADMAP.md).
