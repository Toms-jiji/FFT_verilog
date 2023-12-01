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
//       and NOT 2's complement) even if they are negative - signed magnitude
//////////////////////////////////////////////////////////////////////////////////
module dit_fft_8 (
    input [15:0] in0_r, in1_r, in2_r, in3_r, in4_r, in5_r, in6_r, in7_r,            // input real vectors
    input [15:0] in0_i, in1_i, in2_i, in3_i, in4_i, in5_i, in6_i, in7_i,            // input imaginary vectors
    input clk, RST_N, write, start,                                                 // clock, active low rst, input write signal, start signal, 
    output [15:0] out0_r, out1_r, out2_r, out3_r, out4_r, out5_r, out6_r, out7_r,   // output real vectors
    output [15:0] out0_i, out1_i, out2_i, out3_i, out4_i, out5_i, out6_i, out7_i,   // output imaginary vectors 
    output ready                                                                    // output ready signal
);
                      
    reg [15:0] input_r[0:7];
    reg [15:0] input_i[0:7];
    
    reg [15:0] in_r[0:7];
    reg [15:0] in_i[0:7];
    
    wire [15:0] pp1o_r[0:7];
    wire [15:0] pp1o_i[0:7];

    reg [15:0] pp2i_r[0:7];
    reg [15:0] pp2i_i[0:7];
    
    wire [15:0] pp2o_r[0:7];
    wire [15:0] pp2o_i[0:7];

    reg [15:0] pp3i_r[0:7];
    reg [15:0] pp3i_i[0:7];
    
    reg ready_stage0=0, ready_stage1=0, ready_stage2=0, ready_stage3=0;
    
    wire [15:0] w_r[0:7];
    wire [15:0] w_i[0:7];
    
    reg [15:0] out_r[0:7];
    reg [15:0] out_i[0:7];
    
    
    wire [15:0] tmp_r1[0:7];
    wire [15:0] tmp_i1[0:7];
    wire [15:0] tmp_r2[0:7];
    wire [15:0] tmp_i2[0:7];
    integer i;
    
    initial begin
	    for (i = 0; i < 8; i = i + 1) begin
			input_r[i] = 0;
			input_i[i]=0;
			in_r[i]=0;
			in_i[i]=0;
			pp2i_r[i]=0;
			pp2i_i[i]=0;
			pp3i_r[i]=0;
			pp3i_i[i]=0;
			out_r[i]=0;
			out_i[i]=0;
	    end
    end
    
    
    
    
    always @(negedge clk) begin
    ready_stage3 <= 0;
    end
    always @(posedge clk) begin
      if (RST_N == 1'b0) begin
        ready_stage0 <= 0;
        ready_stage1 <= 0;
        ready_stage2 <= 0;
        ready_stage3 <= 0;
        for (i = 0; i < 8; i = i + 1) begin     // If reset is low then write 0 to all reg
          in_r[i] <= 0;
          in_i[i] <= 0;
        end
      end 
      else begin                                      //else write the input data vector if write is high
        if (write == 1'b1) begin
          input_r[0] <= in0_r;
          input_r[1] <= in1_r;
          input_r[2] <= in2_r;
          input_r[3] <= in3_r;
          input_r[4] <= in4_r;
          input_r[5] <= in5_r;
          input_r[6] <= in6_r;
          input_r[7] <= in7_r;
                
          input_i[0] <= in0_i;
          input_i[1] <= in1_i;
          input_i[2] <= in2_i;
          input_i[3] <= in3_i;
          input_i[4] <= in4_i;
          input_i[5] <= in5_i;
          input_i[6] <= in6_i;
          input_i[7] <= in7_i;
        end
            
        if (start == 1'b0) begin
          ready_stage0 <= 0;
        end  
        else begin
          ready_stage0 <= 1;
        end
            
        ready_stage1 <= ready_stage0;
        ready_stage2 <= ready_stage1;
        ready_stage3 <= ready_stage2;
        for (i = 0; i < 8; i = i + 1) begin     // If reset is low then write 0 to all reg
          in_r[i] <= input_r[i];
          in_i[i] <= input_i[i];
          pp2i_r[i] <= pp1o_r[i];
          pp2i_i[i] <= pp1o_i[i];
          pp3i_r[i] <= pp2o_r[i];
          pp3i_i[i] <= pp2o_i[i];
          out_r[i] <= w_r[i];
          out_i[i] <= w_i[i];
        end
      end
    end 
    
    assign out0_r = out_r[0];
    assign out1_r = out_r[1];
    assign out2_r = out_r[2];
    assign out3_r = out_r[3];
    assign out4_r = out_r[4];
    assign out5_r = out_r[5];
    assign out6_r = out_r[6];
    assign out7_r = out_r[7];
    
    assign out0_i = out_i[0];
    assign out1_i = out_i[1];
    assign out2_i = out_i[2];
    assign out3_i = out_i[3];
    assign out4_i = out_i[4];
    assign out5_i = out_i[5];
    assign out6_i = out_i[6];
    assign out7_i = out_i[7];
    
    
    assign ready = ready_stage3;
        butterfly_stage_1 B1(.in_r0(in_r[0]), .in_r1(in_r[4]), .in_r2(in_r[2]), .in_r3(in_r[6]), .in_r4(in_r[1]), .in_r5(in_r[5]), .in_r6(in_r[3]), .in_r7(in_r[7]), 
                          .in_i0(in_i[0]), .in_i1(in_i[4]), .in_i2(in_i[2]), .in_i3(in_i[6]), .in_i4(in_i[1]), .in_i5(in_i[5]), .in_i6(in_i[3]), .in_i7(in_i[7]), 
                          .out_r0(pp1o_r[0]), .out_r1(pp1o_r[1]), .out_r2(pp1o_r[2]), .out_r3(pp1o_r[3]), .out_r4(pp1o_r[4]), .out_r5(pp1o_r[5]), .out_r6(pp1o_r[6]), .out_r7(pp1o_r[7]),  
                          .out_i0(pp1o_i[0]), .out_i1(pp1o_i[1]), .out_i2(pp1o_i[2]), .out_i3(pp1o_i[3]), .out_i4(pp1o_i[4]), .out_i5(pp1o_i[5]), .out_i6(pp1o_i[6]), .out_i7(pp1o_i[7]));
                     
        butterfly_stage_2 B2(.in_r0(pp2i_r[0]), .in_r1(pp2i_r[1]), .in_r2(pp2i_r[2]), .in_r3(pp2i_r[3]), .in_r4(pp2i_r[4]), .in_r5(pp2i_r[5]), .in_r6(pp2i_r[6]), .in_r7(pp2i_r[7]), 
                          .in_i0(pp2i_i[0]), .in_i1(pp2i_i[1]), .in_i2(pp2i_i[2]), .in_i3(pp2i_i[3]), .in_i4(pp2i_i[4]), .in_i5(pp2i_i[5]), .in_i6(pp2i_i[6]), .in_i7(pp2i_i[7]), 
                          .out_r0(pp2o_r[0]), .out_r1(pp2o_r[1]), .out_r2(pp2o_r[2]), .out_r3(pp2o_r[3]), .out_r4(pp2o_r[4]), .out_r5(pp2o_r[5]), .out_r6(pp2o_r[6]), .out_r7(pp2o_r[7]),  
                          .out_i0(pp2o_i[0]), .out_i1(pp2o_i[1]), .out_i2(pp2o_i[2]), .out_i3(pp2o_i[3]), .out_i4(pp2o_i[4]), .out_i5(pp2o_i[5]), .out_i6(pp2o_i[6]), .out_i7(pp2o_i[7]));
                  
        butterfly_stage_3 B3(.in_r0(pp3i_r[0]), .in_r1(pp3i_r[1]), .in_r2(pp3i_r[2]), .in_r3(pp3i_r[3]), .in_r4(pp3i_r[4]), .in_r5(pp3i_r[5]), .in_r6(pp3i_r[6]), .in_r7(pp3i_r[7]), 
                          .in_i0(pp3i_i[0]), .in_i1(pp3i_i[1]), .in_i2(pp3i_i[2]), .in_i3(pp3i_i[3]), .in_i4(pp3i_i[4]), .in_i5(pp3i_i[5]), .in_i6(pp3i_i[6]), .in_i7(pp3i_i[7]), 
                          .out_r0(w_r[0]), .out_r1(w_r[1]), .out_r2(w_r[2]), .out_r3(w_r[3]), .out_r4(w_r[4]), .out_r5(w_r[5]), .out_r6(w_r[6]), .out_r7(w_r[7]),  
                          .out_i0(w_i[0]), .out_i1(w_i[1]), .out_i2(w_i[2]), .out_i3(w_i[3]), .out_i4(w_i[4]), .out_i5(w_i[5]), .out_i6(w_i[6]), .out_i7(w_i[7]));       


endmodule



module butterfly_stage_3(input [15:0] in_r0, in_r1, in_r2, in_r3, in_r4, in_r5, in_r6, in_r7, 
                         input [15:0] in_i0, in_i1, in_i2, in_i3, in_i4, in_i5, in_i6, in_i7, 
                         output [15:0] out_r0, out_r1, out_r2, out_r3, out_r4, out_r5, out_r6, out_r7,  
                         output [15:0] out_i0, out_i1, out_i2, out_i3, out_i4, out_i5, out_i6, out_i7);

    // First butterfly
    butterfly_8_ip B8(.a_r0(in_r0), .b_r1(in_r1), .c_r2(in_r2), .d_r3(in_r3), .e_r4(in_r4), .f_r5(in_r5), .g_r6(in_r6), .h_r7(in_r7), 
                   .a_i0(in_i0), .b_i1(in_i1), .c_i2(in_i2), .d_i3(in_i3), .e_i4(in_i4), .f_i5(in_i5), .g_i6(in_i6), .h_i7(in_i7), 
                   .A_r0(out_r0), .B_r1(out_r1), .C_r2(out_r2), .D_r3(out_r3), .E_r4(out_r4), .F_r5(out_r5), .G_r6(out_r6), .H_r7(out_r7), 
                   .A_i0(out_i0), .B_i1(out_i1), .C_i2(out_i2), .D_i3(out_i3), .E_i4(out_i4), .F_i5(out_i5), .G_i6(out_i6), .H_i7(out_i7));

endmodule

module butterfly_8_ip(input [15:0] a_r0, b_r1, c_r2, d_r3, e_r4, f_r5, g_r6, h_r7 
                                        , a_i0, b_i1, c_i2, d_i3, e_i4, f_i5, g_i6, h_i7, 
                      output [15:0] A_r0, B_r1, C_r2, D_r3, E_r4, F_r5, G_r6, H_r7, 
                                           A_i0, B_i1, C_i2, D_i3, E_i4, F_i5, G_i6, H_i7);
                                           
  wire [15:0] f_tmp_r, f_tmp_i, h_tmp_r, h_tmp_i;
   // A+C - first output
  adder add0(.in0(a_r0), .in1(e_r4), .out(A_r0));
  adder add1(.in0(a_i0), .in1(e_i4), .out(A_i0));
  
  // B+w1F - second output
  complex_multiplier_pn mult0(.in_r1(f_r5), .in_i1(f_i5), .out_r(f_tmp_r), .out_i(f_tmp_i));
  adder add2(.in0(b_r1), .in1(f_tmp_r), .out(B_r1));
  adder add3(.in0(b_i1), .in1(f_tmp_i), .out(B_i1));
  
   // C-jG - third output
  adder add4(.in0(c_r2), .in1(g_i6), .out(C_r2));
  subtractor sub0(.in0(c_i2), .in1(g_r6), .out(C_i2));
  
    // B+w1F - Fourth output
  complex_multiplier_nn mult1(.in_r1(h_r7), .in_i1(h_i7), .out_r(h_tmp_r), .out_i(h_tmp_i));
  adder add5(.in0(d_r3), .in1(h_tmp_r), .out(D_r3));
  adder add6(.in0(d_i3), .in1(h_tmp_i), .out(D_i3));
  
  
     // A+C - Fifth output
  subtractor sub1(.in0(a_r0), .in1(e_r4), .out(E_r4));
  subtractor sub2(.in0(a_i0), .in1(e_i4), .out(E_i4));
  
  // B+w1F - Sixth output
  subtractor sub3(.in0(b_r1), .in1(f_tmp_r), .out(F_r5));
  subtractor sub4(.in0(b_i1), .in1(f_tmp_i), .out(F_i5));
  
   // C-jG - Seventh output
  subtractor sub5(.in0(c_r2), .in1(g_i6), .out(G_i6));
  adder add7(.in0(c_i2), .in1(g_r6), .out(G_r6));
  
    // B+w1F - Eighth output
  subtractor sub6(.in0(d_r3), .in1(h_tmp_r), .out(H_r7));
  subtractor sub7(.in0(d_i3), .in1(h_tmp_i), .out(H_i7));
  
  

endmodule

module butterfly_stage_2(input [15:0] in_r0, in_r1, in_r2, in_r3, in_r4, in_r5, in_r6, in_r7, 
                         input [15:0] in_i0, in_i1, in_i2, in_i3, in_i4, in_i5, in_i6, in_i7, 
                         output [15:0] out_r0, out_r1, out_r2, out_r3, out_r4, out_r5, out_r6, out_r7,  
                         output [15:0] out_i0, out_i1, out_i2, out_i3, out_i4, out_i5, out_i6, out_i7);

    // First butterfly
  butterfly_4_ip b0(.in_r0(in_r0), .in_r1(in_r1), .in_r2(in_r2), .in_r3(in_r3), .in_i0(in_i0), .in_i1(in_i1), .in_i2(in_i2), .in_i3(in_i3), .out_r0(out_r0), .out_r1(out_r1), .out_r2(out_r2), .out_r3(out_r3), .out_i0(out_i0), .out_i1(out_i1), .out_i2(out_i2), .out_i3(out_i3));
  
    // Second butterfly
  butterfly_4_ip b1(.in_r0(in_r4), .in_r1(in_r5), .in_r2(in_r6), .in_r3(in_r7), .in_i0(in_i4), .in_i1(in_i5), .in_i2(in_i6), .in_i3(in_i7), .out_r0(out_r4), .out_r1(out_r5), .out_r2(out_r6), .out_r3(out_r7), .out_i0(out_i4), .out_i1(out_i5), .out_i2(out_i6), .out_i3(out_i7));
  
endmodule

module butterfly_4_ip(input [15:0] in_r0, in_r1, in_r2, in_r3, in_i0, in_i1, in_i2, in_i3, 
                      output [15:0] out_r0, out_r1, out_r2, out_r3, out_i0, out_i1, out_i2, out_i3);
   // A+C - first output
  adder add0(.in0(in_r0), .in1(in_r2), .out(out_r0));
  adder add1(.in0(in_i0), .in1(in_i2), .out(out_i0));
  
   // A-C - second output
  adder add2(.in0(in_r1), .in1(in_i3), .out(out_r1));
  subtractor sub0(.in0(in_i1), .in1(in_r3), .out(out_i1));
  
   // A-C - third output
  subtractor sub1(.in0(in_r0), .in1(in_r2), .out(out_r2));
  subtractor sub2(.in0(in_i0), .in1(in_i2), .out(out_i2));
  
   // A-C - fourth output
  subtractor sub3(.in0(in_r1), .in1(in_i3), .out(out_r3));
  adder add3(.in0(in_i1), .in1(in_r3), .out(out_i3));
endmodule

module butterfly_stage_1(input [15:0] in_r0, in_r1, in_r2, in_r3, in_r4, in_r5, in_r6, in_r7, 
                         input [15:0] in_i0, in_i1, in_i2, in_i3, in_i4, in_i5, in_i6, in_i7, 
                         output [15:0] out_r0, out_r1, out_r2, out_r3, out_r4, out_r5, out_r6, out_r7,  
                         output [15:0] out_i0, out_i1, out_i2, out_i3, out_i4, out_i5, out_i6, out_i7);

    // First butterfly
  butterfly_2_ip b0(.in_r0(in_r0), .in_r1(in_r1), .in_i0(in_i0), .in_i1(in_i1), .out_r0(out_r0), .out_r1(out_r1), .out_i0(out_i0), .out_i1(out_i1));

    // Second butterfly
  butterfly_2_ip b1(.in_r0(in_r2), .in_r1(in_r3), .in_i0(in_i2), .in_i1(in_i3), .out_r0(out_r2), .out_r1(out_r3), .out_i0(out_i2), .out_i1(out_i3));

    // Third butterfly
  butterfly_2_ip b2(.in_r0(in_r4), .in_r1(in_r5), .in_i0(in_i4), .in_i1(in_i5), .out_r0(out_r4), .out_r1(out_r5), .out_i0(out_i4), .out_i1(out_i5));

    // Fourth butterfly
  butterfly_2_ip b3(.in_r0(in_r6), .in_r1(in_r7), .in_i0(in_i6), .in_i1(in_i7), .out_r0(out_r6), .out_r1(out_r7), .out_i0(out_i6), .out_i1(out_i7));
endmodule

module butterfly_2_ip(input [15:0] in_r0, in_r1, in_i0, in_i1, output [15:0] out_r0, out_r1, out_i0, out_i1);
   // A+B - first output
  adder add0(.in0(in_r0), .in1(in_r1), .out(out_r0));
  adder add1(.in0(in_i0), .in1(in_i1), .out(out_i0));

  // A-B - second output
  subtractor sub0(.in0(in_r0), .in1(in_r1), .out(out_r1));
  subtractor sub1(.in0(in_i0), .in1(in_i1), .out(out_i1));
endmodule

module complex_multiplier_pn(input [15:0] in_r1, in_i1, output [15:0] out_r, out_i);
  wire [15:0] tmp_A, tmp_B, tmp_C, tmp_D;

  mult_pos mp0(.in(in_r1) ,.out(tmp_A));
  mult_pos mp1(.in(in_i1) ,.out(tmp_B));
  mult_neg mp2(.in(in_r1) ,.out(tmp_C));
  mult_pos mp3(.in(in_i1) ,.out(tmp_D));

  // Subtract the product of the imaginary parts from the product of the real parts
  adder add0(.in0(tmp_A), .in1(tmp_B), .out(out_r));
  adder add1(.in0(tmp_C), .in1(tmp_D), .out(out_i));
endmodule

module complex_multiplier_nn(input [15:0] in_r1, in_i1, output [15:0] out_r, out_i);
  wire [15:0] tmp_A, tmp_B, tmp_C, tmp_D;

  mult_pos mp0(.in(in_i1) ,.out(tmp_B));   
  mult_neg mp1(.in(in_r1) ,.out(tmp_A));
  mult_neg mp2(.in(in_i1) ,.out(tmp_C));
  mult_neg mp3(.in(in_r1) ,.out(tmp_D));

  // Subtract the product of the imaginary parts from the product of the real parts
  adder add0(.in0(tmp_A), .in1(tmp_B), .out(out_r));
  adder add1(.in0(tmp_C), .in1(tmp_D), .out(out_i));
endmodule

module adder(input [15:0] in0, in1, output [15:0] out);
  wire [15:0] temp1, temp2;
  reg [15:0] temp_out;

  always @* begin
      if(in0[15] == in1[15]) 
          begin      //sign are equal
            temp_out = in0[15]==0 ? {(in0[14:0] + in1[14:0])& 16'h7fff}: {16'h8000 | ((in0[14:0] + in1[14:0])& 16'h7fff)};
            end
        if(in0[15] != in1[15]) //not equal sign
            begin
                if(in0[14:0]>in1[14:0])     // in 0 is greater
                    begin
                        temp_out = in0[15]==0 ? {(in0[14:0] - in1[14:0])& 16'h7fff} : {16'h8000 | ((in0[14:0] - in1[14:0])& 16'h7fff)};
                    end
                else if (in1[14:0]>in0[14:0])
                    begin
                        temp_out = in1[15]==0 ? {(in1[14:0] - in0[14:0])& 16'h7fff} : {16'h8000 | ((in1[14:0] - in0[14:0])& 16'h7fff)};
                    end
                else 
                    begin
                        temp_out = 16'h0000;
                    end
            end
  end
  assign out = temp_out;  
endmodule

module subtractor(input [15:0] in0, in1, output [15:0] out);
  wire [15:0] temp1, temp2;
  reg [15:0] temp_out;
  adder a1(.in0(in0), .in1({~in1[15], in1[14:0]}), .out(out)); 
endmodule

module mult_pos(input [15:0] in, output [15:0] out);
    assign out[15] = in[15];
    assign out[14:0] = (in[14:0]>>1)+(in[14:0]>>3)+(in[14:0]>>4)+(in[14:0]>>6)+(in[14:0]>>8)+ (in[14:0]>>14);
endmodule

module mult_neg(input [15:0] in, output [15:0] out);
    assign out[15] = ~in[15];
    assign out[14:0] = (in[14:0]>>1)+(in[14:0]>>3)+(in[14:0]>>4)+(in[14:0]>>6)+(in[14:0]>>8) + (in[14:0]>>14);
endmodule
