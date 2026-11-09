"""Keep visual evidence in files and command output independent of image size."""
import json
from pathlib import Path


def write_manifest(paths, destination):
    destination = Path(destination)
    destination.parent.mkdir(parents=True, exist_ok=True)
    (destination.parent / '.gdignore').touch()
    entries = [{'path': str(path), 'bytes': path.stat().st_size}
               for path in paths if path.is_file()]
    destination.write_text(json.dumps({'files': entries}, indent=2) + '\n')
    print(f'Visual evidence: {len(entries)} files; manifest: {destination}')
    return entries
