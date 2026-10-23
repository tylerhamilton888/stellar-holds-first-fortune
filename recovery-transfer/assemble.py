import hashlib,json,os,pathlib,subprocess
stage=pathlib.Path.cwd()
m=json.loads((stage/'recovery-transfer/manifest.json').read_text())
root=pathlib.Path(os.environ['RUNNER_TEMP'])/'royal-source'
subprocess.run(['git','worktree','add','--detach',str(root),m['base']],check=True)
for item in m['files']:
    p=pathlib.PurePosixPath(item['path'])
    assert not p.is_absolute() and '..' not in p.parts
    data=b''.join((stage/part).read_bytes() for part in item['parts'])
    assert hashlib.sha256(data).hexdigest()==item['sha256'],str(p)
    target=root/p;target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(data)
subprocess.run(['git','add','--',*[item['path'] for item in m['files']]],cwd=root,check=True)
tree=subprocess.check_output(['git','write-tree'],cwd=root,text=True).strip()
assert tree==m['tree'],(tree,m['tree'])
subprocess.run(['git','config','user.name','Stellar Holds build'],cwd=root,check=True)
subprocess.run(['git','config','user.email','41898282+github-actions[bot]@users.noreply.github.com'],cwd=root,check=True)
commit=subprocess.check_output(['git','commit-tree',tree,'-p',m['base'],'-m','Complete recovered royal hall and grounded Keldrath update'],cwd=root,text=True).strip()
branch='refs/heads/feature/royal79-recovered'
assert not subprocess.check_output(['git','ls-remote','origin',branch],cwd=root,text=True).strip(),'Recovery target already exists'
subprocess.run(['git','push','origin',commit+':'+branch],cwd=root,check=True)
receipt={'commit':commit,'tree':tree,'base':m['base'],'files_verified':len(m['files'])}
(stage/'recovery-receipt.json').write_text(json.dumps(receipt,indent=2))
print(json.dumps(receipt))
with open(os.environ['GITHUB_STEP_SUMMARY'],'a') as f:f.write('Verified recovered source: '+commit+'\nTree: '+tree+'\n')
