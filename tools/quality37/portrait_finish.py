"""Final garment silhouette and exposed scalp coverage for the portrait painter."""
import numpy as np
from PIL import Image,ImageDraw,ImageFilter
OUTLINES={
'male0':[(0,253),(18,241),(49,229),(76,216),(91,195),(113,187),(280,220),(302,231),(329,241),(350,251),(370,267),(384,284)],
'male1':[(0,256),(21,241),(50,229),(79,216),(96,195),(119,190),(280,218),(308,232),(334,243),(356,255),(375,272),(384,286)],
'male2':[(0,255),(22,241),(52,230),(78,220),(100,204),(128,196),(281,220),(309,234),(333,245),(355,258),(375,274),(384,289)],
'male3':[(0,256),(21,242),(52,230),(79,216),(98,197),(120,184),(283,220),(307,232),(334,242),(354,254),(375,270),(384,285)],
'male4':[(0,247),(22,232),(47,222),(73,207),(92,189),(112,181),(284,215),(313,229),(340,241),(361,255),(379,270),(384,281)],
'female0':[(0,258),(23,243),(53,231),(78,223),(102,204),(122,200),(269,223),(290,232),(319,239),(344,250),(369,265),(384,284)],
'female1':[(0,271),(21,254),(47,238),(75,228),(93,217),(109,205),(127,201),(268,232),(286,230),(312,236),(339,248),(366,266),(384,289)],
'female2':[(0,277),(21,262),(46,251),(73,237),(99,219),(123,202),(279,235),(312,247),(341,262),(366,279),(384,301)],
'female3':[(0,257),(22,241),(49,229),(73,219),(99,214),(122,210),(274,216),(293,230),(320,238),(345,251),(370,269),(384,287)],
'female4':[(0,268),(20,253),(47,239),(75,230),(96,218),(120,211),(272,233),(294,235),(320,245),(347,260),(370,279),(384,298)]}
def raster(points,side):
 m=Image.new('L',(side*3,side*3));d=ImageDraw.Draw(m);d.polygon([(x*side*3/384,y*side*3/384) for x,y in points],fill=255)
 return np.asarray(m.filter(ImageFilter.GaussianBlur(.5*side*3/384)).resize((side,side),Image.Resampling.LANCZOS),float)/255

def refine(ident,src,w):
 side=src.width;a=np.asarray(src,float)/255;r,g,b=a[:,:,:3].transpose(2,0,1)
 body=raster(OUTLINES[ident]+[(384,384),(0,384)],side)
 w[:,:,2]*=body
 if ident=='male4':
  scalp=raster([(120,0),(275,0),(285,110),(265,150),(160,150)],side)
  scalp*=np.clip((r-g)*255/22,0,1)*np.clip((r-b)*255/35,0,1)*(1-w[:,:,0])
  w[:,:,1]=np.maximum(w[:,:,1],scalp)
 w[:,:,2]=np.minimum(w[:,:,2],np.clip(1-w[:,:,0]-w[:,:,1],0,1))
 w[:,:,3]=np.minimum(w[:,:,3],np.clip(1-w[:,:,:3].sum(2),0,1))
 return w
if __name__=='__main__':
 from pathlib import Path
 root=Path(__file__).resolve().parents[2]/'assets/portraits-v37'
 for p in root.glob('*.coverage'):
  im=Image.open(p.with_suffix('.png')).convert('RGBA');w=np.fromfile(p,np.uint8).reshape((512,512,4)).astype(float)/255
  w=refine(p.stem,im,w);p.write_bytes((w*255).round().astype('uint8').tobytes())
 print('Finished ten portrait garment silhouettes and scalp coverage')
