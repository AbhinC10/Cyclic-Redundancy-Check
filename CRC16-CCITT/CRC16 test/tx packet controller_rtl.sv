module tx_packet_controller (

  input  logic        clk_i,
  input  logic        rst_n_i,

  input  logic        start_i,
  input  logic [7:0]  payload_i,

  input  logic        tx_busy_i,

  output logic [7:0]  tx_data_o,
  output logic        tx_valid_o,

  output logic        crc_en_o,
  output logic [7:0]  crc_data_o,

  input  logic [15:0] crc_i,

  output logic        done_o

);

  typedef enum logic [2:0] {
    ST_IDLE,
    ST_LOAD_DATA,
    ST_WAIT_DATA,
    ST_SEND_CRC_LOW,
    ST_WAIT_CRC_LOW,
    ST_SEND_CRC_HIGH,
    ST_WAIT_CRC_HIGH,
    ST_DONE
  } state_t;

  state_t state_q, state_d;

  always_ff @(posedge clk_i or negedge rst_n_i) begin

    if (!rst_n_i)
      state_q <= ST_IDLE;
    else
      state_q <= state_d;

  end

  always_comb begin

    state_d     = state_q;

    tx_data_o   = 8'h00;
    tx_valid_o  = 1'b0;

    crc_en_o    = 1'b0;
    crc_data_o  = 8'h00;

    done_o      = 1'b0;

    case (state_q)

      ST_IDLE: begin

        if (start_i)
          state_d = ST_LOAD_DATA;

      end

      ST_LOAD_DATA: begin

        tx_data_o   = payload_i;
        tx_valid_o  = 1'b1;

        crc_en_o    = 1'b1;
        crc_data_o  = payload_i;

        state_d     = ST_WAIT_DATA;

      end

      ST_WAIT_DATA: begin

        if (!tx_busy_i)
          state_d = ST_SEND_CRC_LOW;

      end

      ST_SEND_CRC_LOW: begin

        tx_data_o  = crc_i[7:0];
        tx_valid_o = 1'b1;

        state_d    = ST_WAIT_CRC_LOW;

      end

      ST_WAIT_CRC_LOW: begin

        if (!tx_busy_i)
          state_d = ST_SEND_CRC_HIGH;

      end

      ST_SEND_CRC_HIGH: begin

        tx_data_o  = crc_i[15:8];
        tx_valid_o = 1'b1;

        state_d    = ST_WAIT_CRC_HIGH;

      end

      ST_WAIT_CRC_HIGH: begin

        if (!tx_busy_i)
          state_d = ST_DONE;

      end

      ST_DONE: begin

        done_o = 1'b1;

        state_d = ST_IDLE;

      end

    endcase

  end

endmodule
