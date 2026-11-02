"""Import intact generated figures. No drawing or body-part assembly."""
import json,subprocess,sys
from pathlib import Path
import numpy as np
from PIL import Image
from scipy.ndimage import label
ROOT=Path(__file__).resolve().parents[3];HERE=Path(__file__).parent;WORLD=ROOT/'assets/story105/world'
for kind,rows,cols in [('core',5,4),('extra',2,4),('opposite',1,2)]:
 source_file=HERE/(kind+'-sources.json')
 if not source_file.exists():continue
 for identity,source in json.loads(source_file.read_text()).items():
  name=identity if kind=='core' else identity+kind
  image=Image.open(source);w,h=image.size;alpha=np.asarray(image)[:,:,3]
  components,_=label(alpha>24,structure=np.ones((3,3)));sizes=np.bincount(components.ravel());sizes[0]=0
  bodies=[]
  for index in np.argsort(sizes)[-rows*cols:]:
   ys,xs=np.nonzero(components==index);bodies.append([int(xs.min()),int(ys.min()),int(xs.max()+1),int(ys.max()+1)])
  bodies.sort(key=lambda b:(int(((b[1]+b[3])/2)/(h/rows)),b[0]))
  bounds=[[max(0,b[0]-3),max(0,b[1]-3),min(w,b[2]+3),min(h,b[3]+3)]for b in bodies]
  subprocess.run([sys.executable,str(ROOT/'tools/import_story_world105.py'),source,name,'--rows',str(rows),'--columns',str(cols),'--frame-bounds',json.dumps(bounds)],check=True)
  path=WORLD/(name+'.json');frames=json.loads(path.read_text())
  for frame in frames:frame['source']='res://assets/story105/world/'+name+'.webp'
  path.write_text(json.dumps(frames,separators=(',',':'))+'\n')
for identity in ['alden','maren']:
 path=WORLD/(identity+'.json');frames=json.loads(path.read_text())[:20]
 extras=json.loads((WORLD/(identity+'extra.json')).read_text());frames+=extras[4:8]
 opposite=WORLD/(identity+'opposite.json')
 if opposite.exists():frames[14:16]=json.loads(opposite.read_text())
 path.write_text(json.dumps(frames,separators=(',',':'))+'\n')
