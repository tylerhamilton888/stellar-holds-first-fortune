"""Author portrait material coverage from anatomical contours, not hue islands.
Coordinates are in a 384px design space; source painting and coverage are sampled
at 512px together. Keep anatomy and straps outside each hair silhouette.
"""
from portrait_finish import refine
from pathlib import Path
from PIL import Image,ImageDraw,ImageFilter
import numpy as np,json
from scipy.ndimage import binary_erosion, binary_dilation, binary_fill_holes, gaussian_filter
ROOT=Path(__file__).resolve().parents[2];OUT=ROOT/'assets/portraits-v37';OUT.mkdir(exist_ok=True)
N=1536;TARGET=512
male_face=[(164,96),(177,84),(188,80),(205,81),(226,88),(250,82),(258,95),(258,111),(260,131),(267,149),(264,162),(254,168),(240,164),(228,162),(218,166),(206,166),(200,163),(188,165),(177,164),(168,169),(162,161),(156,152),(155,139),(158,117)]
male_ear=[(110,128),(117,122),(126,122),(136,132),(141,145),(137,159),(132,171),(124,171),(115,164),(109,153),(107,140)]
head=[(55,0),(290,0),(292,150),(278,178),(133,200),(115,183),(100,198),(67,185),(55,155)]
beards=[
[(131,157),(163,165),(190,158),(239,159),(263,159),(283,179),(289,186),(284,195),(292,213),(288,240),(276,257),(253,278),(226,303),(207,288),(186,276),(164,259),(146,244),(132,222),(123,196)],
[(131,157),(164,164),(192,157),(240,157),(263,159),(283,179),(288,187),(280,194),(288,222),(282,244),(265,260),(248,248),(231,260),(211,248),(185,262),(158,243),(137,223),(124,195)],
[(129,157),(164,164),(194,157),(243,157),(266,162),(285,179),(293,184),(286,195),(297,207),(302,239),(299,272),(286,300),(263,324),(244,348),(229,333),(209,315),(190,307),(168,290),(148,265),(134,236),(122,200)],
[(131,157),(164,164),(194,157),(242,157),(263,159),(284,178),(292,184),(286,195),(298,206),(307,240),(306,270),(292,294),(278,317),(264,290),(252,272),(243,260),(235,286),(229,316),(212,304),(195,285),(177,280),(159,262),(140,235),(124,200)],
[(130,150),(161,150),(190,148),(239,149),(264,150),(281,169),(289,174),(280,182),(290,202),(292,230),(300,257),(298,288),(305,309),(298,331),(281,345),(268,324),(253,341),(238,355),(220,340),(207,320),(198,337),(181,346),(170,329),(162,306),(171,286),(161,267),(146,248),(132,224),(122,194)]
]
female_head=[
[(65,130),(100,80),(142,30),(216,18),(270,40),(295,75),(296,125),(284,143),(285,176),(271,201),(273,212),(260,223),(253,218),(270,176),(271,148),(266,118),(259,100),(247,86),(229,86),(214,94),(206,106),(193,117),(177,124),(172,140),(164,161),(152,173),(136,174),(135,195),(124,207),(112,204),(101,213),(95,225),(76,228),(59,232),(43,241),(21,248),(17,246),(31,230),(25,224),(40,213),(47,199),(72,189),(73,179),(82,172),(82,148)],
[(65,0),(290,0),(305,80),(295,138),(277,151),(275,121),(265,99),(252,90),(236,91),(218,106),(199,118),(180,126),(175,151),(163,169),(154,179),(144,182),(141,197),(123,191),(111,190),(105,178),(92,168),(92,137),(79,115),(68,89)],
[(0,0),(310,0),(316,180),(384,280),(365,275),(350,257),(338,259),(322,246),(311,240),(290,239),(277,232),(264,233),(246,225),(260,205),(271,196),(275,169),(268,137),(273,122),(267,102),(257,81),(239,82),(222,93),(211,105),(187,121),(172,126),(169,148),(164,170),(156,181),(149,199),(145,218),(127,224),(111,224),(100,233),(105,247),(78,238),(62,246),(50,254),(25,263),(0,280)],
[(55,0),(300,0),(306,123),(282,161),(273,155),(273,123),(263,98),(250,81),(237,75),(219,92),(203,111),(181,123),(166,131),(152,143),(145,157),(149,176),(145,194),(138,201),(134,194),(118,200),(100,189),(84,189),(78,180),(75,160),(80,146),(74,137),(78,115),(83,100),(85,78)],
[(40,0),(310,0),(313,230),(276,229),(269,216),(265,202),(272,182),(274,166),(268,146),(270,123),(264,101),(253,87),(238,88),(219,99),(204,113),(182,125),(175,138),(169,158),(167,178),(166,199),(166,211),(175,221),(169,229),(148,232),(136,222),(126,220),(114,225),(99,217),(83,222),(70,214),(59,205),(45,194),(45,151)]
]
braids=[
[(148,128),(172,124),(171,151),(165,163),(170,183),(161,202),(168,219),(164,238),(159,257),(165,279),(160,293),(144,301),(142,296),(154,286),(149,272),(143,260),(137,246),(141,229),(136,211),(141,193),(140,173),(145,160)],
[(149,146),(174,138),(173,163),(166,176),(174,194),(171,210),(173,223),(164,238),(150,245),(143,240),(154,231),(154,222),(143,212),(138,196),(143,180),(141,165)],
[(151,130),(176,124),(171,152),(167,172),(173,191),(165,209),(172,230),(179,244),(177,255),(165,268),(169,280),(177,288),(171,299),(156,307),(154,301),(166,294),(160,286),(151,279),(149,265),(156,253),(151,242),(145,227),(147,213),(146,197),(144,180),(149,163)],
[(100,180),(139,181),(153,195),(161,216),(171,224),(176,246),(183,251),(188,274),(185,289),(192,310),(188,334),(180,347),(190,351),(185,358),(170,357),(166,345),(151,347),(145,337),(159,336),(165,328),(164,318),(153,307),(142,293),(128,279),(129,259),(119,242),(116,225),(99,217),(84,206),(81,196)],
[]]
def shape(polys,holes=(),blur=.45):
 a=Image.new('L',(N,N));d=ImageDraw.Draw(a)
 for poly in polys:
  if poly:d.polygon([(round(x*4),round(y*4)) for x,y in poly],fill=255)
 for poly in holes:d.polygon([(round(x*4),round(y*4)) for x,y in poly],fill=0)
 return np.asarray(a.filter(ImageFilter.GaussianBlur(blur*4)).resize((TARGET,TARGET),Image.Resampling.LANCZOS),float)/255

