# Character coloration

The creator exposes one pigment choice. Normalization links the legacy beard_color field to hair_color for both genders; first/family names, equipment and world state are preserved.

Each portrait and exact cropped animation pose has a flat byte material map in assets/palette-v33. Labels: 0 unchanged, 1 hair/brows/mustache/beard, 3 skin, 4 cloth, 5 fittings. Missing or incorrectly sized maps fail closed without guessed recoloring. The original paintings remain unchanged.

The offline authoring script combines silhouette polygons, protected skin regions, source pigment selection and reviewed pose corrections. These are segmentation masks, not newly painted replacement artwork. Runtime rendering loads the baked labels only. New artwork or crop changes require regenerating and visually reviewing its masks.

To regenerate from the project directory: run Godot headless with --script res://tools/palette33/export.gd, then run python tools/palette33/build_masks.py (Pillow and NumPy). Raw exports and review PNGs are working files, not shipped game resources. Review dark and white palettes, braid ends, hairlines, bare neck, palms and equipment in every normal, combat, guard and armed walk pose. Keep gold fittings distinct from hair. Run tests/test_palette33.gd and tests/test_sculpt_contract17.gd after edits.

Palette33 checks 330 assets at contrasting colors for dimensions, color response and invariance outside the hair masks. It also renders all eight colors for each portrait, standing/mining pose and two attack poses. Visual review remains necessary: invariance alone cannot prove that a mask boundary is anatomically correct. The test does not certify unrelated world art or every possible outfit/marking combination.
