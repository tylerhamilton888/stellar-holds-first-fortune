"""Measure reserved source-hair pigment; never repaint or assemble character art."""
import json
from pathlib import Path
import numpy as np
from PIL import Image
ROOT=Path(__file__).resolve().parents[1]
meta={}
for name in ['whole-v58/frames.json','whole-motion59/runtime.json','town-walk66/frames.json','appearance74/frames.json']:
 meta.update(json.loads((ROOT/'assets'/name).read_text()))
# Town contact keys must inherit current corrections, not historical PNG names.
for identity in [f'{g}{s}' for g in ['male','female'] for s in range(7)]:
 if identity in ['male6','female6']:continue
 for i in [8,10]:
  frame=dict(meta[identity+'-core'][i]);frame.setdefault('source',identity+'-core')
  meta[identity+'-town'][i]=frame
sources={}
def measure(sheet, frame):
 source=frame.get('source',sheet)
 path=source[6:] if source.startswith('res://') else 'assets/whole-v58/'+source+'.png'
 if len(sources)>4:sources.clear()
 if path not in sources:sources[path]=np.asarray(Image.open(ROOT/path).convert('RGBA'))
 x,y,w,h=frame['rect'];a=sources[path][y:y+h,x:x+w].astype(np.float32)/255
 for xx,yy,n in frame.get('omit',[]):a[yy,xx:xx+n,3]=0
 r,g,b=a[:,:,:3].transpose(2,0,1);hi=a[:,:,:3].max(2);lo=a[:,:,:3].min(2)
 mask=(r-g>.04)&(b-g>.04)&(a[:,:,3]>.9)
 if mask.sum()<20:return None
 return float(np.median(hi[mask])),float(np.median(((hi-lo)/np.maximum(hi,.001))[mask]))
refs={}
for gender in ['male','female']:
 for sculpt in range(7):
  key=f'{gender}{sculpt}';refs[key]=measure(key+'-core',meta[key+'-core'][1])
result={}
for sheet,frames in meta.items():
 if sheet.split('-')[0] not in refs:continue
 ref=refs[sheet.split('-')[0]];values=[]
 for f in frames:
  m=measure(sheet,f) if f else None
  values.append([round(float(np.clip(m[0]/ref[0],.75,1.3)),5),round(float(np.clip(m[1]/ref[1],.75,1.3)),5)] if m else [1,1])
 result[sheet]=values
(ROOT/'assets/appearance74/palette.json').write_text(json.dumps(result,separators=(',',':'))+'\n')
# Source scale is calibrated against the same identity's contact drawing.
# A bent knee or a bare crown must not make the entire Dwarf grow taller.
town=meta.copy();scales={}
for identity in refs:
 if identity in ['male6','female6']:continue
 contact=meta[identity+'-core'][8]['height']
 for i in [9,11]:
  # The moustache variant's passing painting is intrinsically shorter; use
  # a bounded compromise that preserves both skull size and footfall height.
  scales[f'{identity}-town:{i}']=round((contact+meta[identity+'-town'][i]['height'])/2,3) if identity=='male5' else contact
(ROOT/'assets/appearance74/scale.json').write_text(json.dumps(scales,indent=2)+'\n')
print('Measured',sum(map(len,result.values())),'frame slots; calibrated',len(scales),'passing poses')
