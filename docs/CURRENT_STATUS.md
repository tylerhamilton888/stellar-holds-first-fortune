# Current source: whole-character integration, unreleased

2026-10-19 · checkpoint **whole-integration-wip-58**. Complete painted character frames are active in the existing game, including player, ordinary NPC, work, carrying, equipment and portraits. Saved identity variants remain distinct. Source-purple hair is recolored to the selected natural palette; see `testing/whole-0.58.0/hair-palette.png`.

**Visual release gate failed.** Several sequences still change shoulder, hairstyle, facing or tool; some source keys are clipped. Carry material parity, tray occlusion, tattoos, contact sockets and fuller gait sequences remain unfinished. See `art/whole-integration-58.md` for precise blockers. This is a recoverable runnable development milestone, not a polished new game build.

Native input/mining/handling/combat checks passed **98/98**, with native core, equipment, interior and movement captures. These mechanical passes do not establish animation quality. See `testing/whole-0.58.0.md`. Windows execution/audio/hardware performance are unverified.

No gameplay balance, terrain, quests or save schema changed. The .57 Windows package remains the last package, with visuals rejected by the user. All prior checkpoints/backups remain; continue from the new source milestone rather than shipping .57 as the fix.
