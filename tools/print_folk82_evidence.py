import base64
from pathlib import Path
for path in sorted(Path('test-results/ci/people').glob('*.png')):
 data=base64.b64encode(path.read_bytes()).decode()
 for i in range(0,len(data),2000):print('FOLK82_IMAGE',path.stem,data[i:i+2000])
