module rx_packet_checker (

  input  logic        clk_i,
  input  logic        rst_n_i,

  input  logic [7:0]  data_i,
  input  logic        data_valid_i,

  input  logic [15:0] crc_i,

  output logic        crc_en_o,
  output logic [7:0]  crc_data_o,

  output logic        crc_error_o,
  output logic        done_o

);

  typedef enum logic [2:0] {
    ST_IDLE,
    ST_RX_DATA,
    ST_RX_CRC_HIGH,
    ST_RX_CRC_LOW,
    ST_CHECK,
    ST_DONE
  } state_t;

  state_t state_q, state_d;

  logic crc_error_q;
  logic done_q;

  
  // STATE REGISTER
  

  always_ff @(posedge clk_i or negedge rst_n_i) begin

    if (!rst_n_i)
      state_q <= ST_IDLE;
    else
      state_q <= state_d;

  end

  
  // NEXT STATE and  OUTPUT LOGIC
  

  always_comb begin

    state_d     = state_q;

    crc_en_o    = 1'b0;
    crc_data_o  = 8'h00;

    case (state_q)

      ST_IDLE: begin

        if (data_valid_i)
          state_d = ST_RX_DATA;

      end

      ST_RX_DATA: begin

        crc_en_o    = 1'b1;
        crc_data_o  = data_i;

        state_d     = ST_RX_CRC_HIGH;

      end

      ST_RX_CRC_HIGH: begin

        if (data_valid_i) begin

          crc_en_o    = 1'b1;
          crc_data_o  = data_i;

          state_d     = ST_RX_CRC_LOW;

        end

      end

      ST_RX_CRC_LOW: begin

        if (data_valid_i) begin

          crc_en_o    = 1'b1;
          crc_data_o  = data_i;

          state_d     = ST_CHECK;

        end

      end

      ST_CHECK: begin

        state_d = ST_DONE;

      end

      ST_DONE: begin

        state_d = ST_IDLE;

      end

      default: begin

        state_d = ST_IDLE;

      end

    endcase

  end

  
  // REGISTERED STATUS FLAGS
  

  always_ff @(posedge clk_i or negedge rst_n_i) begin

    if (!rst_n_i) begin

      crc_error_q <= 1'b0;
      done_q      <= 1'b0;

    end

    else begin

      done_q <= 1'b0;

      if (state_q == ST_CHECK) begin

        if (crc_i == 16'h0000)
          crc_error_q <= 1'b0;
        else
          crc_error_q <= 1'b1;

      end

      if (state_q == ST_DONE)
        done_q <= 1'b1;

    end

  end

  assign crc_error_o = crc_error_q;
  assign done_o      = done_q;

endmodule
