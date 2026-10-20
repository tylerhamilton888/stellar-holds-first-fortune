
## 0.20.0 — Rune armor and responsive movement

Rune armor now carries a small angular engraving positioned on its shoulder plate. It is clipped by the painted garment mask, so it cannot draw over skin, hair or shields. Removed the full-height luminous stripes. Ordinary armor has no glowing rune.

Movement integrates at 120 Hz independently of rendering: stronger acceleration, faster reversal and braking, 120 ms jump buffering, 90 ms coyote time and variable jump height. Tap Space for a short hop; hold for the full jump. Holding Space never auto-repeats jumps. Mining impact pauses no longer freeze locomotion. Single-cell steps require clear headroom; ground contact uses a quarter-pixel probe. Camera/world draw offsets share a pixel grid.

Fixed the sprite cache fallback ignoring indoor zoom and lighting; cached and direct draws now match within one sampling pixel at 1.5x. Newly built atlases are not used before their first rendered frame. Native pose scale remains fixed within each source family; crouching and arm movement do not dynamically resize the character. Feet remain the visual and collision origin.

Verification: 18 controller checks (30/60/120 FPS, braking, reversal, buffered/coyote/tap jumps, ceiling clearance and dodge-wall collision), eight cached/direct scale comparisons, floor/wall contact regression and 47 combat checks. Actual ten-dwarf gameplay captures reviewed with armor and both facings. Linux Godot runtime tested; Windows package not executed here.
