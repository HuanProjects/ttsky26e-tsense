# tw.py -- the tile wiring of tt_um_huanprojects_tsense (results_m7 section 4): every cross-block net as data, checked
# against the placed tile's geometry before it is painted. KLayout batch:
#   klayout -b -r tw.py -rd gds=<placed tile .gds> -rd tcl=<out tile_wiring.tcl>
# Checks, per layer: a route against all existing shapes except the net's own (its pins), with the layer's spacing;
# routes of different nets against each other; met3 against MIM caps (capm.11, 1.34 um). Prints CONFLICT lines.
import pya

SP = {"met1": 0.14, "met2": 0.14, "met3": 0.30, "met4": 0.30}
GDSL = {"met1": (68, 20), "met2": (69, 20), "met3": (70, 20), "met4": (71, 20), "capm": (89, 44)}
METALS = ["met1", "met2", "met3", "met4"]
CUT = {("met1", "met2"): "via1", ("met2", "met3"): "via2", ("met3", "met4"): "via3"}
# single cut: drawn contact size, metal pad; 2 x 2: contact, pads (helpers.tcl / mk_tile stack sizes)
CUT1 = {"via1": 0.26, "via2": 0.28, "via3": 0.32}
PAD1 = {"met1": 0.34, "met2": 0.40, "met3": 0.40, "met4": 0.40}
CUT2 = {"via1": 0.60, "via2": 0.70, "via3": 0.80}
PAD2 = {"met1": 0.80, "met2": 0.80, "met3": 1.00, "met4": 1.00}

shapes = []   # (net, layer, x1, y1, x2, y2)
cuts = []     # (net, cut, x1, y1, x2, y2)
pins = {}     # net -> [(layer, x1, y1, x2, y2)]: existing geometry the net connects to


def R(net, lay, x1, y1, x2, y2):
    shapes.append((net, lay, min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2)))


def H(net, lay, y, x1, x2, w=0.4):
    """horizontal wire from x1 to x2, extended by w/2 at both ends so bends close without a notch"""
    R(net, lay, min(x1, x2) - w / 2, y - w / 2, max(x1, x2) + w / 2, y + w / 2)


def V(net, lay, x, y1, y2, w=0.4):
    R(net, lay, x - w / 2, min(y1, y2) - w / 2, x + w / 2, max(y1, y2) + w / 2)


def S(net, x, y, lo, hi, n=1):
    """via stack from metal lo to metal hi at (x, y), single cut (n=1) or 2 x 2 (n=2)"""
    i, j = METALS.index(lo), METALS.index(hi)
    for k in range(i, j + 1):
        p = (PAD1 if n == 1 else PAD2)[METALS[k]] / 2
        if n == 1 and METALS[k] == "met3" and i < k < j:
            p = 0.25        # a met3 pad that only passes the stack through: 0.5 x 0.5 for the 0.24 um2 minimum area
        R(net, METALS[k], x - p, y - p, x + p, y + p)
    for k in range(i, j):
        c = CUT[(METALS[k], METALS[k + 1])]
        h = (CUT1 if n == 1 else CUT2)[c] / 2
        cuts.append((net, c, x - h, y - h, x + h, y + h))


def P(net, lay, x1, y1, x2, y2):
    pins.setdefault(net, []).append((lay, x1, y1, x2, y2))


# ======================================================================================================================
# placements (tile um): osc_core (7, 12), vref_decap (25.0, 122.1), swdrv (25.99, 146.0), dig_top (8.05, 188.36),
# montg ua0 (225.9, 1.2), montg ua1 (233.9, 1.2)
MON = {"ua0": 225.9, "ua1": 233.9}
MY0 = 1.2


def mon(which, cx, cy):
    return MON[which] + cx, MY0 + cy


# ---------------------------------------------------------------------------- supplies
# stripes (met4, y 5 .. 220.76)
for x in (1.0, 90.0, 327.0):
    P("VDPWR", "met4", x, 5.0, x + 2.0, 220.76)
for x in (4.0, 93.0, 330.0):
    P("VGND", "met4", x, 5.0, x + 2.0, 220.76)
