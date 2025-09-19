module tt_um_sjsu (
    input clk,
    input rst_n,
    input [7:0] ui_in,
    output [7:0] uo_out,
    output [7:0] uio_out,
    input [7:0] uio_in,
    input [7:0] ena
);

    // Bouncing square logic
    // (This is a simplified representation)
    reg [9:0] x_pos, y_pos;
    reg [0:0] x_dir, y_dir;

    always @(posedge clk) begin
        if (!rst_n) begin
            x_pos <= 0;
            y_pos <= 0;
            x_dir <= 1; // 1 = right, 0 = left
            y_dir <= 1; // 1 = down, 0 = up
        end else begin
            // Move square
            if (x_dir) x_pos <= x_pos + 1;
            else x_pos <= x_pos - 1;

            if (y_dir) y_pos <= y_pos + 1;
            else y_pos <= y_pos - 1;

            // Bounce off edges
            if (x_pos == 639) x_dir <= 0; // right edge
            if (x_pos == 0) x_dir <= 1;  // left edge
            if (y_pos == 479) y_dir <= 0; // bottom edge
            if (y_pos == 0) y_dir <= 1;  // top edge
        end
    end
    
    // Assign outputs
    assign uo_out = {x_pos[7:0]}; // Example output
    assign uio_out = {y_pos[7:0]}; // Example output

endmodule
