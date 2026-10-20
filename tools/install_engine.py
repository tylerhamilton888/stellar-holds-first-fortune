#!/usr/bin/env python3
"""Fetch the pinned official Linux editor for CI; verify before extraction/execution."""
import hashlib,sys,urllib.request,zipfile
from pathlib import Path
out=Path(sys.argv[1]).resolve();out.mkdir(parents=True,exist_ok=True)
name='Godot_v4.4.1-stable_linux.x86_64'
archive=out/(name+'.zip')
expected='ef4e76880a514257175544952c61191106fdef3095b909bafed9fcbeb230c3e5533920a0f3012882dd4bbde83028a67549825794e2d2c3cf76eba7918b71370e'
if not archive.exists():urllib.request.urlretrieve('https://github.com/godotengine/godot-builds/releases/download/4.4.1-stable/'+archive.name,archive)
with archive.open('rb') as stream:actual=hashlib.file_digest(stream,'sha512').hexdigest()
if actual!=expected:raise SystemExit('Official engine checksum mismatch')
with zipfile.ZipFile(archive) as z:
    (out/name).write_bytes(z.read(name))
(out/name).chmod(0o755)
print(out/name)
