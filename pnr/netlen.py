#!/usr/bin/env python3
"""netlen.py <block.def> [regex] : routed length (um) of every signal net in an OpenROAD DEF, per routing layer.
Prints the nets matching the regex (default: all) and a summary per group of ring nets."""
import re
import sys
from collections import defaultdict

text = open(sys.argv[1]).read()
pat = re.compile(sys.argv[2]) if len(sys.argv) > 2 else None
units = int(re.search(r"UNITS DISTANCE MICRONS (\d+)", text).group(1))
nets = text[text.index("\nNETS "):text.index("END NETS")]
out = {}
for blk in nets.split("\n    - ")[1:]:
    name = blk.split()[0]
    total = defaultdict(float)
    for m in re.finditer(r"(?:ROUTED|NEW) (\w+)(?: \d+)? \( ([-\d*]+) ([-\d*]+)(?: [-\d]+)? \)((?: \( [-\d*]+ [-\d*]+(?: [-\d]+)? \))*)", blk):
        lay, x, y, rest = m.group(1), m.group(2), m.group(3), m.group(4)
        px, py = int(x), int(y)
        for q in re.finditer(r"\( ([-\d*]+) ([-\d*]+)(?: [-\d]+)? \)", rest):
            qx = px if q.group(1) == "*" else int(q.group(1))
            qy = py if q.group(2) == "*" else int(q.group(2))
            total[lay] += (abs(qx - px) + abs(qy - py)) / units
            px, py = qx, qy
    out[name] = total
groups = defaultdict(list)
for name, t in sorted(out.items()):
    L = sum(t.values())
    if pat and pat.search(name):
        print(f"{name:28s} {L:7.2f} um  " + " ".join(f"{k}:{v:.1f}" for k, v in sorted(t.items())))
    g = re.match(r"(xring/x[npd])/r\d+$", name)
    if g:
        groups[g.group(1)].append(L)
for g, ls in sorted(groups.items()):
    print(f"GROUP {g}: {len(ls)} stage nets, mean {sum(ls)/len(ls):.2f} um, min {min(ls):.2f}, max {max(ls):.2f}")
