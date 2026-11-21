"""Bake idle sheets from the game's registered full-figure drawings. Input is a Godot project."""
import argparse
import json
import math
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

KEYS = 12
DENSITY = 128
# How each character stands: side carrying weight, shoulder breadth in motion,
# and how far the off hand settles towards the belt. The feet stay on the ground.
STANCES = {
    "braced": (1, .78, .60), "at_ease": (-1, 1.10, .90),
    "watchful": (1, .95, 1.22), "upright": (-1, .82, .74),
}
GROUPS = {
    "braced": "male0 male4 female1 female5 borin odrin dagr brann rurik hakon",
    "at_ease": "male1 male5 female0 female3 maren hedrik ketil yrsa orla",
    "watchful": "male2 male6 female4 female6 alden skarrin tovan osvik kelvar sigrid",
    "upright": "male3 female2 dagna ragnhild brynja edda torvik bram sten ivar eldric eirik",
}
STYLE = {name: stance for stance, names in GROUPS.items() for name in names.split()}

def deform(im, anchors, phase, style, view, seated):
    # Inverse skinning in normalized figure space. Warp premultiplied colors
    # and alpha together so the painted outline doesn't acquire colored fringes.
    rgba = np.asarray(im, dtype=np.float32) / 255
    rgba[:, :, :3] *= rgba[:, :, 3:]
    h, w = rgba.shape[:2]
    yy, xx = np.mgrid[0:h, 0:w].astype(np.float32)
    x, y = (xx-6)/(w-12), (yy-6)/(h-12)
    side, breadth, ease = STANCES[style]
    s, c = math.sin(phase), math.cos(phase)
    breath = math.sin(2*phase-.4)
    plant = np.clip((.85-y)/.22, 0, 1)
    head = np.clip((.51-y)/.22, 0, 1)
    chest = np.exp(-((y-.40)/.21)**2)
    glance = (.5+.5*c)**3
    narrow = .68 if view in (1,2) else 1
    dx = (h-12)*(.020*side*s*plant + .011*side*glance*head)
    dy = (h-12)*(-.014*(breath+.35)*plant + .004*s*head)
    dx += (w-12)*.026*(x-.5)*chest*breath*breadth
    for hand, (wx, wy) in enumerate((anchors[:2], anchors[2:])):
        sign = -1 if hand==0 else 1
        weight = np.exp(-((x-wx)/.19)**2-((y-wy)/.15)**2)
        settle = (.5+.5*math.sin(phase+sign*.9))**2
        dx -= sign*(w-12)*narrow*(.020+.049*settle*ease)*weight
        dy += (h-12)*(.013-.046*settle*ease+.010*breath)*weight
    if seated:
        support=np.clip((.68-y)/.24,0,1)
        dx*=support*.67
        dy*=support*.8
    sx, sy = np.clip(xx-dx,0,w-1.01), np.clip(yy-dy,0,h-1.01)
    ix, iy = sx.astype(int), sy.astype(int)
    fx, fy = (sx-ix)[:,:,None], (sy-iy)[:,:,None]
    out=(rgba[iy,ix]*(1-fx)+rgba[iy,ix+1]*fx)*(1-fy)+(rgba[iy+1,ix]*(1-fx)+rgba[iy+1,ix+1]*fx)*fy
    out[:,:,:3] /= np.maximum(out[:,:,3:],1/255)
    return Image.fromarray(np.clip(out*255+.5,0,255).astype('uint8'))

def bake(out, figures, get_pose):
    packed={}
    for name, anchors in figures.items():
        rows=[]; info=[]
        for view in range(4):
            src, root, height = get_pose(name,view)
            ratio=DENSITY/height
            sz=tuple(max(1,round(k*ratio)) for k in src.size)
            padded=Image.new('RGBA',(sz[0]+12,sz[1]+12))
            padded.paste(src.resize(sz, Image.Resampling.LANCZOS),(6,6))
            row=[deform(padded,anchors[view],i*2*math.pi/KEYS,STYLE[name],view,name=='eirik' and view==2) for i in range(KEYS)]
            rows.append(row)
            info.append(([root[0]*sz[0]/src.width+6, root[1]*sz[1]/src.height+6],height*sz[1]/src.height))
        width=max(row[0].width for row in rows)
        height=max(row[0].height for row in rows)
        atlas=Image.new('RGBA',(width*6,height*8)); metas=[]
        for v,row in enumerate(rows):
            for i,im in enumerate(row):
                x=(i%6)*width; y=(v*2+i//6)*height
                atlas.paste(im,(x,y)); root,h=info[v]
                metas.append({'rect':[x,y,im.width,im.height],'root':[round(x+root[0],3),round(y+root[1],3)],'height':round(h,3),'source':'res://hands/poses/'+name+'.webp'})
        path=out/(name+'.webp')
        if name.startswith(('male','female')):atlas.save(path,lossless=True,method=3)
        else:atlas.save(path,quality=89,method=5)
        packed[name]=metas
    (out/'frames.json').write_text(json.dumps(packed,separators=(',',':')))

def run(project,out):
    def load(rel):return json.loads((project/rel).read_text())
    meta=load('assets/whole-v58/frames.json')
    meta.update(load('assets/appearance74/frames.json'))
    scales=load('assets/appearance74/scale.json')
    figures=load('hands/rigs.json')
    def get_pose(name,view):
        if name=='eirik':
            image=Image.open(project/'assets/royal79/eirik-poses.png').convert('RGBA')
            edges=[0,303,602,912,1254]
            part=image.crop((edges[view],877,edges[view+1],1254))
            part=part.crop(part.getchannel('A').point(lambda a:255 if a>38 else 0).getbbox())
            return part,(part.width*.5,part.height),part.height
        is_base=name.startswith(('male','female'))
        sheet=name+'-core' if is_base else 'res://assets/story105/world/'+name+'.webp'
        m=(meta[sheet] if is_base else load('assets/story105/world/'+name+'.json'))[view]
        src=m.get('source',sheet)
        path=src.removeprefix('res://') if src.startswith('res://') else 'assets/whole-v58/'+src+'.png'
        image=Image.open(project/path).convert('RGBA')
        x,y,w,h=m['rect'];part=image.crop((x,y,x+w,y+h));draw=ImageDraw.Draw(part)
        for i,j,n in m.get('omit',[]):draw.line((i,j,i+n-1,j),fill=(0,0,0,0))
        return part,(m['root'][0]-x,m['root'][1]-y),scales.get(sheet+':'+str(view),m['height'])
    out.mkdir(parents=True,exist_ok=True)
    bake(out,figures,get_pose)
if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('project',type=Path);args=parser.parse_args()
    run(args.project,args.project/'hands/poses')
