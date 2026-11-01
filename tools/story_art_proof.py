#!/usr/bin/env python3
"""Mechanical atlas extraction/display proof; no painting or limb composition.

Usage: python tools/story_art_proof.py GENERATED_IMAGE_DIRECTORY OUTPUT.png
Requires ImageMagick convert. Source artwork is generated with imagegen.
"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sources, output = Path(sys.argv[1]), Path(sys.argv[2])
data = json.loads((ROOT / 'docs/art/story-translation/crops.json').read_text())
portrait = sources / 'exec-1142fb88-79df-4eea-b3fd-c0aa81a0f570.png'
with tempfile.TemporaryDirectory() as temp:
    args = ['convert', '-size', '960x660', 'xc:#183138', '-font', 'DejaVu-Sans',
            '-fill', '#ecd5aa', '-pointsize', '24', '-annotate', '+26+36',
            'STELLAR HOLDS — production scale proof', '-pointsize', '13',
            '-annotate', '+26+62', 'Portraits 86px square • whole figures 62px high • enlarged idle at right',
            '-annotate', '+26+640', 'Design proof only. Walk studies are not accepted animation cycles.']
    for row, name in enumerate(['Dagna', 'Ivar', 'Skarrin']):
        top = 90 + row * 178
        args += ['-fill', '#ecd5aa', '-pointsize', '17', '-annotate', f'+26+{top+19}', name]
        p = Path(temp) / f'p{row}.png'
        subprocess.run(['convert', str(portrait), '-crop', f'724x724+{row*724}+0', '+repage',
                        '-resize', '86x86!', str(p)], check=True)
        args += [str(p), '-geometry', f'+26+{top+30}', '-composite']
        for family in ['idle', 'walk']:
            for col in range(4):
                x, y, w, h = data[family]['frames'][row*4+col]
                p = Path(temp) / f'{family}{row}{col}.png'
                subprocess.run(['convert', str(sources/data[family]['file']), '-crop',
                                f'{w}x{h}+{x}+{y}', '+repage', '-resize', 'x62', str(p)], check=True)
                xpos = 176 + col*115
                ypos = top+12 if family == 'idle' else top+91
                args += [str(p), '-geometry', f'+{xpos}+{ypos}', '-composite']
                if family == 'idle' and col == 0:
                    big = Path(temp) / f'big{row}.png'
                    subprocess.run(['convert', str(p), '-filter', 'point', '-resize', '200%', str(big)], check=True)
                    args += [str(big), '-geometry', f'+735+{top+16}', '-composite']
        args += ['-fill', '#9bb5b8', '-pointsize', '11', '-annotate', f'+121+{top+49}', 'Idle',
                 '-annotate', f'+121+{top+129}', 'Walk']
    subprocess.run(args + [str(output)], check=True)
