module tb_crc16_ccitt;

  logic        clk_i;
  logic        rst_n_i;
  logic        crc_en_i;

  logic [7:0]  data_i;
  logic [15:0] crc_o;

  crc16_ccitt dut (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .crc_en_i(crc_en_i),
    .data_i(data_i),
    .crc_o(crc_o)
  );

  initial clk_i = 0;
  always #5 clk_i = ~clk_i;

  task send_byte(input [7:0] data_byte);

    begin

      @(posedge clk_i);

      crc_en_i = 1;
      data_i   = data_byte;

      @(posedge clk_i);

      crc_en_i = 0;

      $display(
        "T=%0t | DATA=%h | CRC=%h",
        $time,
        data_byte,
        crc_o
      );

    end

  endtask

  initial begin

    rst_n_i  = 0;
    crc_en_i = 0;
    data_i   = 8'h00;

    #20;
    rst_n_i = 1;

    // ASCII "123456789"
    send_byte("1");
    send_byte("2");
    send_byte("3");
    send_byte("4");
    send_byte("5");
    send_byte("6");
    send_byte("7");
    send_byte("8");
    send_byte("9");

    #20;

    $display("FINAL CRC = %h", crc_o);
    $display("EXPECTED  = 29B1");

    #20 $finish;

  end

endmodule
