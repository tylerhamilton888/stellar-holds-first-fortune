"""Protected exposed-neck anatomy. This changes labels only, never source art.
Portrait contours use the 512-pixel painting's coordinates. Sprite contours use
per-pose eye landmarks. Warm neck shadows cannot inherit a hair material label.
"""
from pathlib import Path
import json
import numpy as np
from PIL import Image,ImageDraw,ImageFilter
ROOT=Path(__file__).resolve().parents[2]
MALE_LEFT=[(157,231),(170,232),(168,251),(173,276),(184,304),(199,327),(220,345),(245,363),(230,366),(214,356),(189,345),(166,331),(149,311),(136,287),(137,277),(150,262),(154,247)]
FRONT=[(223,274),(243,289),(266,298),(292,302),(315,299),(326,295),(328,311),(344,321),(363,332),(367,354),(356,376),(339,401),(327,438),(313,423),(296,395),(280,376),(262,360),(239,353),(217,344),(218,328),(220,310),(216,291)]
PORTRAIT={
'male0':[MALE_LEFT,[(243,367),(266,384),(288,400),(301,406),(314,403),(337,385),(361,363),(373,349),(372,367),(356,389),(339,406),(328,444),(317,468),(301,431),(283,409),(271,391),(247,384)]],
'male1':[MALE_LEFT,[(279,328),(289,335),(299,345),(305,347),(313,336),(326,321),(332,332),(335,348),(330,367),(337,379),(330,406),(321,439),(314,441),(304,414),(294,395),(278,384),(267,380),(268,362),(272,347),(272,335)]],
'male2':[MALE_LEFT],
'male3':[MALE_LEFT,[(329,351),(339,373),(349,389),(338,405),(327,423),(317,445),(311,431),(316,414),(321,394)]],
'male4':[[(x+3,y-12) for x,y in MALE_LEFT]],
'female0':[[(174,236),(184,233),(185,250),(181,265),(185,281),(179,296),(184,310),(183,327),(170,319),(160,305),(153,291),(166,275),(172,257)],FRONT],
'female1':[[(178,239),(189,240),(187,259),(183,273),(187,289),(196,307),(203,319),(212,324),(221,316),(229,303),(230,285),(235,279),(253,293),(277,302),(304,305),(326,302),(328,316),(350,327),(365,340),(369,361),(360,382),(341,405),(327,441),(312,428),(296,402),(281,383),(261,375),(243,369),(219,354),(194,341),(178,331),(163,317),(150,298),(159,281),(170,271),(175,255)]],
'female2':[[(187,235),(194,235),(193,251),(191,267),(195,282),(197,297),(195,317),(184,313),(172,302),(165,292),(177,282),(183,266),(185,249)],[(x+9 if x<250 else x,y) for x,y in FRONT]],
'female3':[[(221,266),(240,284),(263,297),(291,302),(316,300),(329,294),(331,310),(349,322),(369,338),(371,357),(357,385),(338,416),(325,443),(311,424),(296,393),(280,370),(255,358),(240,351),(235,329),(230,311),(226,292)]],
'female4':[[(231,304),(241,301),(248,291),(253,286),(271,297),(294,304),(315,302),(328,297),(334,312),(350,320),(368,335),(372,353),(358,382),(340,411),(328,447),(316,432),(295,403),(277,383),(258,373),(238,366),(217,355),(200,344),(184,332),(175,317),(177,304),(197,301),(214,305)]]}

def coverage(polys,size=512):
 im=Image.new('L',(size*3,size*3));d=ImageDraw.Draw(im)
 for p in polys:d.polygon([(x*3,y*3) for x,y in p],fill=255)
 return np.asarray(im.filter(ImageFilter.GaussianBlur(.65)).resize((size,size),Image.Resampling.LANCZOS),float)/255

def portrait_guard(id,im):
 a=np.asarray(im.convert('RGB'),float)/255;h=np.asarray(im.convert('RGB').convert('HSV'),float)[:,:,0]/255
 # Only reddish complexion pigment is restored inside the authored neck.
 # Gold braid tips and metal bands are outside the contours and excluded by hue.
 skin_hue=np.clip((.074-h)/.012,0,1)
 skin_warm=np.clip((a[:,:,0]-a[:,:,2])/.08,0,1)
 guard=coverage(PORTRAIT[id])*skin_hue*skin_warm
 if id=="female1":
  guard*=1-coverage([[(202,316),(214,306),(226,297),(224,316),(216,327),(204,329)]])
 return guard

def fix_portrait(id,im,w):
 guard=portrait_guard(id,im);removed=w[:,:,0]*guard;w[:,:,0]-=removed
 w[:,:,1]=np.minimum(w[:,:,1]+removed,1-w[:,:,0]-w[:,:,2]-w[:,:,3])
 return np.clip(w,0,1),guard

