#!/usr/bin/env python3
"""Portable, isolated smoke suite. No third-party Python packages required."""
import argparse,json,os,re,subprocess,tempfile,time
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--godot',required=True);p.add_argument('--skip-import',action='store_true');a=p.parse_args()
root=Path(__file__).resolve().parents[1];out=root/'test-results';out.mkdir(exist_ok=True)
engine=str(Path(a.godot).resolve()) if Path(a.godot).exists() else a.godot
cases=['continuity_smoke','test_slots25','test_granular','test_controller20','test_opening39','test_outpost29','test_industry30']
results=[]
with tempfile.TemporaryDirectory(prefix='stellar-smoke-') as tmp:
 env=os.environ.copy();env['XDG_DATA_HOME']=tmp;env['APPDATA']=tmp;env['LOCALAPPDATA']=tmp
 jobs=[] if a.skip_import else [('import',['--editor','--import','--quit'])]
 jobs+=[('title_boot',['--quit-after','3'])]+[(c,['--script','res://tests/'+c+'.gd']) for c in cases]
 for name,args in jobs:
  started=time.monotonic()
  try:
   r=subprocess.run([engine,'--headless','--path',str(root),*args],env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,timeout=240)
   text=r.stdout;code=r.returncode
  except subprocess.TimeoutExpired as e:
   text=str(e.stdout or '')+'\nTIMEOUT';code=-1
  (out/(name+'.log')).write_text(text)
  errors=[line for line in text.splitlines() if ('SCRIPT ERROR:' in line or line.startswith('ERROR:')) and not re.search(r'ERROR: \d+ resources still in use at exit',line)]
  result={'test':name,'passed':code==0 and not errors,'exit_code':code,'seconds':round(time.monotonic()-started,2),'errors':errors,'teardown_warning':'resources still in use at exit' in text or 'ObjectDB instances leaked' in text,'summary':[l for l in text.splitlines() if re.search(r'(SMOKE:|SLOTS25:|GRANULAR|CONTROLLER|OPENING39:|OUTPOST29:|INDUSTRY30:)',l)]}
  results.append(result);print(name, 'PASS' if result['passed'] else 'FAIL',flush=True)
  if name=='import' and not result['passed']:break
(out/'smoke-results.json').write_text(json.dumps(results,indent=2))
raise SystemExit(0 if all(r['passed'] for r in results) else 1)
