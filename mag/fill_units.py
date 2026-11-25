# fill_units.py -- used by fillcheck.sh:  klayout -b -r fill_units.py -rd gds=<cell gds> -rd fill=<fill gds> -rd kind=res|mos|pnp [-rd png=<out.png>]
# For every matched unit: how much floating fill sits right above it, per metal layer.
import pya

FILL = [("li1", (56, 28)), ("met1", (36, 28)), ("met2", (41, 28)), ("met3", (34, 28)), ("met4", (51, 28)), ("met5", (59, 28))]
DRAWN = {"li1": (67, 20), "met1": (68, 20), "met2": (69, 20), "met3": (70, 20), "met4": (71, 20), "met5": (72, 20)}


def reg(ly, top, l, d):
    idx = ly.find_layer(l, d)
    r = pya.Region()
    if idx is not None:
        r = pya.Region(top.begin_shapes_rec(idx))
    r.merge()
    return r


ly = pya.Layout()
ly.read(gds)
top = ly.top_cell()
dbu = ly.dbu
lf = pya.Layout()
lf.read(fill)
ftop = lf.top_cell()

poly = reg(ly, top, 66, 20)
diff = reg(ly, top, 65, 20)
if kind == "res":
    units = reg(ly, top, 66, 13)            # poly resistor id = the resistor bodies
    if units.count() == 0:
        units = poly & reg(ly, top, 86, 20)  # fallback: poly under rpm
elif kind == "mos":
    units = poly & diff                      # channels
else:
    units = pya.Region()
    for p in diff.each():                    # emitters: the small square diffusions
        b = p.bbox()
        if b.width() * dbu < 4.0 and b.height() * dbu < 4.0 and p.area() > 0.9 * b.area():
            units.insert(p)
    units = units.sized(0)

ulist = sorted([p for p in units.each()], key=lambda p: (round(p.bbox().center().y * dbu, 1), p.bbox().center().x))
print("%s: %d units, first unit %.2f x %.2f um" % (top.name, len(ulist),
      ulist[0].bbox().width() * dbu, ulist[0].bbox().height() * dbu))
print("%-6s %28s %28s" % ("layer", "FILL above a unit, % of its area", "OWN metal above a unit, %"))
print("%-6s %8s %8s %8s   %8s %8s %8s" % ("", "min", "mean", "max", "min", "mean", "max"))
for name, (l, d) in FILL:
    fr = reg(lf, ftop, l, d)
    dr = reg(ly, top, *DRAWN[name])
    fv = []
    dv = []
    for p in ulist:
        ur = pya.Region(p)
        ua = ur.area()
        fv.append(100.0 * (fr & ur).area() / ua)
        dv.append(100.0 * (dr & ur).area() / ua)
    print("%-6s %8.1f %8.1f %8.1f   %8.1f %8.1f %8.1f" % (
        name, min(fv), sum(fv) / len(fv), max(fv), min(dv), sum(dv) / len(dv), max(dv)))
    if name == "met1":
        print("       per-unit met1 fill %: " + " ".join("%.0f" % v for v in fv))

try:
    out = png
except NameError:
    out = None
if out:
    # one layout holding the cell and the fill, drawn with a few layers only
    lm = pya.Layout()
    lm.dbu = dbu
    t = lm.create_cell("VIEW")
    def put(region, l, d):
        t.shapes(lm.layer(l, d)).insert(region)
    put(units, 1, 0)
    put(reg(ly, top, 68, 20), 2, 0)
    put(reg(lf, ftop, 36, 28), 3, 0)
    lv = pya.LayoutView()
    lv.show_layout(lm, False)
    lv.set_config("background-color", "#ffffff")
    lv.set_config("grid-visible", "false")
    lv.set_config("text-visible", "false")
    it = lv.begin_layers()
    styles = {1: (0xb8c4d6, 0xb8c4d6, 0), 2: (0x2a6fdb, 0x2a6fdb, 0), 3: (0xe0662b, 0xe0662b, 0)}
    while not it.at_end():
        lp = it.current()
        st = styles.get(lp.source_layer)
        if st:
            lp.fill_color = st[0]
            lp.frame_color = st[1]
            lp.dither_pattern = st[2]
            lp.visible = True
            lv.set_layer_properties(it, lp)
        it.next()
    lv.max_hier()
    lv.zoom_fit()
    bb = t.dbbox()
    w = 1800
    h = max(300, int(w * bb.height() / bb.width()))
    lv.save_image(out, w, h)
    print("PNG " + out)
