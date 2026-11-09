#!/usr/bin/env python3
"""Keep command output in a new log; print metadata only, even on failure."""
import argparse
import json
import math
import os
from pathlib import Path
import signal
import subprocess


def capture(command, log_path, timeout=900):
    log_path = Path(log_path)
    log_path.parent.mkdir(parents=True, exist_ok=True)
    # Never overwrite evidence from a previous attempt.
    with log_path.open('xb') as log:
        (log_path.parent / '.gdignore').touch()
        try:
            proc = subprocess.Popen(command, stdout=log, stderr=subprocess.STDOUT,
                                    start_new_session=(os.name == 'posix'))
        except OSError:
            return {'exit_code': 127, 'timed_out': False, 'bytes': 0,
                    'launch_failed': True}
        timed_out = False
        try:
            code = proc.wait(timeout=timeout)
        except (subprocess.TimeoutExpired, KeyboardInterrupt) as exc:
            if os.name == 'posix':
                try:
                    os.killpg(proc.pid, signal.SIGKILL)
                except ProcessLookupError:
                    pass
            else:
                proc.kill()
            proc.wait()
            timed_out = isinstance(exc, subprocess.TimeoutExpired)
            code = 124 if timed_out else 130
    return {'exit_code': code, 'timed_out': timed_out,
            'bytes': log_path.stat().st_size, 'launch_failed': False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--log', type=Path, required=True)
    parser.add_argument('--timeout', type=float, default=900)
    parser.add_argument('command', nargs=argparse.REMAINDER)
    args = parser.parse_args()
    command = args.command[1:] if args.command[:1] == ['--'] else args.command
    if not command or not math.isfinite(args.timeout) or args.timeout <= 0:
        parser.error('a command and positive timeout are required')
    try:
        result = capture(command, args.log, args.timeout)
    except OSError:
        # Paths and exception messages can themselves contain oversized content.
        print('{"capture_failed":true,"reason":"cannot create new log"}')
        return 125
    print(json.dumps(result, separators=(',', ':')))
    code = result['exit_code']
    return code if code >= 0 else 128 - code


if __name__ == '__main__':
    raise SystemExit(main())
