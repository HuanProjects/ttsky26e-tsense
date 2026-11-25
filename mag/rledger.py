#!/usr/bin/env python3
"""rledger.py -- series resistance of the tile-level routes, from the route data in tw.py (the extraction is C only).
Every shape of a net counts as length / width squares of its layer in series (pads included), plus one via per stack
level (2 x 2 stacks: a quarter). An upper bound for a route with side branches. Sheet values: sky130 nominal.
Usage (in tt_tsense/mag): python3 rledger.py [tw.py] [net ...]"""
import collections, re, sys
src = open(sys.argv[1] if len(sys.argv) > 1 else "tw.py").read()
src = src[:src.index("# checks")].replace("import pya", "")
g = {}
exec(src, g)
RS = {"met1": 0.125, "met2": 0.125, "met3": 0.047, "met4": 0.047}
RV = {"via1": 4.5, "via2": 3.41, "via3": 3.41}
sq, lng, nv = collections.defaultdict(float), collections.defaultdict(float), collections.defaultdict(float)
for net, lay, x1, y1, x2, y2 in g["shapes"]:
    l, w = max(x2 - x1, y2 - y1), min(x2 - x1, y2 - y1)
    sq[net] += l / w * RS[lay]
    lng[(net, lay)] += l
for net, cut, x1, y1, x2, y2 in g["cuts"]:
    nv[net] += RV[cut] / (4 if (x2 - x1) > 0.5 else 1)
print("| net | length by layer (um) | wire (ohm) | vias (ohm) | total (ohm) |\n|---|---|---|---|---|")
for net in sys.argv[2:] or sorted(sq):
    ls = ", ".join("%s %.0f" % (lay, lng[(net, lay)]) for lay in RS if lng[(net, lay)] > 0.5)
    print("| %s | %s | %.1f | %.1f | %.1f |" % (net, ls, sq[net], nv[net], sq[net] + nv[net]))
