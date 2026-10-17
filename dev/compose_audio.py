"""Original Stellar Holds score and foley. Deterministic synthesis, no samples.
Run with Python + numpy + scipy. Output: ../audio/*.wav, PCM16/22050Hz.
"""
from pathlib import Path
import numpy as np
from scipy.signal import butter, sosfilt
import wave
OUT=Path(__file__).resolve().parents[1]/'audio'
OUT.mkdir(exist_ok=True)
SR=22050
rng=np.random.default_rng(7408)
def filt(x,hz,kind='lowpass'):
 return sosfilt(butter(2,hz,kind,fs=SR,output='sos'),x)
def noise(n):return rng.normal(0,1,n)
def put(dst,src,at,pan=0,wrap=False):
 if dst.ndim==2 and src.ndim==1:src=src[:,None]*np.array([np.sqrt((1-pan)/2),np.sqrt((1+pan)/2)])
 start=int(at*SR)
 if wrap:
  ix=(np.arange(len(src))+start)%len(dst)
  np.add.at(dst,ix,src)
 else:
  count=min(len(src),len(dst)-start)
  if count>0:dst[start:start+count]+=src[:count]
def save(name,x,peak=.8):
 x=x-np.mean(x,axis=0);m=np.max(np.abs(x))
 if m>peak:x=x*(peak/m)
 if x.ndim==1:
  fade=min(150,len(x)//8);x[:fade]*=np.linspace(0,1,fade);x[-fade:]*=np.linspace(1,0,fade)
 with wave.open(str(OUT/(name+'.wav')),'wb') as w:
  w.setnchannels(1 if x.ndim==1 else 2);w.setsampwidth(2);w.setframerate(SR);w.writeframes((x*32767).astype('<i2').tobytes())
def tone(freq,dur,decay=.8):
 t=np.arange(int(SR*dur))/SR
 return (np.sin(2*np.pi*freq*t)+.28*np.sin(2*np.pi*freq*2.003*t)+.12*np.sin(2*np.pi*freq*3.01*t))*np.exp(-t/decay)*(1-np.exp(-t/.006))
# Layered impact: attack, resonant body, grit, little secondary chips.
materials={'stone':(145,900,.17),'earth':(80,400,.09),'metal':(270,1600,.25),'coal':(105,700,.12),'crystal':(680,2600,.4)}
for material,(base,cut,decay) in materials.items():
 for variant in range(3):
  t=np.arange(int(.65*SR))/SR
  x=.36*tone(base*rng.uniform(.93,1.07),.65,decay)
  x+=filt(noise(len(t)),cut)*np.exp(-t/.032)*.8
  x+=filt(noise(len(t)),2800)*np.exp(-t/.13)*.13
  if material in ('metal','crystal'):
   for mult,amp in [(2.71,.15),(4.13,.08)]:x+=tone(base*mult,.65,decay*.8)*amp
  for at in [.065,.12,.20]:
   chip=filt(noise(int(.055*SR)),1800)*np.exp(-np.arange(int(.055*SR))/SR/.015)*.13
   put(x,chip,at+rng.uniform(0,.025))
  save(material+'_'+str(variant),x)
for material,base in [('rock',110),('earth',65),('crystal',470)]:
 t=np.arange(int(.95*SR))/SR;x=np.zeros(len(t))
 for at in [0,.035,.083,.15,.23,.36,.51]:
  n=int(.22*SR);tt=np.arange(n)/SR
  chip=filt(noise(n),1400 if material!='earth' else 550)*np.exp(-tt/.045)*(.65-at*.5)
  chip+=tone(base*rng.uniform(.7,1.5),.22,.075)*.25
  put(x,chip,at)
 if material=='crystal':x+=tone(940,.95,.26)*.22
 save('break_'+material,x)
for surface,hz in [('stone',800),('wood',450),('gravel',1800)]:
 for v in range(3):
  t=np.arange(int(.24*SR))/SR
  x=filt(noise(len(t)),hz)*np.exp(-t/.035)*.37+tone(90+v*12,.24,.025)*.25
  save('step_'+surface+'_'+str(v),x,.65)
t=np.arange(int(.24*SR))/SR
save('swing',filt(noise(len(t)),2400)*np.sin(np.pi*t/.24)**2*.13)
save('pickup',tone(510,.3,.045)*.14+tone(770,.3,.055)*.07)
save('door',tone(72,.7,.12)*.6+filt(noise(int(.7*SR)),500)*np.exp(-np.arange(int(.7*SR))/SR/.14)*.45)
save('latch',tone(620,.22,.03)*.2+filt(noise(int(.22*SR)),2000)*np.exp(-np.arange(int(.22*SR))/SR/.025)*.25)
save('winch',tone(145,.32,.1)*.16)
save('quest',sum(tone(f,.95,.3)*.15 for f in [220,330,440,550]))
# 64-second, 24-bar original modal score: plucked strings, bowed drone, breath flute.
# 90 BPM, 4/4, eight-bar phrase repeated with variation; tails wrap into loop.
beat=2/3;duration=64
motif=[(0,62,2),(2,65,1),(3,67,1),(4,69,3),(7,67,1),(8,65,2),(10,64,2),(12,62,4),
       (16,57,2),(18,62,2),(20,65,3),(23,64,1),(24,60,2),(26,57,2),(28,62,4)]
def hz(m):return 440*2**((m-69)/12)
for name,mode in [('mountain_oath','hold'),('beneath_the_roots','mine'),('hearth_and_hammer','room')]:
 track=np.zeros((int(duration*SR),2))
 for bar in range(24):
  chord=[(38,45,50),(36,43,48),(41,48,53),(38,45,50)][(bar//2)%4]
  for j,m in enumerate(chord):
   length=4*beat+1.4;t=np.arange(int(length*SR))/SR
   env=np.minimum(t/.7,1)*np.minimum((length-t)/1.3,1)
   bowed=(np.sin(2*np.pi*hz(m)*t)+.14*np.sin(2*np.pi*hz(m)*2*t))*.028*env
   put(track,bowed,bar*4*beat,(-.35,0,.35)[j],True)
  if mode!='mine':
   for k in range(4):
    m=chord[[0,1,2,1][k]]+12
    put(track,tone(hz(m),1.7,.45)*(.10 if mode=='room' else .065),(bar*4+k)*beat,(-.4 if k%2 else .4),True)
  if mode=='hold':
   put(track,tone(64,.35,.07)*.065,bar*4*beat,0,True)
 for phrase in range(3):
  for at,m,length in motif:
   if mode=='mine' and at%4:continue
   dur=length*beat*.85;t=np.arange(int(dur*SR))/SR
   env=np.minimum(t/.09,1)*np.minimum((dur-t)/.2,1)
   f=hz(m+(12 if phrase==1 and mode=='hold' else 0))
   phase=2*np.pi*f*t+.025*np.sin(2*np.pi*4.7*t)
   flute=(np.sin(phase)+.10*np.sin(phase*2))*.09*env
   put(track,flute,(phrase*32+at)*beat,.15,True)
 # Soft room reflections, no discontinuity on loop.
 track+=np.roll(track,int(.23*SR),axis=0)[:,::-1]*.16+np.roll(track,int(.41*SR),axis=0)*.09
 save(name,track,.6)
# Seamless ambience, noise generated with wrap-safe filtering and circular events.
for name in ['hall','mine','road','hearth','forge','study']:
 length=24;n=int(length*SR);t=np.arange(n)/SR
 raw=noise(n);bed=filt(np.tile(raw,3),250)[n:2*n]
 x=np.zeros((n,2))
 level={'hall':.05,'mine':.025,'road':.08,'hearth':.018,'forge':.045,'study':.016}[name]
 wind=bed*level*(.7+.3*np.sin(2*np.pi*t/length))
 x+=wind[:,None]
 if name in ['hall','forge','study']:
  for f in [55,110,165]:x+=np.sin(2*np.pi*f*t)[:,None]*.006
 if name in ['hearth','forge']:
  for i in range(85):
   tt=np.arange(int(.035*SR))/SR
   crack=filt(noise(len(tt)),1800)*np.exp(-tt/.007)*rng.uniform(.025,.09)
   put(x,crack,rng.uniform(0,length),rng.uniform(-.7,.7),True)
 if name=='mine':
  for at in [1.3,5.8,9.2,14.6,21.4]:
   drop=tone(rng.uniform(900,1500),.45,.055)*.055
   put(x,drop,at,-.4,True);put(x,drop*.28,at+.24,.5,True)
 if name=='road':
  for at in [4.2,12.7,20.4]:
   tt=np.arange(int(.35*SR))/SR
   bird=np.sin(2*np.pi*(1400*tt+600*tt**2))*np.sin(np.pi*tt/.35)**2*.025
   put(x,bird,at,.6,True)
 save('amb_'+name,x,.5)
print('Synthesized original score, ambience, and foley.')
