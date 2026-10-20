"""Offline full-frame walk baker. Continuous textured leg meshes, planted-foot
trajectory, and an invariant foot root. Gameplay only draws complete frames."""
from pathlib import Path
import numpy as np,math,json
from scipy.ndimage import map_coordinates,maximum_filter,label,binary_fill_holes,binary_opening
from PIL import Image,ImageDraw
ROOT=Path(__file__).resolve().parents[2]
RAW=ROOT/'tools/quality36/raw';OUT=ROOT/'assets/walk-v37';OUT.mkdir(exist_ok=True)
meta=json.loads((RAW/'metadata.json').read_text());S=3;W=H=336;ORIGIN=np.array([56.,104.]);N=16
source=Image.open(ROOT/'tools/quality36/leg-reference.png').convert('RGBA')
# One continuous painted leg: no separate knee or boot sprites.
poly=[(884,338),(961,340),(950,386),(954,395),(951,410),(942,419),(945,433),(956,440),(978,447),(979,477),(865,477),(864,455),(872,438),(875,418),(874,394),(882,382)]
alpha=Image.new('L',source.size);ImageDraw.Draw(alpha).polygon(poly,fill=255)
a=np.array(source);a[:,:,3]=np.minimum(a[:,:,3],np.array(alpha));a=a[330:480,860:980]
leg=a.astype(np.float32)/255;leg[:,:,:3]*=leg[:,:,3:4]
xs=[866,882,900,919,938,957,980];ys=[334,350,370,388,394,400,414,422,430,438,450,477]
uv=np.array([(x-860,y-330) for y in ys for x in xs],float)
tri=[]
for j in range(len(ys)-1):
 for i in range(len(xs)-1):
  q=j*len(xs)+i;tri.extend([[q,q+1,q+len(xs)],[q+1,q+len(xs)+1,q+len(xs)]])

def point(v,angle):
 c,s=math.cos(angle),math.sin(angle);return np.array([v[0]*c-v[1]*s,v[0]*s+v[1]*c])

def leg_mesh(phase,near=True):
 # A planted foot moves backward exactly one world stride (64 units/cycle).
 # The other foot clears the floor and passes it, with the knee bending forward.
 phase%=1;stance=phase<.5
 if stance:
  u=phase/.5;x=16-32*u;lift=0
  angle=-.13*max(0,1-u/.16)+.24*max(0,(u-.78)/.22)
 else:
  u=(phase-.5)/.5;smooth=u*u*(3-2*u);x=-16+32*smooth;lift=6*math.sin(math.pi*u)
  angle=.24*(1-u)-.13*u
 # Rotate the boot about its ankle, then place its lowest heel/toe on the floor.
 boot_bottom=max(point(np.array([q,9.4]),angle)[1] for q in [-12,12])
 ankle=np.array([x,-boot_bottom-lift]);bob=.9*math.cos(phase*4*math.pi)
 hip=np.array([-3. if near else 3.,-29.+bob]);delta=ankle-hip;d=np.linalg.norm(delta)
 length=max(16.,d*.501);mid=(hip+ankle)*.5;perp=np.array([delta[1],-delta[0]])/max(.001,d)
 knee=mid+perp*math.sqrt(max(0,length*length-d*d*.25))
 thigh_angle=math.atan2(*(knee-hip)[::-1])-math.pi/2
 shin_angle=math.atan2(*(ankle-knee)[::-1])-math.pi/2
 pts=[]
 for px,py in uv+np.array([860,330]):
  dx=(px-919)*.175
  # Knee-high leather boots keep their painted volume. A continuous trouser
  # mesh joins the hip to the boot cuff; no separate knee patch or ankle shear.
  cuff=ankle+point(np.array([0.,(394-430)*.20]),angle)
  axis=cuff-hip;axis/=max(.001,np.linalg.norm(axis));normal=np.array([axis[1],-axis[0]])
  p1=hip+(cuff-hip)*((py-334)/60)+normal*dx
  p2=ankle+point(np.array([dx,(py-430)*.20]),angle)
  if py<388:p=p1
  elif py<400:
   t=(py-388)/12;p=p1*(1-t)+p2*t
  else:p=p2
  pts.append((p+ORIGIN)*S)
 return np.array(pts,np.float32),{'foot':[float(x),float(-lift)],'hip':hip.tolist(),'knee':knee.tolist(),'ankle':ankle.tolist(),'stance':stance}

