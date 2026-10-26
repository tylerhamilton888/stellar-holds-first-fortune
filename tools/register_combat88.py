"""Measure complete combat drawings and independent props; never repaint PNGs."""
from pathlib import Path
import json
import numpy as np
from PIL import Image
from scipy import ndimage

ROOT = Path(__file__).resolve().parents[1]
ART = ROOT / 'assets/combat88'
frames = {}
palette = {}
report = {}

def objects(path, count, columns):
    rgba = np.asarray(Image.open(path).convert('RGBA'))
    labels, _ = ndimage.label(rgba[:, :, 3] > 128)
    found = []
    for label, sl in enumerate(ndimage.find_objects(labels), 1):
        if sl is None or np.count_nonzero(labels[sl] == label) < 1000:
            continue
        y, x = sl
        found.append((x.start, y.start, x.stop, y.stop, label))
    assert len(found) == count, (path.name, len(found), count)
    found.sort(key=lambda b: (b[1] + b[3]) / 2)
    found = [b for row in range(count // columns)
             for b in sorted(found[row * columns:(row + 1) * columns])]
    return rgba, labels, found

def pigment(a, owned):
    c = a[:, :, :3].astype(float) / 255
    r, g, b = c.transpose(2, 0, 1)
    mask = (r-g > .04) & (b-g > .04) & owned
    if mask.sum() < 20:
        return None
    high = c.max(2); low = c.min(2)
    return [float(np.median(high[mask])), float(np.median(((high-low)/np.maximum(high,.001))[mask]))]

for path in sorted(ART.glob('*-shield.png')):
    identity = path.stem.removesuffix('-shield')
    rgba, labels, found = objects(path, 40, 8)
    standard = float(np.median([b[3]-b[1] for row in range(4) for b in found[row*8:row*8+4]]))
    registered = []; measurements = []
    for index, (x0,y0,x1,y1,label) in enumerate(found):
        x=max(0,x0-2);y=max(0,y0-2);xx=min(rgba.shape[1],x1+2);yy=min(rgba.shape[0],y1+2)
        owned=labels[y:yy,x:xx]==label
        foreign=(rgba[y:yy,x:xx,3]>0)&~ndimage.binary_dilation(owned,iterations=2)
        omit=[]
        for sy, row in enumerate(foreign):
            changes=np.diff(np.r_[False,row,False].astype(int))
            for start,end in zip(np.where(changes==1)[0],np.where(changes==-1)[0]):
                omit.append([int(start),sy,int(end-start)])
        # Feet anchor the pose. Fixed cell centres avoid a weapon/shield changing
        # the actor's horizontal root as the silhouette extends during a swing.
        root_x=(index%8+.5)*rgba.shape[1]/8
        frame={'rect':[x,y,xx-x,yy-y], 'root':[root_x,y1-1], 'height':round(standard,3),
               'crown':y0,'omit':omit,'right_tip':[x1-1,(y0+y1)/2],
               'source':'res://assets/combat88/'+path.name,
               'equipment':'axe_shield','identity':identity}
        registered.append(frame)
        measurements.append(pigment(rgba[y:yy,x:xx],owned))
    ref=measurements[0]
    frames[identity+'-shield88']=registered
    palette[identity+'-shield88']=[[round(float(np.clip(m[0]/ref[0],.75,1.3)),5),
                                    round(float(np.clip(m[1]/ref[1],.75,1.3)),5)] if m and ref else [1,1]
                                   for m in measurements]
    report[identity]={'complete_drawings':40,'body_height':standard,'source_unchanged':True}

rgba, labels, found = objects(ART/'decorations.png',6,3)
decor={}
for kind,b in zip(['runestone','signpost','road_lantern','barrel','crate','plinth'],found):
    x,y,xx,yy,_=b
    decor[kind]=[int(x),int(y),int(xx-x),int(yy-y)]
(ART/'frames.json').write_text(json.dumps(frames,separators=(',',':'))+'\n')
(ART/'palette.json').write_text(json.dumps(palette,separators=(',',':'))+'\n')
(ART/'decor.json').write_text(json.dumps(decor,indent=2)+'\n')
(ART/'registration.json').write_text(json.dumps(report,indent=2)+'\n')
print('Registered',len(frames),'identities,',sum(map(len,frames.values())),'whole combat frames and',len(decor),'independent props')

# Eight historical hammer crops stopped at a column boundary, cutting away
# part of the connected hammer head. Measure the complete original figure;
# retain its established body scale, foot root, palette and source painting.
canonical=json.loads((ROOT/'assets/whole-v58/frames.json').read_text())
canonical.update(json.loads((ROOT/'assets/appearance74/frames.json').read_text()))
corrections={}
for identity in ['male2','male3','female3','female6']:
    sheet=identity+'-core'
    for index in [28,30]:
        frame=dict(canonical[sheet][index])
        source=frame.get('source',sheet)
        path=ROOT/source.removeprefix('res://') if source.startswith('res://') else ROOT/'assets/whole-v58'/(source+'.png')
        rgba=np.asarray(Image.open(path).convert('RGBA'))
        labels,_=ndimage.label(rgba[:,:,3]>128)
        x,y,w,h=frame['rect'];counts=np.bincount(labels[y:y+h,x:x+w].ravel());counts[0]=0
        label=int(counts.argmax());sy,sx=ndimage.find_objects(labels)[label-1]
        x=max(0,sx.start-2);y=max(0,sy.start-2);xx=min(rgba.shape[1],sx.stop+2);yy=min(rgba.shape[0],sy.stop+2)
        owned=labels[y:yy,x:xx]==label
        foreign=(rgba[y:yy,x:xx,3]>0)&~ndimage.binary_dilation(owned,iterations=2)
        omit=[]
        for row_index,row in enumerate(foreign):
            changes=np.diff(np.r_[False,row,False].astype(int))
            for start,end in zip(np.where(changes==1)[0],np.where(changes==-1)[0]):omit.append([int(start),row_index,int(end-start)])
        tip_y,_=np.nonzero(owned & (np.indices(owned.shape)[1]>=sx.stop-x-3))
        frame.update(rect=[x,y,xx-x,yy-y],omit=omit,source='res://'+str(path.relative_to(ROOT)),right_tip=[sx.stop-1,round(y+float(np.median(tip_y)),2)])
        corrections[sheet+':'+str(index)]=frame
(ART/'corrections.json').write_text(json.dumps(corrections,separators=(',',':'))+'\n')
print('Restored',len(corrections),'complete original hammer silhouettes')