# join the left and middle stripes (tile-level LVS sees one VGND and one VDPWR)
H("VGND", "met3", 166.0, 4.5, 94.5, 0.8)
S("VGND", 5.0, 166.0, "met3", "met4", 2)
S("VGND", 94.0, 166.0, "met3", "met4", 2)
H("VDPWR", "met3", 168.0, 1.5, 91.5, 0.8)
S("VDPWR", 2.0, 168.0, "met3", "met4", 2)
S("VDPWR", 91.0, 168.0, "met3", "met4", 2)
# osc_core: VGND spine (met1) to the left VGND stripe; VDPWR (cmp2s's supply track end) to the middle stripe
P("VGND", "met1", 7.0, 75.16, 7.8, 109.74)
for y in (80.0, 100.0):
    H("VGND", "met1", y, 4.6, 7.8, 0.8)
    S("VGND", 5.0, y, "met1", "met4", 2)
P("VDPWR", "met2", 77.075, 98.1, 77.875, 98.7)
S("VDPWR", 77.475, 98.4, "met2", "met4", 2)
H("VDPWR", "met4", 98.4, 77.0, 90.5, 1.0)
# V_REF decap: VGND tab (met3) east under the VDPWR stripe to the middle VGND stripe
P("VGND", "met3", 73.66, 123.1, 74.66, 124.1)
H("VGND", "met3", 123.6, 74.2, 94.5, 1.0)
S("VGND", 94.0, 123.6, "met3", "met4", 2)
# dig_top: VGND strap (met2, left) to the left VGND stripe; VDPWR strap (met2, right) to the middle VDPWR stripe
P("VGND", "met2", 8.4, 190.84, 10.0, 218.52)
for y in (195.0, 205.0, 215.0):
    S("VGND", 9.2, y, "met2", "met3", 2)
    H("VGND", "met3", y, 4.5, 9.7, 0.8)
    S("VGND", 5.0, y, "met3", "met4", 2)
P("VDPWR", "met2", 85.92, 193.56, 87.52, 215.8)
for y in (196.0, 206.0):
    S("VDPWR", 86.72, y, "met2", "met3", 2)
    H("VDPWR", "met3", y, 86.2, 91.5, 0.8)
    S("VDPWR", 91.0, y, "met3", "met4", 2)
# swdrv ring: inner VGND side (met2) to the left VGND stripe, outer VDPWR side to the left VDPWR stripe
P("VGND", "met2", 28.83, 147.42, 29.63, 158.18)
P("VDPWR", "met2", 27.53, 146.12, 28.33, 159.48)
S("VGND", 29.23, 152.8, "met2", "met3", 2)
H("VGND", "met3", 152.8, 4.5, 29.73, 0.8)
S("VGND", 5.0, 152.8, "met3", "met4", 2)
S("VDPWR", 27.93, 150.0, "met2", "met3", 2)
H("VDPWR", "met3", 150.0, 1.5, 28.43, 0.8)
S("VDPWR", 2.0, 150.0, "met3", "met4", 2)
# monitor switches: VDPWR (met1 y 6.8) and VGND (met1 y 7.8) from the right stripes, under bg_core
H("VDPWR", "met1", 6.8, 231.6, 328.0, 0.4)
S("VDPWR", 328.0, 6.8, "met1", "met4", 2)
H("VGND", "met1", 7.8, 233.9, 331.0, 0.4)
S("VGND", 331.0, 7.8, "met1", "met4", 2)
for w in ("ua0", "ua1"):
    x, y = mon(w, 5.965, 2.2)
    P("VDPWR", "met1", x - 0.17, y - 0.17, x + 0.17, y + 0.17)
    V("VDPWR", "met1", x, y - 0.17, 6.8, 0.34)
    x, y = mon(w, 0.385, 1.4)
    P("VGND", "met1", x - 0.17, y - 0.17, x + 0.17, y + 0.17)
    S("VGND", x, y, "met1", "met2")
# ua1's VGND: met2 up to the VGND line; ua0's VGND: met2 up to shield A (below vref's jog)
x1, y1 = mon("ua1", 0.385, 1.4)
V("VGND", "met2", x1, y1, 7.8, 0.34)
S("VGND", x1, 7.8, "met1", "met2")
x0, y0 = mon("ua0", 0.385, 1.4)
V("VGND", "met2", x0, y0, 4.6, 0.34)
S("VGND", x0, 4.6, "met2", "met3")

