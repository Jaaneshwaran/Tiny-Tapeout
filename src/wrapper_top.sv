// This is the 8-bit wrapper architecture for sha 256 algo

module wrapper_8bit_sha_256 (
  input  logic [7:0] ui_in,    // Dedicated inputs
  output logic [7:0] uo_out,   // Dedicated outputs
  input  logic [7:0] uio_in,   // IOs: Input path
  output logic [7:0] uio_out,  // IOs: Output path
  output logic [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
  input  logic       ena,      // always 1 when the design is powered, so you can ignore it
  input  logic       clk,      // clock
  input  logic       rst_n     // reset_n - low to reset
);

  logic [511:0] input_msg_digest ;
  logic [255:0] output_sha_message ;
  logic start , hash_ready , _unused , hash_read_allowed ;
  logic [8:0] lsb_pos , msb_pos ;

  assign lsb_pos = {uio_in[5:0],3'b0}
  assign msb_pos = {uio_in[5:0],3'b111} ;


  always @(posedge clk or negedge rst_n)begin
     if(rst_n == 1'b0)begin
       input_msg_digest <= 512'h0 ;
       start <= 1'b0
     end else begin
       if(uio_in[6] == 1'b1)begin
          input_msg_digest[msb_pos : lsb_pos] = ui_in ;
          start <= &(uio_in[5:0]) ;
       end else begin
          start <= 1'b0 ;
       end
     end
  end

  sha_256_top main_sha_inst1 (
    .clk(clk) ,
    .rstn (rst_n) ,
    .input_msg_digest(input_msg_digest) ,
    .start(start) ,
    .hash_ready(hash_ready) ,
    .sha_result(output_sha_message)
  );

  always @(posedge clk or negedge rst_n)begin
     if(rst_n == 1'b0)begin
        hash_read_allowed <= 1'b0 ;
     end else begin
        if(hash_read == 1'b1)begin
           hash_read_allowed <= 1'b1 ;
        end else if (uio_in[6] == 1'b1)begin
           hash_read_allowed <= 1'b0 ;
        end
     end

  assign uio_out[7] = hash_ready ;
  assign uio_out[6:0] = 7'h0 ;
  assign _unused = &{1'b0,ena,uio_in[7]} ;

  assign uo_out = (hash_read_allowed == 1'b1) ? output_sha_message[msb_pos : lsb_pos] : 8'h0 ;



  assign uio_oe = 8'b1000_0000 ;


endmodule

/*
case (uio_in[5:0])
 6'd0:   input_msg_digest[7:0] = ui_in;
 6'd1:   input_msg_digest[15:8] = ui_in;
 6'd2:   input_msg_digest[23:16] = ui_in;
 6'd3:   input_msg_digest[31:24] = ui_in;
 6'd4:   input_msg_digest[39:32] = ui_in;
 6'd5:   input_msg_digest[47:40] = ui_in;
 6'd6:   input_msg_digest[55:48] = ui_in;
 6'd7:   input_msg_digest[63:56] = ui_in;
 6'd8:   input_msg_digest[71:64] = ui_in;
 6'd9:   input_msg_digest[79:72] = ui_in;
 6'd10:  input_msg_digest[87:80] = ui_in;
 6'd11:  input_msg_digest[95:88] = ui_in;
 6'd12:  input_msg_digest[103:96] = ui_in;
 6'd13:  input_msg_digest[111:104] = ui_in;
 6'd14:  input_msg_digest[119:112] = ui_in;
 6'd15:  input_msg_digest[127:120] = ui_in;
 6'd16:  input_msg_digest[135:128] = ui_in;
 6'd17:  input_msg_digest[143:136] = ui_in;
 6'd18:  input_msg_digest[151:144] = ui_in;
 6'd19:  input_msg_digest[159:152] = ui_in;
 6'd20:  input_msg_digest[167:160] = ui_in;
 6'd21:  input_msg_digest[175:168] = ui_in;
 6'd22:  input_msg_digest[183:176] = ui_in;
 6'd23:  input_msg_digest[191:184] = ui_in;
 6'd24:  input_msg_digest[199:192] = ui_in;
 6'd25:  input_msg_digest[207:200] = ui_in;
 6'd26:  input_msg_digest[215:208] = ui_in;
 6'd27:  input_msg_digest[223:216] = ui_in;
 6'd28:  input_msg_digest[231:224] = ui_in;
 6'd29:  input_msg_digest[239:232] = ui_in;
 6'd30:  input_msg_digest[247:240] = ui_in;
 6'd31:  input_msg_digest[255:248] = ui_in;
 6'd32:  input_msg_digest[263:256] = ui_in;
 6'd33:  input_msg_digest[271:264] = ui_in;
 6'd34:  input_msg_digest[279:272] = ui_in;
 6'd35:  input_msg_digest[287:280] = ui_in;
 6'd36:  input_msg_digest[295:288] = ui_in;
 6'd37:  input_msg_digest[303:296] = ui_in;
 6'd38:  input_msg_digest[311:304] = ui_in;
 6'd39:  input_msg_digest[319:312] = ui_in;
 6'd40:  input_msg_digest[327:320] = ui_in;
 6'd41:  input_msg_digest[335:328] = ui_in;
 6'd42:  input_msg_digest[343:336] = ui_in;
 6'd43:  input_msg_digest[351:344] = ui_in;
 6'd44:  input_msg_digest[359:352] = ui_in;
 6'd45:  input_msg_digest[367:360] = ui_in;
 6'd46:  input_msg_digest[375:368] = ui_in;
 6'd47:  input_msg_digest[383:376] = ui_in;
 6'd48:  input_msg_digest[391:384] = ui_in;
 6'd49:  input_msg_digest[399:392] = ui_in;
 6'd50:  input_msg_digest[407:400] = ui_in;
 6'd51:  input_msg_digest[415:408] = ui_in;
 6'd52:  input_msg_digest[423:416] = ui_in;
 6'd53:  input_msg_digest[431:424] = ui_in;
 6'd54:  input_msg_digest[439:432] = ui_in;
 6'd55:  input_msg_digest[447:440] = ui_in;
 6'd56:  input_msg_digest[455:448] = ui_in;
 6'd57:  input_msg_digest[463:456] = ui_in;
 6'd58:  input_msg_digest[471:464] = ui_in;
 6'd59:  input_msg_digest[479:472] = ui_in;
 6'd60:  input_msg_digest[487:480] = ui_in;
 6'd61:  input_msg_digest[495:488] = ui_in;
 6'd62:  input_msg_digest[503:496] = ui_in;
 6'd63:  input_msg_digest[511:504] = ui_in;
 default: input_msg_digest = 512'b0; // Default case to avoid latches
endcase
*/
