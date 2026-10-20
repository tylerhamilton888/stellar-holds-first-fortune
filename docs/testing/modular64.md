# Modular placement — 0.61.3

Native Godot 4.4.1 / OpenGL compatibility / Linux software rendering, isolated saves. `tests/modular64.gd` covers 28 assertions: shared furniture geometry/recipes, fine snapping, real feet collision, safe moves/cancel, filled chest identity/material preservation, close storage rows, blocked placement, affordable/unaffordable previews, foundation construction, stair landing protection, save/reload, town catalogue reuse and actual-displacement walking direction.

Visually inspected native worksite, tavern, green/red furniture previews and foundation grid. The item ghost is tinted; its ground footprint is outlined and labelled PLACE/BLOCKED. Furniture uses a fine 10-unit grid, equipment 20 and house pieces 40. The preview does not imply pixel-perfect sprite collision. Upper-floor checks use the entire furniture base; door/stair and existing route restrictions remain authoritative. Build grids appear only while placing.

Verification command: `tools/check.py --suite modular` (native display required). Includes orientation, ambient, equipment, handworks and world cases in addition to modular checks. Working captures/logs: animations61/qa/modular64-pass. Earlier failed fixture placements intentionally landed near the founding-stones interaction; final fixture selects valid nearby ground and separately checks occupied ground. The save assertion normalizes JSON numeric types without omitting any saved values.

Recovery: local pre-modular64 preserves 0.61.2; current work is on polish/modular64 in GitHub. No old release/bundle overwritten. New Windows export and hardware/audio checks are not included in this source milestone. Broader animation/world-art backlog remains separate.
