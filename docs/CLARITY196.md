# Player-facing clarity pass — 196

Owner direction: use understandable names throughout the interface, explain what choices do, and hide construction plans until their technology is learned. Keep Dwarven character through art, dialogue, and concise flavor after functional information.

## Scope

Shared menu titles, pause/settings navigation, architectural styles, building types, furnishing names, skill names and descriptions, research names, notifications, onboarding guidance, and matching test selectors now use consistent practical terms. Stable IDs, save keys, named town destinations and existing player building names are preserved. AGENTS.md records the standard for future edits.

Building cards say Homes, Workshops or Halls. Style descriptions state their materials and lack of production bonuses. Plan details explain the purpose and list actual optional furniture/workstations from the authoritative room templates. Copies of named public buildings use generic building types; the hall description explicitly says town services/staff are not supplied. No NPC or service spawning was added.

## Research visibility

Single-storey homes remain available initially. Stoneworking unlocks multi-storey homes; Precision forging unlocks workshop plans; Fine masonry unlocks hall plans. Research descriptions state these effects. Catalogue, plan selection, preparation and construction commit enforce the same eligibility. Moving existing buildings is exempt so old possessions remain usable. These are new prefab eligibility rules, not an assertion that the old source already gated them. Costs are unchanged; inability to afford a known plan does not hide it.

Furniture retains its existing Home comforts/collection eligibility and hides unavailable entries. The recipe book hides entries blocked by its existing research/collection rules and recovers a stale selection. Research screens continue to explain future unlocks. Individual construction tiles and existing room-plan rules are unchanged; this pass does not claim new room-purpose unlocks.

## Recovery and integration boundary

The prior 0.125 visual checkout and local recovery bundle were missing when this session resumed. The presentation/holding191 remote ref does not exist. This branch was recovered from published-source master 1a5633176866f744f9292bc3b06c72c275278f84 (0.124). It is an isolated patch, not a replacement for the approved 0.125 artwork/UI. Do not release it as 0.125 or claim the Mason’s Book itself has been updated. Integration with that branch remains blocked by the missing source. Saved screenshots and generated assets still exist separately.

## Verification

Pinned Godot 4.4.1 architecture_style 69, menu_quality100 36 and disciplines 38 passed (143 checks, no script errors) at test-results/clarity196-r1. Final menu_quality100 at clarity196-final passed 36 checks after replacing ambiguous skill progress units; the final capture was visually reviewed. Output policy and whitespace checks passed. Architecture coverage includes fresh availability, hidden plans, research reveal, stale callbacks, commit-time refusal without spending, and original construction/renovation behavior. Menu coverage includes hidden unknown recipes, stale selection fallback, reveal after research and unchanged inventory. Visual evidence comes from the recovered 0.124 UI, not the missing 0.125 book.
