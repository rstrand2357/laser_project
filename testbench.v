//http://iverilog.wikia.com/wiki/GTKWAVE
//http://www.sutherland-hdl.com/papers/2006-SNUG-Boston_standard_gotchas_presentation.pdf
`timescale 1ns/1ns
`include "control.v"

module test;

  /* Make a reset that pulses once. */
    reg reset = 0;
    initial begin
      $dumpfile("test.vcd");
      $dumpvars(0,test);

      # 17ns reset = 1;
      # 11ns reset = 0;
      # 29ns reset = 1;
      # 5ns  reset =0;
      # 5ms $finish;
      //# 50ms $finish;
    end

  /* Make a regular pulsing clock. */
    reg clk = 0;
    always begin
      clk = 0;
      # 1ns
      clk = 1;
      # 1ns;
    end

    wire encoder_trigger;

    reg [31:0] N_encoder = 160;

    clk_decimator dm(clk,N_encoder,encoder_trigger);

    reg laser_on = 1;
    reg digitizer_on = 1;

    reg [31:0] N1=6;
    reg [31:0] N2=3;
    reg [31:0] N3=2;
    reg [31:0] N4=5;
    reg [31:0] N5=2;

    reg [31:0] NF1=7;
    reg [31:0] NF2=47;
    reg [31:0] NF3=88;
    reg [31:0] NF4=128;

    control cm(clk, // I tried to name this control_module and it didnt like that
               reset,
               encoder_trigger, // input
               N1,N2,N3,N4,N5,  // input
               NF1,NF2,NF3,NF4, // input
               laser_trigger,   // output
               digitizer_trigger // output
              );

endmodule // test
