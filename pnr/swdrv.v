// swdrv: structural netlist from swdrv.spice (spice2v.py), for OpenROAD

module swdrv (ich_sel, i3_sel, chop_sel, ich_on, ich_onb, ich_dump, i3_on, i3_onb, i3_dump, swa, swb, chop, chopb);
  input ich_sel;
  input i3_sel;
  input chop_sel;
  output ich_on;
  output ich_onb;
  output ich_dump;
  output i3_on;
  output i3_onb;
  output i3_dump;
  output swa;
  output swb;
  output chop;
  output chopb;
  wire chop_selb;
  wire i3_selb;
  wire ich_selb;
  sky130_fd_sc_hd__inv_1 xichi (.A(ich_sel), .Y(ich_selb));
  sky130_fd_sc_hd__nor2_1 xichn1 (.A(ich_sel), .B(ich_dump), .Y(ich_on));
  sky130_fd_sc_hd__nor2_1 xichn2 (.A(ich_selb), .B(ich_on), .Y(ich_dump));
  sky130_fd_sc_hd__inv_1 xichib (.A(ich_on), .Y(ich_onb));
  sky130_fd_sc_hd__inv_1 xi3i (.A(i3_sel), .Y(i3_selb));
  sky130_fd_sc_hd__nor2_1 xi3n1 (.A(i3_sel), .B(i3_dump), .Y(i3_on));
  sky130_fd_sc_hd__nor2_1 xi3n2 (.A(i3_selb), .B(i3_on), .Y(i3_dump));
  sky130_fd_sc_hd__inv_1 xi3ib (.A(i3_on), .Y(i3_onb));
  sky130_fd_sc_hd__inv_1 xci (.A(chop_sel), .Y(chop_selb));
  sky130_fd_sc_hd__nor2_1 xcn1 (.A(chop_sel), .B(swb), .Y(swa));
  sky130_fd_sc_hd__nor2_1 xcn2 (.A(chop_selb), .B(swa), .Y(swb));
  sky130_fd_sc_hd__nand2_1 xca1 (.A(chop_sel), .B(chop), .Y(chopb));
  sky130_fd_sc_hd__nand2_1 xca2 (.A(chop_selb), .B(chopb), .Y(chop));
endmodule

