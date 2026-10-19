"""Register full-character paintings; source PNGs remain unchanged."""
from pathlib import Path
from PIL import Image
from scipy import ndimage
import numpy as np
import json

OUT=Path(__file__).resolve().parents[1]/'assets/whole-v58'
result={};report=[]
for path in sorted(OUT.glob('*.png')):
 kind=path.stem.split('-')[-1]
 if kind not in ('core','utility','handling','equipped','corrected','handfix','backwalk','axes','repair'):continue
 layout='core' if kind=='corrected' else 'handling' if kind=='handfix' else kind
 cols=8 if layout in ('handling','equipped') else 4
 rows=6 if layout=='equipped' else 7 if layout in ('backwalk','axes') else 2 if layout=='repair' else 8
 rgba=np.array(Image.open(path).convert('RGBA'));hsv=np.array(Image.fromarray(rgba[:,:,:3]).convert('HSV'))
 mask=rgba[:,:,3]>128;labels,_=ndimage.label(mask);objects=[]
 for label,sl in enumerate(ndimage.find_objects(labels),1):
  if sl is not None and np.count_nonzero(labels[sl]==label)>500:
   y,x=sl;objects.append((x.start,y.start,x.stop,y.stop,label))
 segmented=len(objects)!=cols*rows
 if not segmented:
  objects.sort(key=lambda b:(b[1]+b[3])/2)
  objects=[b for row in range(rows) for b in sorted(objects[row*cols:(row+1)*cols])]
 else:
  objects=[];height,width=mask.shape
  for row in range(rows):
   for col in range(cols):
    x0=round(col*width/cols);x1=round((col+1)*width/cols);cuts=[]
    for boundary in (row,row+1):
     target=round(boundary*height/rows)
     if boundary in (0,rows):cuts.append(target);continue
     radius=round(height/rows*.30)
     choices=np.arange(max(0,target-radius),min(height,target+radius+1))
     density=mask[choices,x0:x1].sum(axis=1)
     cuts.append(int(choices[np.argmin(density+abs(choices-target)*.02)]))
    y0,y1=cuts;local,n=ndimage.label(mask[y0:y1,x0:x1])
    sizes=np.bincount(local.ravel());sizes[0]=0;which=int(np.argmax(sizes))
    y,x=ndimage.find_objects(local)[which-1];new=10000+row*cols+col
    labels[y0:y1,x0:x1][local==which]=new
    objects.append((x0+x.start,y0+y.start,x0+x.stop,y0+y.stop,new))
  report.append({'sheet':path.stem,'segmented':True,'reason':'neighbor contact in source alpha; visually review edges'})
 frames=[]
 for index,(x0,y0,x1,y1,label) in enumerate(objects):
  x=max(0,x0-2);y=max(0,y0-2);xx=min(mask.shape[1],x1+2);yy=min(mask.shape[0],y1+2)
  owned=labels[y:yy,x:xx]==label;region=hsv[y:yy,x:xx]
  blue=(region[:,:,0]>112)&(region[:,:,0]<175)&(region[:,:,1]>40)&owned
  by,bx=np.nonzero(blue);rx=x+float(np.median(bx)) if len(bx) else (x0+x1)/2
  # Exclude another character's islands; retain this figure's antialiased edge.
  foreign=(rgba[y:yy,x:xx,3]>0)&~owned&~ndimage.binary_dilation(owned,iterations=2)
  omit=[]
  for sy in range(yy-y):
   runs=np.diff(np.r_[False,foreign[sy],False].astype(int))
   for a,b in zip(np.where(runs==1)[0],np.where(runs==-1)[0]):omit.append([int(a),sy,int(b-a)])
  frames.append({'rect':[x,y,xx-x,yy-y],'root':[round(rx,2),y1-1],'height':y1-y0,'crown':y0,'omit':omit})
 # Keep one anatomical scale for a sequence: tools raised overhead and crouches
 # must not make the actor inflate or shrink.
 reference=8 if layout=='utility' else 48 if layout=='handling' else 0
 standard=frames[reference]['height']
 for i,frame in enumerate(frames):
  frame['height']=frames[(i//4)*4]['height'] if layout in ('backwalk','axes','repair') else standard
 result[path.stem]=frames
 print(path.stem,len(frames),'segmented' if segmented else 'isolated',flush=True)

if 'female0-corrected' in result:
 for i in list(range(12,16))+list(range(24,28)):
  result['female0-core'][i]=dict(result['female0-corrected'][i],source='female0-corrected')
for gender in ('male','female'):
 if gender+'-backwalk' in result:
  for sculpt in range(7):
   for key in range(4):result[f'{gender}{sculpt}-core'][16+key]=dict(result[gender+'-backwalk'][sculpt*4+key],source=gender+'-backwalk')
if 'female-axes' in result:
 for sculpt in range(7):
  for key in range(4):result[f'female{sculpt}-core'][24+key]=dict(result['female-axes'][sculpt*4+key],source='female-axes')
if 'front-repair' in result:
 for row,identity in enumerate(('male3','female6')):
  for key in range(4):result[identity+'-core'][4+key]=dict(result['front-repair'][row*4+key],source='front-repair')
(OUT/'frames.json').write_text(json.dumps(result,separators=(',',':'))+'\n')
(OUT/'extraction-review.json').write_text(json.dumps(report,indent=2)+'\n')
