"""Bake corner masks and continuous stone registration for the meadow paving."""
from pathlib import Path
import sys
import numpy as np
from PIL import Image, ImageEnhance, ImageOps

def bake(source, destination):
    cell = 64
    period = 3 * cell
    source_image = Image.open(source).convert("RGB").resize((period, period), Image.Resampling.LANCZOS)
    source_image = ImageEnhance.Color(source_image).enhance(.64)
    mirrored = Image.new("RGB", (period * 2, period * 2))
    mirrored.paste(source_image, (0, 0))
    mirrored.paste(ImageOps.mirror(source_image), (period, 0))
    mirrored.paste(ImageOps.flip(mirrored.crop((0, 0, period * 2, period))), (0, period))
    surface = np.array(mirrored).astype(float)
    atlas = Image.new("RGBA", (cell*24, cell*24))
    y,x = np.mgrid[:cell,:cell]
    for row in range(6):
        for col in range(6):
            gx,gy = x+col*cell, y+row*cell
            # World-registered irregularity keeps adjoining masks exactly in step.
            u=(x+.5)/cell
            v=(y+.5)/cell
            u=u*u*(3-2*u)
            v=v*v*(3-2*v)
            kernel=[(1-u)*(1-v),u*(1-v),u*v,(1-u)*v]
            wobble=(np.sin(gx*2*np.pi/96+np.sin(gy*2*np.pi/48))*.035+
                    np.sin((gx+gy)*2*np.pi/24)*.017+np.sin((gx*3-gy*2)*2*np.pi/16)*.013)
            rock=surface[row*cell:(row+1)*cell,col*cell:(col+1)*cell]
            for mask in range(1,16):
                field=sum(weight for bit,weight in enumerate(kernel) if mask & (1<<bit))
                dist=field+wobble-.51
                alpha=np.clip((dist+.115)/.15,0,1)
                blend=np.clip((dist+.01)/.16,0,1)[:,:,None]
                turf=rock*np.array([.62,.70,.47])
                color=(rock*.88)*blend+turf*(1-blend)
                pixels=np.dstack((color,alpha*255)).astype(np.uint8)
                atlas.paste(Image.fromarray(pixels),(cell*(col*4+mask%4),cell*(row*4+mask//4)))
    atlas.save(destination,lossless=False,quality=90,method=6)

if __name__=="__main__":bake(*sys.argv[1:])
