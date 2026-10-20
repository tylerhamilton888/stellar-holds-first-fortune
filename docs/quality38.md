# Neck material correction, 0.37.1

The defect was material ownership at warm, shaded neck boundaries. Those pixels could be included in the hair label, so selecting dark or pale hair tinted the neck. This patch changes material coverage and labels only.

`tools/quality38/neck_masks.py` defines portrait-specific exposed-neck contours and pose-relative sprite neck regions. It reclassifies reddish complexion shadows within those regions, while retaining foreground hair. The correction is transferred to existing baked walk material maps using the canonical head placement. Source paintings, full-frame walking PNGs, sockets, gait metadata and movement code are preserved.

Run this correction after rebuilding the quality36 source material maps and quality37 portraits/walking assets. Its retained original masks make repeat runs deterministic. The source export can be reproduced with `tools/quality36/export.gd` if the raw directory is absent.

Verification uses rendered dark and pale hair comparisons at independent neck landmarks; complete female walking cycles at the two previously contaminated shadows; and a byte comparison of all walking PNGs and attachment/gait data against the delivered 0.37 source archive. The exported pack is loaded separately. Windows runtime execution remains untested in this Linux environment.
