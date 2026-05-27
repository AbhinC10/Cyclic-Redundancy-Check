module tb_rx_packet_checker;

  logic clk_i;
  logic rst_n_i;

  logic [7:0] data_i;
  logic       data_valid_i;

  logic [15:0] crc_i;

  logic crc_en_o;
  logic [7:0] crc_data_o;

  logic crc_error_o;
  logic done_o;

  logic [15:0] crc_o;

  // DUT
  
  rx_packet_checker dut (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .data_i(data_i),
    .data_valid_i(data_valid_i),

    .crc_i(crc_o),

    .crc_en_o(crc_en_o),
    .crc_data_o(crc_data_o),

    .crc_error_o(crc_error_o),
    .done_o(done_o)
  );

  // CRC 
  
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

  // TASK

  task send_byte(input [7:0] data_byte);

    begin

      @(posedge clk_i);

      data_i       = data_byte;
      data_valid_i = 1'b1;

      @(posedge clk_i);

      data_valid_i = 1'b0;

    end

  endtask

  // Display

  always @(posedge clk_i) begin

    $display(
      "T=%0t | STATE=%0d | VALID=%0b | DATA=%h | CRC=%h | CRC_ERR=%0b | DONE=%0b",
      $time,
      dut.state_q,
      data_valid_i,
      data_i,
      crc_o,
      crc_error_o,
      done_o
    );

  end

  // TEST

  initial begin

    rst_n_i      = 0;
    data_i       = 8'h00;
    data_valid_i = 0;

    #20;

    rst_n_i = 1;

    // payload = 0x31
    // crc     = C782
    //
    // TX order:
    // 31 C7 82
    
    send_byte(8'h31);
    send_byte(8'hC7);
    send_byte(8'h82);

    wait(done_o);

    #20;

    $display("FINAL CRC     = %h", crc_o);
    $display("CRC ERROR     = %0b", crc_error_o);

    #20;

    $finish;

  end

endmodule
