// This module is the controller for sha 256 algo

module controller_sha (
  input logic clk ,
  input logic rstn,
  input logic start ,
  output logic hash_ready ,
  output logic [5:0] state_counter_phase1 ,
  output logic sha_p1_running ,
  output logic sha_p2_running
);

  logic run_sha_p1 , run_sha_p2 , hash_ready_reg ;
  logic start_dly ;
  logic sha_completed_p1, sha_completed_p2  ;
  logic [5:0] state_counter_phase1_int , state_counter_phase2_int ;


  always @(posedge clk or negedge rstn)begin
     if(rstn == 1'b0)begin
        run_sha_p1 <= 1'b0 ;
        start_dly <= 1'b0 ;
     end else begin
        start_dly <= start ;
        //if ((start == 1'b1) && (sha_completed_p1 == 1'b0)  )begin
        if ((start == 1'b1))begin
           run_sha_p1 <= 1'b1 ;
        end else if (sha_completed_p1 == 1'b1)begin
           run_sha_p1 <= 1'b0 ;
        end
     end
  end

  always @(posedge clk or negedge rstn)begin
     if(rstn == 1'b0)begin
        run_sha_p2 <= 1'b0 ;
     end else begin
        //if ((start_dly == 1'b1) && (sha_completed_p2 == 1'b0))begin
        if ((start_dly == 1'b1))begin
           run_sha_p2 <= 1'b1 ;
        end else if (sha_completed_p2 == 1'b1)begin
           run_sha_p2 <= 1'b0 ;
        end
     end
  end

  always @(posedge clk or negedge rstn)begin
    if(rstn == 1'b0)begin
      state_counter_phase1_int <= 6'h0 ;
      state_counter_phase2_int <= 6'h0 ;
    end else begin
      if (sha_completed_p1 == 1'b1)begin
        state_counter_phase1_int <= 6'h0 ;
      end else if((run_sha_p1 == 1'b1)) begin
         state_counter_phase1_int <= state_counter_phase1_int + 1'b1 ;
      end
      if (sha_completed_p2 == 1'b1)begin
         state_counter_phase2_int <= 6'h0 ;
      end else if((run_sha_p2 == 1'b1)) begin
         state_counter_phase2_int <= state_counter_phase2_int + 1'b1 ;
      end
    end
  end

  assign sha_completed_p1 = &(state_counter_phase1_int) ;
  assign sha_completed_p2 = &(state_counter_phase2_int) ;

  always @(posedge clk or negedge rstn)begin
     if(rstn == 1'b0)begin
        hash_ready_reg <= 1'b0 ;
     end else begin
        hash_ready_reg <= run_sha_p2 & ~run_sha_p1 ;
     end
  end

  assign hash_ready = hash_ready_reg ;
  assign sha_p1_running = run_sha_p1 ;
  assign sha_p2_running = run_sha_p2 ;
  assign state_counter_phase1 = state_counter_phase1_int ;
  //assign state_counter_phase2 = state_counter_phase2_int ;





endmodule
