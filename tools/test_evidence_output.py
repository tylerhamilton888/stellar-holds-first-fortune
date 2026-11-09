"""Protect chat/log size while preserving original evidence bytes."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

TOOLS = Path(__file__).resolve().parent


class EvidenceOutputTests(unittest.TestCase):
    def test_large_images_stay_in_files(self):
        for script, folder, name in (
            ('print_folk82_evidence.py', 'people', 'large'),
            ('print_worksite_evidence.py', 'firstshift', '00-offer'),
        ):
            with self.subTest(script=script), tempfile.TemporaryDirectory() as tmp:
                root = Path(tmp) / 'test-results/ci' / folder
                root.mkdir(parents=True)
                image = root / (name + '.png')
                # The reporters must not parse or encode image bytes.
                image.write_bytes(b'\x89PNG\r\n\x1a\n' + b'payload' * 500_000)
                before = hashlib.sha256(image.read_bytes()).hexdigest()
                result = subprocess.run([sys.executable, str(TOOLS / script)],
                                        cwd=tmp, capture_output=True, check=True)
                self.assertLess(len(result.stdout) + len(result.stderr), 512)
                manifest = json.loads((root / 'evidence.json').read_text())
                self.assertEqual(manifest['files'], [{
                    'path': str(image.relative_to(tmp)), 'bytes': image.stat().st_size}])
                self.assertEqual(hashlib.sha256(image.read_bytes()).hexdigest(), before)
                self.assertTrue((root / '.gdignore').exists())

    def test_missing_evidence_is_reported_without_binary_fallback(self):
        with tempfile.TemporaryDirectory() as tmp:
            result = subprocess.run([sys.executable, str(TOOLS / 'print_worksite_evidence.py')],
                                    cwd=tmp, capture_output=True, check=True, text=True)
            self.assertIn('0 files', result.stdout)
            manifest = Path(tmp) / 'test-results/ci/firstshift/evidence.json'
            self.assertEqual(json.loads(manifest.read_text()), {'files': []})


if __name__ == '__main__':
    unittest.main()
