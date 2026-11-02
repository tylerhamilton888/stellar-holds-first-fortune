#!/usr/bin/env python3
"""Extract whole generated frames; never assemble or repaint body parts.

Usage: import_story_world105.py SOURCE ID [core|work]
Pillow reads alpha bounds only. ImageMagick exports the untouched atlas losslessly.
Generated sheets require visual review before adding an ID to the runtime cast.
"""
import argparse
import json
import os
import subprocess
import tempfile
from pathlib import Path
from PIL import Image
import numpy as np
from scipy.ndimage import binary_dilation, label

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('identity')
    parser.add_argument('kind', choices=['core', 'work'], default='core', nargs='?')
    parser.add_argument('--columns', type=int, default=4)
    parser.add_argument('--rows', type=int, default=5)
    parser.add_argument('--row-edges', help='Measured row boundaries, including 0 and image height, comma-separated')
    args = parser.parse_args()
    if not args.identity.isalpha():
        parser.error('Identity must contain letters only')
    if args.columns < 1 or args.rows < 1:
        parser.error('Grid dimensions must be positive')
    image = Image.open(args.source)
    if image.mode != 'RGBA':
        parser.error('Expected transparent RGBA source')
    width, height = image.size
    row_edges = [round(i*height/args.rows) for i in range(args.rows+1)]
    if args.row_edges:
        try:
            row_edges = [int(value) for value in args.row_edges.split(',')]
        except ValueError:
            parser.error('Row edges must be comma-separated integers')
        if (len(row_edges) != args.rows+1 or row_edges[0] != 0 or row_edges[-1] != height
                or any(a >= b for a, b in zip(row_edges, row_edges[1:]))):
            parser.error('Row edges must increase from 0 to image height, with rows+1 entries')
    alpha = image.getchannel('A')
    if alpha.getextrema()[0] != 0:
        parser.error('Source has no transparent surroundings')
    frames = []
    for row in range(args.rows):
        for col in range(args.columns):
            left, right = round(col*width/args.columns), round((col+1)*width/args.columns)
            top, bottom = row_edges[row:row+2]
            pixels = np.asarray(alpha.crop((left, top, right, bottom)))
            components, count = label(pixels > 24, structure=np.ones((3, 3)))
            if not count:
                parser.error(f'Empty frame {row}:{col}')
            sizes = np.bincount(components.ravel()); sizes[0] = 0
            body = components == sizes.argmax()
            ys, xs = np.nonzero(body)
            x, y, r, b = int(xs.min()), int(ys.min()), int(xs.max()+1), int(ys.max()+1)
            # Preserve the original antialias fringe around the whole figure.
            # Omit disconnected neighboring figures, just as whole_frames does.
            keep = binary_dilation(body, iterations=2)
            x += left; r += left; y += top; b += top
            x0, y0 = max(left, x-2), max(top, y-2)
            x1, y1 = min(right, r+2), min(bottom, b+2)
            omit = []
            for py in range(y0, y1):
                bad = (~keep[py-top, x0-left:x1-left]) & (pixels[py-top, x0-left:x1-left] > 0)
                starts = np.flatnonzero(np.diff(np.r_[False, bad, False].astype(int)) == 1)
                ends = np.flatnonzero(np.diff(np.r_[False, bad, False].astype(int)) == -1)
                omit.extend([[int(a), py-y0, int(z-a)] for a, z in zip(starts, ends)])
            frames.append({'rect': [x0, y0, x1-x0, y1-y0], 'omit': omit,
                           'root': [(x+r)/2, b-1], 'height': b-y,
                           'right_tip': [r-1, b-1]})
    output = ROOT/'assets/story105/world'
    output.mkdir(exist_ok=True)
    name = args.identity + ('-work' if args.kind == 'work' else '')
    # Godot scans visible *.webp files while production is running. Never expose
    # an incomplete conversion (or overwrite metadata before conversion passes).
    with tempfile.TemporaryDirectory(prefix='.story-import-', dir=output) as scratch:
        temporary = Path(scratch)/f'{name}.webp'
        subprocess.run(['convert', str(args.source), '-define', 'webp:lossless=true',
                        str(temporary)], check=True)
        with Image.open(temporary) as exported:
            exported.verify()
        metadata = Path(scratch)/f'{name}.json'
        metadata.write_text(json.dumps(frames, separators=(',', ':'))+'\n')
        os.replace(temporary, output/f'{name}.webp')
        os.replace(metadata, output/f'{name}.json')
    print(f'{name}: {len(frames)} whole frames; activation requires review')


if __name__ == '__main__':
    main()
