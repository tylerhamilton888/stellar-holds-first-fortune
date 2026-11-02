"""Lossless whole-frame extraction and measured boot/body anchors for batch 123.

No drawing, body-part composition or source-pixel correction. Sources are the
built-in imagegen outputs in action-sources.json; runtime WebPs are durable.
"""
import json
import subprocess
import sys
from pathlib import Path
import numpy as np
from PIL import Image
from scipy.ndimage import label

ROOT = Path(__file__).resolve().parents[3]
WORLD = ROOT / 'assets/story105/world'
SOURCE = json.loads((Path(__file__).parent/'action-sources.json').read_text())

for name, source in SOURCE.items():
    image = Image.open(source).convert('RGBA')
    width, height = image.size
    pixels = np.asarray(image)[:, :, 3]
    row_count = 3 if name.endswith('pick') else 2 if name.endswith('actions') else 1
    components, count = label(pixels > 24, structure=np.ones((3, 3)))
    sizes = np.bincount(components.ravel()); sizes[0] = 0
    bodies = []
    for index in np.argsort(sizes)[-4*row_count:]:
        ys, xs = np.nonzero(components == index)
        bodies.append([int(xs.min()), int(ys.min()), int(xs.max()+1), int(ys.max()+1)])
    bodies.sort(key=lambda b: (int(((b[1]+b[3])/2)/(height/row_count)), b[0]))
    edges = [0] + [int((max(bodies[r*4+c][2] for r in range(row_count))
                        + min(bodies[r*4+c+1][0] for r in range(row_count)))/2)
                   for c in range(3)] + [width]
    subprocess.run([sys.executable, str(ROOT/'tools/import_story_world105.py'),
                    source, name, '--rows', str(row_count), '--column-edges',
                    ','.join(map(str, edges)), '--frame-bounds', json.dumps([
                        [max(0,b[0]-3),max(0,b[1]-3),min(width,b[2]+3),min(height,b[3]+3)]
                        for b in bodies])], cwd=ROOT, check=True)
    file = WORLD/(name+'.json')
    frames = json.loads(file.read_text())
    for i, frame in enumerate(frames):
        x,y,w,h = frame['rect']
        mask = pixels[y:y+h,x:x+w] > 24
        # Broad boot soles determine the floor; a narrow low pick point does not.
        counts = mask.sum(axis=1)
        boot_y = int(np.flatnonzero(counts > counts.max()*.30)[-1])
        soles = np.nonzero(mask[max(0,boot_y-5):boot_y+1])[1]
        frame['root'] = [x+float((soles.min()+soles.max())/2), y+boot_y]
        frame['source'] = 'res://assets/story105/world/'+name+'.webp'
        # The tool must not shrink the body when raised above the crown. Use
        # the resting body calibration throughout each four-key working row.
        if not name.endswith('actions') or i >= 4:
            first = frames[(i//4)*4]
            frame['height'] = first['root'][1]-first['rect'][1]
        frame['right_tip'] = [x+w-4, y+h-4]
    file.write_text(json.dumps(frames,separators=(',',':'))+'\n')
    print(name, 'anchors:', [(f['root'], f['height']) for f in frames])

for identity, names in {'dagr':['dagractions','dagrpick'], 'odrin':['odrinhammer'],
                         'osvik':['osvikactions','osvikpick'], 'tovan':['tovanactions','tovanpick'],
                         'kelvar':['kelvaractions','kelvarpick'], 'yrsa':['yrsahammer','yrsapick']}.items():
    if not all(name in SOURCE for name in names):
        continue
    file = WORLD/(identity+'.json')
    frames = json.loads(file.read_text())[:24 if identity=='yrsa' else 20]
    for name in names:
        frames += json.loads((WORLD/(name+'.json')).read_text())
    file.write_text(json.dumps(frames,separators=(',',':'))+'\n')
