# add_waffledrop.py -- keep the shuttle's metal fill off the matched arrays.
#   klayout -b -r add_waffledrop.py -rd gds=<in.gds> -rd out=<out.gds>
#           [-rd cells=bg_pnp_arr,bg_rrow_arr,bg_mirror_arr] [-rd mets=1,2,3,4] [-rd margin=0.4]
# For every placement of the named array cells (anywhere in the hierarchy, any rotation) it takes the placement's
# bounding box and draws it in the TOP cell on the sky130 fill-block ("waffleDrop") layers:
#   cmm1.waffleDrop 62/24, cmm2.waffleDrop 105/52, cmm3.waffleDrop 107/24, cmm4.waffleDrop 112/4.
# Not met5 (the shuttle needs it for power distribution) and not the *.blockage layers (TinyTapeout's answer).
# On each layer the design's own metal of that layer, grown by <margin> um (default 0.4: the widest wide-metal spacing, met3.3d), is cut out of the box: Magic reads a
# waffleDrop shape as its obstruction type (obsm1..4), which shares a plane with the real metal, and its DRC
# ("Can't overlap those layers") rejects any overlap of the two. Own metal keeps fill away by itself.
# The boxes are not in the .mag cells: Magic's default GDS style writes obsm1..4 to the blockage layers (68/98 ...).
import pya

WD = {1: (62, 24), 2: (105, 52), 3: (107, 24), 4: (112, 4)}
MET = {1: (68, 20), 2: (69, 20), 3: (70, 20), 4: (71, 20)}
try:
    names = cells.split(",")
except NameError:
    names = ["bg_pnp_arr", "bg_rrow_arr", "bg_mirror_arr"]
try:
    mets_l = [int(v) for v in str(mets).split(",")]
except NameError:
    mets_l = [1, 2, 3, 4]
try:
    marg = float(margin)
except NameError:
    marg = 0.4

ly = pya.Layout()
ly.read(gds)
top = ly.top_cell()
dbu = ly.dbu
boxes = []


def walk(cell, trans):
    for inst in cell.each_inst():
        t = trans * pya.ICplxTrans(inst.cplx_trans)
        child = inst.cell
        if child.name in names:
            boxes.append((child.name, child.bbox().transformed(t)))
        else:
            walk(child, t)


if top.name in names:
    boxes.append((top.name, top.bbox()))
else:
    walk(top, pya.ICplxTrans())
if not boxes:
    raise RuntimeError("none of %s found under %s" % (names, top.name))
boxreg = pya.Region()
for nm, b in boxes:
    boxreg.insert(b)
    print("WAFFLEDROP %-14s x %.3f..%.3f  y %.3f..%.3f um  (%.0f um2)" % (
        nm, b.left * dbu, b.right * dbu, b.bottom * dbu, b.top * dbu, b.width() * b.height() * dbu * dbu))
boxreg.merge()
for n in mets_l:
    own = pya.Region()
    idx = ly.find_layer(*MET[n])
    if idx is not None:
        own = pya.Region(top.begin_shapes_rec(idx))
    own.merge()
    drop = boxreg - own.sized(int(round(marg / dbu)))
    # slivers narrower than 0.3 um cannot hold a fill square anyway and only add shapes: drop them
    drop = drop.sized(-150).sized(150) & drop
    drop.merge()
    rects = drop.decompose_trapezoids_to_region()
    li = ly.layer(*WD[n])
    top.shapes(li).insert(rects)
    print("WAFFLEDROP met%d: %.0f um2 blocked (%.0f %% of the boxes), %d rectangles on %d/%d" % (
        n, drop.area() * dbu * dbu, 100.0 * drop.area() / boxreg.area(), rects.count(), WD[n][0], WD[n][1]))
ly.write(out)
