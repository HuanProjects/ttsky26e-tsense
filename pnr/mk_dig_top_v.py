#!/usr/bin/env python3
"""mk_dig_top_v.py > dig_top.v : the dig_top block = readout_glue + ring3 in one module, from readout_glue.v and
ring3.v (spice2v.py output). ring_en (readout_glue's output, ring3's input) stays inside; every other port of the
two cells becomes a port of dig_top, in the order the tile wiring uses."""
import re

ORDER = (["ui%d" % i for i in range(8)]
         + ["rst", "cmp_raw", "su", "osc_en", "osc_enb", "thr_sel", "thr_selb", "vref_mon_en", "vref_mon_enb",
            "iptat_mon_en", "iptat_mon_enb", "ich_sel", "chop_sel", "i3_sel"]
         + ["uo%d" % i for i in range(8)] + ["uio_out%d" % i for i in range(8)] + ["uio_oe%d" % i for i in range(8)])
INTERNAL = {"ring_en"}


def ports(path, mod):
    t = open(path).read()
    m = re.search(r"module %s \(([^)]*)\);(.*?)endmodule" % mod, t, re.S)
    names = [p.strip() for p in m.group(1).split(",")]
    dirs = dict((n, d) for d, n in re.findall(r"^\s*(input|output|inout) (\S+);", m.group(2), re.M))
    return names, dirs


g, gd = ports("readout_glue.v", "readout_glue")
r, rd = ports("ring3.v", "ring3")
top = [p for p in g if p not in INTERNAL] + [p for p in r if p not in INTERNAL and p not in g]
assert sorted(ORDER) == sorted(top), set(ORDER) ^ set(top)
d = dict(gd)
d.update(rd)
out = [open("readout_glue.v").read(), open("ring3.v").read(),
       "// dig_top: readout_glue and ring3 placed and routed as one block; ring_en stays inside.",
       "module dig_top (%s);" % ", ".join(ORDER)]
out += ["  %s %s;" % (d[p], p) for p in ORDER]
out.append("  wire ring_en;")
out.append("  readout_glue xglue (%s);" % ", ".join(".%s(%s)" % (p, p) for p in g))
out.append("  ring3 xring (%s);" % ", ".join(".%s(%s)" % (p, p) for p in r))
out.append("endmodule\n")
print("\n".join(out))