def edge_matte(coverage,rgb,old_hair,old_skin):
 from sklearn.mixture import GaussianMixture
 from scipy.sparse import coo_matrix
 from scipy.sparse.csgraph import maximum_flow,breadth_first_order
 binary=coverage>.5
 nearby=binary_dilation(binary,iterations=12)
 binary|=old_hair&nearby
 # The traced contours are guides. Follow the actual painted boundaries in a
 # small uncertainty band, using both pigment and contrast along the edge.
 fg=binary_erosion(binary,iterations=7);bg=~binary_dilation(binary,iterations=9)
 hsv=np.asarray(Image.fromarray((rgb*255).astype('uint8')).convert('HSV'),float)/255
 ratio=rgb[:,:,2]/np.maximum(rgb[:,:,0],.001)
 complexion=binary_erosion(old_skin,iterations=3)&(ratio>.32)&(hsv[:,:,0]<.083)
 fg&=old_hair&~complexion;bg|=complexion
 warm=(rgb[:,:,0]>rgb[:,:,2]+.06)
 fseed=fg&old_hair&warm
 bseed=bg
 samples=rgb.reshape(-1,3);rng=np.random.default_rng(370)
 models=[]
 for selection in [fseed,bseed]:
  pixels=rgb[selection];pixels=pixels[rng.choice(len(pixels),min(12000,len(pixels)),replace=False)]
  model=GaussianMixture(6,reg_covar=.001,random_state=37,max_iter=80).fit(pixels)
  models.append(model.score_samples(samples).reshape(binary.shape))
 delta=np.clip(models[1]-models[0],-12,12)+(0.8-coverage*1.6)
 cf=np.maximum(delta,0)+.04;cb=np.maximum(-delta,0)+.04
 cf[fg]=0;cb[fg]=10000;cf[bg]=10000;cb[bg]=0
 h,w=binary.shape;n=h*w;idx=np.arange(n).reshape(h,w)
 rows=[];cols=[];data=[]
 def add(u,v,c):rows.append(np.ravel(u));cols.append(np.ravel(v));data.append(np.maximum(1,np.ravel(c)*100).astype(np.int64))
 add(np.full(n,n),idx,cb);add(idx,np.full(n,n+1),cf)
 for u,v,aa,bb in [(idx[:,:-1],idx[:,1:],rgb[:,:-1],rgb[:,1:]),(idx[:-1],idx[1:],rgb[:-1],rgb[1:])]:
  weight=5*np.exp(-np.sum((aa-bb)**2,2)/.024)+.03
  add(u,v,weight);add(v,u,weight)
 graph=coo_matrix((np.concatenate(data),(np.concatenate(rows),np.concatenate(cols))),shape=(n+2,n+2)).tocsr()
 flow=maximum_flow(graph,n,n+1,method='dinic')
 residual=graph-flow.flow;residual.eliminate_zeros()
 reached=breadth_first_order(residual,n,directed=True,return_predecessors=False)
 mask=np.zeros(n+2,np.uint8);mask[reached]=255
 return np.asarray(Image.fromarray(mask[:n].reshape(h,w)).filter(ImageFilter.GaussianBlur(.45)),float)/255

