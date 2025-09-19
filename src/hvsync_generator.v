`default_nettype none

module hvsync_generator (
    input  wire clk,
    input  wire rst,
    output reg  hsync,
    output reg  vsync,
    output wire display_on,
    output reg [9:0] hpos,
    output reg [9:0] vpos
);

    // VGA 640x480 @ 60Hz timings
    parameter H_VISIBLE   = 640;
    parameter H_FRONT     = 16;
    parameter H_SYNC      = 96;
    parameter H_BACK      = 48;
    parameter H_TOTAL     = H_VISIBLE + H_FRONT + H_SYNC + H_BACK;

    parameter V_VISIBLE   = 480;
    parameter V_FRONT     = 10;
    parameter V_SYNC      = 2;
    parameter V_BACK      = 33;
    parameter V_TOTAL     = V_VISIBLE + V_FRONT + V_SYNC + V_BACK;

    // Horizontal position counter
    always @(posedge clk) begin
        if (rst) begin
            hpos <= 0;
        end else if (hpos == H_TOTAL-1) begin
            hpos <= 0;
        end else begin
            hpos <= hpos + 1;
        end
    end

    // Vertical position counter
    always @(posedge clk) begin
        if (rst) begin
            vpos <= 0;
        end else if (hpos == H_TOTAL-1) begin
            if (vpos == V_TOTAL-1) begin
                vpos <= 0;
            end else begin
                vpos <= vpos + 1;
            end
        end
    end

    // HSync signal
    always @(posedge clk) begin
        hsync <= ~((hpos >= H_VISIBLE+H_FRONT) &&
                   (hpos <  H_VISIBLE+H_FRONT+H_SYNC));
    end

    // VSync signal
    always @(posedge clk) begin
        vsync <= ~((vpos >= V_VISIBLE+V_FRONT) &&
                   (vpos <  V_VISIBLE+V_FRONT+V_SYNC));
    end

    // Visible region
    assign display_on = (hpos < H_VISIBLE) && (vpos < V_VISIBLE);

endmodule
