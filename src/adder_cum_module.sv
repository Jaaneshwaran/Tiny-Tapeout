// This module contains 10 adders

module adder_cummulative_module (
  input logic [31:0] add1_a ,
  input logic [31:0] add1_b ,
  input logic [31:0] add2_a ,
  input logic [31:0] add2_b ,
  input logic [31:0] add3_a ,
  input logic [31:0] add3_b ,
  input logic [31:0] add4_a ,
  input logic [31:0] add4_b ,
  input logic [31:0] add5_a ,
  input logic [31:0] add5_b ,
  input logic [31:0] add6_a ,
  input logic [31:0] add6_b ,
  input logic [31:0] add7_a ,
  input logic [31:0] add7_b ,
  input logic [31:0] add8_a ,
  input logic [31:0] add8_b ,
  input logic [31:0] add9_a ,
  input logic [31:0] add9_b ,
  input logic [31:0] add10_a ,
  input logic [31:0] add10_b ,
  output logic [31:0] add1_res ,
  output logic [31:0] add2_res ,
  output logic [31:0] add3_res ,
  output logic [31:0] add4_res ,
  output logic [31:0] add5_res ,
  output logic [31:0] add6_res ,
  output logic [31:0] add7_res ,
  output logic [31:0] add8_res ,
  output logic [31:0] add9_res ,
  output logic [31:0] add10_res
);

fh_without_carry_adder_32_bits full_adder_inst_1 (
 .a (add1_a) ,
 .b (add1_b) ,
 .sum (add1_res)
);

fh_without_carry_adder_32_bits full_adder_inst_2 (
 .a (add2_a) ,
 .b (add2_b) ,
 .sum (add2_res)
);

fh_without_carry_adder_32_bits full_adder_inst_3 (
 .a (add3_a) ,
 .b (add3_b) ,
 .sum (add3_res)
);

fh_without_carry_adder_32_bits full_adder_inst_4 (
 .a (add4_a) ,
 .b (add4_b) ,
 .sum (add4_res)
);

fh_without_carry_adder_32_bits full_adder_inst_5 (
 .a (add5_a) ,
 .b (add5_b) ,
 .sum (add5_res)
);

fh_without_carry_adder_32_bits full_adder_inst_6 (
 .a (add6_a) ,
 .b (add6_b) ,
 .sum (add6_res)
);

fh_without_carry_adder_32_bits full_adder_inst_7 (
 .a (add7_a) ,
 .b (add7_b) ,
 .sum (add7_res)
);

fh_without_carry_adder_32_bits full_adder_inst_8 (
 .a (add8_a) ,
 .b (add8_b) ,
 .sum (add8_res)
);

fh_without_carry_adder_32_bits full_adder_inst_9 (
 .a (add9_a) ,
 .b (add9_b) ,
 .sum (add9_res)
);

fh_without_carry_adder_32_bits full_adder_inst_10 (
 .a (add10_a) ,
 .b (add10_b) ,
 .sum (add10_res)
);

endmodule 
