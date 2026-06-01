`timescale 1ns/1ps

module tb_crc16_ccitt;

  logic        clk;
  logic        rst_n;
  logic        crc_en;
  logic        crc_reset;
  logic [7:0]  data;
  logic [15:0] crc;

 
  crc16_ccitt dut (
    .clk_i       (clk),
    .rst_n_i     (rst_n),
    .crc_reset_i (crc_reset),
    .crc_en_i    (crc_en),
    .data_i      (data),
    .crc_o       (crc)
  );

  //clock
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

 //task
  
  task send_byte(input [7:0] data_byte);
  begin
    @(posedge clk);
    data   = data_byte;
    crc_en = 1'b1;

    @(posedge clk);
    crc_en = 1'b0;

    $display("Data = %02h  CRC = %04h",
              data_byte, crc);
  end
  endtask

  //test
  
  initial begin

    rst_n     = 0;
    crc_en    = 0;
    crc_reset = 0;
    data      = 0;

    // Global reset
    repeat(2) @(posedge clk);
    rst_n = 1;

    // CRC reset to FFFF
    @(posedge clk);
    crc_reset = 1;

    @(posedge clk);
    crc_reset = 0;

    $display("\nCRC test for \"ASCII 123456789\"\n");

    // ASCII "123456789"
    send_byte(8'h31);
    send_byte(8'h32);
    send_byte(8'h33);
    send_byte(8'h34);
    send_byte(8'h35);
    send_byte(8'h36);
    send_byte(8'h37);
    send_byte(8'h38);
    send_byte(8'h39);
   
    $display("\nCRC = %04h", crc);
    $display("Expected  = 29b1");
    
    @(posedge clk);
    crc_reset = 1;

    @(posedge clk);
    crc_reset = 0;
    
    send_byte(8'h31);
    send_byte(8'h32);
    send_byte(8'h33);
    send_byte(8'h34);
    send_byte(8'h35);
    send_byte(8'h36);
    send_byte(8'h37);
    send_byte(8'h38);
    send_byte(8'h39);
    send_byte(8'h29);
    send_byte(8'hb1);
    
    @(posedge clk);

    
    $display("CRC = %04h", crc);
    $display("Expected  = 0000");
    

    #20;
    $finish;

  end

endmodule
