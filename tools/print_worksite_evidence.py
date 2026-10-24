"""Keep a small, readable-by-tools visual record even when artifact storage is full."""
import base64
from pathlib import Path
for name in ("00-offer", "00-briefing", "01-lift", "04-worksite-journal"):
    path = Path("test-results/ci/firstshift") / (name + ".png")
    if not path.exists():
        continue
    data = base64.b64encode(path.read_bytes()).decode("ascii")
    for offset in range(0, len(data), 2000):
        print("WORKSITE81_IMAGE " + name + " " + data[offset:offset+2000])
