// This is stage 2 of sha 256 compute

module stage2_sha (
  input logic [31:0] a_reg,
  input logic [31:0] b_reg,
  input logic [31:0] c_reg,
  input logic [31:0] d_reg,
  input logic [31:0] e_reg,
  input logic [31:0] f_reg,
  input logic [31:0] g_reg,
  input logic [31:0] h_reg,
  input logic [31:0] wk_reg,
  output logic [31:0] st2_add1_a ,
  output logic [31:0] st2_add1_b ,
  input logic [31:0] st2_add1_res ,
  output logic [31:0] st2_add2_a ,
  output logic [31:0] st2_add2_b ,
  input logic [31:0] st2_add2_res ,
  output logic [31:0] st2_add3_a ,
  output logic [31:0] st2_add3_b ,
  input logic [31:0] st2_add3_res ,
  output logic [31:0] st2_add4_a ,
  output logic [31:0] st2_add4_b ,
  input logic [31:0] st2_add4_res ,
  output logic [31:0] st2_add5_a ,
  output logic [31:0] st2_add5_b ,
  input logic [31:0] st2_add5_res ,
  output logic [31:0] st2_add6_a ,
  output logic [31:0] st2_add6_b ,
  input logic [31:0] st2_add6_res ,
  output logic [31:0] a,
  output logic [31:0] b,
  output logic [31:0] c,
  output logic [31:0] d,
  output logic [31:0] e,
  output logic [31:0] f,
  output logic [31:0] g,
  output logic [31:0] h
);

  logic [31:0] choice_res , maj_res , sigma1 , sigma0 ;

  choose_func_32_bits choice_inst1 (
    .x (e_reg),
    .y (f_reg),
    .z (g_reg),
    .ch_res (choice_res)
  );

  maj_func_32_bits majority_inst1 (
    .x (a_reg),
    .y (b_reg),
    .z (c_reg),
    .maj_res (maj_res)
  );

  sigma_1_func sigma1_inst1 (
    .x (e_reg),
    .sig1_x (sigma1)
  );

  sigma_0_func sigma0_inst1 (
    .x (a_reg),
    .sig0_x (sigma0)
  );


  /*fh_without_carry_adder_32_bits full_adder_inst1 (
    .a (wk_reg) ,
    .b (h_reg) ,
    .sum (T1_p1)
  );*/
  assign st2_add1_a = wk_reg ;
  assign st2_add1_b = h_reg ;

  /*fh_without_carry_adder_32_bits full_adder_inst2 (
    .a (T1_p1) ,
    .b (choice_res) ,
    .sum (T1_p2)
  );*/
  assign st2_add2_a = st2_add1_res ;
  assign st2_add2_b = choice_res ;

  /*fh_without_carry_adder_32_bits full_adder_inst111 (
    .a (T1_p2) ,
    .b (sigma1) ,
    .sum (T1)
  );*/
  assign st2_add3_a = st2_add2_res ;
  assign st2_add3_b = sigma1 ;

  /*fh_without_carry_adder_32_bits full_adder_inst11 (
    .a (maj_res) ,
    .b (sigma0) ,
    .sum (T2)
  );*/
  assign st2_add4_a = maj_res ;
  assign st2_add4_b = sigma0 ;

  /*fh_without_carry_adder_32_bits full_adder_inst21 (
    .a (d_reg) ,
    .b (T1) ,
    .sum (e)
  );*/
  assign st2_add5_a =  st2_add3_res ;
  assign st2_add5_b = d_reg ;
  assign e = st2_add5_res ;

  /*fh_without_carry_adder_32_bits full_adder_inst3 (
    .a (T1) ,
    .b (T2) ,
    .sum (a)
  );*/
  assign st2_add6_a = st2_add3_res ;
  assign st2_add6_b = st2_add4_res ;
  assign a = st2_add6_res ;

  assign h = g_reg ;
  assign g = f_reg ;
  assign f = e_reg ;
  assign d = c_reg ;
  assign c = b_reg ;
  assign b = a_reg ;

endmodule
