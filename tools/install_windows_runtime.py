#!/usr/bin/env python3
"""Fetch only the official 4.4.1 Windows release template; verify before saving."""
import hashlib, io, sys, urllib.request, zipfile
from pathlib import Path

URL = 'https://github.com/godotengine/godot-builds/releases/download/4.4.1-stable/Godot_v4.4.1-stable_export_templates.tpz'
SIZE = 1206040900
SHA256 = 'b493c1d53fb915f7805f360cfe42d1c3126e720dfc234a4b0f2feb99200f9a4b'

class OfficialArchive(io.RawIOBase):
    """Read the ZIP directory and one member without downloading unrelated platforms."""
    def __init__(self): self.position = 0
    def seekable(self): return True
    def readable(self): return True
    def tell(self): return self.position
    def seek(self, offset, whence=0):
        self.position = offset + (0 if whence == 0 else self.position if whence == 1 else SIZE)
        return self.position
    def read(self, count=-1):
        count = min(count if count >= 0 else SIZE-self.position, SIZE-self.position)
        if count <= 0: return b''
        request = urllib.request.Request(URL, headers={'Range': f'bytes={self.position}-{self.position+count-1}'})
        with urllib.request.urlopen(request, timeout=120) as response:
            if response.status != 206: raise RuntimeError('Official archive does not support range reads')
            data = response.read()
        if len(data) != count: raise RuntimeError('Incomplete official archive response')
        self.position += len(data)
        return data

def main():
    output = Path(sys.argv[1]).resolve()
    if output.exists():
        data = output.read_bytes()
    else:
        with zipfile.ZipFile(OfficialArchive()) as archive:
            data = archive.read('templates/windows_release_x86_64.exe')
    if hashlib.sha256(data).hexdigest() != SHA256: raise RuntimeError('Official Windows runtime checksum mismatch')
    output.parent.mkdir(parents=True, exist_ok=True)
    if not output.exists(): output.write_bytes(data)
    print(output)

if __name__ == '__main__': main()
