"""One-off post-publication identity check for the worker-route delivery."""
import hashlib,json,os,urllib.request
from output_safety import emit

REPO="tylerhamilton888/stellar-holds-first-fortune"
SOURCE="9bd7d68c2fbe9dbc8996ca5a426bda78304d2bd0"
request=urllib.request.Request("https://api.github.com/repos/"+REPO+"/releases/tags/v0.111.0",
 headers={"Authorization":"Bearer "+os.environ["GH_TOKEN"],"Accept":"application/vnd.github+json"})
with urllib.request.urlopen(request,timeout=30) as response:
 release=json.load(response)
assert release["tag_name"]=="v0.111.0" and not release["draft"] and not release["prerelease"]
assert release["target_commitish"]==SOURCE
assets={a["name"]:a for a in release["assets"]}
names=["build.json","release-summary.json","Stellar-Holds-First-Fortune-0.111.0-Windows.zip","verification-evidence.tar.gz"]
assert all(n in assets and assets[n]["state"]=="uploaded" and assets[n]["size"]>0 for n in names)
def document(name):
 with urllib.request.urlopen(assets[name]["browser_download_url"],timeout=30) as response:
  raw=response.read(16385)
 assert len(raw)<=16384 and len(raw)==assets[name]["size"]
 assert assets[name]["digest"]=="sha256:"+hashlib.sha256(raw).hexdigest()
 return json.loads(raw)
build=document("build.json");receipt=document("release-summary.json")
archive=assets[names[2]]
assert build["version"]==receipt["version"]=="0.111.0"
assert build["commit"]==receipt["source_sha"]==SOURCE and not build["dirty"] and receipt["passed"] is True
assert build["files"]["FirstFortune.pck"]==receipt["pack_sha256"]
assert build["zip_sha256"]==receipt["zip_sha256"]
assert archive["size"]==build["zip_bytes"] and archive["digest"]=="sha256:"+build["zip_sha256"]
assert receipt["cases"]==76 and receipt["shards"]==4 and receipt["assertions"]>0
emit("PUBLISHED160 "+json.dumps(dict(version=build["version"],source=SOURCE,
 zip_sha256=build["zip_sha256"],zip_bytes=build["zip_bytes"],pack_sha256=receipt["pack_sha256"],
 cases=receipt["cases"],assertions=receipt["assertions"],json_digests_verified=True),separators=(",",":")))
