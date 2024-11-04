// This is the stage 1 sha 256 module

module stage1_sha (
  input logic clk ,
  input logic rstn ,
  input logic [511:0] input_msg_digest ,
  input logic start ,
  input logic sha_running ,
  input logic [5:0] state_counter ,
  output logic [31:0] st1_add1_a ,
  output logic [31:0] st1_add1_b ,
  input logic [31:0] st1_add1_res ,
  output logic [31:0] st1_add2_a ,
  output logic [31:0] st1_add2_b ,
  input logic [31:0] st1_add2_res ,
  output logic [31:0] st1_add3_a ,
  output logic [31:0] st1_add3_b ,
  input logic [31:0] st1_add3_res ,
  output logic [31:0] st1_add4_a ,
  output logic [31:0] st1_add4_b ,
  input logic [31:0] st1_add4_res ,
  output logic [31:0] wk_info
);

  logic [511:0] w_fifo ;
  logic [31:0] next_w_word , s_sigma_res0 , s_sigma_res1 , w_info ;
  logic [31:0] next_k_word ;

  always @(posedge clk or negedge rstn)begin
    if(rstn == 1'b0)begin
       w_fifo <= 512'h0 ;
    end else begin
       if(start == 1'b1) begin
          w_fifo <= input_msg_digest ;
       end else if (sha_running == 1'b1)begin
          w_fifo <= {w_fifo[479 : 0], next_w_word} ;
       end
    end
  end

  low_sigma_1_func sigma_1_func_inst1 (
    .x (w_fifo[63:32]) ,
    .l_sig1_x (s_sigma_res1)
  );

  low_sigma_0_func sigma_0_func_inst1 (
    .x (w_fifo[479:448]) ,
    .l_sig0_x (s_sigma_res0)
  );

  param_k_look_up_table k_look_up_table_inst1 (
    .look_up_addr (state_counter),
    .k_value (next_k_word)
  );

  assign w_info = w_fifo[511:480] ;

  /*fh_without_carry_adder_32_bits f_adder_inst1 (
    .a (w_fifo[511:480]),
    .b (w_fifo[223:192]),
    .sum (w_word_p1)
  );*/
  assign st1_add1_a =  w_fifo[511:480] ;
  assign st1_add1_b =  w_fifo[223:192] ;

  /*fh_without_carry_adder_32_bits full_adder_inst2 (
    .a (s_sigma_res0) ,
    .b (w_word_p1) ,
    .sum (w_word_p2)
  );*/
  assign st1_add2_a = s_sigma_res0 ;
  assign st1_add2_b = st1_add1_res ;

  /*fh_without_carry_adder_32_bits full_adder_inst3 (
    .a (s_sigma_res1) ,
    .b (w_word_p2) ,
    .sum (next_w_word)
  );*/
  assign st1_add3_a = s_sigma_res1 ;
  assign st1_add3_b = st1_add2_res ;
  assign next_w_word = st1_add3_res ;

  /*fh_without_carry_adder_32_bits f_adder_inst2 (
    .a (w_info),
    .b (next_k_word),
    .sum (wk_info)
  );*/
  assign st1_add4_a = w_info ;
  assign st1_add4_b = next_k_word ;
  assign wk_info = st1_add4_res ;



endmodule