# ---------------------------------------------------------------------------- bottom strip: vref, veb3, ib_cmp1/2, shields
# vref: bgr's pin (met2) west to the left channel, up to the mux's vref pin; inside the mux on to the decap bus
P("vref", "met2", 219.5, 8.3, 224.0, 8.8)
P("vref", "met3", 9.15, 120.85, 17.155, 121.35)          # the mux's vref line (tile)
P("vref", "met4", 25.0, 120.5, 73.66, 121.5)             # the decap's bus
H("vref", "met2", 8.55, 7.6, 219.6, 0.5)
S("vref", 7.8, 8.55, "met2", "met4")
V("vref", "met4", 7.8, 8.55, 121.1)
S("vref", 7.8, 121.1, "met3", "met4")
H("vref", "met3", 121.1, 7.6, 9.65, 0.5)
H("vref", "met3", 121.1, 17.0, 23.55, 0.5)
S("vref", 23.6, 121.1, "met3", "met4")
R("vref", "met4", 23.4, 120.5, 25.5, 121.5)
# vref -> ua0's switch (a): down from bgr's pin, east under bg_core, down to the a bar
P("vref", "met2", 226.685, 1.2, 231.465, 1.54)
V("vref", "met2", 219.9, 7.4, 8.4, 0.4)
H("vref", "met2", 7.6, 219.7, 227.025, 0.4)
V("vref", "met2", 226.855, 1.3, 7.8, 0.34)
# veb3: bgr's met1 (x 220.5 .. 221.1, down to y 10.4) west, up the left channel to the mux's veb3 pin
P("veb3", "met1", 220.5, 10.4, 221.1, 14.0)
P("veb3", "met3", 9.15, 121.85, 9.65, 122.35)
H("veb3", "met1", 10.65, 8.5, 221.1, 0.5)
S("veb3", 8.7, 10.65, "met1", "met4")
V("veb3", "met4", 8.7, 10.65, 122.1)
S("veb3", 8.7, 122.1, "met3", "met4")
H("veb3", "met3", 122.1, 8.5, 9.65, 0.5)
# ib_cmp1: bgr pin, met3 down at x 221.6, west at y 11.0, up at x 30.5, east at y 89.0 to cmp2s's pin
P("ib_cmp1", "met2", 219.5, 37.85, 224.0, 38.25)
P("ib_cmp1", "met2", 54.995, 88.6, 55.795, 89.4)
S("ib_cmp1", 221.6, 38.05, "met2", "met3")
V("ib_cmp1", "met3", 221.6, 11.0, 38.05)
H("ib_cmp1", "met3", 11.0, 30.3, 221.8)
S("ib_cmp1", 30.5, 11.0, "met3", "met4")
V("ib_cmp1", "met4", 30.5, 11.0, 89.0)
H("ib_cmp1", "met4", 89.0, 30.3, 55.6)
S("ib_cmp1", 55.4, 89.0, "met2", "met4")
# ib_cmp2: bgr pin, met3 down at x 223.3, west at y 5.6 between VGND shields, up at x 24.6 (met4 shields beside it)
P("ib_cmp2", "met2", 219.5, 38.75, 224.0, 39.25)
P("ib_cmp2", "met2", 24.19, 89.7, 24.99, 90.3)
S("ib_cmp2", 223.3, 39.0, "met2", "met3")
V("ib_cmp2", "met3", 223.3, 5.6, 39.0)
H("ib_cmp2", "met3", 5.6, 24.4, 223.5)
S("ib_cmp2", 24.6, 5.6, "met3", "met4")
V("ib_cmp2", "met4", 24.6, 5.6, 90.0)
S("ib_cmp2", 24.59, 90.0, "met2", "met4")
H("VGND", "met3", 4.6, 4.8, 226.5)                   # shield A (and ua0's VGND)
H("VGND", "met3", 6.6, 4.8, 222.5)                   # shield B
V("VGND", "met3", 5.0, 4.4, 8.1)
S("VGND", 5.0, 7.6, "met3", "met4", 2)
for x in (23.6, 25.6):
    S("VGND", x, 4.6, "met3", "met4")
    V("VGND", "met4", x, 4.6, 66.0)

# ---------------------------------------------------------------------------- vcap: C_osc's bus, down its right side,
# east along the bottom strip (met3), up the channel between ota2s and bg_core (met4), to bgr's ich pin (P4's drain)
P("vcap", "met4", 86.92, 64.5, 87.92, 65.5)
P("vcap", "met3", 223.8, 117.95, 224.7, 118.85)
R("vcap", "met4", 87.4, 64.5, 88.8, 65.5)
V("vcap", "met4", 88.5, 2.6, 65.5, 0.6)
S("vcap", 88.5, 2.6, "met3", "met4")
H("vcap", "met3", 2.6, 88.3, 211.6)
S("vcap", 211.4, 2.6, "met3", "met4")
V("vcap", "met4", 211.4, 2.6, 118.4, 0.8)
H("vcap", "met4", 118.4, 211.0, 224.7, 0.9)
S("vcap", 224.25, 118.4, "met3", "met4")

