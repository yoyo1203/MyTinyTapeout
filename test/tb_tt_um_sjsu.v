`timescale 1ns / 1ns

module tb_tt_um_sjsu;

  // Testbench signals
  reg clk;
  reg rst_n;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  reg [7:0] ena;
  
  // Wires to connect to the module's outputs
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  
  // Parameters
  parameter CLK_PERIOD = 20; // 20ns for a 50MHz clock

  // Instantiate the Device Under Test (DUT)
  tt_um_sjsu dut (
      .clk(clk),
      .rst_n(rst_n),
      .ui_in(ui_in),
      .uo_out(uo_out),
      .uio_out(uio_out),
      .uio_in(uio_in),
      .ena(ena)
  );
  
  // Clock generation
  initial begin
    clk = 0;
    forever #(CLK_PERIOD / 2) clk = ~clk;
  end

  // Test sequence
  initial begin
    $display("--- Starting Bouncing Square Simulation ---");
    
    // Set unused inputs to a fixed value
    ui_in  = 8'h00;
    uio_in = 8'h00;
    ena    = 8'hFF;

    // Apply a reset
    rst_n = 0;
    #(CLK_PERIOD * 5); // Hold reset for 5 clock cycles

    // Release reset
    rst_n = 1;
    $display("Reset released. Bouncing square logic is now active.");
    
    // Monitor key signals during simulation
    $monitor("Time=%0t: x_pos=%0d, y_pos=%0d", $time, dut.x_pos, dut.y_pos);

    // Let the simulation run for a long enough time to see the square move
    #(CLK_PERIOD * 1500);

    // Finish the simulation
    $display("--- Simulation complete ---");
    $finish;
  end

endmodule