def render_leg(phase,near):
 dst,marks=leg_mesh(phase,near);out=np.zeros((H,W,4),np.float32)
 for ids in tri:
  source=uv[ids];target=dst[ids]
  lo=np.maximum(np.floor(target.min(axis=0)).astype(int),0);hi=np.minimum(np.ceil(target.max(axis=0)).astype(int)+1,[W,H])
  if np.any(hi<=lo):continue
  yy,xx=np.mgrid[lo[1]:hi[1],lo[0]:hi[0]];p=np.stack([xx.ravel(),yy.ravel(),np.ones(xx.size)])
  matrix=np.vstack([target.T,np.ones(3)])
  if abs(np.linalg.det(matrix))<1e-7:continue
  weights=np.linalg.solve(matrix,p);inside=np.all(weights>=-1e-5,axis=0)
  coords=source.T@weights[:,inside]
  for c in range(4):out[yy.ravel()[inside],xx.ravel()[inside],c]=map_coordinates(leg[:,:,c],[coords[1],coords[0]],order=1,mode='constant')
 active=np.where(out[:,:,3]>.4)[0]
 if len(active):
  lift=-marks["foot"][1];target=int(round(ORIGIN[1]*S-1-lift*S));shift=target-int(active.max())
  out=np.roll(out,shift,axis=0)
  if shift>0:out[:shift]=0
  elif shift<0:out[shift:]=0
 if not near:out[:,:,:3]*=.73
 return out,marks

def composite(dst,src):return src+dst*(1-src[:,:,3:4])

def place(src,offset,labels=False):
 y,x=np.indices((H,W));coords=[(y-offset[1]*S)/1.5,(x-offset[0]*S)/1.5]
 if labels:return map_coordinates(src,coords,order=0,mode='constant')
 return np.stack([map_coordinates(src[:,:,c],coords,order=1,mode='constant') for c in range(4)],axis=2)

def head_region(im,m,info):
 y,x=np.indices(m.shape);eye=np.array(info['eye']);dx=x-eye[0];dy=y-eye[1]
 face_candidates=(m==3)&(dx>-40)&(dx<40)&(dy>-60)&(dy<25)
 components,count=label(face_candidates);face=np.zeros(m.shape,bool)
 for component in range(1,count+1):
  ys,xs=np.where(components==component)
  if len(ys) and ys.min()<eye[1]+18:face|=components==component
 hsv=np.asarray(Image.fromarray(im).convert('RGB').convert('HSV'),float)/255
 hair=(m==1)&(dx>-125)&(dx<50)&(dy<100)&(hsv[:,:,0]>.073)&(hsv[:,:,1]>.15)
 shape=binary_fill_holes(maximum_filter((face|hair).astype(np.uint8),size=5)>0)
 return binary_opening(shape&(im[:,:,3]>0),iterations=3)

def premult(im):
 p=im.astype(np.float32)/255;p[:,:,:3]*=p[:,:,3:4];return p