# ---------------------------------------------------------------------------- iptat_mon: bgr pin up to met4, down over
# bg_core to y 6.0, west on met3 under bg_core to ua1's switch (a)
P("iptat_mon", "met2", 275.5, 118.1, 276.0, 118.7)
P("iptat_mon", "met2", 234.685, 1.2, 239.465, 1.54)
S("iptat_mon", 275.75, 118.4, "met2", "met4")
V("iptat_mon", "met4", 275.75, 6.0, 118.4)
S("iptat_mon", 275.75, 6.0, "met3", "met4")
H("iptat_mon", "met3", 6.0, 234.655, 275.95)
S("iptat_mon", 234.855, 6.0, "met2", "met3")
V("iptat_mon", "met2", 234.855, 1.3, 6.0, 0.34)

# ---------------------------------------------------------------------------- pad lines (met4, under the stripes' ends)
for w, pin, x_stub, ylane in (("ua0", "ua[0]", 151.81, 0.95), ("ua1", "ua[1]", 132.49, 0.25)):
    bx, by = mon(w, 3.4, 1.25)
    P(pin, "met2", bx - 0.17, by - 0.17, bx + 0.17, by + 0.17)
    P(pin, "met4", x_stub, 0.0, x_stub + 0.9, 3.0)
    S(pin, bx, by, "met2", "met4")
    V(pin, "met4", bx, ylane, by)
    if w == "ua0":
        H(pin, "met4", ylane, x_stub, bx)
    else:
        # ua1's line passes under the ua0 stub on met3
        H(pin, "met4", ylane, 153.9, bx, 0.3)
        S(pin, 153.9, ylane, "met3", "met4")
        H(pin, "met3", ylane, 150.6, 153.9, 0.3)
        S(pin, 150.6, ylane, "met3", "met4")
        H(pin, "met4", ylane, x_stub, 150.8, 0.3)

# ---------------------------------------------------------------------------- enables: dig_top's bottom-right pins, down
# the band's right side, east under the stripes (met3), over ota2s (met4) above vcap's top, down over bg_core
EN = [("vref_mon_en", 76.36, 119.45, mon("ua0", 1.6, 1.85)),
      ("vref_mon_enb", 77.28, 120.15, mon("ua0", 5.0, 3.55)),
      ("iptat_mon_en", 78.20, 120.85, mon("ua1", 1.6, 1.85)),
      ("iptat_mon_enb", 79.12, 121.55, mon("ua1", 5.0, 3.55))]
for i, (net, x, ylane, (px, py)) in enumerate(EN):
    P(net, "met2", x - 0.14, 188.36, x + 0.14, 189.16)
    P(net, "met2", px - 0.17, py - 0.17, px + 0.17, py + 0.17)
    V(net, "met2", x, 187.6, 188.6, 0.28)
    S(net, x, 187.8, "met2", "met4")
    V(net, "met4", x, ylane, 187.8)
    S(net, x, ylane, "met3", "met4")
    xe = 96.2 + 0.9 * (i % 2)
    H(net, "met3", ylane, x, xe)
    S(net, xe, ylane, "met3", "met4")
    H(net, "met4", ylane, xe, px)
    V(net, "met4", px, py, ylane)
    S(net, px, py, "met2", "met4")

# ---------------------------------------------------------------------------- control column dig_top -> osc_core
COL = {"thr_sel": 11.96, "thr_selb": 13.34, "osc_en": 16.10, "cmp_raw": 17.48, "osc_enb": 21.62, "rst": 23.00}
for net, x in COL.items():
    P(net, "met2", x - 0.14, 188.36, x + 0.14, 189.16)
    V(net, "met2", x, 187.6, 188.6, 0.28)
    S(net, x, 187.8, "met2", "met4")
