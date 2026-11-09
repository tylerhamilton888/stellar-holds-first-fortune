#!/usr/bin/env python3
"""Read at most 12 short diagnostic lines without dumping a log or encoded line."""
import argparse
from pathlib import Path
from output_safety import emit, excerpt


def inspect(path, contains=None):
    shown = 0
    scanned = 0
    with Path(path).open('rb') as stream:
        while scanned < 8 * 1024 * 1024 and shown < 12:
            raw = stream.readline(4096)
            if not raw:
                break
            scanned += len(raw)
            truncated = not raw.endswith(b'\n') and len(raw) == 4096
            line = raw.decode('utf-8', errors='replace')
            if contains is None or contains in line:
                emit(excerpt(line.rstrip(), 400), '[long line shortened]' if truncated else '')
                shown += 1
            # Discard the rest of an oversized line in bounded chunks.
            while truncated and scanned < 8 * 1024 * 1024:
                raw = stream.readline(4096)
                scanned += len(raw)
                truncated = bool(raw) and not raw.endswith(b'\n')
    emit('Diagnostic excerpt complete; lines:', shown, 'bytes scanned:', scanned)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('log', type=Path)
    parser.add_argument('--contains')
    args = parser.parse_args()
    inspect(args.log, args.contains)
