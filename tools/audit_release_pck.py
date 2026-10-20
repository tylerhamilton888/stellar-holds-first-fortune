from pathlib import Path,PurePosixPath
import struct,hashlib,json,collections
import argparse
parser=argparse.ArgumentParser(description="Validate and unpack an unencrypted Godot 4.4.1 PCK for local malware scanning.")
parser.add_argument("pck",type=Path);parser.add_argument("output",type=Path);parser.add_argument("inventory",type=Path)
parser.add_argument("--inventory-only",action="store_true",help="Verify every entry without creating an unpacked duplicate.")
args=parser.parse_args();p=args.pck;out=args.output;rows=[]
if not args.inventory_only:out.mkdir()
with p.open('rb') as f:
 magic,version,major,minor,patch,flags,base=struct.unpack('<6IQ',f.read(32));assert (magic,version,major,minor,patch,flags)==(0x43504447,2,4,4,1,0)
 f.seek(96);count=struct.unpack('<I',f.read(4))[0]
 for i in range(count):
  n=struct.unpack('<I',f.read(4))[0];name=f.read(n).rstrip(b'\0').decode();offset,size=struct.unpack('<QQ',f.read(16));md5=f.read(16);entry_flags=struct.unpack('<I',f.read(4))[0]
  assert entry_flags==0 and not PurePosixPath(name).is_absolute() and '..' not in PurePosixPath(name).parts and '\\' not in name
  assert name not in [r['path'] for r in rows]
  rows.append({'path':name,'offset':offset+base,'size':size,'md5':md5.hex()})
 for row in rows:
  assert row['offset']+row['size']<=p.stat().st_size
  f.seek(row['offset']);data=f.read(row['size']);assert hashlib.md5(data).hexdigest()==row['md5']
  if not args.inventory_only:
   target=out/row['path'];target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(data)
  row['sha256']=hashlib.sha256(data).hexdigest()
counts=collections.Counter(Path(r['path']).suffix for r in rows)
for row in rows:assert Path(row['path']).suffix not in ['.exe','.dll','.so','.bat','.cmd','.ps1','.py','.js','.vbs','.gdextension']
args.inventory.write_text(json.dumps({'count':count,'extensions':dict(counts),'files':rows},indent=2))
print('All PCK file hashes, bounds and relative paths verified',count);print(counts)
