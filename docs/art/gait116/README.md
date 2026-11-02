# Rurik Stonehand — world animation 116

Fifth enabled named character. Twenty whole-character poses: four resting views and four walking keys per view, at the existing 62px stature. Red work shirt, leather harness, charcoal trousers, right-hip pouch, full reddish beard and broad compact male dwarf proportions. Boots retain two front buckles between walking and rest.

Whole replacement figures were generated with imagegen. production.json records prompts, accepted source hashes, runtime hashes and selection decisions. Reference PNGs are whole-figure crops or layouts; no limb assembly. Original rurik.webp remains unchanged. New lossless sibling atlases are selected through rurik.json, with opposite-step overrides where row generation repeated a foot or arm pose. Named cache revision 16 refreshes existing frames.

Reviewed all twenty poses on the native four-view board and ordered animation frames, including transparency, alternating support feet, harness/pouch continuity and stature. Quarter sprites have nonzero hidden RGB outside the figure but zero alpha; native rendering confirms clean transparency. Minor painted shape variation remains; leftward mirroring reverses apparent accessory handedness as in the existing renderer.

The live lodge route uses walking and resting only. No invented hauling, mining or drinking behavior. The new fixture checks 113 samples of the existing route, conversation, save/load identity and inventory, and lodge visibility. Unsupported future activities retain the existing renderer and require dedicated art before named activation.

Evidence: ../../testing/gait116/. Owner visual feedback and hosted full-suite acceptance remain separate gates.
