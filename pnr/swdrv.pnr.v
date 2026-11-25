module swdrv (chop,
    chop_sel,
    chopb,
    i3_dump,
    i3_on,
    i3_onb,
    i3_sel,
    ich_dump,
    ich_on,
    ich_onb,
    ich_sel,
    swa,
    swb,
    VDPWR,
    VGND);
 output chop;
 input chop_sel;
 output chopb;
 output i3_dump;
 output i3_on;
 output i3_onb;
 input i3_sel;
 output ich_dump;
 output ich_on;
 output ich_onb;
 input ich_sel;
 output swa;
 output swb;
 inout VDPWR;
 inout VGND;

 wire chop_selb;
 wire i3_selb;
 wire ich_selb;

 sky130_fd_sc_hd__fill_8 FILLER_0_0 ();
 sky130_fd_sc_hd__fill_8 FILLER_0_16 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_24 ();
 sky130_fd_sc_hd__fill_4 FILLER_0_32 ();
 sky130_fd_sc_hd__fill_8 FILLER_0_8 ();
 sky130_fd_sc_hd__fill_8 FILLER_1_0 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_10 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_17 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_34 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_8 ();
 sky130_fd_sc_hd__fill_8 FILLER_2_0 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_12 ();
 sky130_fd_sc_hd__fill_4 FILLER_2_16 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_20 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_24 ();
 sky130_fd_sc_hd__fill_4 FILLER_2_32 ();
 sky130_fd_sc_hd__fill_4 FILLER_2_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_1 ();
 sky130_fd_sc_hd__nand2_1 xca1 (.A(chop_sel),
    .B(chop),
    .Y(chopb));
 sky130_fd_sc_hd__nand2_1 xca2 (.A(chop_selb),
    .B(chopb),
    .Y(chop));
 sky130_fd_sc_hd__inv_1 xci (.A(chop_sel),
    .Y(chop_selb));
 sky130_fd_sc_hd__nor2_1 xcn1 (.A(chop_sel),
    .B(swb),
    .Y(swa));
 sky130_fd_sc_hd__nor2_1 xcn2 (.A(chop_selb),
    .B(swa),
    .Y(swb));
 sky130_fd_sc_hd__inv_1 xi3i (.A(i3_sel),
    .Y(i3_selb));
 sky130_fd_sc_hd__inv_1 xi3ib (.A(i3_on),
    .Y(i3_onb));
 sky130_fd_sc_hd__nor2_1 xi3n1 (.A(i3_sel),
    .B(i3_dump),
    .Y(i3_on));
 sky130_fd_sc_hd__nor2_1 xi3n2 (.A(i3_selb),
    .B(i3_on),
    .Y(i3_dump));
 sky130_fd_sc_hd__inv_1 xichi (.A(ich_sel),
    .Y(ich_selb));
 sky130_fd_sc_hd__inv_1 xichib (.A(ich_on),
    .Y(ich_onb));
 sky130_fd_sc_hd__nor2_1 xichn1 (.A(ich_sel),
    .B(ich_dump),
    .Y(ich_on));
 sky130_fd_sc_hd__nor2_1 xichn2 (.A(ich_selb),
    .B(ich_on),
    .Y(ich_dump));
endmodule