P("thr_sel", "met2", 11.79, 106.05, 12.29, 106.55)
V("thr_sel", "met4", 11.96, 106.3, 187.8)
S("thr_sel", 11.96, 106.3, "met2", "met4")
P("thr_selb", "met2", 13.23, 106.05, 13.73, 106.55)
V("thr_selb", "met4", 13.34, 106.3, 187.8)
S("thr_selb", 13.34, 106.3, "met2", "met4")
P("osc_en", "met2", 13.355, 78.6, 13.695, 79.0)
V("osc_en", "met4", 16.10, 104.6, 187.8)
S("osc_en", 16.10, 104.6, "met3", "met4")
H("osc_en", "met3", 104.6, 13.525, 16.10)
S("osc_en", 13.525, 104.6, "met3", "met4")
V("osc_en", "met4", 13.525, 78.8, 104.6)
S("osc_en", 13.525, 78.8, "met2", "met4")
P("cmp_raw", "met3", 14.7, 78.8, 15.2, 89.55)
V("cmp_raw", "met4", 17.48, 84.2, 187.8)
S("cmp_raw", 17.48, 84.2, "met3", "met4")
H("cmp_raw", "met3", 84.2, 15.0, 17.48)
P("osc_enb", "met2", 25.85, 78.6, 26.19, 79.0)
V("osc_enb", "met4", 21.62, 104.5, 187.8)
H("osc_enb", "met4", 104.5, 21.62, 26.02)
V("osc_enb", "met4", 26.02, 78.8, 104.5)
S("osc_enb", 26.02, 78.8, "met2", "met4")
P("rst", "met2", 27.33, 78.6, 27.67, 79.0)
H("rst", "met4", 187.8, 22.55, 23.00)
V("rst", "met4", 22.55, 105.5, 187.8)
H("rst", "met4", 105.5, 22.55, 27.50)
V("rst", "met4", 27.50, 78.8, 105.5)
S("rst", 27.50, 78.8, "met2", "met4")

# ---------------------------------------------------------------------------- dig_top -> swdrv (straight met2)
for net, x in (("ich_sel", 32.2), ("i3_sel", 37.72), ("chop_sel", 43.24)):
    P(net, "met2", x - 0.14, 188.36, x + 0.14, 189.16)
    P(net, "met2", x - 0.14, 158.8, x + 0.14, 159.6)
    V(net, "met2", x, 159.0, 188.6, 0.3)

# ---------------------------------------------------------------------------- swdrv -> bgr
SW_Y = {"swa": 147.02, "swb": 147.70, "ich_dump": 148.38, "ich_on": 149.06, "ich_onb": 149.74,
        "i3_dump": 150.42, "i3_on": 151.10, "i3_onb": 151.78, "chopb": 155.86, "chop": 157.22}
for net, y in SW_Y.items():
    P(net, "met3", 50.03, y - 0.15, 50.83, y + 0.15)
# chop / chopb: met3 east under the stripes, down onto bgr's met2 pins
P("chop", "met2", 96.53, 157.0, 97.33, 157.8)
P("chopb", "met2", 96.53, 155.5, 97.33, 156.3)
for net in ("chop", "chopb"):
    y = SW_Y[net]
    H(net, "met3", y, 50.7, 97.1, 0.3)
    S(net, 96.93, y, "met2", "met3")
# swa / swb: down in the band at x 87.6 / 86.6, east at y 127.3 / 126.5, down onto bgr's pins
BG = {"swa": (193.6, 123.7, 192.5, 123.3, 193.3, 124.1), "swb": (192.8, 124.8, 192.5, 124.4, 193.3, 125.2),
      "ich_dump": (245.6, 98.7, 245.2, 98.3, 246.0, 99.1), "ich_on": (248.4, 99.5, 248.0, 99.1, 248.8, 99.9),
      "ich_onb": (251.6, 100.45, 251.2, 100.05, 252.0, 100.85), "i3_dump": (284.1, 88.7, 283.7, 88.3, 284.5, 89.1),
      "i3_on": (286.9, 89.5, 286.5, 89.1, 287.3, 89.9), "i3_onb": (290.1, 90.45, 289.7, 90.05, 290.5, 90.85)}
for net, (xd, yd, x1, y1, x2, y2) in BG.items():
    P(net, "met2", x1, y1, x2, y2)
