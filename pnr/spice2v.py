#!/usr/bin/env python3
"""spice2v.py <frozen.spice> <top> > <top>.v

Structural Verilog of <top> and every subckt it uses, from a frozen xschem netlist, for OpenROAD.
sky130_fd_sc_hd cells stay instances; their pin names come from the PDK's hd SPICE library, so the
positional nets of the SPICE instance lines map one to one. Supply pins (VGND, VNB, VPB, VPWR) and the
subckts' VDPWR / VGND ports are left out: OpenROAD connects them globally (pdngen).
"""
import os
import re
import sys

HD = os.environ.get("HD_SPICE", "/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice")
CELL_SUPPLY = {"VGND", "VNB", "VPB", "VPWR"}
PORT_SUPPLY = {"VDPWR", "VGND"}


def joined_lines(text):
    text = text.replace("\n*+", " ")          # xschem's commented header continues on '*+' lines
    text = re.sub(r"\n\+", " ", text)          # SPICE continuation lines
    return text.splitlines()


def hd_pins(path):
    pins = {}
    for ln in joined_lines(open(path).read()):
        t = ln.split()
        if t and t[0].lower() == ".subckt":
            pins[t[1]] = [p for p in t[2:] if "=" not in p]
    return pins


def subckts(path):
    subs, cur = {}, None
    for ln in joined_lines(open(path).read()):
        s = ln.strip()
        m = re.match(r"^\*{0,2}\.subckt\s+(\S+)\s+(.*)$", s, re.I)
        if m:
            cur = m.group(1)
            subs[cur] = {"ports": m.group(2).split(), "dir": {}, "inst": []}
            continue
        if re.match(r"^\*{0,2}\.ends", s, re.I):
            cur = None
            continue
        if cur is None or not s:
            continue
        m = re.match(r"^\*\.(ipin|opin|iopin)\s+(\S+)", s)
        if m:
            subs[cur]["dir"][m.group(2)] = {"ipin": "input", "opin": "output", "iopin": "inout"}[m.group(1)]
        elif s[0] in "xX":
            t = s.split()
            subs[cur]["inst"].append((t[0], t[1:-1], t[-1]))
    return subs


def emit(name, subs, cells, done, out):
    if name in done:
        return
    sc = subs[name]
    for _, _, ref in sc["inst"]:
        if ref in subs:
            emit(ref, subs, cells, done, out)
    ports = [p for p in sc["ports"] if p not in PORT_SUPPLY]
    nets = set()
    body = []
    for inst, conns, ref in sc["inst"]:
        if ref in cells:
            pins = cells[ref]
            supply = CELL_SUPPLY
        elif ref in subs:
            pins = subs[ref]["ports"]
            supply = PORT_SUPPLY
        else:
            sys.exit(f"unknown cell {ref} in {name}")
        if len(pins) != len(conns):
            sys.exit(f"{inst}: {len(conns)} nets for {len(pins)} pins of {ref}")
        args = []
        for p, n in zip(pins, conns):
            if p in supply:
                continue
            if n in PORT_SUPPLY:
                sys.exit(f"{inst}.{p} is tied to {n}: needs a tie cell")
            args.append(f".{p}({n})")
            nets.add(n)
        body.append(f"  {ref} {inst} ({', '.join(args)});")
    out.append(f"module {name} ({', '.join(ports)});")
    for p in ports:
        out.append(f"  {sc['dir'].get(p, 'inout')} {p};")
    for n in sorted(nets - set(ports)):
        out.append(f"  wire {n};")
    out.extend(body)
    out.append("endmodule\n")
    done.add(name)


def main():
    spice, top = sys.argv[1], sys.argv[2]
    subs = subckts(spice)
    out = [f"// {top}: structural netlist from {os.path.basename(spice)} (spice2v.py), for OpenROAD", ""]
    emit(top, subs, hd_pins(HD), set(), out)
    print("\n".join(out))


if __name__ == "__main__":
    main()
