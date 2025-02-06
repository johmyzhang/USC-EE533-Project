////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /    Vendor: Xilinx 
// \   \   \/     Version : 10.1
//  \   \         Application : sch2verilog
//  /   /         Filename : detect7B.vf
// /___/   /\     Timestamp : 01/30/2025 18:06:48
// \   \  /  \ 
//  \___\/\___\ 
//
//Command: C:\Xilinx\10.1\ISE\bin\nt\unwrapped\sch2verilog.exe -intstyle ise -family virtex2 -w "C:/Documents and Settings/student/isetest/isim/lab3/detect7B.sch" detect7B.vf
//Design Name: detect7B
//Device: virtex2
//Purpose:
//    This verilog netlist is translated from an ECS schematic.It can be 
//    synthesized and simulated, but it should not be modified. 
//
`timescale 1ns / 1ps

module detect7B(ce, 
                clk, 
                hwregA, 
                match_en, 
                mrst, 
                pipe1, 
                match, 
                pipe0);

    input ce;
    input clk;
    input [63:0] hwregA;
    input match_en;
    input mrst;
    input [71:0] pipe1;
   output match;
   output [71:0] pipe0;
   
   wire [55:0] hwergA;
   wire [111:0] XLXN_1;
   wire XLXN_8;
   wire XLXN_13;
   wire XLXN_14;
   wire match_DUMMY;
   wire [71:0] pipe0_DUMMY;
   
   assign match = match_DUMMY;
   assign pipe0[71:0] = pipe0_DUMMY[71:0];
   busmerge XLXI_1 (.da(pipe0_DUMMY[47:0]), 
                    .db(pipe1[63:0]), 
                    .q(XLXN_1[111:0]));
   wordmatch XLXI_2 (.datacomp(hwergA[55:0]), 
                     .datain(XLXN_1[111:0]), 
                     .wildcard(hwregA[62:56]), 
                     .match(XLXN_14));
   reg9B XLXI_3 (.ce(ce), 
                 .clk(clk), 
                 .clr(XLXN_8), 
                 .D(pipe1[71:0]), 
                 .Q(pipe0_DUMMY[71:0]));
   FD XLXI_4 (.C(clk), 
              .D(mrst), 
              .Q(XLXN_8));
   defparam XLXI_4.INIT = 1'b0;
   FDCE XLXI_5 (.C(clk), 
                .CE(XLXN_13), 
                .CLR(XLXN_8), 
                .D(XLXN_13), 
                .Q(match_DUMMY));
   defparam XLXI_5.INIT = 1'b0;
   AND3B1 XLXI_6 (.I0(match_DUMMY), 
                  .I1(match_en), 
                  .I2(XLXN_14), 
                  .O(XLXN_13));
endmodule
