"""Compile immutable material labels at twice the old sampling resolution.
No color classification is run during gameplay. Face-edge dark gold and braid
ends are explicitly included; the former pipeline confused both with skin.
"""
from pathlib import Path
import numpy as np,json
from scipy.ndimage import binary_propagation, binary_fill_holes, label, maximum_filter
from PIL import Image, ImageFilter
ROOT=Path(__file__).resolve().parents[2]
RAW=ROOT/'tools/quality36/raw';OUT=ROOT/'assets/actors-v36';MASK=ROOT/'assets/palette-v36'
OUT.mkdir(exist_ok=True);MASK.mkdir(exist_ok=True)
meta=json.loads((RAW/'metadata.json').read_text())
for path in RAW.glob('*.png'):
 if '.review' in path.stem:continue
 im=Image.open(path).convert('RGBA');a=np.asarray(im);old=np.frombuffer((ROOT/'assets/palette-v35'/f'{path.stem}.mask').read_bytes(),np.uint8)
 old=old.reshape(im.height//2,im.width//2);m=np.asarray(Image.fromarray(old).resize(im.size,Image.Resampling.NEAREST)).copy()
 hsv=np.asarray(im.convert('RGB').convert('HSV'),float)/255;h,s,v=hsv[:,:,0],hsv[:,:,1],hsv[:,:,2]
 r,g,b=[a[:,:,i].astype(float)/255 for i in range(3)];y,x=np.indices(m.shape);female=path.stem.startswith('female');sculpt=int(path.stem.split('-')[0][-1]);opaque=a[:,:,3]>8
 near=np.asarray(Image.fromarray(((m==1)*255).astype('uint8')).filter(ImageFilter.MaxFilter(19)))>0
 original_hair=m==1
 portrait=path.stem.endswith('portrait')
 if portrait:region=near
 else:
  ex,ey=meta[path.stem]['eye'];pose=path.stem.split('-',1)[1]
  if ((pose in ['combat2','combat6'] and not female and sculpt!=1) or (pose in ['combat10','combat14'] and female)):ex+=20;ey-=2
  dx=(x-ex)/2;dy=(y-ey)/2
  region=(dx>-38)&(dx<15)&(dy>-40)&(dy<6)
  if female:
   region|=(dx>-34)&(dx<3)&(dy>=3)&(dy<[30,27,36,47,25][sculpt])
   if sculpt==2:region|=(dx>-58)&(dx<-9)&(dy>-15)&(dy<20)
  else:
   region|=(dx>-13)&(dx<18)&(dy>=4)&(dy<[30,43,40,35,43][sculpt])
   if sculpt==2:region|=(dx>-58)&(dx<-9)&(dy>-20)&(dy<12)
  if female and sculpt==1:region|=(dx>-48)&(dx<15)&(dy<-10)&(dy>-40)
  region|=(dx>-38)&(dx<22)&(dy<-2)&(dy>-40)
  if not female and sculpt==4:region&=~((dx>-8)&(dx<10)&(dy<-3)&~near)
 golden=(h>=.084)&(h<.19)&(s>.18)
 dark_gold=(h>=.070)&(h<.18)&(s>.58)&(b<r*.34)&(v>.08)
 pale=(h>.095)&(h<.19)&(s>.08)&(s<=.25)&(v>.62)&near
 shadow=(h>.025)&(h<.19)&(s>.70)&(b<r*.22)&(v>.025)
 # Only gold cores seed the region. Dark brown leather is never a seed and
 # cannot carry a flood from a braid into the shoulder strap or satchel.
 seed=original_hair&(golden|pale)&region
 if not portrait:
  safe_head=((dy<-8)&(dy>-40))|((dx<-18)&(dy<19)&(dy>-20))
  if not female and sculpt==4:safe_head&=dx<-12
  seed|=safe_head&region&golden
  seed|=original_hair&region&dark_gold&(dy<(6 if not female and sculpt==0 else 0))
  if female:seed|=region&golden&(dx>-18)&(dx<-5)&(dy>10)&(dy<[30,27,36,47,25][sculpt])
 m[original_hair]=0
 skin=original_hair&(h>.015)&(h<.088)&(s>.2)&(v>.35)
 m[skin]=3
 if not portrait:
  metal_hue=.085 if (female and sculpt!=3) or (not female and sculpt in [0,3]) else .105
  fittings=(dy>30)&(dy<40)&(abs(dx)<14)&(h>metal_hue)&(h<.18)&(s>.62)&(v>.3)
  if female or sculpt not in [1,4]:m[(m==5)&near&region&~fittings]=0
  m[fittings&opaque]=5
  # Eyebrows are independent hair islands, located from the actual eye whites.
  whites=(abs(dx)<12)&(abs(dy)<8)&(s<.18)&(v>.88)&opaque
  components,count=label(whites)
  if count:
   candidates=[]
   for k in range(1,count+1):
    ys,xs=np.where(components==k)
    if len(xs)>=2:candidates.append((float((xs.mean()-ex)**2+(ys.mean()-ey)**2),xs,ys))
   if candidates:
    _,xs,ys=min(candidates,key=lambda t:t[0])
    brow=(x>=xs.min()-4)&(x<=xs.max()+5)&(y>=ys.min()-9)&(y<ys.min())
    seed|=brow&(golden|dark_gold)&region
 add=region&(golden|pale)&opaque&(m!=4)&(m!=5)
 seed&=(m!=4)&(m!=5)
 core=binary_propagation(seed,structure=np.ones((3,3)),mask=seed|add)
 edge_range=maximum_filter(core.astype(np.uint8),size=13)>0
 hair=core|(edge_range&(dark_gold|shadow)&region&opaque&(m!=4)&(m!=5))
 if portrait:
  # The source portrait has broad warm shadow bands inside the hair. They
  # must remain hair even when more than six pixels from a pale highlight.
  hair|=original_hair&(dark_gold|shadow)&opaque
 # Bright enclosed highlights are pigment, even when their antialiased hue
 # falls just below the gold threshold. Never fill eyes, skin or accessories.
 holes=binary_fill_holes(hair)&~hair
 components,count=label(holes)
 sizes=np.bincount(components.ravel())
 small=(components>0)&(sizes[components]<=64)
 hair|=small&(h>.065)&(h<.19)&(s>.35)&opaque&(m!=4)&(m!=5)
 m[hair]=1
 # Grow the material into same-colored anti-aliased silhouettes. Preserve the
 # original fractional alpha and dark outline; neither is thresholded away.
 for _ in range(2):
  adj=np.asarray(Image.fromarray(((m==1)*255).astype('uint8')).filter(ImageFilter.MaxFilter(3)))>0
  edge=adj&(a[:,:,3]<220)&(a[:,:,3]>0)&(h>.045)&(h<.19)&(m!=4)&(m!=5)
  m[edge]=1
 if portrait:
  # Portrait-specific anatomy boundaries. Gold-lit forehead skin and nearby
  # buckles cannot be inferred from hue alone, so these are authored landmarks.
  if not female and sculpt<4:
   forehead=((x-196)**2/11**2+(y-86)**2/8**2)<1
   m[forehead]=3
  if female:
   brow=((x>184)&(x<236)&(y>103)&(y<124))|((x>247)&(x<275)&(y>107)&(y<126))
   m[brow&(h>.058)&(h<.15)&(s>.65)&(b<r*.31)&(v<.80)]=1
   lower=[(y>242)&((x<130)|(x>174)),y>245,(y>273)&((x<140)|(x>185)),(y>269)&(x<137),y>235][sculpt]
   m[lower&(m==1)]=0
   buttons=[[(176,263,194,283)],[],[(184,269,201,289)],[(187,261,205,284)],[]][sculpt]
   for x0,y0,x1,y1 in buttons:
    part=(x>=x0)&(x<=x1)&(y>=y0)&(y<=y1)&(m==1)
    m[part]=5
 m[a[:,:,3]==0]=0
 (MASK/f'{path.stem}.mask').write_bytes(m.tobytes())
 if not (OUT/path.name).exists():im.save(OUT/path.name)
 # Actual neutral-render diagnostic, preserving source luminance and alpha.
 z=a.copy();sel=m==1;shade=np.clip(v/.82,0,1.22);z[sel,:3]=np.clip(shade[sel,None]*np.array([40,41,54]),0,255).astype('uint8')
 Image.fromarray(z).save(RAW/f'{path.stem}.review.png')
print('Compiled',len(list(MASK.glob('*.mask'))),'high-detail material maps')
