`default_nettype none

module tt_um_sjsu (
    input  wire [7:0] ui_in,    // User inputs
    output wire [7:0] uo_out,   // User outputs
    input  wire [7:0] uio_in,   // Bidirectional I/O (not used)
    output wire [7:0] uio_out,  // Bidirectional I/O (not used)
    output wire [7:0] uio_oe,   // Bidirectional I/O (not used)
    input  wire       ena,      // Design enable
    input  wire       clk,      // Clock
    input  wire       rst_n     // Reset (active low)
);

    // ------------------------------------------------
    // VGA Timing Generator
    // ------------------------------------------------
    wire hsync, vsync, display_on;
    wire [9:0] hpos;
    wire [9:0] vpos;

    hvsync_generator hvsync_inst (
        .clk(clk),
        .rst(~rst_n),
        .hsync(hsync),
        .vsync(vsync),
        .display_on(display_on),
        .hpos(hpos),
        .vpos(vpos)
    );

    // ------------------------------------------------
    // Simple bouncing square logo
    // ------------------------------------------------
    reg [9:0] logo_x = 100;
    reg [9:0] logo_y = 50;
    reg signed [1:0] dx = 1;
    reg signed [1:0] dy = 1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            logo_x <= 100;
            logo_y <= 50;
            dx <= 1;
            dy <= 1;
        end else if (display_on) begin
            if (hpos == 0 && vpos == 0) begin
                logo_x <= logo_x + dx;
                logo_y <= logo_y + dy;

                if (logo_x <= 0 || logo_x >= 600) dx <= -dx;
                if (logo_y <= 0 || logo_y >= 440) dy <= -dy;
            end
        end
    end

    // ------------------------------------------------
    // Pixel generation
    // ------------------------------------------------
    wire in_logo = (hpos >= logo_x && hpos < logo_x + 64 &&
                    vpos >= logo_y && vpos < logo_y + 64);

    // Color control: invert if ui_in[0] = 1
    wire invert = ui_in[0];
    wire [2:0] color = in_logo ? 3'b111 : 3'b000;
    wire [2:0] final_color = invert ? ~color : color;

    // ------------------------------------------------
    // Assign outputs
    // ------------------------------------------------
    assign uo_out[0] = final_color[0]; // R
    assign uo_out[1] = final_color[1]; // G
    assign uo_out[2] = final_color[2]; // B
    assign uo_out[3] = hsync;
    assign uo_out[4] = vsync;
    assign uo_out[7:5] = 3'b000;       // unused

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
