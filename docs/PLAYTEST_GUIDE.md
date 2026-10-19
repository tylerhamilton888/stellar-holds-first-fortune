# Playtest 0.53.1 — Standard Windows release
Extract the full Windows ZIP and run FirstFortune.exe. The Windows runtime matches the official Godot export template. The game data was tested using the native Linux release runtime;  Windows launch, audible balance and your judgement of feel are the remaining acceptance checks.

1. **Tutorial:** Start a new fortune, follow Ivar or skip his walk. Check the chest and rest at the bed in either order. Rest lasts about a second; moving cancels. The objective should name only the remaining task. Meet Borin, Orla and Hedrik through the existing introductions.
2. **Transport:** Craft/place a handcart with Shift+B, load raw stone/logs using E, and take its handles with C. Travel the gate, trail, mine door and real stairs. Check the same cargo after returning and reloading. Park before withdrawing/unloading. A wagon parks outside an interior, ready to collect on return. Ladders and house stairs require parking; no cargo should disappear.
3. **Practice:** After the return-route lesson and lift repairs, accept Borin's Keep your feet lesson. Enter the practice bay. Move with WASD, face with the mouse, hold LMB to strike, hold RMB to guard, tap guard before contact to parry, and Q to dodge in your movement direction. Watch amber attack arcs. There is no stamina or practice damage. Land three blows, guard once, and evade a real strike; report at the south bench with E.
4. **Deep combat:** After reporting training, explore below depth one. F switches weapon/tools; B opens equipment. Walls should stop blows/shots, rear attacks should bypass guard, hammer impacts should stagger, and carbine shots spend ammunition. Defeated encounters stay defeated and salvage pays once. Save/reload partway through a fight to check wounds, then clear it and reload again.
5. **Comfort:** Open inventory during an enemy windup; it must pause. Dodge toward a wall; it must stop. Try a parked cart beside a doorway; E must still let an empty-handed Dwarf through. Watch weapon/tool labels and confirm NPC/player silhouettes do not acquire neighboring sprite fragments.

Report the location/depth, equipment, action, save slot and a screenshot for any snag. Transport still uses the Dwarf's collision rather than a full vehicle turning-radius simulation. House carts, additional authored directional combat/guard art and convoy automation are future work.

## Wider regression route

# Playtest 0.52.0 — A Place to Begin

Extract the entire Windows ZIP before running PLAY-WINDOWS.bat. Continue an existing fortune or start normally. Older saves receive an exact uniquely named backup before the additive upgrade. Keep that backup with its matching older build if rolling back.

Start a **new fortune in a spare save slot** to see the new intro. After the arrival illustrations, Ivar meets you at King's Gate, walks you to the workers' quarters and explains the room. Space/Enter or the button continues; Esc skips the tour. Rest at the bed and check your chest with E, in either order. J then guides you to Borin, Orla and Hedrik. Continue an existing fortune to check that its progress is unchanged; the intro will not replay on progressed saves.

Watch the walk from front, side and back, with and without a raw load. Stop, turn, resume, and walk against a wall. Feet should plant when blocked; hair and clothing should stay consistent. With Strong Shoulders, try mixed cargo and set down one load while keeping the other supported.

1. Walk Keldrath, use the stairs/lift, enter the tavern and visit the seated Lord. Check head/hair continuity, drinking, table scale, door thresholds and the river bridge. 1–0 selects the visual hotbar; I opens your pack, G directions, J quests.
2. Enter Old Workings from the High Trail. Hold LMB to excavate; ordinary rock is quick and harder formations crack. Test each cardinal direction, shovel and hammer. Look for continuous strata, connected veins, cavern/geode discoveries and a clear floor edge. Create/use a stair, descend and return along the same connection.
3. In Pinewood, select axe [3] and hold LMB on a reachable trunk. The Dwarf approaches a working stance. Watch the cut, fall and subsequent log cutting. E lifts a freed raw log, Q sets it down.
4. Shift+B crafts/placeable stonebreakers, sawbenches, stockpiles, pallets and carts. E lifts/deposits, Shift+E withdraws. Hold E at a supplied bench; the Dwarf approaches and performs three short strokes. Check that the same rock/log appears in hands, on the rack and on the bench. Collect output and use it in a house or sell it.
5. Earn eight productive masonry/forestry credits for Strong Shoulders. Carry two rocks, two logs, then a mixed pair. Craft a freight wagon after unlocking it. C takes/parks cart handles. Check empty/full cargo pictures and quantities. General carts/wagons follow connected outdoor routes and mine stairs. Wagons park outside interiors; house stairs and mine ladders require parking.
6. J → River & Root explains fishing/gardening. Craft field tools (3 timber + 1 iron), then place a garden bed on your claim (3 timber + 1 stone). E plants a seed, E waters with one water. Spend three minutes working elsewhere; return and harvest. Crops do not wither. The harvest returns seed.
7. On the High Trail, fish at the west bank north of the bridge, beside the ripples. Hold E to cast, wait and reel. Walking away cancels without a penalty. Sell the catch/turnips at Orla's or use Borin's Crafting tab to make crew provisions.
8. Save, quit and Continue. Revisit excavations, stairs, raw cargo, wagons, beds, chests and crops. Existing miners, masons, machinery, quests and other progression should remain intact.

Please report the area/depth, selected tool, character sculpt, what you pressed and a screenshot/video for a visual or contact issue. In particular, judge the contact/pass gait and supported carrying poses at normal speed. Additional directional working and pushing drawings remain future refinement.

Native gameplay and exported-pack checks use Linux Godot 4.4.1. Windows launcher execution, audio balance and subjective feel remain player acceptance checks.