def shift(poly,dx=0,dy=0):return [(x+dx,y+dy) for x,y in poly]
left_brow=[(190,113),(201,108),(214,110),(229,115),(233,119),(232,124),(225,123),(212,118),(198,116),(189,120)]
right_brow=[(248,119),(257,114),(269,114),(274,119),(271,126),(262,124),(252,126)]
bands={1:[[(173,292),(184,288),(202,289),(205,294),(204,312),(208,316),(174,319),(170,314),(173,309)],[(264,293),(274,289),(290,290),(293,294),(293,311),(295,317),(263,321),(260,316)]],4:[[(173,268),(182,264),(199,265),(205,269),(205,286),(208,291),(174,292),(170,286)],[(223,272),(237,268),(253,271),(259,275),(259,290),(261,295),(224,297),(219,291)],[(269,274),(283,271),(296,275),(296,291),(301,296),(269,299),(264,293)]]}
for gender in range(2):
 for sculpt in range(5):
  ident=('female' if gender else 'male')+str(sculpt)
  src=Image.open(ROOT/'assets/portraits-v21'/f'{ident}.png').convert('RGBA').resize((TARGET,TARGET),Image.Resampling.LANCZOS);a=np.asarray(src)/255;r,g,b=a[:,:,:3].transpose(2,0,1)
  if not gender:
   support=[head,beards[sculpt]]
   if sculpt==1:support += [[(162,226),(203,226),(216,247),(210,272),(203,289),(204,319),(217,342),(215,372),(192,385),(170,369),(160,342),(170,320),(168,287),(162,258)],[(258,224),(282,223),(300,244),(300,271),(293,292),(297,321),(310,343),(305,368),(281,387),(260,375),(251,346),(263,317),(260,292),(251,274)]]
   if sculpt==2:support += [[(70,110),(120,150),(132,179),(117,199),(94,218),(68,224),(43,217),(49,204),(55,180),(59,156)]]
   face=male_face;ear=male_ear
   if sculpt==4:
    support[0]=[(52,70),(132,67),(159,75),(176,84),(174,106),(157,129),(154,160),(136,181),(113,187),(88,187),(69,167),(61,140)]
    face=[(176,96),(187,95),(237,95),(261,108),(262,127),(268,144),(264,153),(248,155),(231,150),(217,154),(202,158),(185,162),(173,170),(158,157),(154,141),(159,122)]
    ear=shift(male_ear,3,-10)
   if sculpt==3:support[0]=[(73,0),(290,0),(292,153),(145,191),(111,184),(106,148),(109,112),(80,102),(69,74)]
   hair=shape(support,[face,ear,[(206,191),(219,186),(234,186),(245,190),(241,196),(223,194),(212,198)]]+bands.get(sculpt,[]))
   lb=[(173,118),(182,108),(196,108),(210,113),(225,113),(228,123),(219,128),(207,122),(190,118),(178,125),(169,128)]
   rb=[(237,117),(249,111),(265,110),(271,118),(270,123),(257,124),(245,126),(237,125)]
   brows=shape([shift(lb,5,-8) if sculpt==4 else lb,shift(rb,0,-8) if sculpt==4 else rb])
   skin=shape([[(102,69),(264,67),(280,162),(266,183),(284,259),(248,302),(237,364),(214,324),(180,285),(135,253),(97,212),(117,178)],ear])
  else:
   ear=[(123,130),(130,126),(140,131),(150,142),(151,155),(144,169),(134,175),(124,168),(118,153),(117,140)]
   if sculpt==1:ear=shift(ear,3,3)
   if sculpt==3:ear=shift(ear,-2,-12)
   hair=shape([female_head[sculpt],braids[sculpt]],[ear])
   dx,dy=[(0,0),(8,4),(-3,-1),(-3,-4),(0,0)][sculpt]
   brows=shape([shift(left_brow,dx,dy),shift(right_brow,dx,dy)])
   skin=shape([[(118,77),(270,76),(291,132),(283,193),(250,229),(278,250),(284,280),(261,320),(239,361),(210,317),(185,283),(130,254),(104,224),(129,191),(119,173)],ear])
  # Warm source pigment follows anatomical coverage. Blue background and ink
  # remain untouched; no yellow/skin hue threshold creates holes inside hair.
  warmth=np.clip((r-b)*255/20,0,1)
  old=np.fromfile(ROOT/'assets/palette-v36'/f'{ident}-portrait.mask',np.uint8).reshape(384,384)
  old_hair=np.asarray(Image.fromarray(((old==1)*255).astype('uint8')).resize((TARGET,TARGET),Image.Resampling.NEAREST))>0
  old_skin=np.asarray(Image.fromarray(((old==3)*255).astype('uint8')).resize((TARGET,TARGET),Image.Resampling.NEAREST))>0
  hair=edge_matte(np.maximum(hair,brows),a[:,:,:3],old_hair,old_skin)*warmth
  hsv=np.asarray(src.convert('RGB').convert('HSV'),float)/255
  hue=hsv[:,:,0];ratio=b/np.maximum(r,.001)
  pigment=np.maximum(np.clip((hue-.075)/.018,0,1),np.clip((.31-ratio)/.10,0,1)*np.clip((hue-.025)/.03,0,1))
  hair=np.maximum(hair,brows*pigment*warmth)
  if gender and sculpt==4:
   yy,xx=np.indices(hair.shape);xx=xx*384/TARGET;yy=yy*384/TARGET
   enclosed=binary_fill_holes(hair>.5)&(hair<.5)
   hair[enclosed&(xx>184)&(xx<224)&(yy>87)&(yy<126)]=1
  if not gender and sculpt in bands:
   clasps=shape(bands[sculpt])
   nearby=binary_dilation(clasps>.1,iterations=4)
   old_metal=np.asarray(Image.fromarray(((old==5)*255).astype('uint8')).filter(ImageFilter.GaussianBlur(.35)).resize((TARGET,TARGET),Image.Resampling.LANCZOS),float)/255
   clasps=np.maximum(clasps,old_metal*nearby)
   hair*=1-clasps
  skin*=np.clip((r-g)*255/22,0,1)*np.clip((r-b)*255/35,0,1)*(1-hair)
  # Keep the natural skin/hair boundary on the painted line. Shirt tint uses
  # the existing garment selection with a narrow, continuous edge.
  old=np.fromfile(ROOT/'assets/palette-v36'/f'{ident}-portrait.mask',np.uint8).reshape(384,384)
  cloth=np.asarray(Image.fromarray(((old==4)*255).astype('uint8')).filter(ImageFilter.GaussianBlur(.45)).resize((TARGET,TARGET),Image.Resampling.LANCZOS),float)/255
  cloth*=np.clip(1-hair-skin,0,1)
  metal=np.asarray(Image.fromarray(((old==5)*255).astype('uint8')).resize((TARGET,TARGET),Image.Resampling.LANCZOS),float)/255
  if not gender:metal=np.maximum(metal,shape(bands.get(sculpt,[])))
  metal*=np.clip(1-hair-skin-cloth,0,1)
  weights=np.stack([hair,skin,cloth,metal],axis=-1);weights=refine(ident,src,np.clip(weights,0,1))
  src.save(OUT/f'{ident}.png');(OUT/f'{ident}.coverage').write_bytes((weights*255).round().astype('uint8').tobytes())
  # Compatibility labels expose the dominant material for diagnostics only.
  ids=np.array([1,3,4,5],np.uint8)[weights.argmax(2)];ids[weights.max(2)==0]=0
  (OUT/f'{ident}.mask').write_bytes(ids.tobytes())
  z=a.copy();target=np.array([40,41,54])/255;shade=np.clip(a[:,:,:3].max(2)/.82,0,1.22)
  z[:,:,:3]=a[:,:,:3]*(1-hair[:,:,None])+target*shade[:,:,None]*hair[:,:,None]
  Image.fromarray(np.clip(z*255,0,255).astype('uint8')).save(OUT/f'{ident}-review.png')
print('Compiled ten anatomically bounded portrait coverages')
