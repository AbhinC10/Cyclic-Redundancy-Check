module tb_tx_packet_controller;

  logic clk_i;
  logic rst_n_i;

  logic start_i;
  logic [7:0] payload_i;

  logic tx_busy_i;

  logic [7:0] tx_data_o;
  logic       tx_valid_o;

  logic       crc_en_o;
  logic [7:0] crc_data_o;

  logic [15:0] crc_i;

  logic done_o;

  logic [15:0] crc_o;

  // DUT
  
  tx_packet_controller dut (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .start_i(start_i),
    .payload_i(payload_i),

    .tx_busy_i(tx_busy_i),

    .tx_data_o(tx_data_o),
    .tx_valid_o(tx_valid_o),

    .crc_en_o(crc_en_o),
    .crc_data_o(crc_data_o),

    .crc_i(crc_o),

    .done_o(done_o)
  );


  // CRC16 lfsr
  

  crc16_ccitt crc_inst (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .crc_en_i(crc_en_o),
    .data_i(crc_data_o),
    .crc_o(crc_o)
  );

  // CLOCK

  initial clk_i = 0;
  always #5 clk_i = ~clk_i;

 
  // UART BUSY
  

  initial begin
    tx_busy_i = 0;

    forever begin

      @(posedge clk_i);

      if (tx_valid_o) begin

        tx_busy_i = 1;

        repeat(4)
          @(posedge clk_i);

        tx_busy_i = 0;

      end

    end
  end

 
  // DISPLAY
  

  always @(posedge clk_i) begin

    $display(
      "T=%0t | STATE=%0d | TX_VALID=%0b | TX_BUSY=%0b | TX_DATA=%h | CRC=%h | DONE=%0b",
      $time,
      dut.state_q,
      tx_valid_o,
      tx_busy_i,
      tx_data_o,
      crc_o,
      done_o
    );

  end

  
  // TEST
  

  initial begin

    rst_n_i  = 0;
    start_i  = 0;
    payload_i = 8'h00;

    #20;

    rst_n_i = 1;

    // send payload

    @(posedge clk_i);

    payload_i = 8'h31; // ASCII '1'
    start_i   = 1;

    @(posedge clk_i);

    start_i = 0;

    wait(done_o);

    #50;

    $finish;

  end

endmodule
