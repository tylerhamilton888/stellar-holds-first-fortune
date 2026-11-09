"""Exercise real child output without returning its contents to the caller."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

SCRIPT = Path(__file__).with_name('capture_command.py')


class CaptureCommandTests(unittest.TestCase):
    def run_capture(self, log, source, *options):
        return subprocess.run([sys.executable, str(SCRIPT), '--log', str(log),
                               *options, '--', sys.executable, '-c', source],
                              capture_output=True)

    def test_large_binary_and_error_output_preserved_without_echo(self):
        with tempfile.TemporaryDirectory() as tmp:
            log = Path(tmp) / 'large.log'
            result = self.run_capture(log,
                "import os,sys; os.write(1,b'\\x00\\xff'*2000000); "
                "os.write(2,b'SCRIPT ERROR: repeated\\n'*100000); sys.exit(7)")
            self.assertEqual(result.returncode, 7)
            self.assertLess(len(result.stdout) + len(result.stderr), 256)
            expected = b'\x00\xff' * 2000000 + b'SCRIPT ERROR: repeated\n' * 100000
            self.assertEqual(log.read_bytes(), expected)
            self.assertEqual(json.loads(result.stdout)['bytes'], len(expected))

    def test_existing_evidence_is_never_overwritten(self):
        with tempfile.TemporaryDirectory() as tmp:
            log = Path(tmp) / 'existing.log'
            log.write_bytes(b'original')
            result = self.run_capture(log, "print('replacement')")
            self.assertEqual(result.returncode, 125)
            self.assertEqual(log.read_bytes(), b'original')
            self.assertTrue(json.loads(result.stdout)['capture_failed'])

    def test_timeout_keeps_partial_evidence_and_fails(self):
        with tempfile.TemporaryDirectory() as tmp:
            log = Path(tmp) / 'timeout.log'
            result = self.run_capture(log, "import time; print('started',flush=True); time.sleep(30)",
                                      '--timeout', '0.5')
            self.assertEqual(result.returncode, 124)
            self.assertTrue(json.loads(result.stdout)['timed_out'])
            self.assertEqual(log.read_bytes(), b'started\n')

    def test_success_and_missing_executable_have_distinct_status(self):
        with tempfile.TemporaryDirectory() as tmp:
            log = Path(tmp) / 'success.log'
            result = self.run_capture(log, "print('ok')")
            self.assertEqual(result.returncode, 0)
            self.assertEqual(log.read_bytes(), b'ok\n')
            result = subprocess.run([sys.executable, str(SCRIPT), '--log',
                str(Path(tmp) / 'missing.log'), '--', str(Path(tmp) / 'absent')],
                capture_output=True)
            self.assertEqual(result.returncode, 127)
            self.assertTrue(json.loads(result.stdout)['launch_failed'])


if __name__ == '__main__':
    unittest.main()
