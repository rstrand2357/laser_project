module clk_decimator(clk, //
               N,   // Input -- decimation factor
               y   // Output signal
              );

    // Input ports
    input clk;
    input [31:0] N;

    // Output ports
    output y;

    // Input port data types
    wire clk;
    wire [31:0] N;
    wire x;

    // Ouput port data type
    reg y;

    reg [31:0] internal_counter = 0;
    always @(posedge clk) begin
      if (internal_counter == N-1)
        y <= 1;
      else
        y <= 0;
    end

    always @(posedge clk) begin
      if (internal_counter < N - 1)
        internal_counter <= internal_counter + 1;
      else
        internal_counter <= 0;
    end

    // // https://stackoverflow.com/questions/25857630/can-verilog-variables-be-given-local-scope-to-an-always-block
    // reg [31:0] internal_counter = 0; // COUNTS UP
    // always @(posedge clk) begin
    //     if (x==1) begin
    //       if (internal_counter == N) begin
    //           y = 1;
    //           internal_counter = 0;
    //       end
    //       else begin
    //         y = 0;
    //         internal_counter = internal_counter + 1;
    //       end
    //     end
    //     // No endif???? https://www.doulos.com/knowhow/verilog_designers_guide/if_statement/
    //     // I guess it looks like begin/end is equiv to {/}
    //     // example: http://www.asic-world.com/verilog/vbehave2.html
    //     else begin
    //       y = 0;
    //     end
    // end

endmodule
