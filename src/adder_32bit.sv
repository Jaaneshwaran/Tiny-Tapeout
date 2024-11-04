// This is the adder implementation - Ripple carry adder

module half_adder (
  input logic a ,
  input logic b ,
  output logic sum ,
  output logic carry_out
);

  logic b_b , a_b ;

  assign b_b = ~b ;
  assign a_b = ~a ;

  assign sum = ( a & b_b) | (a_b & b) ;
  assign carry_out = a & b ;

endmodule

module half_adder_without_carry (
  input logic a ,
  input logic b ,
  output logic sum
);

  logic b_b , a_b ;

  assign b_b = ~b ;
  assign a_b = ~a ;

  assign sum = ( a & b_b) | (a_b & b) ;

endmodule

module full_adder (
  input logic a ,
  input logic b ,
  input logic cin ,
  output logic sum ,
  output logic carry_out
);

 logic sum_1 , sum_2 ;
 logic c_1 , c_2 ;

 half_adder half_adder_inst1 (
   .a (a) ,
   .b (b) ,
   .sum (sum_1) ,
   .carry_out (c_1)
 );

 half_adder half_adder_inst2 (
   .a (sum_1) ,
   .b (cin) ,
   .sum (sum_2) ,
   .carry_out (c_2)
 );

assign sum  = sum_2 ;
assign carry_out = c_1 | c_2 ;

endmodule

module full_adder_without_carry (
  input logic a ,
  input logic b ,
  input logic cin ,
  output logic sum
);

 logic sum_1 , sum_2 ;

 half_adder_without_carry half_adder_inst1 (
   .a (a) ,
   .b (b) ,
   .sum (sum_1)
 );

 half_adder_without_carry half_adder_inst2 (
   .a (sum_1) ,
   .b (cin) ,
   .sum (sum_2)
 );

assign sum  = sum_2 ;

endmodule

module fh_without_carry_adder_32_bits (
  input logic [31:0] a ,
  input logic [31:0] b ,
  output logic [31:0] sum
);

 genvar i ;
 logic [30:0] cout ;

 half_adder half_adder_bit_0 (
   .a (a[0]) ,
   .b (b[0]) ,
   .sum (sum[0]) ,
   .carry_out (cout[0])
 );


 generate
   for (i = 1 ; i < 31 ; i = i + 1) begin : adder_loop
     full_adder full_addr_bit (
       .a(a[i]),
       .b(b[i]),
       .cin(cout[i-1]),
       .sum (sum[i]) ,
       .carry_out (cout[i])
     );
   end
 endgenerate

 full_adder_without_carry full_addr_bit_31 (
   .a(a[31]),
   .b(b[31]),
   .cin(cout[30]),
   .sum (sum[31])
 );

endmodule
