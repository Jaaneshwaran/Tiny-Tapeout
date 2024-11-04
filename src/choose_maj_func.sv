// This is one of the integral functions of the sha 256
// This includes the choose algo and majority algo

module choose_func_1_bit (
   input logic x ,
   input logic y ,
   input logic z ,
   output logic ch_res
) ;

   logic a , b , x_b ;

   assign x_b = ~x ;
   assign a = (x&y) ;
   assign b = (x_b & z) ;

   assign ch_res  = (a ^ b) ;

endmodule

module maj_func_1_bit (
   input logic x ,
   input logic y ,
   input logic z ,
   output logic maj_res
) ;

   logic a , c , d ;

   assign a = (x & y) ;
   assign c  = (x & z) ;
   assign d  = (y & z) ;

   assign maj_res  = (a ^ d ^ c) ;

endmodule


module choose_func_32_bits (
    input logic [31:0] x ,
    input logic [31:0] y ,
    input logic [31:0] z ,
    output logic [31:0] ch_res
);

  logic [31:0] ch_res_c ;
  genvar i ;

  generate
    for(i=0 ; i < 32 ; i = i + 1) begin : choose_func_loop
       choose_func_1_bit choose_func_inst_bit (
         .x(x[i]) ,
         .y(y[i]) ,
         .z(z[i]) ,
         .ch_res (ch_res_c[i])
       );
    end
  endgenerate

  assign ch_res = ch_res_c ;

endmodule

module maj_func_32_bits (
    input logic [31:0] x ,
    input logic [31:0] y ,
    input logic [31:0] z ,
    output logic [31:0] maj_res
);

  logic [31:0] maj_res_c ;
  genvar i ;

  generate
    for(i=0 ; i < 32 ; i = i + 1) begin : choose_func_loop
       maj_func_1_bit maj_func_inst_bit (
         .x(x[i]) ,
         .y(y[i]) ,
         .z(z[i]) ,
         .maj_res (maj_res_c[i])
       );
    end
  endgenerate

  assign maj_res = maj_res_c ;

endmodule
