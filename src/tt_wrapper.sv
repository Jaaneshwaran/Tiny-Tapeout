// This is the wrapper for tt_sha_256_top module

module tt_um_wrapper_8bit_sha_256 (
  input  logic [7:0] ui_in,    // Dedicated inputs
  output logic [7:0] uo_out,   // Dedicated outputs
  input  logic [7:0] uio_in,   // IOs: Input path
  output logic [7:0] uio_out,  // IOs: Output path
  output logic [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
  input  logic       ena,      // always 1 when the design is powered, so you can ignore it
  input  logic       clk,      // clock
  input  logic       rst_n     // reset_n - low to reset
);

logic  hash_ready , unused , hash_read_allowed ;

tt_sha_256_top main_sha_inst1(
  .clk(clk) ,
  .rstn(rst_n) ,
  .input_bus(ui_in) ,
  .load(uio_in[0]) ,
  .start(uio_in[1]) ,
  .read(uio_in[2]) ,
  .hash_ready(hash_ready) ,
  .output_data(uo_out)
);

assign uio_out[7] = hash_ready ;
assign uio_out[6:0] = 7'h0 ;
assign unused = 1'b0 & ena & (&(uio_in[7:3])) ;

assign uio_oe = 8'h80 ;

endmodule