for net, xb, yl in (("swa", 87.6, 127.3), ("swb", 86.6, 126.5)):
    y = SW_Y[net]
    xd, yd = BG[net][0], BG[net][1]
    H(net, "met3", y, 50.7, xb, 0.3)
    S(net, xb, y, "met3", "met4")
    V(net, "met4", xb, yl, y)
    S(net, xb, yl, "met3", "met4")
    xe = 96.2 if net == "swb" else 97.1
    H(net, "met3", yl, xb, xe)
    S(net, xe, yl, "met3", "met4")
    H(net, "met4", yl, xe, xd)
    V(net, "met4", xd, yd, yl)
    S(net, xd, yd, "met2", "met4")
# the six switch controls: met3 east under the stripes, met4 east over ota2s / bg_core below Cc, down to the pins
for i, net in enumerate(("ich_dump", "ich_on", "ich_onb", "i3_dump", "i3_on", "i3_onb")):
    y = SW_Y[net]
    xd, yd = BG[net][0], BG[net][1]
    xe = 96.2 + 0.9 * (i % 2)
    H(net, "met3", y, 50.7, xe, 0.3)
    S(net, xe, y, "met3", "met4")
    H(net, "met4", y, xe, xd, 0.34)
    V(net, "met4", xd, yd, y, 0.34)
    S(net, xd, yd, "met2", "met4")

# ---------------------------------------------------------------------------- su: bgr pin, up over bg_core, west along
# the top of the tile, into dig_top's right edge
P("su", "met2", 287.0, 55.95, 292.0, 56.76)
P("su", "met3", 88.67, 218.47, 89.47, 218.77)
S("su", 291.5, 56.35, "met2", "met4")
V("su", "met4", 291.5, 56.35, 218.62)
H("su", "met4", 218.62, 140.5, 291.7)
S("su", 140.5, 218.62, "met3", "met4")
H("su", "met3", 218.62, 89.3, 140.5, 0.3)

# ---------------------------------------------------------------------------- top pins
def tt_pin(x):
    return (x - 0.15, 224.76, x + 0.15, 225.76)


UI_Y = {k: 188.36 + 24.82 + 0.68 * (7 - k) for k in range(8)}       # ui7 lowest
for k in range(8):
    net = "ui_in[%d]" % k
    x = 138.46 - 2.76 * k
    y = UI_Y[k]
    P(net, "met4", *tt_pin(x))
    P(net, "met3", 88.67, y - 0.15, 89.47, y + 0.15)
    if k == 7:      # over Cc on met2, above the ui6 row, down at x 90.7 (capm.11: met3 stays 1.34 um off the MIM)
        V(net, "met4", x, 219.6, 224.9, 0.3)
        S(net, x, 219.6, "met2", "met4")
        V(net, "met2", x, 214.6, 219.6, 0.3)
        H(net, "met2", 214.6, 90.7, x, 0.3)
        V(net, "met2", 90.7, y, 214.6, 0.3)
        S(net, 90.7, y, "met2", "met3")
        H(net, "met3", y, 89.3, 90.7, 0.3)
    elif k == 6:
        V(net, "met4", x, 219.6, 224.9, 0.3)
        S(net, x, 219.6, "met2", "met4")
        V(net, "met2", x, y, 219.6, 0.3)
        H(net, "met2", y, 91.4, x, 0.3)
        S(net, 91.4, y, "met2", "met3")
        H(net, "met3", y, 89.3, 91.4, 0.3)
    else:
        # met3 west from the pin, with a 2 um met4 bridge just east of the middle stripes (antenna: when met3 is
        # etched, only the piece from the bridge to dig_top hangs on the buf_1 gate; the bridges step 1 um per
        # track so that their pads stay 0.3 um apart)
        xb = 97.0 + k
        V(net, "met4", x, y, 224.9, 0.3)
        S(net, x, y, "met3", "met4")
        H(net, "met3", y, xb + 2.0, x, 0.3)
        S(net, xb + 2.0, y, "met3", "met4")
        H(net, "met4", y, xb, xb + 2.0, 0.3)
        S(net, xb, y, "met3", "met4")
        H(net, "met3", y, 89.3, xb, 0.3)
TOP = {}
for k in range(8):
    TOP["uio_oe[%d]" % k] = 50.14 - 2.76 * k
    TOP["uio_out[%d]" % k] = 72.22 - 2.76 * k
for k in (2, 3, 4, 5, 6, 7):
    TOP["uo_out[%d]" % k] = 94.30 - 2.76 * k
