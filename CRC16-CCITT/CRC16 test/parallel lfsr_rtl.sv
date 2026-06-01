module crc16_ccitt (

  input  logic        clk_i,
  input  logic        rst_n_i,
  input  logic        crc_reset_i,
  input  logic        crc_en_i,
  input  logic [7:0]  data_i,

  output logic [15:0] crc_o);

  logic [15:0] crc_reg_q;
  logic [15:0] crc_next;

  always_comb begin

    crc_next = crc_reg_q;

    crc_next[0]  = crc_reg_q[8]  ^ crc_reg_q[12] ^ data_i[0] ^ data_i[4];
    crc_next[1]  = crc_reg_q[9]  ^ crc_reg_q[13] ^ data_i[1] ^ data_i[5];
    crc_next[2]  = crc_reg_q[10] ^ crc_reg_q[14] ^ data_i[2] ^ data_i[6];
    crc_next[3]  = crc_reg_q[11] ^ crc_reg_q[15] ^ data_i[3] ^ data_i[7];

    crc_next[4]  = crc_reg_q[12] ^ data_i[4];

    crc_next[5]  = crc_reg_q[8]  ^
                   crc_reg_q[12] ^
                   crc_reg_q[13] ^
                   data_i[0] ^
                   data_i[4] ^
                   data_i[5];

    crc_next[6]  = crc_reg_q[9]  ^
                   crc_reg_q[13] ^
                   crc_reg_q[14] ^
                   data_i[1] ^
                   data_i[5] ^
                   data_i[6];

    crc_next[7]  = crc_reg_q[10] ^
                   crc_reg_q[14] ^
                   crc_reg_q[15] ^
                   data_i[2] ^
                   data_i[6] ^
                   data_i[7];

    crc_next[8]  = crc_reg_q[0] ^
                   crc_reg_q[11] ^
                   crc_reg_q[15] ^
                   data_i[3] ^
                   data_i[7];

    crc_next[9]  = crc_reg_q[1] ^
                   crc_reg_q[12] ^
                   data_i[4];

    crc_next[10] = crc_reg_q[2] ^
                   crc_reg_q[13] ^
                   data_i[5];

    crc_next[11] = crc_reg_q[3] ^
                   crc_reg_q[14] ^
                   data_i[6];

    crc_next[12] = crc_reg_q[4] ^
                   crc_reg_q[8] ^
                   crc_reg_q[12] ^
                   crc_reg_q[15] ^
                   data_i[0] ^
                   data_i[4] ^
                   data_i[7];

    crc_next[13] = crc_reg_q[5] ^
                   crc_reg_q[9] ^
                   crc_reg_q[13] ^
                   data_i[1] ^
                   data_i[5];

    crc_next[14] = crc_reg_q[6] ^
                   crc_reg_q[10] ^
                   crc_reg_q[14] ^
                   data_i[2] ^
                   data_i[6];

    crc_next[15] = crc_reg_q[7] ^
                   crc_reg_q[11] ^
                   crc_reg_q[15] ^
                   data_i[3] ^
                   data_i[7];

  end

  always_ff @(posedge clk_i or negedge rst_n_i) begin

    if (!rst_n_i)
      crc_reg_q <= 16'hFFFF;
    
    else if (crc_reset_i)
      crc_reg_q <= 16'hFFFF;

    else if (crc_en_i)
      crc_reg_q <= crc_next;

  end

  assign crc_o = crc_reg_q;

endmodule
