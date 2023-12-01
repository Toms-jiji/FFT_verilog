`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Author: Toms Jiji Varghese
// 
// Create Date: 11/26/2023 05:10:10 PM
// Last Update: 11/27/2023 08:43:54 PM
// Module Name: DIT_DDT_8
// Revision 0.03
// Additional Comments:
// The input and output data are in the formal ->
//      -----------------------------------------------------------------------
//      | signbit (1) | fractional_part_of_data(7) |  decimal_part_of_data(8) |
//      -----------------------------------------------------------------------
// NOTE: fractional and decimal part of data are in normal form (non inverter  
//       and NOT 2's complement) even if they are negative
//////////////////////////////////////////////////////////////////////////////////


module dit_fft_8_tb;

  // Inputs
  reg [15:0] in0_r, in1_r, in2_r, in3_r, in4_r, in5_r, in6_r, in7_r;
  reg [15:0] in0_i, in1_i, in2_i, in3_i, in4_i, in5_i, in6_i, in7_i;
  reg clk, RST_N, write, start;

  // Outputs
  wire [15:0] out0_r, out1_r, out2_r, out3_r, out4_r, out5_r, out6_r, out7_r;
  wire [15:0] out0_i, out1_i, out2_i, out3_i, out4_i, out5_i, out6_i, out7_i;
  wire ready;

    parameter cp = 4;
    parameter tick = cp/2;
  // Instantiate the Unit Under Test (UUT)
  dit_fft_8 uut (
    .in0_r(in0_r), .in1_r(in1_r), .in2_r(in2_r), .in3_r(in3_r),
    .in4_r(in4_r), .in5_r(in5_r), .in6_r(in6_r), .in7_r(in7_r),
    .in0_i(in0_i), .in1_i(in1_i), .in2_i(in2_i), .in3_i(in3_i),
    .in4_i(in4_i), .in5_i(in5_i), .in6_i(in6_i), .in7_i(in7_i),
    .clk(clk), .RST_N(RST_N), .write(write), .start(start),
    .out0_r(out0_r), .out1_r(out1_r), .out2_r(out2_r), .out3_r(out3_r),
    .out4_r(out4_r), .out5_r(out5_r), .out6_r(out6_r), .out7_r(out7_r),
    .out0_i(out0_i), .out1_i(out1_i), .out2_i(out2_i), .out3_i(out3_i),
    .out4_i(out4_i), .out5_i(out5_i), .out6_i(out6_i), .out7_i(out7_i),
    .ready(ready)
  );
  
  // Initialize Inputs
  initial begin
    $dumpfile("fft_tb.vcd");
    $dumpvars(0);
    clk <= 0;
    RST_N <= 1'b0;
    write <= 1'b0;
    start <= 1'b0;

    #tick RST_N <= 1'b1;

    #cp write <= 1'b0;
    #cp start <= 1'b0;
    in0_r <= 16'h0000;
    in1_r <= 16'h0100;
    in2_r <= 16'h0200;
    in3_r <= 16'h0300;
    in4_r <= 16'h0400;
    in5_r <= 16'h0500;
    in6_r <= 16'h0600;
    in7_r <= 16'h0700;

    in0_i <= 16'h0000;
    in1_i <= 16'h0000;
    in2_i <= 16'h0000;
    in3_i <= 16'h0000;
    in4_i <= 16'h0000;
    in5_i <= 16'h0000;
    in6_i <= 16'h0000;
    in7_i <= 16'h0000;
    #cp write <= 1'b1;
    #cp start <= 1'b1;
     
    in0_r <= 16'h0400;
    in1_r <= 16'h0500;
    in2_r <= 16'h0600;
    in3_r <= 16'h0700;
    in4_r <= 16'h0800;
    in5_r <= 16'h0900;
    in6_r <= 16'h0400;
    in7_r <= 16'h0500;

    in0_i <= 16'h0000;
    in1_i <= 16'h0000;
    in2_i <= 16'h0000;
    in3_i <= 16'h0000;
    in4_i <= 16'h0000;
    in5_i <= 16'h0000;
    in6_i <= 16'h0000;
    in7_i <= 16'h0000;
    
    #cp in0_r <= 16'h0100;
    in1_r <= 16'h0200;
    in2_r <= 16'h0300;
    in3_r <= 16'h0400;
    in4_r <= 16'h0500;
    in5_r <= 16'h0600;
    in6_r <= 16'h0700;
    in7_r <= 16'h0800;

    in0_i <= 16'h0000;
    in1_i <= 16'h0000;
    in2_i <= 16'h0000;
    in3_i <= 16'h0000;
    in4_i <= 16'h0000;
    in5_i <= 16'h0000;
    in6_i <= 16'h0000;
    in7_i <= 16'h0000;
    
    #cp in0_r <= 16'h0100;
    in1_r <= 16'h0000;
    in2_r <= 16'h0500;
    in3_r <= 16'h0800;
    in4_r <= 16'h0600;
    in5_r <= 16'h0700;
    in6_r <= 16'h0300;
    in7_r <= 16'h0100;

    in0_i <= 16'h0000;
    in1_i <= 16'h0000;
    in2_i <= 16'h0000;
    in3_i <= 16'h0000;
    in4_i <= 16'h0000;
    in5_i <= 16'h0000;
    in6_i <= 16'h0000;
    in7_i <= 16'h0000;
    #cp write <= 1'b0;
    #cp start <= 1'b0; 
     
     
     
     
     
    #99 $display("-----------------------------------------------------------------------------");
    #99 $display("in0: %b.%b + i %b.%b",in0_r[15:8] ,in0_r[7:0] ,in0_i[15:8] ,in0_i[7:0]);
    #99 $display("in1: %b.%b + i %b.%b",in1_r[15:8] ,in1_r[7:0] ,in1_i[15:8] ,in1_i[7:0]);
    #99 $display("in2: %b.%b + i %b.%b",in2_r[15:8] ,in2_r[7:0] ,in2_i[15:8] ,in2_i[7:0]);
    #99 $display("in3: %b.%b + i %b.%b",in3_r[15:8] ,in3_r[7:0] ,in3_i[15:8] ,in3_i[7:0]);
    #99 $display("in4: %b.%b + i %b.%b",in4_r[15:8] ,in4_r[7:0] ,in4_i[15:8] ,in4_i[7:0]);
    #99 $display("in5: %b.%b + i %b.%b",in5_r[15:8] ,in5_r[7:0] ,in5_i[15:8] ,in5_i[7:0]);
    #99 $display("in6: %b.%b + i %b.%b",in6_r[15:8] ,in6_r[7:0] ,in6_i[15:8] ,in6_i[7:0]);
    #99 $display("in7: %b.%b + i %b.%b",in7_r[15:8] ,in7_r[7:0] ,in7_i[15:8] ,in7_i[7:0]);

    #99 $display("-----------------------------------------------------------------------------");
    #99 $display("out0: %b.%b + i %b.%b",out0_r[15:8] ,out0_r[7:0] ,out0_i[15:8] ,out0_i[7:0]);
    #99 $display("out1: %b.%b + i %b.%b",out1_r[15:8] ,out1_r[7:0] ,out1_i[15:8] ,out1_i[7:0]);
    #99 $display("out2: %b.%b + i %b.%b",out2_r[15:8] ,out2_r[7:0] ,out2_i[15:8] ,out2_i[7:0]);
    #99 $display("out3: %b.%b + i %b.%b",out3_r[15:8] ,out3_r[7:0] ,out3_i[15:8] ,out3_i[7:0]);
    #99 $display("out4: %b.%b + i %b.%b",out4_r[15:8] ,out4_r[7:0] ,out4_i[15:8] ,out4_i[7:0]);
    #99 $display("out5: %b.%b + i %b.%b",out5_r[15:8] ,out5_r[7:0] ,out5_i[15:8] ,out5_i[7:0]);
    #99 $display("out6: %b.%b + i %b.%b",out6_r[15:8] ,out6_r[7:0] ,out6_i[15:8] ,out6_i[7:0]);
    #99 $display("out7: %b.%b + i %b.%b",out7_r[15:8] ,out7_r[7:0] ,out7_i[15:8] ,out7_i[7:0]);
    #99 $display("-----------------------------------------------------------------------------");
    #99 $display("-----------------------------------------------------------------------------");
   
    #100 $finish;
  end

  // Toggle clock
  always #tick clk = ~clk;

endmodule
