// This module would perform the ROTR operation of sha algo

module rotr_base (
   input logic [31:0] x ,
   output logic [31:0] rotr_x
);

  parameter ROTATE_RIGHT = 2 ;

  logic [31:0] c ;
  assign c = {x[ROTATE_RIGHT - 1 : 0] , x[31:ROTATE_RIGHT]} ;

  assign rotr_x = c ;

endmodule

module shr_base (
   input logic [31:0] x ,
   output logic [31:0] shr_x
);

  parameter SHIFT_RIGHT = 2 ;

  logic [31:0] c ;
  assign c = {{SHIFT_RIGHT{1'b0}} , x[31:SHIFT_RIGHT]} ;

  assign shr_x = c ;

endmodule

module sigma_0_func (
  input logic [31:0] x ,
  output logic [31:0] sig0_x
);

  logic [31:0] a , b, c ;

  rotr_base #(
    .ROTATE_RIGHT(2)
  ) rotr_by_2 (
    .x (x) ,
    .rotr_x (a)
  );

  rotr_base #(
    .ROTATE_RIGHT(13)
  ) rotr_by_13 (
    .x (x) ,
    .rotr_x (b)
  );

  rotr_base #(
    .ROTATE_RIGHT(22)
  ) rotr_by_22 (
    .x (x) ,
    .rotr_x (c)
  );

  assign sig0_x = a ^ b ^ c ;


endmodule

module sigma_1_func (
  input logic [31:0] x ,
  output logic [31:0] sig1_x
);

  logic [31:0] a , b, c ;

  rotr_base #(
    .ROTATE_RIGHT(6)
  ) rotr_by_6 (
    .x (x) ,
    .rotr_x (a)
  );

  rotr_base #(
    .ROTATE_RIGHT(11)
  ) rotr_by_11 (
    .x (x) ,
    .rotr_x (b)
  );

  rotr_base #(
    .ROTATE_RIGHT(25)
  ) rotr_by_25 (
    .x (x) ,
    .rotr_x (c)
  );

  assign sig1_x = a ^ b ^ c ;


endmodule

module low_sigma_0_func (
  input logic [31:0] x ,
  output logic [31:0] l_sig0_x
);

  logic [31:0] a , b , c ;

  rotr_base #(
    .ROTATE_RIGHT(7)
  ) rotr_by_7 (
    .x (x) ,
    .rotr_x (a)
  );

  rotr_base #(
    .ROTATE_RIGHT(18)
  ) rotr_by_18 (
    .x (x) ,
    .rotr_x (b)
  );

  shr_base #(
    .SHIFT_RIGHT(3)
  ) shr_by_3 (
    .x (x) ,
    .shr_x (c)
  );

  assign l_sig0_x = a ^ b ^ c ;

endmodule

module low_sigma_1_func (
  input logic [31:0] x ,
  output logic [31:0] l_sig1_x
);

  logic [31:0] a , b , c ;

  rotr_base #(
    .ROTATE_RIGHT(17)
  ) rotr_by_17 (
    .x (x) ,
    .rotr_x (a)
  );

  rotr_base #(
    .ROTATE_RIGHT(19)
  ) rotr_by_19 (
    .x (x) ,
    .rotr_x (b)
  );

  shr_base #(
    .SHIFT_RIGHT(10)
  ) shr_by_10 (
    .x (x) ,
    .shr_x (c)
  );

  assign l_sig1_x = a ^ b ^ c ;

endmodule
