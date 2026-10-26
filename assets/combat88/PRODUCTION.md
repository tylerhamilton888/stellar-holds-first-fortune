# Combat and separated props — 0.78.0

Created with the built-in ImageGen tool, using the approved whole-character atlases as identity references. Original project art remains untouched. Exact prompts, including rejected attempts and corrections, are in prompts.json.

The shipped assets are male0-shield.png through male6-shield.png, female0-shield.png through female6-shield.png, and decorations.png. Each character sheet contains 40 complete drawings in an 8 × 5 layout. Four directional rows contain four walking drawings and four attack drawings; the last row contains guard and impact poses. Head, torso, arms, fingers, axe and shield belong to the same painting. The purple source pigment uses the existing saved hair palette. Female clothing retains the cream sleeves; all male chins and jaws remain bearded.

Runtime selection intentionally excludes the misdirected northeast windups and shield-on-back drafts. Rear windups use the complete north-facing raised drawing; crown-braid and loose-wave variants use column six. Male topknot/cropped-nape rear-quarter guard uses the valid rear brace. Rear guard and recoil sometimes share the same braced drawing. No pieces of anatomy or equipment are composited onto another frame. Horizontal mirroring retains the established apparent-handedness limitation.

The first female side-braid attempt inherited a work hammer and was rejected. The final sheet derives from the twin-braid combat sheet with one back braid. Several sheets needed ImageGen alpha cleanup before they passed the 40-isolated-figure registration check. The grand-moustache variant was corrected against its canonical shoulder-length mane; cropped-nape drafts are not used. Decor was refined to remove harsh small-scale grain.

tools/register_combat88.py only measures connected alpha components, frame bounds, foot roots and pigment calibration. It does not repaint or rewrite the PNGs. Every frame of an identity uses one body scale, so a raised weapon does not shrink the dwarf. The native extractor omits disconnected neighboring fragments. Native prop textures are resampled before drawing at gameplay scale.

The six decor silhouettes are independent rune-stone, timber sign, lantern post, barrel, crate and stone plinth. HoldFurnishings owns their sizes, costs, footprints and post-root anchors. HoldLooseProps owns the shared artwork, used by world dressing, previews and player placement. Decorative barrel/crate pieces are explicitly labelled; actual storage remains the existing chest.

Eight original hammer ready/contact crops (male2, male3, female3 and female6) ended inside their connected hammer heads. corrections.json extends those crops to the complete original alpha component and removes only disconnected neighbours. The existing body scale, foot root and pigment calibration stay unchanged.

Native acceptance: tests/combat88.gd renders all 14 identities beside their existing town, hammer and carbine frames, checks live guard/recoil/attack selection, and exercises independent placement, payment, collision, save/reload, movement and recovery. It also renders the Roadside catalogue and Wayfarer's Hearth. Source and exact-export suites include the case. Windows hardware performance and subjective combat feel require hands-on playtesting.
