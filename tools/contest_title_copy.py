"""Update title copy in a Cottage Grounds source checkout or an exported Godot 4.4 token file."""
import struct
import sys
from pathlib import Path
COPY = {
    "Earn your mountain. Found your house.": "Stand for Thane of Stonebridge.",
    "KELDRATH  /  THE LOWER WORKS": "STONEBRIDGE  /  THE EAST ROAD",
    "BENEATH THE OLD KINGS\nThe mountain still remembers.": "THE CONTEST FOR THANE\nThe first names are already in the Ledger.",
    "NEW GAME · Meet the miners, make a room your own and earn your first wages. Choose a slot and create your Dwarf. Existing fortunes keep their progress.": "NEW GAME · Stand for Thane of Stonebridge. Skarrin leads the contest. Choose a slot and create your dwarf.",
}
def token(value):
    data = value.encode("utf-8")
    return struct.pack("<II", 4, len(data)) + data + bytes(-len(data) % 4)
def update(data, compiled):
    for old, new in COPY.items():
        a, b = (token(old), token(new)) if compiled else tuple(x.replace("\n", "\\n").encode() for x in (old, new))
        if data.count(a) != 1:
            raise ValueError("Unexpected title copy: " + old)
        data = data.replace(a, b)
    return data
if __name__ == "__main__":
    path = Path(sys.argv[1])
    path.write_bytes(update(path.read_bytes(), path.suffix == ".gdc"))
