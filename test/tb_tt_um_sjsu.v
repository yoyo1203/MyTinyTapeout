`timescale 1ns/1ps
`default_nettype none

module tb_tt_um_sjsu;
    reg clk = 0;
    reg rst_n = 0;
    reg [7:0] ui_in = 0;
    wire [7:0] uo_out;

    // Instantiate DUT
    tt_um_sjsu dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(8'b0),
        .uio_out(),
        .uio_oe(),
        .ena(1'b1),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation: ~25 MHz (for VGA)
    always #20 clk = ~clk;  // 40ns period -> 25 MHz

    initial begin
        $dumpfile("tb_tt_um_sjsu.vcd");
        $dumpvars(0, tb_tt_um_sjsu);

        // Reset
        rst_n = 0;
        #200;
        rst_n = 1;

        // Run for some frames
        #1000000;

        // Toggle invert
        ui_in[0] = 1;
        #1000000;

        $finish;
    end
endmodule
