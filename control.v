// http://www.asic-world.com/verilog/first1.html#Counter_Design_Block
`include "delayer.v"
`include "stretcher.v"
`include "clk_decimator.v"
`include "digitizer_gating_logic.v"

module control(clk, //
                      reset,
                      encoder_trigger, // input
                      N1,N2,N3,N4,N5,  // input
                      NF1,NF2,NF3,NF4, // input
                      laser_trigger,   // output
                      digitizer_trigger // output
                      );

  // --------------Input Ports --------------
  input clk;
  input reset;
  input encoder_trigger;

  input [31:0] N1;
  input [31:0] N2;
  input [31:0] N3;
  input [31:0] N4;
  input [31:0] N5;

  input [31:0] NF1;
  input [31:0] NF2;
  input [31:0] NF3;
  input [31:0] NF4;

  // -------------Output Ports --------------
  output laser_trigger;
  output digitizer_trigger;
  // ----------Input ports Data Type---------
  // Must be wire
  wire clk;
  wire reset;
  wire encoder_trigger;
  wire [31:0] N1;
  wire [31:0] N2;
  wire [31:0] N3;
  wire [31:0] N4;
  wire [31:0] N5;
  wire [31:0] NF1;
  wire [31:0] NF2;
  wire [31:0] NF3;
  wire [31:0] NF4;


  // -----------Ouput Ports Data Type -------
  wire laser_trigger;
  wire digitizer_trigger;


  // -----------INTERNAL SIGNALS -----------
  reg always_true = 1;
  wire laser_frequency_pulse_train;
  wire digitizer_gating_signal;
  wire encoder_trigger_delayed_NF1;
  wire encoder_trigger_delayed_NF2;
  wire encoder_trigger_delayed_NF3;
  wire encoder_trigger_delayed_NF4;


  clk_decimator N1_decimator(clk, N1, laser_frequency_pulse_train);

  // // https://stackoverflow.com/questions/25857630/can-verilog-variables-be-given-local-scope-to-an-always-block
  //   reg [31:0] laser_frequency_pulse_train_internal_counter = 0; // COUNTS UP
  //   always @(posedge clk) begin
  //     if (laser_frequency_pulse_train_internal_counter == N1) begin
  //         laser_frequency_pulse_train = 1;
  //         laser_frequency_pulse_train_internal_counter = 0;
  //     end
  //     else begin
  //       laser_frequency_pulse_train = 0;
  //       laser_frequency_pulse_train_internal_counter = laser_frequency_pulse_train_internal_counter + 1;
  //     end
  //     // No endif???? https://www.doulos.com/knowhow/verilog_designers_guide/if_statement/
  //     // I guess it looks like begin/end is equiv to {/}
  //     // example: http://www.asic-world.com/verilog/vbehave2.html
  //   end


  wire laser_frequency_pulse_train_delayed_N3;

  delayer delay_by_N3(clk,   //
              N3,    // N
              laser_frequency_pulse_train, // X
              laser_frequency_pulse_train_delayed_N3 //Y
              );

  stretcher stretch_by_N2(clk,
                         N2,
                         laser_frequency_pulse_train,
                         laser_frequency_pulse_train_streched_N2);

  delayer delay_by_NF1(clk,   //
    NF1,    // N
    encoder_trigger, // X
    encoder_trigger_delayed_NF1 //Y
  );
  delayer delay_by_NF2(clk,   //
    NF2,    // N
    encoder_trigger, // X
    encoder_trigger_delayed_NF2 //Y
  );
  delayer delay_by_NF3(clk,   //
    NF3,    // N
    encoder_trigger, // X
    encoder_trigger_delayed_NF3 //Y
  );
  delayer delay_by_NF4(clk,   //
    NF4,    // N
    encoder_trigger, // X
    encoder_trigger_delayed_NF4 //Y
  );

  wire gated_delayed_laser_pulse_train;
  wire gated_delayed_laser_pulse_train_streched_N5;
  digitizer_gating_logic dgc(clk,
                             N5,
                             laser_frequency_pulse_train_delayed_N3,
                             digitizer_gating_signal,
                             gated_delayed_laser_pulse_train);

  stretcher strech_by_N5(clk,
                        N5,
                        gated_delayed_laser_pulse_train,
                        gated_delayed_laser_pulse_train_streched_N5);

  assign digitizer_gating_signal = encoder_trigger_delayed_NF1 | encoder_trigger_delayed_NF2 | encoder_trigger_delayed_NF3 | encoder_trigger_delayed_NF4;



  // Actually drive outputs
  assign laser_trigger = laser_frequency_pulse_train_streched_N2;
  assign digitizer_trigger = gated_delayed_laser_pulse_train_streched_N5;
endmodule
