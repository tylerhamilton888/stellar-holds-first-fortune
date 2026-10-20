"""Register complete four-key locomotion paintings, preserving saved identity."""
from pathlib import Path
import json

root=Path(__file__).resolve().parents[1]/'assets/whole-motion59'
data=json.loads((root/'frames.json').read_text())
selection=json.loads((root/'selection.json').read_text()) if (root/'selection.json').exists() else {}
runtime={}
views=['front','side','quarter','back']
for gender in ['male','female']:
 for sculpt in range(7):
  identity=f'{gender}{sculpt}'
  selected=[]
  for row in range(11):
   for view in views:
    base=identity+'-'+view
    source=base+('-tools' if row<6 else '-cargo')
    index=(row if row<6 else row-6)*4
    if source not in data:source=base;index=row*4
    override=selection.get(base,{}).get(str(row))
    if override:source=override['source'];index=override['frame']
    selected.append((source,index))
  if not all(source in data and index+3<len(data[source]) for source,index in selected):continue
  frames=[]
  for source,index in selected:
   for key in range(4):
    m=dict(data[source][index+key]);m['source']='res://assets/whole-motion59/'+source+'.png'
    frames.append(m)
  for key,override in selection.get('keys',{}).get(identity,{}).items():
   source=override['source'];m=dict(data[source][override['frame']])
   m['source']='res://assets/whole-motion59/'+source+'.png';frames[int(key)]=m
  runtime[identity+'-motion']=frames
(root/'runtime.json').write_text(json.dumps(runtime,separators=(',',':'))+'\n')
print('MOTION59 registered:',', '.join(runtime),';',sum(map(len,runtime.values())),'complete keys')
