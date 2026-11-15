# Specialist commissions — 0.118.0 candidate

HoldToolCapabilities owns Borin’s commission quotes, guarded payment and tool/component grants. HoldConversation exposes two small service pages using the existing conversation layout. No new save schema, item, production queue or relationship gate is introduced. Components use HoldData recipe costs; tool assembly uses existing tool costs. Fees: steel 35, reinforced assembly 45, haft 6, head 24, fittings 18 crowns.

The player supplies materials and pays for immediate NPC work. Borin’s expertise replaces player research for these orders only. Reinforced assembly still requires a steel pick; normal self-production and market purchases remain intact. Paid work does not call production/discipline credit or grant research. Owned tools are never replaced or revoked. Exact costs remain visible before every order.

The existing frontier103 source/package case checks actual conversation navigation and orders, unknown/cold/remote rejection, missing money/materials, duplicate owned tools, exact payments, component and finished-tool reload, and unchanged research, relationship and experience. Visual captures cover both service pages, completion and scrolling. Validation and delivery are pending; CURRENT_STATUS remains the published baseline.

Next roadmap slice: Ledger/sandbox integration. Further specialist stories and advanced equipment remain extensions; this slice is a practical paid service, not a new quest chain.
