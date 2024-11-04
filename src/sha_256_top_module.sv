// This is the SHA - 256 implementation for ESDCS Project
// This is the top file for the module

module sha_256_top (
  input logic clk ,
  input logic rstn ,
  input logic [511:0] input_msg_digest ,
  input logic start ,
//  input reStart ,
  output logic hash_ready ,
  output logic [255 : 0] sha_result
);

  logic [31:0] a,b,c,d,e,f,g,h, wk ;
  logic [31:0] a_reg , b_reg , c_reg , d_reg , e_reg , f_reg , g_reg , h_reg , wk_reg  ;
  logic [31:0] h0 , h1 , h2 , h3 ,h4 , h5 , h6 , h7 ;
  logic [31:0] h0_reg , h1_reg , h2_reg , h3_reg ,h4_reg , h5_reg , h6_reg , h7_reg ;
  logic [5:0] state_counter_phase1 ; // , state_counter_phase2 ;
  logic hash_ready_reg , hash_ready_c  ;
  logic  stage1_sha_running , stage2_sha_running ;

  logic [31:0] add1_a , add1_b , add1_res ;
  logic [31:0] add2_a , add2_b , add2_res ;
  logic [31:0] add3_a , add3_b , add3_res ;
  logic [31:0] add4_a , add4_b , add4_res ;
  logic [31:0] add5_a , add5_b , add5_res ;
  logic [31:0] add6_a , add6_b , add6_res ;
  logic [31:0] add7_a , add7_b , add7_res ;
  logic [31:0] add8_a , add8_b , add8_res ;
  logic [31:0] add9_a , add9_b , add9_res ;
  logic [31:0] add10_a , add10_b , add10_res ;

  logic [31:0] st1_add1_a , st1_add1_b , st1_add1_res ;
  logic [31:0] st1_add2_a , st1_add2_b , st1_add2_res ;
  logic [31:0] st1_add3_a , st1_add3_b , st1_add3_res ;
  logic [31:0] st1_add4_a , st1_add4_b , st1_add4_res ;

  logic [31:0] st2_add1_a , st2_add1_b , st2_add1_res ;
  logic [31:0] st2_add2_a , st2_add2_b , st2_add2_res ;
  logic [31:0] st2_add3_a , st2_add3_b , st2_add3_res ;
  logic [31:0] st2_add4_a , st2_add4_b , st2_add4_res ;
  logic [31:0] st2_add5_a , st2_add5_b , st2_add5_res ;
  logic [31:0] st2_add6_a , st2_add6_b , st2_add6_res ;





  stage1_sha stage1_sha_inst1 (
    .clk (clk) ,
    .rstn (rstn) ,
    .input_msg_digest (input_msg_digest),
    .start (start),
    .sha_running (stage1_sha_running) ,
    .state_counter (state_counter_phase1),
    .st1_add1_a ,
    .st1_add1_b ,
    .st1_add1_res ,
    .st1_add2_a ,
    .st1_add2_b ,
    .st1_add2_res ,
    .st1_add3_a ,
    .st1_add3_b ,
    .st1_add3_res ,
    .st1_add4_a ,
    .st1_add4_b ,
    .st1_add4_res ,
    .wk_info (wk)
  );

  controller_sha controller_sha_inst1 (
    .clk (clk) ,
    .rstn (rstn) ,
    .start (start) ,
    .hash_ready (hash_ready_reg) ,
    .state_counter_phase1 (state_counter_phase1),
    //.state_counter_phase2 (state_counter_phase2),
    .sha_p1_running (stage1_sha_running),
    .sha_p2_running (stage2_sha_running)
  );

  always @(posedge clk or negedge rstn)begin
    if(rstn == 1'b0 )begin
      wk_reg <= 32'h0 ;
    end else begin
      if(stage1_sha_running == 1'b1)begin
         wk_reg <= wk ;
      end else begin
         wk_reg <= 32'h0 ;
      end
    end
  end

  stage2_sha stage2_sha_inst (
    .a_reg (a_reg),
    .b_reg (b_reg),
    .c_reg (c_reg),
    .d_reg (d_reg),
    .e_reg (e_reg),
    .f_reg (f_reg),
    .g_reg (g_reg),
    .h_reg (h_reg),
    .wk_reg (wk_reg),
    .st2_add1_a ,
    .st2_add1_b ,
    .st2_add2_a ,
    .st2_add2_b ,
    .st2_add3_a ,
    .st2_add3_b ,
    .st2_add4_a ,
    .st2_add4_b ,
    .st2_add5_a ,
    .st2_add5_b ,
    .st2_add6_a ,
    .st2_add6_b ,
    .st2_add1_res ,
    .st2_add2_res ,
    .st2_add3_res ,
    .st2_add4_res ,
    .st2_add5_res ,
    .st2_add6_res ,
    .a (a),
    .b (b),
    .c (c),
    .d (d),
    .e (e),
    .f (f),
    .g (g),
    .h (h)
  );

  // Output logic 2nd stage register
  always @(posedge clk or negedge rstn)begin
    if(rstn == 1'b0 )begin
       a_reg <= 32'h6a09e667 ;
       b_reg <= 32'hbb67ae85 ;
       c_reg <= 32'h3c6ef372 ;
       d_reg <= 32'ha54ff53a ;
       e_reg <= 32'h510e527f ;
       f_reg <= 32'h9b05688c ;
       g_reg <= 32'h1f83d9ab ;
       h_reg <= 32'h5be0cd19 ;
    end else begin
       if(start == 1'b1)begin
          a_reg <= h0_reg ;
          b_reg <= h1_reg ;
          c_reg <= h2_reg ;
          d_reg <= h3_reg ;
          e_reg <= h4_reg ;
          f_reg <= h5_reg ;
          g_reg <= h6_reg ;
          h_reg <= h7_reg ;
       end else if(stage2_sha_running == 1'b1)begin
          a_reg <= a ;
          b_reg <= b ;
          c_reg <= c ;
          d_reg <= d ;
          e_reg <= e ;
          f_reg <= f ;
          g_reg <= g ;
          h_reg <= h ;
       end
    end
  end

  always @(posedge clk or negedge rstn)begin
    if(rstn == 1'b0 )begin
       h0_reg <= 32'h6a09e667 ;
       h1_reg <= 32'hbb67ae85 ;
       h2_reg <= 32'h3c6ef372 ;
       h3_reg <= 32'ha54ff53a ;
       h4_reg <= 32'h510e527f ;
       h5_reg <= 32'h9b05688c ;
       h6_reg <= 32'h1f83d9ab ;
       h7_reg <= 32'h5be0cd19 ;
       hash_ready_c <= 1'b0 ;
    end else begin
       if(hash_ready_reg == 1'b1 )begin
          h0_reg <= h0 ;
          h1_reg <= h1 ;
          h2_reg <= h2 ;
          h3_reg <= h3 ;
          h4_reg <= h4 ;
          h5_reg <= h5 ;
          h6_reg <= h6 ;
          h7_reg <= h7 ;
          hash_ready_c <= 1'b1 ;
       end
       else begin
          hash_ready_c <= 1'b0 ;
       end
    end
  end

  /*fh_without_carry_adder_32_bits full_adder_insta (
    .a (h0_reg) ,
    .b (a_reg) ,
    .sum (h0)
  );

   fh_without_carry_adder_32_bits full_adder_instb (
    .a (h1_reg) ,
    .b (b_reg) ,
    .sum (h1)
  );

   fh_without_carry_adder_32_bits full_adder_instc (
    .a (h2_reg) ,
    .b (c_reg) ,
    .sum (h2)
  );

   fh_without_carry_adder_32_bits full_adder_instd (
    .a (h3_reg) ,
    .b (d_reg) ,
    .sum (h3)
  );

   fh_without_carry_adder_32_bits full_adder_inste (
    .a (h4_reg) ,
    .b (e_reg) ,
    .sum (h4)
  );

   fh_without_carry_adder_32_bits full_adder_instf (
    .a (h5_reg) ,
    .b (f_reg) ,
    .sum (h5)
  );

   fh_without_carry_adder_32_bits full_adder_instg (
    .a (h6_reg) ,
    .b (g_reg) ,
    .sum (h6)
  );

   fh_without_carry_adder_32_bits full_adder_insth (
    .a (h7_reg) ,
    .b (h_reg) ,
    .sum (h7)
  );*/

  assign add1_a = (hash_ready_reg == 1'b1) ? h7_reg : st2_add1_a  ;
  assign add1_b = st2_add1_b ;
  assign st2_add1_res = add1_res ;
  assign h7 = add1_res ;
  assign add2_a = (hash_ready_reg == 1'b1) ? h6_reg : st2_add2_a ;
  assign add2_b = (hash_ready_reg == 1'b1) ? g_reg : st2_add2_b ;
  assign st2_add2_res = add2_res ;
  assign h6 = add2_res ;
  assign add3_a = (hash_ready_reg == 1'b1) ? h5_reg : st2_add3_a ;
  assign add3_b = (hash_ready_reg == 1'b1) ? f_reg : st2_add3_b ;
  assign st2_add3_res = add3_res ;
  assign h5 = add3_res ;
  assign add4_a = (hash_ready_reg == 1'b1) ? h4_reg : st2_add4_a ;
  assign add4_b = (hash_ready_reg == 1'b1) ? e_reg : st2_add4_b ;
  assign st2_add4_res = add4_res ;
  assign h4 = add4_res ;
  assign add5_a = (hash_ready_reg == 1'b1) ? h3_reg : st2_add5_a ;
  assign add5_b = st2_add5_b ;
  assign st2_add5_res = add5_res ;
  assign h3 = add5_res ;
  assign add6_a = st2_add6_a;
  assign add6_b = st2_add6_b ;
  assign st2_add6_res = add6_res ;
  assign add7_a = (hash_ready_reg == 1'b1) ? h2_reg : st1_add1_a ;
  assign add7_b = (hash_ready_reg == 1'b1) ? c_reg : st1_add1_b ;
  assign st1_add1_res = add7_res ;
  assign h2 = add7_res ;
  assign add8_a = (hash_ready_reg == 1'b1) ? h1_reg : st1_add2_a;
  assign add8_b = (hash_ready_reg == 1'b1) ? b_reg : st1_add2_b ;
  assign st1_add2_res = add8_res ;
  assign h1 = add8_res ;
  assign add9_a = st1_add3_a ;
  assign add9_b = st1_add3_b ;
  assign st1_add3_res = add9_res ;
  assign add10_a = (hash_ready_reg == 1'b1) ? h0_reg : st1_add4_a ;
  assign add10_b = (hash_ready_reg == 1'b1) ? a_reg : st1_add4_b ;
  assign st1_add4_res = add10_res ;
  assign h0 = add10_res ;


  adder_cummulative_module cummulative_adder_inst1 (
    .add1_a (add1_a) ,
    .add1_b (add1_b) ,
    .add2_a (add2_a) ,
    .add2_b (add2_b) ,
    .add3_a (add3_a) ,
    .add3_b (add3_b) ,
    .add4_a (add4_a) ,
    .add4_b (add4_b) ,
    .add5_a (add5_a) ,
    .add5_b (add5_b) ,
    .add6_a (add6_a) ,
    .add6_b (add6_b) ,
    .add7_a (add7_a) ,
    .add7_b (add7_b) ,
    .add8_a (add8_a) ,
    .add8_b (add8_b) ,
    .add9_a (add9_a) ,
    .add9_b (add9_b) ,
    .add10_a (add10_a) ,
    .add10_b (add10_b) ,
    .add1_res (add1_res) ,
    .add2_res (add2_res) ,
    .add3_res (add3_res) ,
    .add4_res (add4_res) ,
    .add5_res (add5_res) ,
    .add6_res (add6_res) ,
    .add7_res (add7_res) ,
    .add8_res (add8_res) ,
    .add9_res (add9_res) ,
    .add10_res (add10_res)
  );


  assign sha_result = {h0_reg , h1_reg , h2_reg , h3_reg , h4_reg , h5_reg , h6_reg , h7_reg } ;
  assign hash_ready = hash_ready_c ;

endmodule
