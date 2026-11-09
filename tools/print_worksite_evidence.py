"""Legacy entry point: keep screenshots in files even if artifact storage is full."""
from pathlib import Path
from evidence_manifest import write_manifest

root = Path('test-results/ci/firstshift')
names = ('00-offer', '00-briefing', '01-lift', '04-worksite-journal')
write_manifest([root / (name + '.png') for name in names], root / 'evidence.json')
