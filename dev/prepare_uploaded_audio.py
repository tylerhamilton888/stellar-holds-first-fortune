from pathlib import Path
import subprocess,json
import numpy as np
from scipy.io import wavfile
from scipy.signal import resample_poly
src=Path('upload');out=Path('stellar-holds/audio');records=[]
def read(name):
 sr,x=wavfile.read(src/(name+'.wav'));scale=32768 if x.dtype==np.int16 else 2147483648
 return sr,x.astype(np.float64)/scale
def clip(name,key,a,b,peak=.72):
 sr,x=read(name);x=x[int(a*sr):int(b*sr)];x=x.mean(axis=1) if x.ndim>1 else x
 # Remove pre-contact silence, retaining <=2ms before the first meaningful transient.
 threshold=max(abs(x))*.065;hits=np.flatnonzero(abs(x)>threshold)
 if len(hits):x=x[max(0,hits[0]-int(sr*.002)):]
 x-=x.mean();x*=peak/max(abs(x));fade=min(int(sr*.035),len(x)//6);x[-fade:]*=np.linspace(1,0,fade);x[:48]*=np.linspace(0,1,48)
 x=resample_poly(x,147,160);wavfile.write(out/(key+'.wav'),44100,(x*32767).astype(np.int16));records.append(dict(source=name,asset=key,start=a,end=b,duration=len(x)/44100))
for i,(a,b) in enumerate([(1.72,1.96),(2.065,2.35),(2.495,2.91),(9.465,9.73),(9.80,10.10),(10.19,10.59)]):clip('pickaxe sounds','pick_real_'+str(i),a,b)
for i,(a,b) in enumerate([(.12,.75),(5.16,5.7),(6.32,6.57)]):clip('digging dirt and gravel','dig_real_'+str(i),a,b)
for i,(a,b) in enumerate([(.81,1.25),(1.50,1.95),(6.84,7.08),(7.15,7.57)]):clip('dwarven walking','step_real_'+str(i),a,b,.55)
for i,(a,b) in enumerate([(.065,1.15),(10.65,11.8)]):clip('rock breaking','rubble_real_'+str(i),a,b,.65)
clip('ancient industrial door','door_real',.08,1.4,.65)
clip('ancient industrial door','door_close_real',7.18,8.1,.65)
# Continuous beds: equal-gain overlap of head and tail, seam falls in continuous source.
for name,key,a,b in [('quiet mountain air','air_real',1,12),('rune powered machinery','machine_real',1,12.5)]:
 sr,x=read(name);x=x[int(a*sr):int(b*sr)];n=sr
 f=np.linspace(0,1,n)[:,None];mix=x[-n:]*(1-f)+x[:n]*f;x=np.concatenate([x[n:-n],mix]);x-=x.mean(axis=0);x*=.45/max(abs(x).max(),.001)
 tmp=Path('tools/audio23')/(key+'.wav');wavfile.write(tmp,sr,(x*32767).astype(np.int16))
 subprocess.run(['ffmpeg','-v','error','-y','-i',str(tmp),'-c:a','libvorbis','-q:a','5',str(out/(key+'.ogg'))],check=True)
 records.append(dict(source=name,asset=key,start=a,end=b,crossfade=1))
for name,key in [('An Oath Beneath the Mountain','score_oath'),('Hearths of Keldrath','score_hold'),('Beneath the Roots of Stone','score_mine'),('The Road Beyond the Gate','score_road'),('ivar speech','ivar_voice')]:
 filters='loudnorm=I=-18:TP=-2:LRA=9' if key=='ivar_voice' else 'loudnorm=I=-20:TP=-2:LRA=11,afade=t=in:d=0.08'
 subprocess.run(['ffmpeg','-v','error','-y','-i',str(src/(name+'.wav')),'-af',filters,'-ar','44100','-c:a','libvorbis','-q:a','5',str(out/(key+'.ogg'))],check=True)
 records.append(dict(source=name,asset=key,processing=filters))
Path('stellar-holds/docs/audio23-sources.json').write_text(json.dumps(records,indent=2))
print('Prepared',len(records),'assets')
