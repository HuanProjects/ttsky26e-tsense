module dig_top (chop_sel,
    cmp_raw,
    i3_sel,
    ich_sel,
    iptat_mon_en,
    iptat_mon_enb,
    osc_en,
    osc_enb,
    rst,
    su,
    thr_sel,
    thr_selb,
    ui0,
    ui1,
    ui2,
    ui3,
    ui4,
    ui5,
    ui6,
    ui7,
    uio_oe0,
    uio_oe1,
    uio_oe2,
    uio_oe3,
    uio_oe4,
    uio_oe5,
    uio_oe6,
    uio_oe7,
    uio_out0,
    uio_out1,
    uio_out2,
    uio_out3,
    uio_out4,
    uio_out5,
    uio_out6,
    uio_out7,
    uo0,
    uo1,
    uo2,
    uo3,
    uo4,
    uo5,
    uo6,
    uo7,
    vref_mon_en,
    vref_mon_enb,
    VDPWR,
    VGND);
 output chop_sel;
 input cmp_raw;
 output i3_sel;
 output ich_sel;
 output iptat_mon_en;
 output iptat_mon_enb;
 output osc_en;
 output osc_enb;
 input rst;
 input su;
 output thr_sel;
 output thr_selb;
 input ui0;
 input ui1;
 input ui2;
 input ui3;
 input ui4;
 input ui5;
 input ui6;
 input ui7;
 output uio_oe0;
 output uio_oe1;
 output uio_oe2;
 output uio_oe3;
 output uio_oe4;
 output uio_oe5;
 output uio_oe6;
 output uio_oe7;
 output uio_out0;
 output uio_out1;
 output uio_out2;
 output uio_out3;
 output uio_out4;
 output uio_out5;
 output uio_out6;
 output uio_out7;
 output uo0;
 output uo1;
 output uo2;
 output uo3;
 output uo4;
 output uo5;
 output uo6;
 output uo7;
 output vref_mon_en;
 output vref_mon_enb;
 inout VDPWR;
 inout VGND;

 wire ring_en;
 wire \xglue/bg_ok ;
 wire \xglue/rst_k ;
 wire \xglue/tie_hi0 ;
 wire \xglue/tie_hi1 ;
 wire \xglue/tie_hi10 ;
 wire \xglue/tie_hi11 ;
 wire \xglue/tie_hi12 ;
 wire \xglue/tie_hi13 ;
 wire \xglue/tie_hi14 ;
 wire \xglue/tie_hi15 ;
 wire \xglue/tie_hi16 ;
 wire \xglue/tie_hi17 ;
 wire \xglue/tie_hi2 ;
 wire \xglue/tie_hi3 ;
 wire \xglue/tie_hi4 ;
 wire \xglue/tie_hi5 ;
 wire \xglue/tie_hi6 ;
 wire \xglue/tie_hi7 ;
 wire \xglue/tie_hi8 ;
 wire \xglue/tie_hi9 ;
 wire \xglue/tq ;
 wire \xglue/tqb ;
 wire \xring/xd/q0 ;
 wire \xring/xd/q1 ;
 wire \xring/xd/q2 ;
 wire \xring/xd/q3 ;
 wire \xring/xd/qb0 ;
 wire \xring/xd/qb1 ;
 wire \xring/xd/qb2 ;
 wire \xring/xd/qb3 ;
 wire \xring/xd/r0 ;
 wire \xring/xd/r1 ;
 wire \xring/xd/r10 ;
 wire \xring/xd/r11 ;
 wire \xring/xd/r12 ;
 wire \xring/xd/r13 ;
 wire \xring/xd/r14 ;
 wire \xring/xd/r15 ;
 wire \xring/xd/r2 ;
 wire \xring/xd/r3 ;
 wire \xring/xd/r4 ;
 wire \xring/xd/r5 ;
 wire \xring/xd/r6 ;
 wire \xring/xd/r7 ;
 wire \xring/xd/r8 ;
 wire \xring/xd/r9 ;
 wire \xring/xn/hi ;
 wire \xring/xn/q0 ;
 wire \xring/xn/q1 ;
 wire \xring/xn/q2 ;
 wire \xring/xn/q3 ;
 wire \xring/xn/q4 ;
 wire \xring/xn/qb0 ;
 wire \xring/xn/qb1 ;
 wire \xring/xn/qb2 ;
 wire \xring/xn/qb3 ;
 wire \xring/xn/qb4 ;
 wire \xring/xn/r0 ;
 wire \xring/xn/r1 ;
 wire \xring/xn/r10 ;
 wire \xring/xn/r11 ;
 wire \xring/xn/r12 ;
 wire \xring/xn/r13 ;
 wire \xring/xn/r14 ;
 wire \xring/xn/r15 ;
 wire \xring/xn/r16 ;
 wire \xring/xn/r17 ;
 wire \xring/xn/r18 ;
 wire \xring/xn/r19 ;
 wire \xring/xn/r2 ;
 wire \xring/xn/r20 ;
 wire \xring/xn/r21 ;
 wire \xring/xn/r22 ;
 wire \xring/xn/r23 ;
 wire \xring/xn/r24 ;
 wire \xring/xn/r25 ;
 wire \xring/xn/r26 ;
 wire \xring/xn/r27 ;
 wire \xring/xn/r28 ;
 wire \xring/xn/r29 ;
 wire \xring/xn/r3 ;
 wire \xring/xn/r30 ;
 wire \xring/xn/r4 ;
 wire \xring/xn/r5 ;
 wire \xring/xn/r6 ;
 wire \xring/xn/r7 ;
 wire \xring/xn/r8 ;
 wire \xring/xn/r9 ;
 wire \xring/xn/tie_lo ;
 wire \xring/xp/enb ;
 wire \xring/xp/lo ;
 wire \xring/xp/q0 ;
 wire \xring/xp/q1 ;
 wire \xring/xp/q2 ;
 wire \xring/xp/q3 ;
 wire \xring/xp/q4 ;
 wire \xring/xp/qb0 ;
 wire \xring/xp/qb1 ;
 wire \xring/xp/qb2 ;
 wire \xring/xp/qb3 ;
 wire \xring/xp/qb4 ;
 wire \xring/xp/r0 ;
 wire \xring/xp/r1 ;
 wire \xring/xp/r10 ;
 wire \xring/xp/r11 ;
 wire \xring/xp/r12 ;
 wire \xring/xp/r13 ;
 wire \xring/xp/r14 ;
 wire \xring/xp/r15 ;
 wire \xring/xp/r16 ;
 wire \xring/xp/r17 ;
 wire \xring/xp/r18 ;
 wire \xring/xp/r19 ;
 wire \xring/xp/r2 ;
 wire \xring/xp/r20 ;
 wire \xring/xp/r21 ;
 wire \xring/xp/r22 ;
 wire \xring/xp/r23 ;
 wire \xring/xp/r24 ;
 wire \xring/xp/r25 ;
 wire \xring/xp/r26 ;
 wire \xring/xp/r27 ;
 wire \xring/xp/r28 ;
 wire \xring/xp/r29 ;
 wire \xring/xp/r3 ;
 wire \xring/xp/r30 ;
 wire \xring/xp/r4 ;
 wire \xring/xp/r5 ;
 wire \xring/xp/r6 ;
 wire \xring/xp/r7 ;
 wire \xring/xp/r8 ;
 wire \xring/xp/r9 ;
 wire \xring/xp/tie_hi ;

 sky130_fd_sc_hd__fill_8 FILLER_0_0 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_101 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_103 ();
 sky130_fd_sc_hd__fill_8 FILLER_0_11 ();
 sky130_fd_sc_hd__fill_8 FILLER_0_113 ();
 sky130_fd_sc_hd__fill_8 FILLER_0_121 ();
 sky130_fd_sc_hd__fill_8 FILLER_0_129 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_137 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_139 ();
 sky130_fd_sc_hd__fill_4 FILLER_0_141 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_145 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_150 ();
 sky130_fd_sc_hd__fill_4 FILLER_0_154 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_158 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_166 ();
 sky130_fd_sc_hd__fill_4 FILLER_0_169 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_19 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_27 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_29 ();
 sky130_fd_sc_hd__fill_8 FILLER_0_37 ();
 sky130_fd_sc_hd__fill_8 FILLER_0_45 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_53 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_55 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_57 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_59 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_63 ();
 sky130_fd_sc_hd__fill_8 FILLER_0_85 ();
 sky130_fd_sc_hd__fill_8 FILLER_1_0 ();
 sky130_fd_sc_hd__fill_4 FILLER_1_106 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_110 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_115 ();
 sky130_fd_sc_hd__fill_8 FILLER_1_13 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_132 ();
 sky130_fd_sc_hd__fill_8 FILLER_1_149 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_157 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_159 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_166 ();
 sky130_fd_sc_hd__fill_4 FILLER_1_169 ();
 sky130_fd_sc_hd__fill_8 FILLER_1_21 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_29 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_43 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_47 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_54 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_60 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_65 ();
 sky130_fd_sc_hd__fill_8 FILLER_1_70 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_78 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_8 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_80 ();
 sky130_fd_sc_hd__fill_4 FILLER_1_84 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_88 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_90 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_95 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_97 ();
 sky130_fd_sc_hd__fill_8 FILLER_2_0 ();
 sky130_fd_sc_hd__fill_8 FILLER_2_103 ();
 sky130_fd_sc_hd__fill_8 FILLER_2_119 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_127 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_137 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_139 ();
 sky130_fd_sc_hd__fill_8 FILLER_2_141 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_149 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_151 ();
 sky130_fd_sc_hd__fill_8 FILLER_2_16 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_160 ();
 sky130_fd_sc_hd__fill_4 FILLER_2_169 ();
 sky130_fd_sc_hd__fill_4 FILLER_2_24 ();
 sky130_fd_sc_hd__fill_8 FILLER_2_32 ();
 sky130_fd_sc_hd__fill_8 FILLER_2_40 ();
 sky130_fd_sc_hd__fill_4 FILLER_2_48 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_52 ();
 sky130_fd_sc_hd__fill_4 FILLER_2_57 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_61 ();
 sky130_fd_sc_hd__fill_8 FILLER_2_71 ();
 sky130_fd_sc_hd__fill_4 FILLER_2_79 ();
 sky130_fd_sc_hd__fill_8 FILLER_2_8 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_83 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_85 ();
 sky130_fd_sc_hd__fill_8 FILLER_2_95 ();
 sky130_fd_sc_hd__fill_8 FILLER_3_0 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_101 ();
 sky130_fd_sc_hd__fill_4 FILLER_3_106 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_110 ();
 sky130_fd_sc_hd__fill_4 FILLER_3_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_117 ();
 sky130_fd_sc_hd__fill_4 FILLER_3_121 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_125 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_146 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_155 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_157 ();
 sky130_fd_sc_hd__fill_8 FILLER_3_16 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_166 ();
 sky130_fd_sc_hd__fill_4 FILLER_3_169 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_24 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_26 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_36 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_41 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_46 ();
 sky130_fd_sc_hd__fill_4 FILLER_3_50 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_54 ();
 sky130_fd_sc_hd__fill_4 FILLER_3_57 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_61 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_63 ();
 sky130_fd_sc_hd__fill_8 FILLER_3_70 ();
 sky130_fd_sc_hd__fill_4 FILLER_3_78 ();
 sky130_fd_sc_hd__fill_8 FILLER_3_8 ();
 sky130_fd_sc_hd__fill_8 FILLER_3_93 ();
 sky130_fd_sc_hd__fill_8 FILLER_4_0 ();
 sky130_fd_sc_hd__fill_4 FILLER_4_129 ();
 sky130_fd_sc_hd__fill_8 FILLER_4_13 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_133 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_137 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_139 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_141 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_143 ();
 sky130_fd_sc_hd__fill_4 FILLER_4_167 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_171 ();
 sky130_fd_sc_hd__fill_4 FILLER_4_21 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_25 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_27 ();
 sky130_fd_sc_hd__fill_8 FILLER_4_35 ();
 sky130_fd_sc_hd__fill_4 FILLER_4_43 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_47 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_49 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_56 ();
 sky130_fd_sc_hd__fill_4 FILLER_4_61 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_65 ();
 sky130_fd_sc_hd__fill_8 FILLER_4_69 ();
 sky130_fd_sc_hd__fill_4 FILLER_4_77 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_8 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_81 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_83 ();
 sky130_fd_sc_hd__fill_4 FILLER_4_85 ();
 sky130_fd_sc_hd__fill_8 FILLER_5_0 ();
 sky130_fd_sc_hd__fill_4 FILLER_5_107 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_11 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_111 ();
 sky130_fd_sc_hd__fill_8 FILLER_5_113 ();
 sky130_fd_sc_hd__fill_8 FILLER_5_121 ();
 sky130_fd_sc_hd__fill_8 FILLER_5_129 ();
 sky130_fd_sc_hd__fill_8 FILLER_5_137 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_145 ();
 sky130_fd_sc_hd__fill_8 FILLER_5_150 ();
 sky130_fd_sc_hd__fill_4 FILLER_5_158 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_16 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_162 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_166 ();
 sky130_fd_sc_hd__fill_4 FILLER_5_169 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_20 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_25 ();
 sky130_fd_sc_hd__fill_8 FILLER_5_29 ();
 sky130_fd_sc_hd__fill_8 FILLER_5_37 ();
 sky130_fd_sc_hd__fill_8 FILLER_5_45 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_53 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_55 ();
 sky130_fd_sc_hd__fill_8 FILLER_5_57 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_65 ();
 sky130_fd_sc_hd__fill_4 FILLER_6_0 ();
 sky130_fd_sc_hd__fill_8 FILLER_6_12 ();
 sky130_fd_sc_hd__fill_4 FILLER_6_127 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_131 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_133 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_137 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_139 ();
 sky130_fd_sc_hd__fill_4 FILLER_6_141 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_145 ();
 sky130_fd_sc_hd__fill_4 FILLER_6_167 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_171 ();
 sky130_fd_sc_hd__fill_8 FILLER_6_20 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_38 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_4 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_54 ();
 sky130_fd_sc_hd__fill_4 FILLER_6_58 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_62 ();
 sky130_fd_sc_hd__fill_8 FILLER_6_69 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_77 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_81 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_83 ();
 sky130_fd_sc_hd__fill_8 FILLER_6_85 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_93 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_95 ();
 sky130_fd_sc_hd__fill_8 FILLER_6_99 ();
 sky130_fd_sc_hd__fill_8 FILLER_7_0 ();
 sky130_fd_sc_hd__fill_2 FILLER_7_102 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_104 ();
 sky130_fd_sc_hd__fill_4 FILLER_7_108 ();
 sky130_fd_sc_hd__fill_4 FILLER_7_113 ();
 sky130_fd_sc_hd__fill_4 FILLER_7_120 ();
 sky130_fd_sc_hd__fill_2 FILLER_7_124 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_126 ();
 sky130_fd_sc_hd__fill_8 FILLER_7_147 ();
 sky130_fd_sc_hd__fill_8 FILLER_7_15 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_158 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_162 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_167 ();
 sky130_fd_sc_hd__fill_4 FILLER_7_169 ();
 sky130_fd_sc_hd__fill_8 FILLER_7_23 ();
 sky130_fd_sc_hd__fill_8 FILLER_7_31 ();
 sky130_fd_sc_hd__fill_8 FILLER_7_39 ();
 sky130_fd_sc_hd__fill_8 FILLER_7_47 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_55 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_57 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_8 ();
 sky130_fd_sc_hd__fill_4 FILLER_7_98 ();
 sky130_fd_sc_hd__fill_8 FILLER_8_0 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_117 ();
 sky130_fd_sc_hd__fill_2 FILLER_8_138 ();
 sky130_fd_sc_hd__fill_2 FILLER_8_161 ();
 sky130_fd_sc_hd__fill_4 FILLER_8_169 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_17 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_21 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_32 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_39 ();
 sky130_fd_sc_hd__fill_8 FILLER_8_52 ();
 sky130_fd_sc_hd__fill_8 FILLER_8_60 ();
 sky130_fd_sc_hd__fill_8 FILLER_8_71 ();
 sky130_fd_sc_hd__fill_4 FILLER_8_79 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_83 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_85 ();
 sky130_fd_sc_hd__fill_8 FILLER_8_89 ();
 sky130_fd_sc_hd__fill_8 FILLER_9_0 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_101 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_103 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_107 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_115 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_119 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_121 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_131 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_133 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_137 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_139 ();
 sky130_fd_sc_hd__fill_4 FILLER_9_144 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_152 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_156 ();
 sky130_fd_sc_hd__fill_8 FILLER_9_16 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_166 ();
 sky130_fd_sc_hd__fill_4 FILLER_9_169 ();
 sky130_fd_sc_hd__fill_4 FILLER_9_24 ();
 sky130_fd_sc_hd__fill_8 FILLER_9_29 ();
 sky130_fd_sc_hd__fill_8 FILLER_9_37 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_48 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_50 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_54 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_60 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_62 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_66 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_68 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_72 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_74 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_78 ();
 sky130_fd_sc_hd__fill_8 FILLER_9_8 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_80 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_85 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_89 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_91 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_95 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_97 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_1_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_1_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_1_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_3_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_3_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_3_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_5_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_5_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_5_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_22 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_7_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_7_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_7_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_28 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_35 ();
 sky130_fd_sc_hd__buf_2 \xglue/xbgb  (.A(\xglue/bg_ok ),
    .X(uo4));
 sky130_fd_sc_hd__inv_1 \xglue/xbgi  (.A(su),
    .Y(\xglue/bg_ok ));
 sky130_fd_sc_hd__buf_1 \xglue/xbi0  (.A(ui0),
    .X(osc_en));
 sky130_fd_sc_hd__buf_1 \xglue/xbi1  (.A(ui1),
    .X(thr_sel));
 sky130_fd_sc_hd__buf_1 \xglue/xbi2  (.A(ui2),
    .X(vref_mon_en));
 sky130_fd_sc_hd__buf_1 \xglue/xbi3  (.A(ui3),
    .X(iptat_mon_en));
 sky130_fd_sc_hd__buf_1 \xglue/xbi4  (.A(ui4),
    .X(ich_sel));
 sky130_fd_sc_hd__buf_1 \xglue/xbi5  (.A(ui5),
    .X(chop_sel));
 sky130_fd_sc_hd__buf_1 \xglue/xbi6  (.A(ui6),
    .X(ring_en));
 sky130_fd_sc_hd__buf_1 \xglue/xbi7  (.A(ui7),
    .X(i3_sel));
 sky130_fd_sc_hd__buf_2 \xglue/xcb  (.A(cmp_raw),
    .X(uo2));
 sky130_fd_sc_hd__inv_1 \xglue/xci0  (.A(osc_en),
    .Y(osc_enb));
 sky130_fd_sc_hd__inv_1 \xglue/xci1  (.A(thr_sel),
    .Y(thr_selb));
 sky130_fd_sc_hd__inv_1 \xglue/xci2  (.A(vref_mon_en),
    .Y(vref_mon_enb));
 sky130_fd_sc_hd__inv_1 \xglue/xci3  (.A(iptat_mon_en),
    .Y(iptat_mon_enb));
 sky130_fd_sc_hd__dfrtp_1 \xglue/xtff  (.CLK(\xglue/rst_k ),
    .D(\xglue/tqb ),
    .RESET_B(osc_en),
    .Q(\xglue/tq ));
 sky130_fd_sc_hd__inv_1 \xglue/xti  (.A(\xglue/tq ),
    .Y(\xglue/tqb ));
 sky130_fd_sc_hd__conb_1 \xglue/xtie0  (.HI(\xglue/tie_hi0 ),
    .LO(uo5));
 sky130_fd_sc_hd__conb_1 \xglue/xtie1  (.HI(\xglue/tie_hi1 ),
    .LO(uo7));
 sky130_fd_sc_hd__conb_1 \xglue/xtie10  (.HI(\xglue/tie_hi10 ),
    .LO(uio_oe0));
 sky130_fd_sc_hd__conb_1 \xglue/xtie11  (.HI(\xglue/tie_hi11 ),
    .LO(uio_oe1));
 sky130_fd_sc_hd__conb_1 \xglue/xtie12  (.HI(\xglue/tie_hi12 ),
    .LO(uio_oe2));
 sky130_fd_sc_hd__conb_1 \xglue/xtie13  (.HI(\xglue/tie_hi13 ),
    .LO(uio_oe3));
 sky130_fd_sc_hd__conb_1 \xglue/xtie14  (.HI(\xglue/tie_hi14 ),
    .LO(uio_oe4));
 sky130_fd_sc_hd__conb_1 \xglue/xtie15  (.HI(\xglue/tie_hi15 ),
    .LO(uio_oe5));
 sky130_fd_sc_hd__conb_1 \xglue/xtie16  (.HI(\xglue/tie_hi16 ),
    .LO(uio_oe6));
 sky130_fd_sc_hd__conb_1 \xglue/xtie17  (.HI(\xglue/tie_hi17 ),
    .LO(uio_oe7));
 sky130_fd_sc_hd__conb_1 \xglue/xtie2  (.HI(\xglue/tie_hi2 ),
    .LO(uio_out0));
 sky130_fd_sc_hd__conb_1 \xglue/xtie3  (.HI(\xglue/tie_hi3 ),
    .LO(uio_out1));
 sky130_fd_sc_hd__conb_1 \xglue/xtie4  (.HI(\xglue/tie_hi4 ),
    .LO(uio_out2));
 sky130_fd_sc_hd__conb_1 \xglue/xtie5  (.HI(\xglue/tie_hi5 ),
    .LO(uio_out3));
 sky130_fd_sc_hd__conb_1 \xglue/xtie6  (.HI(\xglue/tie_hi6 ),
    .LO(uio_out4));
 sky130_fd_sc_hd__conb_1 \xglue/xtie7  (.HI(\xglue/tie_hi7 ),
    .LO(uio_out5));
 sky130_fd_sc_hd__conb_1 \xglue/xtie8  (.HI(\xglue/tie_hi8 ),
    .LO(uio_out6));
 sky130_fd_sc_hd__conb_1 \xglue/xtie9  (.HI(\xglue/tie_hi9 ),
    .LO(uio_out7));
 sky130_fd_sc_hd__buf_2 \xglue/xtk  (.A(rst),
    .X(\xglue/rst_k ));
 sky130_fd_sc_hd__buf_2 \xglue/xto  (.A(\xglue/tq ),
    .X(uo0));
 sky130_fd_sc_hd__buf_2 \xring/xd/xbo  (.A(\xring/xd/q3 ),
    .X(uo6));
 sky130_fd_sc_hd__dlygate4sd3_1 \xring/xd/xd1  (.A(\xring/xd/r0 ),
    .X(\xring/xd/r1 ));
 sky130_fd_sc_hd__dlygate4sd3_1 \xring/xd/xd10  (.A(\xring/xd/r9 ),
    .X(\xring/xd/r10 ));
 sky130_fd_sc_hd__dlygate4sd3_1 \xring/xd/xd11  (.A(\xring/xd/r10 ),
    .X(\xring/xd/r11 ));
 sky130_fd_sc_hd__dlygate4sd3_1 \xring/xd/xd12  (.A(\xring/xd/r11 ),
    .X(\xring/xd/r12 ));
 sky130_fd_sc_hd__dlygate4sd3_1 \xring/xd/xd13  (.A(\xring/xd/r12 ),
    .X(\xring/xd/r13 ));
 sky130_fd_sc_hd__dlygate4sd3_1 \xring/xd/xd14  (.A(\xring/xd/r13 ),
    .X(\xring/xd/r14 ));
 sky130_fd_sc_hd__dlygate4sd3_1 \xring/xd/xd15  (.A(\xring/xd/r14 ),
    .X(\xring/xd/r15 ));
 sky130_fd_sc_hd__dlygate4sd3_1 \xring/xd/xd2  (.A(\xring/xd/r1 ),
    .X(\xring/xd/r2 ));
 sky130_fd_sc_hd__dlygate4sd3_1 \xring/xd/xd3  (.A(\xring/xd/r2 ),
    .X(\xring/xd/r3 ));
 sky130_fd_sc_hd__dlygate4sd3_1 \xring/xd/xd4  (.A(\xring/xd/r3 ),
    .X(\xring/xd/r4 ));
 sky130_fd_sc_hd__dlygate4sd3_1 \xring/xd/xd5  (.A(\xring/xd/r4 ),
    .X(\xring/xd/r5 ));
 sky130_fd_sc_hd__dlygate4sd3_1 \xring/xd/xd6  (.A(\xring/xd/r5 ),
    .X(\xring/xd/r6 ));
 sky130_fd_sc_hd__dlygate4sd3_1 \xring/xd/xd7  (.A(\xring/xd/r6 ),
    .X(\xring/xd/r7 ));
 sky130_fd_sc_hd__dlygate4sd3_1 \xring/xd/xd8  (.A(\xring/xd/r7 ),
    .X(\xring/xd/r8 ));
 sky130_fd_sc_hd__dlygate4sd3_1 \xring/xd/xd9  (.A(\xring/xd/r8 ),
    .X(\xring/xd/r9 ));
 sky130_fd_sc_hd__dfrtp_1 \xring/xd/xf0  (.CLK(\xring/xd/r0 ),
    .D(\xring/xd/qb0 ),
    .RESET_B(ring_en),
    .Q(\xring/xd/q0 ));
 sky130_fd_sc_hd__dfrtp_1 \xring/xd/xf1  (.CLK(\xring/xd/q0 ),
    .D(\xring/xd/qb1 ),
    .RESET_B(ring_en),
    .Q(\xring/xd/q1 ));
 sky130_fd_sc_hd__dfrtp_1 \xring/xd/xf2  (.CLK(\xring/xd/q1 ),
    .D(\xring/xd/qb2 ),
    .RESET_B(ring_en),
    .Q(\xring/xd/q2 ));
 sky130_fd_sc_hd__dfrtp_1 \xring/xd/xf3  (.CLK(\xring/xd/q2 ),
    .D(\xring/xd/qb3 ),
    .RESET_B(ring_en),
    .Q(\xring/xd/q3 ));
 sky130_fd_sc_hd__nand2_1 \xring/xd/xg0  (.A(ring_en),
    .B(\xring/xd/r15 ),
    .Y(\xring/xd/r0 ));
 sky130_fd_sc_hd__inv_1 \xring/xd/xqi0  (.A(\xring/xd/q0 ),
    .Y(\xring/xd/qb0 ));
 sky130_fd_sc_hd__inv_1 \xring/xd/xqi1  (.A(\xring/xd/q1 ),
    .Y(\xring/xd/qb1 ));
 sky130_fd_sc_hd__inv_1 \xring/xd/xqi2  (.A(\xring/xd/q2 ),
    .Y(\xring/xd/qb2 ));
 sky130_fd_sc_hd__inv_1 \xring/xd/xqi3  (.A(\xring/xd/q3 ),
    .Y(\xring/xd/qb3 ));
 sky130_fd_sc_hd__buf_2 \xring/xn/xbo  (.A(\xring/xn/q4 ),
    .X(uo1));
 sky130_fd_sc_hd__dfrtp_1 \xring/xn/xf0  (.CLK(\xring/xn/r0 ),
    .D(\xring/xn/qb0 ),
    .RESET_B(ring_en),
    .Q(\xring/xn/q0 ));
 sky130_fd_sc_hd__dfrtp_1 \xring/xn/xf1  (.CLK(\xring/xn/q0 ),
    .D(\xring/xn/qb1 ),
    .RESET_B(ring_en),
    .Q(\xring/xn/q1 ));
 sky130_fd_sc_hd__dfrtp_1 \xring/xn/xf2  (.CLK(\xring/xn/q1 ),
    .D(\xring/xn/qb2 ),
    .RESET_B(ring_en),
    .Q(\xring/xn/q2 ));
 sky130_fd_sc_hd__dfrtp_1 \xring/xn/xf3  (.CLK(\xring/xn/q2 ),
    .D(\xring/xn/qb3 ),
    .RESET_B(ring_en),
    .Q(\xring/xn/q3 ));
 sky130_fd_sc_hd__dfrtp_1 \xring/xn/xf4  (.CLK(\xring/xn/q3 ),
    .D(\xring/xn/qb4 ),
    .RESET_B(ring_en),
    .Q(\xring/xn/q4 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg0  (.A(ring_en),
    .B(\xring/xn/r30 ),
    .Y(\xring/xn/r0 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg1  (.A(\xring/xn/hi ),
    .B(\xring/xn/r0 ),
    .Y(\xring/xn/r1 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg10  (.A(\xring/xn/hi ),
    .B(\xring/xn/r9 ),
    .Y(\xring/xn/r10 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg11  (.A(\xring/xn/hi ),
    .B(\xring/xn/r10 ),
    .Y(\xring/xn/r11 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg12  (.A(\xring/xn/hi ),
    .B(\xring/xn/r11 ),
    .Y(\xring/xn/r12 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg13  (.A(\xring/xn/hi ),
    .B(\xring/xn/r12 ),
    .Y(\xring/xn/r13 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg14  (.A(\xring/xn/hi ),
    .B(\xring/xn/r13 ),
    .Y(\xring/xn/r14 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg15  (.A(\xring/xn/hi ),
    .B(\xring/xn/r14 ),
    .Y(\xring/xn/r15 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg16  (.A(\xring/xn/hi ),
    .B(\xring/xn/r15 ),
    .Y(\xring/xn/r16 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg17  (.A(\xring/xn/hi ),
    .B(\xring/xn/r16 ),
    .Y(\xring/xn/r17 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg18  (.A(\xring/xn/hi ),
    .B(\xring/xn/r17 ),
    .Y(\xring/xn/r18 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg19  (.A(\xring/xn/hi ),
    .B(\xring/xn/r18 ),
    .Y(\xring/xn/r19 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg2  (.A(\xring/xn/hi ),
    .B(\xring/xn/r1 ),
    .Y(\xring/xn/r2 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg20  (.A(\xring/xn/hi ),
    .B(\xring/xn/r19 ),
    .Y(\xring/xn/r20 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg21  (.A(\xring/xn/hi ),
    .B(\xring/xn/r20 ),
    .Y(\xring/xn/r21 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg22  (.A(\xring/xn/hi ),
    .B(\xring/xn/r21 ),
    .Y(\xring/xn/r22 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg23  (.A(\xring/xn/hi ),
    .B(\xring/xn/r22 ),
    .Y(\xring/xn/r23 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg24  (.A(\xring/xn/hi ),
    .B(\xring/xn/r23 ),
    .Y(\xring/xn/r24 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg25  (.A(\xring/xn/hi ),
    .B(\xring/xn/r24 ),
    .Y(\xring/xn/r25 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg26  (.A(\xring/xn/hi ),
    .B(\xring/xn/r25 ),
    .Y(\xring/xn/r26 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg27  (.A(\xring/xn/hi ),
    .B(\xring/xn/r26 ),
    .Y(\xring/xn/r27 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg28  (.A(\xring/xn/hi ),
    .B(\xring/xn/r27 ),
    .Y(\xring/xn/r28 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg29  (.A(\xring/xn/hi ),
    .B(\xring/xn/r28 ),
    .Y(\xring/xn/r29 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg3  (.A(\xring/xn/hi ),
    .B(\xring/xn/r2 ),
    .Y(\xring/xn/r3 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg30  (.A(\xring/xn/hi ),
    .B(\xring/xn/r29 ),
    .Y(\xring/xn/r30 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg4  (.A(\xring/xn/hi ),
    .B(\xring/xn/r3 ),
    .Y(\xring/xn/r4 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg5  (.A(\xring/xn/hi ),
    .B(\xring/xn/r4 ),
    .Y(\xring/xn/r5 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg6  (.A(\xring/xn/hi ),
    .B(\xring/xn/r5 ),
    .Y(\xring/xn/r6 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg7  (.A(\xring/xn/hi ),
    .B(\xring/xn/r6 ),
    .Y(\xring/xn/r7 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg8  (.A(\xring/xn/hi ),
    .B(\xring/xn/r7 ),
    .Y(\xring/xn/r8 ));
 sky130_fd_sc_hd__nand2_1 \xring/xn/xg9  (.A(\xring/xn/hi ),
    .B(\xring/xn/r8 ),
    .Y(\xring/xn/r9 ));
 sky130_fd_sc_hd__inv_1 \xring/xn/xqi0  (.A(\xring/xn/q0 ),
    .Y(\xring/xn/qb0 ));
 sky130_fd_sc_hd__inv_1 \xring/xn/xqi1  (.A(\xring/xn/q1 ),
    .Y(\xring/xn/qb1 ));
 sky130_fd_sc_hd__inv_1 \xring/xn/xqi2  (.A(\xring/xn/q2 ),
    .Y(\xring/xn/qb2 ));
 sky130_fd_sc_hd__inv_1 \xring/xn/xqi3  (.A(\xring/xn/q3 ),
    .Y(\xring/xn/qb3 ));
 sky130_fd_sc_hd__inv_1 \xring/xn/xqi4  (.A(\xring/xn/q4 ),
    .Y(\xring/xn/qb4 ));
 sky130_fd_sc_hd__conb_1 \xring/xn/xtie  (.HI(\xring/xn/hi ),
    .LO(\xring/xn/tie_lo ));
 sky130_fd_sc_hd__buf_2 \xring/xp/xbo  (.A(\xring/xp/q4 ),
    .X(uo3));
 sky130_fd_sc_hd__dfrtp_1 \xring/xp/xf0  (.CLK(\xring/xp/r0 ),
    .D(\xring/xp/qb0 ),
    .RESET_B(ring_en),
    .Q(\xring/xp/q0 ));
 sky130_fd_sc_hd__dfrtp_1 \xring/xp/xf1  (.CLK(\xring/xp/q0 ),
    .D(\xring/xp/qb1 ),
    .RESET_B(ring_en),
    .Q(\xring/xp/q1 ));
 sky130_fd_sc_hd__dfrtp_1 \xring/xp/xf2  (.CLK(\xring/xp/q1 ),
    .D(\xring/xp/qb2 ),
    .RESET_B(ring_en),
    .Q(\xring/xp/q2 ));
 sky130_fd_sc_hd__dfrtp_1 \xring/xp/xf3  (.CLK(\xring/xp/q2 ),
    .D(\xring/xp/qb3 ),
    .RESET_B(ring_en),
    .Q(\xring/xp/q3 ));
 sky130_fd_sc_hd__dfrtp_1 \xring/xp/xf4  (.CLK(\xring/xp/q3 ),
    .D(\xring/xp/qb4 ),
    .RESET_B(ring_en),
    .Q(\xring/xp/q4 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg0  (.A(\xring/xp/enb ),
    .B(\xring/xp/r30 ),
    .Y(\xring/xp/r0 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg1  (.A(\xring/xp/lo ),
    .B(\xring/xp/r0 ),
    .Y(\xring/xp/r1 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg10  (.A(\xring/xp/lo ),
    .B(\xring/xp/r9 ),
    .Y(\xring/xp/r10 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg11  (.A(\xring/xp/lo ),
    .B(\xring/xp/r10 ),
    .Y(\xring/xp/r11 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg12  (.A(\xring/xp/lo ),
    .B(\xring/xp/r11 ),
    .Y(\xring/xp/r12 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg13  (.A(\xring/xp/lo ),
    .B(\xring/xp/r12 ),
    .Y(\xring/xp/r13 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg14  (.A(\xring/xp/lo ),
    .B(\xring/xp/r13 ),
    .Y(\xring/xp/r14 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg15  (.A(\xring/xp/lo ),
    .B(\xring/xp/r14 ),
    .Y(\xring/xp/r15 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg16  (.A(\xring/xp/lo ),
    .B(\xring/xp/r15 ),
    .Y(\xring/xp/r16 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg17  (.A(\xring/xp/lo ),
    .B(\xring/xp/r16 ),
    .Y(\xring/xp/r17 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg18  (.A(\xring/xp/lo ),
    .B(\xring/xp/r17 ),
    .Y(\xring/xp/r18 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg19  (.A(\xring/xp/lo ),
    .B(\xring/xp/r18 ),
    .Y(\xring/xp/r19 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg2  (.A(\xring/xp/lo ),
    .B(\xring/xp/r1 ),
    .Y(\xring/xp/r2 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg20  (.A(\xring/xp/lo ),
    .B(\xring/xp/r19 ),
    .Y(\xring/xp/r20 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg21  (.A(\xring/xp/lo ),
    .B(\xring/xp/r20 ),
    .Y(\xring/xp/r21 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg22  (.A(\xring/xp/lo ),
    .B(\xring/xp/r21 ),
    .Y(\xring/xp/r22 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg23  (.A(\xring/xp/lo ),
    .B(\xring/xp/r22 ),
    .Y(\xring/xp/r23 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg24  (.A(\xring/xp/lo ),
    .B(\xring/xp/r23 ),
    .Y(\xring/xp/r24 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg25  (.A(\xring/xp/lo ),
    .B(\xring/xp/r24 ),
    .Y(\xring/xp/r25 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg26  (.A(\xring/xp/lo ),
    .B(\xring/xp/r25 ),
    .Y(\xring/xp/r26 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg27  (.A(\xring/xp/lo ),
    .B(\xring/xp/r26 ),
    .Y(\xring/xp/r27 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg28  (.A(\xring/xp/lo ),
    .B(\xring/xp/r27 ),
    .Y(\xring/xp/r28 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg29  (.A(\xring/xp/lo ),
    .B(\xring/xp/r28 ),
    .Y(\xring/xp/r29 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg3  (.A(\xring/xp/lo ),
    .B(\xring/xp/r2 ),
    .Y(\xring/xp/r3 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg30  (.A(\xring/xp/lo ),
    .B(\xring/xp/r29 ),
    .Y(\xring/xp/r30 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg4  (.A(\xring/xp/lo ),
    .B(\xring/xp/r3 ),
    .Y(\xring/xp/r4 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg5  (.A(\xring/xp/lo ),
    .B(\xring/xp/r4 ),
    .Y(\xring/xp/r5 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg6  (.A(\xring/xp/lo ),
    .B(\xring/xp/r5 ),
    .Y(\xring/xp/r6 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg7  (.A(\xring/xp/lo ),
    .B(\xring/xp/r6 ),
    .Y(\xring/xp/r7 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg8  (.A(\xring/xp/lo ),
    .B(\xring/xp/r7 ),
    .Y(\xring/xp/r8 ));
 sky130_fd_sc_hd__nor2_1 \xring/xp/xg9  (.A(\xring/xp/lo ),
    .B(\xring/xp/r8 ),
    .Y(\xring/xp/r9 ));
 sky130_fd_sc_hd__inv_1 \xring/xp/xie  (.A(ring_en),
    .Y(\xring/xp/enb ));
 sky130_fd_sc_hd__inv_1 \xring/xp/xqi0  (.A(\xring/xp/q0 ),
    .Y(\xring/xp/qb0 ));
 sky130_fd_sc_hd__inv_1 \xring/xp/xqi1  (.A(\xring/xp/q1 ),
    .Y(\xring/xp/qb1 ));
 sky130_fd_sc_hd__inv_1 \xring/xp/xqi2  (.A(\xring/xp/q2 ),
    .Y(\xring/xp/qb2 ));
 sky130_fd_sc_hd__inv_1 \xring/xp/xqi3  (.A(\xring/xp/q3 ),
    .Y(\xring/xp/qb3 ));
 sky130_fd_sc_hd__inv_1 \xring/xp/xqi4  (.A(\xring/xp/q4 ),
    .Y(\xring/xp/qb4 ));
 sky130_fd_sc_hd__conb_1 \xring/xp/xtie  (.HI(\xring/xp/tie_hi ),
    .LO(\xring/xp/lo ));
endmodule
