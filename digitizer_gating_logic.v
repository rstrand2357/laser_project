module digitizer_gating_logic(clk, //
               N,   // Input -- number of clocks to stretch by
               x,   // Input -- input pulse train
               gate,
               y   // Output signal
              );
  // Input ports
  input clk;
  input [31:0] N;
  input x;
  input gate;

  // Output ports
  output y;

  // Input port data types
  wire clk;
  wire [31:0] N;
  wire x;
  wire gate;

  // Ouput port data type
  wire y;

  reg [31:0] n_pulses_left_to_emit = 0;
  always @(posedge clk) begin
    if (gate == 1) begin
        if (x==1)
          n_pulses_left_to_emit <= N - 1;
        else
          n_pulses_left_to_emit <= N;
      end
    else begin
      // gate = 00. If x==1 then emit (via the assignment) and decriment
      if ((x==1) && (n_pulses_left_to_emit > 0))
        n_pulses_left_to_emit <= n_pulses_left_to_emit - 1;
    end
  end

  assign y = (x & (n_pulses_left_to_emit > 0)) | (x&gate);

endmodule