for net, x in TOP.items():
    P(net, "met4", *tt_pin(x))
    P(net, "met2", x - 0.14, 220.2, x + 0.14, 221.0)
    V(net, "met2", x, 220.4, 221.6, 0.28)
    S(net, x, 221.4, "met2", "met4")
    V(net, "met4", x, 221.4, 224.9, 0.3)
# uo_out[0] / [1]: dig_top's right edge, met3 east above the middle stripes' ends, up to the pins
for net, y, x in (("uo_out[0]", 219.3, 94.30), ("uo_out[1]", 219.98, 91.54)):
    P(net, "met4", *tt_pin(x))
    P(net, "met3", 88.67, y - 0.15, 89.47, y + 0.15)
    H(net, "met3", y, 89.3, x + 0.15, 0.3)
    yv = 221.8 if net == "uo_out[0]" else 222.5
    V(net, "met3", x, y, yv, 0.4)
    S(net, x, yv, "met3", "met4")
    V(net, "met4", x, yv, 224.9, 0.3)

# ======================================================================================================================
# checks
ly = pya.Layout()
ly.read(gds)
top = ly.top_cell()
dbu = ly.dbu


def box(x1, y1, x2, y2):
    return pya.Box(int(round(x1 / dbu)), int(round(y1 / dbu)), int(round(x2 / dbu)), int(round(y2 / dbu)))


obst = {}
for lay in METALS + ["capm"]:
    li = ly.find_layer(*GDSL[lay])
    obst[lay] = pya.Region(top.begin_shapes_rec(li)).merged() if li is not None else pya.Region()
nets = sorted(set(s[0] for s in shapes))
mine = {}
for n in nets:
    for lay in METALS:
        r = pya.Region()
        for s in shapes:
            if s[0] == n and s[1] == lay:
                r.insert(box(*s[2:]))
        mine[(n, lay)] = r.merged()
bad = 0
for n in nets:
    for lay in METALS:
        r = mine[(n, lay)]
        if r.is_empty():
            continue
        own = pya.Region()
        for (pl, x1, y1, x2, y2) in pins.get(n, []):
            if pl == lay:
                own.insert(box(x1, y1, x2, y2))
        others = obst[lay] - obst[lay].interacting(own) if not own.is_empty() else obst[lay]
        hit = r.sized(int(round(SP[lay] / dbu))) & others
        for p in hit.each():
            b = p.bbox()
            print("CONFLICT %s %s with existing at %.3f..%.3f x %.3f..%.3f" % (n, lay, b.left * dbu, b.right * dbu, b.bottom * dbu, b.top * dbu))
            bad += 1
        if lay == "met3":
            hc = r.sized(int(round(1.34 / dbu))) & obst["capm"]
            for p in hc.each():
                b = p.bbox()
                print("CAPM11 %s near MIM at %.3f..%.3f x %.3f..%.3f" % (n, b.left * dbu, b.right * dbu, b.bottom * dbu, b.top * dbu))
for lay in METALS:
    for i, a in enumerate(nets):
        ra = mine[(a, lay)]
        if ra.is_empty():
            continue
        grown = ra.sized(int(round(SP[lay] / dbu)))
        for b_ in nets[i + 1:]:
            rb = mine[(b_, lay)]
            if rb.is_empty():
                continue
            hit = grown & rb
            for p in hit.each():
                b = p.bbox()
                print("CONFLICT %s/%s %s at %.3f..%.3f x %.3f..%.3f" % (a, b_, lay, b.left * dbu, b.right * dbu, b.bottom * dbu, b.top * dbu))
                bad += 1
print("SHAPES %d CUTS %d NETS %d CONFLICTS %d" % (len(shapes), len(cuts), len(nets), bad))

# ======================================================================================================================
# Magic commands
with open(tcl, "w") as f:
    f.write("# tile_wiring.tcl -- written by tw.py (the routes are defined and checked there); sourced by mk_tile.tcl\n")
    f.write("proc twr {x1 y1 x2 y2 l} { box [format %.3fum $x1] [format %.3fum $y1] [format %.3fum $x2] [format %.3fum $y2]; paint $l }\n")
    for (n, lay, x1, y1, x2, y2) in shapes:
        f.write("twr %.3f %.3f %.3f %.3f %s\n" % (x1, y1, x2, y2, lay))
    for (n, c, x1, y1, x2, y2) in cuts:
        f.write("twr %.3f %.3f %.3f %.3f %s\n" % (x1, y1, x2, y2, c))
print("TCL", tcl)
