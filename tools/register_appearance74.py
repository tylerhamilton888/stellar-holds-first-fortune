"""Register complete new walk paintings without changing their pixels."""
from pathlib import Path
import json
import numpy as np
from PIL import Image
from scipy import ndimage
root=Path(__file__).resolve().parents[1]
path=root/'assets/appearance74/crown-ponytail-walk.png'
a=np.asarray(Image.open(path).convert('RGBA'));labels,n=ndimage.label(a[:,:,3]>128)
objects=[]
for i,sl in enumerate(ndimage.find_objects(labels),1):
 if sl is None:continue
 if np.count_nonzero(labels[sl]==i)>5000:
  y,x=sl;objects.append((x.start,y.start,x.stop,y.stop,i))
assert len(objects)==8,len(objects)
objects.sort(key=lambda b:(b[1]+b[3])/2)
objects=[b for row in range(2) for b in sorted(objects[row*4:row*4+4])]
core=json.loads((root/'assets/whole-v58/frames.json').read_text());result={}
for row,identity in enumerate(['male6','female6']):
 frames=[{} for _ in range(12)]
 first=objects[row*4];reference=core[identity+'-core'][8]
 scale=(first[3]-first[1])*reference['height']/reference['rect'][3]
 for key,(x,y,xx,yy,label) in enumerate(objects[row*4:row*4+4]):
  owned=labels[y:yy,x:xx]==label
  # Root is the torso center, independent of the forward foot or trailing hair.
  region=a[y:yy,x:xx,:3].astype(float)/255
  r,g,b=region.transpose(2,0,1)
  cy,cx=np.nonzero((b>r*1.15)&(g>r*1.05)&owned)
  rx=x+float(np.median(cx))
  frames[8+key]={'rect':[x,y,xx-x,yy-y],'root':[round(rx,2),yy-1],'height':round(scale,3),'crown':y,'omit':[],'source':'res://assets/appearance74/crown-ponytail-walk.png'}
 result[identity+'-town']=frames
(root/'assets/appearance74/frames.json').write_text(json.dumps(result,separators=(',',':'))+'\n')
# The irregularly spaced greatbeard utility sheet was cut on an equal grid.
# Register its complete connected paintings; two adjacent saws touch and are
# separated at their original column boundary. Source pixels remain untouched.
path=root/'assets/whole-v58/male2-utility.png';a=np.asarray(Image.open(path).convert('RGBA'))
labels,n=ndimage.label(a[:,:,3]>128);objects=[]
for label,sl in enumerate(ndimage.find_objects(labels),1):
 if sl is None or np.count_nonzero(labels[sl]==label)<=3000:continue
 y,x=sl
 if x.stop-x.start>350:
  for left,right in [(x.start,444),(444,x.stop)]:
   yy,xx=np.nonzero(labels[y.start:y.stop,left:right]==label)
   objects.append((left+xx.min(),y.start+yy.min(),left+xx.max()+1,y.start+yy.max()+1,label,left,right))
 else:objects.append((x.start,y.start,x.stop,y.stop,label,x.start,x.stop))
assert len(objects)==32
objects.sort(key=lambda b:(b[1]+b[3])/2)
objects=[b for row in range(8) for b in sorted(objects[row*4:row*4+4])]
frames=[]
for i,(x0,y0,x1,y1,label,left,right) in enumerate(objects):
 x=max(0,int(x0)-2);y=max(0,int(y0)-2);xx=min(a.shape[1],int(x1)+2);yy=min(a.shape[0],int(y1)+2)
 owned=labels[y:yy,x:xx]==label
 owned[:,:max(0,left-x)]=False;owned[:,max(0,right-x):]=False
 foreign=(a[y:yy,x:xx,3]>0)&~ndimage.binary_dilation(owned,iterations=2)
 omit=[]
 for sy,row in enumerate(foreign):
  runs=np.diff(np.r_[False,row,False].astype(int))
  for start,end in zip(np.where(runs==1)[0],np.where(runs==-1)[0]):omit.append([int(start),sy,int(end-start)])
 base=dict(core['male2-utility'][i]);base.update(rect=[x,y,xx-x,yy-y],root=[base['root'][0],int(y1)-1],height=int(objects[8][3]-objects[8][1]),crown=int(y0),omit=omit,source='res://assets/whole-v58/male2-utility.png')
 ty,tx=np.nonzero(owned & (np.indices(owned.shape)[1]>=int(x1)-x-3));base['right_tip']=[int(x1)-1,round(y+float(np.median(ty)),2)]
 frames.append(base)
result['male2-utility']=frames
(root/'assets/appearance74/frames.json').write_text(json.dumps(result,separators=(',',':'))+'\n')
