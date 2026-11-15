# Session handoff — component crafting in progress

Published baseline remains 0.116.0; see CURRENT_STATUS.md. Owner requested the next Home and Fortune milestone. Working branch: feat/components173, based on current master after PR #172. AGENTS.md and RELEASE_PIPELINE.md remain authoritative.

## Implemented locally, not released

0.117.0 adds shaped hafts, forged pickheads and tool fittings through existing State recipes/queue and market routes. Reinforced-pick assembly consumes one of each with unchanged total raw material cost; owned picks and ordinary steel crafting are preserved. Completed work credits Woodworking/Smithing. The communal forge has a Tool components view with clear output and acquisition guidance. See COMPONENTS173.md.

Extended frontier103 covers manufacturing, completion credit, queued save/reload, bought components, exact/atomic payment and guarded assembly; menu92 covers every new item. Local import/validation and visual review are in progress. No PR or release branch yet. Run focused frontier103, menu92, forge147, disciplines and excavation154, plus tooling. Continue through source/package gates and update delivery documentation only after confirmed publication.

## Environment and safeguards

Local checkout: /workspace/scratch/73404e92e628/stellar-holds. Godot 4.4.1 downloaded alongside it in engine. This host needs Xorg dummy over TCP in the same command process as native tests; Unix sockets are restricted. Local Git HTTPS push has no credentials; use the established authenticated blob/tree upload fallback with exact local tree comparison. Keep output bounded and original assets/saves/releases intact. No sub-agents unless requested.

Freight follow-up from 0.116.0 remains unresolved: one intermittent test failed then passed retry and package/seed trials. Capture state if it recurs. Normal Windows input/audio/performance need ordinary playtesting.

[Previous handoff](history/SESSION_HANDOFF-before-components173.md).
