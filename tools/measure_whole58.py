"""Read-only alpha measurement for whole-character source atlases.

Writes frame registration metadata; never edits the generated paintings.
The source's head/body/boots stay together. No limb or head extraction.
"""
from pathlib import Path
from PIL import Image
from scipy import ndimage
import numpy as np
import json

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / 'assets/folk-v58'
result = {}
for gender in ('male', 'female'):
    rgba = np.array(Image.open(OUTPUT / (gender + '-core.png')))
    hsv = np.array(Image.fromarray(rgba[:, :, :3]).convert('HSV'))
    labels, _ = ndimage.label(rgba[:, :, 3] > 128)
    boxes = []
    for number, region in enumerate(ndimage.find_objects(labels)):
        if region is None or np.count_nonzero(labels[region] == number + 1) < 1500:
            continue
        y, x = region
        boxes.append((x.start, y.start, x.stop - x.start, y.stop - y.start))
    boxes.sort(key=lambda r: (round(r[1] / 255), r[0]))
    assert len(boxes) == 24, (gender, len(boxes))
    frames = []
    for index, (x, y, width, height) in enumerate(boxes):
        # Shirt centroid, rather than moving feet or the full tool silhouette,
        # keeps locomotion registered around the character's centre of mass.
        region = hsv[y:y+height, x:x+width]
        blue = (region[:, :, 0] > 120) & (region[:, :, 0] < 160)
        blue &= (region[:, :, 1] > 50) & (rgba[y:y+height, x:x+width, 3] > 128)
        yy, xx = np.nonzero(blue)
        center_x = x + float(np.median(xx))
        baseline = y + height - 1
        # Crown-to-sole bounds are suitable for idle/walk. The pick keys keep
        # one scale across anticipation, crouched contact and recovery.
        body_height = height if index < 20 else (232 if gender == 'male' else 229)
        frames.append({
            'rect': [max(0, x-2), max(0, y-2),
                     min(rgba.shape[1], x+width+2)-max(0, x-2),
                     min(rgba.shape[0], y+height+2)-max(0, y-2)],
            'root': [round(center_x, 2), baseline],
            'height': body_height,
        })
    result[gender+'-core'] = frames
(OUTPUT / 'frames.json').write_text(json.dumps(result, indent=2)+'\n')
print('Measured 48 complete figures; source pixels unchanged.')
