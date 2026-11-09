"""Legacy entry point: report evidence paths, never image bytes."""
from pathlib import Path
from evidence_manifest import write_manifest

root = Path('test-results/ci/people')
write_manifest(sorted(root.glob('*.png')), root / 'evidence.json')
