# Disciplines71 verification

Candidate 0.65.0 integrates twelve active mastery paths and a clearly reserved Brewing tab, thirteen techniques and the eight existing research methods. Assets: original SVG emblems in assets/disciplines71. No new in-world sprite or character animation is introduced.

Test suite `disciplines` covers actual UI callbacks, all tabs/window bounds, raw ore/log yield, recipe completion, branch/research eligibility, legacy migration, saved experience/unlocks, underground shortcut, dodge recovery and crew capacity. Existing Handworks, mining, first-shift, ancestral quest, menu and world cases run alongside it. The exact-pack runner also includes the new case.

Initial testing caught a JSON numeric-type assertion issue and a fixture attempting combat before the tutorial granted it; both were corrected without bypassing gameplay eligibility. The new shortcut moved from U to Y to preserve existing underground unloading. Native Mining/Engineer/Brewing screens were visually inspected at gameplay resolution. Final passing results will be recorded here after completion. No Windows release is claimed by this source record.
