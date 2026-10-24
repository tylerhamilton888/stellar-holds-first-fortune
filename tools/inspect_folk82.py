import json,base64,io
from pathlib import Path
from PIL import Image,ImageDraw
m=json.loads(Path("assets/whole-v58/frames.json").read_text())
m.update(json.loads(Path("assets/appearance74/frames.json").read_text()))
for gender in ["male","female"]:
 board=Image.new("RGB",(1440,7*150),(40,48,48)); draw=ImageDraw.Draw(board)
 for sculpt in range(7):
  for col in range(12):
   sheet=gender+str(sculpt)+("-core" if col<4 else "-utility")
   index=20+col if col<4 else col-4
   entry=m[sheet][index]; source=entry.get("source",sheet)
   path=source.replace("res://","") if source.startswith("res://") else "assets/whole-v58/"+source+".png"
   r=entry["rect"]; img=Image.open(path).convert("RGBA").crop((r[0],r[1],r[0]+r[2],r[1]+r[3]))
   img.thumbnail((118,126));board.paste(img,(col*120+(120-img.width)//2,sculpt*150+20),img)
   draw.text((col*120+2,sculpt*150+2),f"{gender}{sculpt} {index}",fill="white")
   print("PICK_SOURCE",sheet,index,json.dumps(entry))
 out=io.BytesIO();board.save(out,format="PNG");b64=base64.b64encode(out.getvalue()).decode()
 for i in range(0,len(b64),2000):print("FOLK82_IMAGE",gender,b64[i:i+2000])
