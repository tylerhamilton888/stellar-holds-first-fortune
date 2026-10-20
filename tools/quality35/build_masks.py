from pathlib import Path
from PIL import Image,ImageFilter
import numpy as np
src=Path('stellar-holds/assets/palette-v33');out=Path('stellar-holds/assets/palette-v35');raw=Path('tools/palette33/raw')
counts={}
for p in src.glob('*.mask'):
 a=np.array(Image.open(raw/(p.stem+'.png')).convert('RGBA'));m=np.frombuffer(p.read_bytes(),np.uint8).reshape(a.shape[:2]).copy()
 hsv=np.asarray(Image.fromarray(a[:,:,:3]).convert('HSV'),dtype=float)/255
 h,s,v=hsv[:,:,0],hsv[:,:,1],hsv[:,:,2]
 # Recover gold and pale gold edge pixels immediately adjoining authored hair.
 # Saturated orange skin, blue clothing and classified metal fittings are excluded.
 added=np.zeros(m.shape,bool)
 for _ in range(3):
  near=np.array(Image.fromarray(((m==1)*255).astype('uint8')).filter(ImageFilter.MaxFilter(3)))>0
  gold=(h>.095)&(h<.185)&(s>.12)
  pale=(h>.085)&(h<.19)&(s<=.25)&(v>.65)
  take=near&(gold|pale)&(m!=1)&(m!=4)&(m!=5)&(a[:,:,3]>114)
  m[take]=1;added|=take
 (out/p.name).write_bytes(m.tobytes());counts[p.stem]=int(added.sum())
print('Expanded edge coverage in',sum(v>0 for v in counts.values()),'of',len(counts),'masks;',sum(counts.values()),'pixels')
# Diagnostic exact source overlays: green existing hair, red newly included fringe.
canvas=Image.new('RGB',(192*5,212*2),'#172833')
for idx,id in enumerate([f'{g}{i}' for g in ['male','female'] for i in range(5)]):
 a=np.array(Image.open(raw/(id+'-portrait.png')).convert('RGBA'));old=np.frombuffer((src/(id+'-portrait.mask')).read_bytes(),np.uint8).reshape(192,192);new=np.frombuffer((out/(id+'-portrait.mask')).read_bytes(),np.uint8).reshape(192,192)
 a[old==1,:3]=[65,150,110];a[(new==1)&(old!=1),:3]=[255,40,70]
 canvas.paste(Image.fromarray(a),(idx%5*192,idx//5*212))
canvas.save('tools/quality35/fringe-coverage.png')
# Authored face-boundary corrections where beard roots / shaved sideburns were
# previously mistaken for warm complexion. Lips and ear interiors stay protected.
import json
meta=json.loads((raw/'metadata.json').read_text())
for path in out.glob('*.mask'):
 a=np.array(Image.open(raw/(path.stem+'.png')).convert('RGBA'));m=np.frombuffer(path.read_bytes(),np.uint8).reshape(a.shape[:2]).copy();hsv=np.asarray(Image.fromarray(a[:,:,:3]).convert('HSV'),dtype=float)/255;h,s,v=hsv[:,:,0],hsv[:,:,1],hsv[:,:,2];yy,xx=np.indices(m.shape)
 if path.stem=='male3-portrait':
  patch=(xx>=73)&(xx<=83)&(yy>=37)&(yy<=72)&(h>.065)&(h<.18)&(s>.28)
  m[patch]=1
 elif path.stem.startswith('male') and 'portrait' not in path.stem:
  ex,ey=meta[path.stem]['eye'];pose=path.stem.split('-',1)[1];sculpt=int(path.stem[4])
  if pose in ['combat2','combat6'] and sculpt!=1:ex+=10;ey-=1
  patch=(xx-ex>=-6)&(xx-ex<=13)&(yy-ey>=7)&(yy-ey<=13)&(h>.068)&(h<.19)&(s>.28)&(a[:,:,3]>114)
  # Exclude exposed forearm crossing beard using the same pose-local wrist corridor.
  ax,ay=meta[path.stem]['elbow'];bx,by=meta[path.stem]['wrist'];vx,vy=bx-ax,by-ay;t=np.clip(((xx-ax)*vx+(yy-ay)*vy)/max(.01,vx*vx+vy*vy),0,1)
  arm=((xx-ax-t*vx)**2+(yy-ay-t*vy)**2)<28
  m[patch&~arm]=1
 path.write_bytes(m.tobytes())
