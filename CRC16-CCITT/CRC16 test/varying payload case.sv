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