leg_cache={(f,near):render_leg(f/N+(0 if near else .5),near) for f in range(N) for near in [False,True]}
anchors={};gait={}
for gender in range(2):
 for sculpt in range(5):
  ident=('female' if gender else 'male')+str(sculpt)
  for armed in [False,True]:
   neutral_key=ident+('-walk'+str(gender*4) if armed else '-normal-0')
   neutral=meta[neutral_key]
   neutral_image=np.array(Image.open(RAW/(neutral_key+'.png')).convert('RGBA'))
   neutral_mask=np.fromfile(ROOT/'assets/palette-v36'/(neutral_key+'.mask'),np.uint8).reshape(neutral_image.shape[:2])
   neutral_head=head_region(neutral_image,neutral_mask,neutral)
   target=(np.array(neutral['eye'])-np.array(neutral['root']))*.5
   for f in range(N):
    phase=f/N;old=f//4 if armed else [1,0,2,4,5,6,3,7][f//2]
    key=ident+('-walk'+str(gender*4+old) if armed else '-normal-'+str(old))
    im=np.array(Image.open(RAW/(key+'.png')).convert('RGBA'));m=np.frombuffer((ROOT/'assets/palette-v36'/(key+'.mask')).read_bytes(),np.uint8).reshape(im.shape[:2]).copy();info=meta[key]
    root=np.array(info['root'])*.5;eye=np.array(info['eye'])*.5;hand=np.array(info['wrist'])*.5
    shift=target-(eye-root);shift[1]+=.9*math.cos(phase*4*math.pi)
    y,x=np.indices(m.shape);worldx=x*.5-root[0];worldy=y*.5-root[1]
    # The coat overlaps the hips. Preserve long beards, hands and integrated gear.
    keep=worldy<-25
    hair_edge=maximum_filter((m==1).astype(np.uint8),size=5)>0
    src_rgb=im[:,:,:3].astype(float);src_v=src_rgb.max(axis=2)
    src_h=np.asarray(Image.fromarray(im).convert("RGB").convert("HSV"))[:,:,0]/255
    keep|=hair_edge&(worldy<-4)
    coat=maximum_filter(((m==4)&(src_h<.56)).astype(np.uint8),size=3)>0
    keep|=coat&(worldy<-16)
    keep|=(m==3)&(src_v>140)&(src_rgb[:,:,2]>src_rgb[:,:,0]*.25)&((x*.5-hand[0])**2+(y*.5-hand[1])**2<10**2)
    if armed:
     keep|=(np.abs(worldx)>22)&(worldy<-5)
     keep|=((x*.5-hand[0])>0)&((x*.5-hand[0])<30)&(np.abs(y*.5-hand[1])<18)
    im[~keep,3]=0;m[~keep]=0
    upper=im.astype(np.float32)/255;upper[:,:,:3]*=upper[:,:,3:4]
    far,far_marks=leg_cache[(f,False)];near,near_marks=leg_cache[(f,True)]
    canvas=composite(far,near)
    offset=ORIGIN-root+shift
    upper=place(upper,offset)
    # Every frame uses the same complete head and braids. The changing source
    # poses supply the torso and arms, not a different hairstyle each time.
    own_head=maximum_filter(head_region(im,m,info).astype(np.uint8),size=9)>0
    own_head&=im[:,:,3]>0
    remove=place(own_head.astype(np.uint8),offset,True)>0
    nroot=np.array(neutral['root'])*.5
    noffset=ORIGIN-nroot+np.array([0.,.9*math.cos(phase*4*math.pi)])
    original=place(premult(neutral_image),noffset)
    stable=place(neutral_head.astype(np.uint8),noffset,True)>0
    own_labels=place(m,offset,True)
    stable_labels=place(neutral_mask,noffset,True)
    # Replace former head pixels with the corresponding canonical painting,
    # including the shirt behind any old, inconsistent braid silhouette.
    upper[remove]=0;own_labels[remove]=0
    # Only the shirt may fill a vacated old braid area. Copying an entire idle
    # body here also copied tiny pieces of its far hand and backpack strap.
    fill=remove&~stable
    upper[fill]=original[fill];own_labels[fill]=stable_labels[fill]
    upper[stable]=original[stable];own_labels[stable]=stable_labels[stable]
    # The moving forearm and fingers genuinely occlude the hanging braid.
    arm=(m==3)&(worldy>eye[1]-root[1]+12)&(((x*.5-hand[0])**2+(y*.5-hand[1])**2)<22**2)
    components,count=label(arm)
    if count:
     closest=None
     for component in range(1,count+1):
      ys,xs=np.where(components==component)
      distance=np.min((xs*.5-hand[0])**2+(ys*.5-hand[1])**2)
      if closest is None or distance<closest[0]:closest=(distance,component)
     arm=components==closest[1]
    arm=maximum_filter(arm.astype(np.uint8),size=3)>0
    forearm=im.copy();forearm[~arm,3]=0
    overlay=place(premult(forearm),offset);upper=composite(upper,overlay)
    front=overlay[:,:,3]>.01;own_labels[front]=place(m,offset,True)[front]
    canvas=composite(canvas,upper)
    alpha=canvas[:,:,3:4];rgb=np.divide(canvas[:,:,:3],alpha,out=np.zeros_like(canvas[:,:,:3]),where=alpha>1e-6)
    final=np.concatenate([rgb,alpha],axis=2);final=np.clip(final*255,0,255).astype('uint8')
    mask=own_labels
    components,count=label(final[:,:,3]>40)
    if count:
     counts=np.bincount(components.ravel());counts[0]=0;keep_shape=maximum_filter((components==counts.argmax()).astype(np.uint8),size=3)>0
     final[~keep_shape,3]=0
    mask[final[:,:,3]==0]=0
    name=ident+('-armed' if armed else '-normal')+str(f)
    Image.fromarray(final).save(OUT/(name+'.png'));(OUT/(name+'.mask')).write_bytes(mask.tobytes())
    eye_world=eye-root+shift;palm_world=hand-root+shift;elbow=np.array(info['elbow'])*.5-root+shift
    anchors[name]={'head':(eye_world+[-7,-8]).tolist(),'neck':(eye_world+[-8,13]).tolist(),'chest':(eye_world+[-14,24]).tolist(),'shoulder':(elbow+[-2,-8]).tolist(),'hand':palm_world.tolist(),'boots':[0,0]}
    gait[name]={'near':near_marks,'far':far_marks,'old':old,'head_source':neutral_key}
  print(ident,flush=True)
(OUT/'sockets.json').write_text(json.dumps(anchors));(OUT/'gait.json').write_text(json.dumps(gait))
print('Baked 320 whole-frame poses at 3x resolution',flush=True)
