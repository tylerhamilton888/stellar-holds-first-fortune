# Cottage grounds playtest

Open the homestead panel with O outside the seeded Copper Ridge cottage and choose **Tend cottage grounds**. Cut a selected tuft, fell the rowan, rake work marks, or place and lift stone path tiles. Select **Garden beds and seeds** for normal field work. Grounds jobs use the nearby plot and preserve the lane and doorway. The streambank and bedrock are landmarks.

One completed sawbench job leaves a worn patch and shavings at its world position. A new site starts clean. Work marks fade over ten minutes of world time and can be raked. Building a bed reclaims overlapping marks and tufts. Ground edits and wear timestamps belong to the original claim save. Returning plots suppress a new solid landmark where installed rooms, equipment, beds or furnishings already occupy its footprint.

The standalone Windows preview uses the usual Windows resources and Godot 4.4.1 runtime with two export-only project settings. Set the main scene to res://dev/claim_yard_preview.tscn and enable the custom user directory named Stellar Holds Cottage Grounds Preview. First launch provisions the west bench, two timber racks, hand tools, seeds, water and masonry supplies. Subsequent launches resume the preview save. The regular game still starts at the title screen.

Run tests/claim_yard.gd against a fresh user directory with a writable screenshot directory after the -- separator. It completes two real saw jobs with the same bench, grows carrots in its original position, and verifies terrain edits before and after reloading. The test advances the world clock for a ripe-crop picture. Production uses normal game time.
