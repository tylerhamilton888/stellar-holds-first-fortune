#!/usr/bin/env python3
"""Build one complete Windows ZIP using the pinned engine and unchanged official runtime."""
import argparse, hashlib, json, os, re, shutil, subprocess, sys, tempfile, zipfile
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]

def sha(path):
    with Path(path).open('rb') as stream:return hashlib.file_digest(stream,'sha256').hexdigest()

def metadata():
    return dict(re.findall(r'^const (\w+)="([^"]+)"', (ROOT/'scripts/build_info.gd').read_text(),re.M))

def command(engine,args,log):
    p=subprocess.run([engine,'--headless','--path',str(ROOT),*args],stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,timeout=900)
    log.write_text(p.stdout)
    errors=[line for line in p.stdout.splitlines() if ('SCRIPT ERROR:' in line or line.startswith('ERROR:'))
            and not re.search(r'ERROR: \d+ resources still in use at exit',line)]
    if p.returncode or errors:raise RuntimeError(f'Godot failed: see {log}')

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--godot',required=True)
    parser.add_argument('--windows-runtime',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True,help='New directory only')
    args=parser.parse_args(); info=metadata(); out=args.output.resolve()
    engine=str(Path(args.godot).resolve()) if Path(args.godot).exists() else args.godot
    actual=subprocess.check_output([engine,'--version'],text=True).strip()
    if not actual.startswith(info['ENGINE']+'.stable.'):raise RuntimeError('Wrong engine: '+actual)
    expected='b493c1d53fb915f7805f360cfe42d1c3126e720dfc234a4b0f2feb99200f9a4b'
    if sha(args.windows_runtime)!=expected:raise RuntimeError('Windows runtime does not match verified official 4.4.1 template')
    out.mkdir(parents=True,exist_ok=False)
    command(engine,['--editor','--import','--quit'],out/'import.log')
    command(engine,['--export-pack','Windows Desktop',str(out/'FirstFortune.pck')],out/'export.log')
    subprocess.run([sys.executable,str(ROOT/'tools/audit_release_pck.py'),str(out/'FirstFortune.pck'),str(out/'unused'),str(out/'pck-inventory.json'),'--inventory-only'],check=True)
    shutil.copyfile(args.windows_runtime,out/'FirstFortune.exe')
    for name in ['GODOT-LICENSE.txt','GODOT-COPYRIGHT.txt']:shutil.copyfile(ROOT/'tools/licenses'/name,out/name)
    commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip()
    dirty=bool(subprocess.check_output(['git','status','--porcelain','--untracked-files=no'],cwd=ROOT,text=True))
    (out/'version.txt').write_text(f"{info['VERSION']}\nSource: {commit}\nTracked changes: {dirty}\nEngine: {actual}\n")
    (out/'START-HERE.txt').write_text('Extract every file into a new folder. Run FirstFortune.exe beside FirstFortune.pck. Existing save locations are preserved.\n')
    files=['FirstFortune.exe','FirstFortune.pck','GODOT-LICENSE.txt','GODOT-COPYRIGHT.txt','version.txt','START-HERE.txt']
    hashes={name:sha(out/name) for name in files}
    (out/'FILE-HASHES.sha256').write_text(''.join(f'{digest}  {name}\n' for name,digest in hashes.items()))
    archive=out/f"Stellar-Holds-First-Fortune-{info['VERSION']}-Windows.zip"
    # Stable member order/timestamps; repeatable packaging from the same bytes.
    with zipfile.ZipFile(archive,'x',compression=zipfile.ZIP_DEFLATED,compresslevel=6) as z:
        for name in files+['FILE-HASHES.sha256']:
            entry=zipfile.ZipInfo(name,(2020,1,1,0,0,0));entry.compress_type=zipfile.ZIP_DEFLATED
            with z.open(entry,'w',force_zip64=True) as dest,(out/name).open('rb') as source:shutil.copyfileobj(source,dest)
    with zipfile.ZipFile(archive) as z:
        if z.testzip() is not None:raise RuntimeError('ZIP integrity failure')
    report=dict(version=info['VERSION'],commit=commit,dirty=dirty,engine=actual,files=hashes,zip_sha256=sha(archive),zip_bytes=archive.stat().st_size)
    (out/'build.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))
if __name__=='__main__':main()
