module prbs8 (
  input  logic       clk_i,
  input  logic       rst_n_i,
  input  logic       enable_i,
  output logic [7:0] prbs_o
);

  logic feedback;

  always_comb begin
    feedback = prbs_o[7] ^ prbs_o[5] ^ prbs_o[4] ^ prbs_o[3];
  end

  always_ff @(posedge clk_i or negedge rst_n_i) begin
    if (!rst_n_i)
      prbs_o <= 8'h01;
    else if (enable_i)
      prbs_o <= {prbs_o[6:0], feedback};
  end

endmodule