def sprite_guard(key,im,info):
 a=np.asarray(im.convert('RGBA'));h=np.asarray(im.convert('RGB').convert('HSV'),float)[:,:,0]/255
 y,x=np.indices(a.shape[:2]);ex,ey=info['eye'];female=key.startswith('female');sculpt=int(key.split('-')[0][-1]);pose=key.split('-',1)[1]
 if ((pose in ['combat2','combat6'] and not female and sculpt!=1) or (pose in ['combat10','combat14'] and female)):ex+=20;ey-=2
 dx=x-ex;dy=y-ey;normal=pose.startswith('normal')
 if female:
  # Jaw-to-collar wedge, on the face side of the hanging braid.
  right=5 if normal else 3;left=-9 if normal else -15
  region=(dx>left)&(dx<right)&(dy>16)&(dy<38)&(dx>(dy-20)*.20+left)
  if sculpt==4:region|=(dx>-17)&(dx<4)&(dy>22)&(dy<37)
 else:
  # Exposed strip behind the beard and beneath the ear; beard fronts excluded.
  region=(dx>-27)&(dx<-19)&(dy>9)&(dy<31)
 warm=(a[:,:,0].astype(float)>a[:,:,2]*1.5)&(a[:,:,0]>24)
 return region&(h<.070)&warm&(a[:,:,3]>0)

def run():
 portraits=ROOT/'assets/portraits-v37';actors=ROOT/'assets/actors-v36';masks=ROOT/'assets/palette-v36';raw=ROOT/'tools/quality36/raw'
 backup=ROOT/'tools/quality38/original-masks';backup.mkdir(exist_ok=True)
 meta=json.loads((raw/'metadata.json').read_text());count=0
 for id in PORTRAIT:
  p=portraits/f'{id}.coverage';saved=backup/p.name
  if not saved.exists():saved.write_bytes(p.read_bytes())
  im=Image.open(portraits/f'{id}.png');w=np.frombuffer(saved.read_bytes(),np.uint8).reshape(512,512,4).astype(float)/255
  corrected,guard=fix_portrait(id,im,w.copy());p.write_bytes((corrected*255).round().astype('uint8').tobytes())
  Image.fromarray((guard*255).round().astype('uint8')).save(backup/f'{id}-protected.png')
  labels=np.array([1,3,4,5],np.uint8)[corrected.argmax(2)];labels[corrected.max(2)==0]=0
  (portraits/f'{id}.mask').write_bytes(labels.tobytes())
  print(id,'portrait hair pixels restored:',int(((w[:,:,0]-corrected[:,:,0])>.01).sum()))
 for key,info in meta.items():
  if key.endswith('portrait'):continue
  p=masks/f'{key}.mask';saved=backup/p.name
  if not saved.exists():saved.write_bytes(p.read_bytes())
  im=Image.open(actors/f'{key}.png').convert('RGBA');m=np.frombuffer(saved.read_bytes(),np.uint8).reshape(im.height,im.width).copy()
  guard=sprite_guard(key,im,info);sel=guard&(m==1);count+=int(sel.sum());m[sel]=3;p.write_bytes(m.tobytes())
 print('Sprite neck pixels restored:',count)
 # Walking geometry stays byte-for-byte unchanged. Transfer the protected neck
 # from the canonical head into the already baked frame's material map only.
 from scipy.ndimage import map_coordinates
 gait=json.loads((ROOT/'assets/walk-v37/gait.json').read_text());walk_count=0
 for name,record in gait.items():
  key=record['head_source'];info=meta[key];im=Image.open(actors/f'{key}.png').convert('RGBA')
  guard=sprite_guard(key,im,info)
  frame=int(name.split('armed')[-1] if 'armed' in name else name.split('normal')[-1])
  offset=np.array([56.,104.])-np.array(info['root'])*.5+np.array([0.,.9*np.cos(frame/16*4*np.pi)])
  yy,xx=np.indices((336,336));placed=map_coordinates(guard.astype(np.uint8),[(yy-offset[1]*3)/1.5,(xx-offset[0]*3)/1.5],order=0,mode='constant')>0
  path=ROOT/'assets/walk-v37'/f'{name}.mask';saved=backup/f'walk-{name}.mask'
  if not saved.exists():saved.write_bytes(path.read_bytes())
  mask=np.frombuffer(saved.read_bytes(),np.uint8).reshape(336,336).copy();sel=placed&(mask==1);walk_count+=int(sel.sum());mask[sel]=3;path.write_bytes(mask.tobytes())
 print('Baked walk neck pixels restored:',walk_count)
if __name__=='__main__':run()
