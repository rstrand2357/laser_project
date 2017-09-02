module stretcher(clk, //
               N,   // Input -- number of clocks to stretch by
               x,   // Input -- input pulse train
               y   // Output signal
              );

    // Input ports
    input clk;
    input [31:0] N;
    input x;

    // Output ports
    output y;

    // Input port data types
    wire clk;
    wire [31:0] N;
    wire x;

    // Ouput port data type
    wire y;

    reg [31:0] internal_counter;
    always @(posedge clk) begin
      if (x == 1)
        internal_counter <= 1;
      else if (internal_counter < 32'b11111111111111111111111111111111)
        internal_counter <= internal_counter + 1;
      else
        internal_counter <= 32'b11111111111111111111111111111111;
    end

    assign y = x || (internal_counter < N);

endmodule
