# The Stellar Holds: The First Fortune

Private Windows test builds and delivery records.

## Download and play

Open **Releases** on this repository and download the attached `Stellar-Holds-First-Fortune-0.60.0-Windows.zip`.

1. Extract the entire ZIP into a new folder.
2. Run `FirstFortune.exe` from that folder.
3. Keep `FirstFortune.pck` next to the executable.

You must be signed into the GitHub account that owns this private repository to download the build. The release attachment is the playable build; GitHub's automatically generated "Source code" archives are not.

## Version 0.60.0 — Faces of the Hold

This build aligns the portraits and royal audience with the integrated complete-character artwork. It includes the existing 0.59.0 motion work. It does not change the save format or mining balance.

The Windows ZIP is the original verified archive, rehosted without modification:

- Size: 698,756,907 bytes
- SHA-256: `0b531ef5957fee4af2af8ed384f551b0aae5a64b524fea62fda482748e15f523`
- Eight archive members; all ZIP integrity checks passed.
- Exported source commit: `37d999bde9af684d3c90218f415fa4057e3357b8`
- Verified recovery checkpoint: `a4eabf6cd4541741315e17dc2288ec5bee19d060`
- Documentation checkpoint: `19e2795c1e4170ac118485c58e0f6be9e4163820`

The recorded development verification comprises 433 checks, including checks against the exported game pack. Gameplay and visual verification used Linux Godot 4.4.1 with software rendering and dummy audio. Native Windows execution, audio, and player-device performance still need playtesting. No current antivirus scan verdict is claimed.

## Recovery and development

This repository begins as a private build-delivery repository. Its Git history does **not** contain the earlier game source history. The original source checkpoints and recovery bundle chain remain preserved separately in the project development files.

The release tag identifies this delivery record, not a replacement for the original source checkpoint. Keep previous backups until a complete source migration has been independently restored and verified.

For future builds, publish a new versioned release with its Windows ZIP, checksum, changes, and test notes. Do not overwrite older release attachments.
