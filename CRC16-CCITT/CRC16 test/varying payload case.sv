always_comb begin

  crc_next = crc_reg_q;

  case(data_bits_i)

    2'b00: begin
      // 5-bit equations
    end

    2'b01: begin
      // 6-bit equations
    end

    2'b10: begin
      // 7-bit equations
    end

    2'b11: begin
      // 8-bit equations
    end

  endcase

end




//or



case(data_bits_i)

  2'b00:
    crc_data = {3'b000, payload[4:0]};

  2'b01:
    crc_data = {2'b00, payload[5:0]};

  2'b10:
    crc_data = {1'b0, payload[6:0]};

  2'b11:
    crc_data = payload[7:0];

endcase
