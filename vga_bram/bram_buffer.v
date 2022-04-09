/* 

    bram_buffer.v

    This module implements a 128 x 128 x 16-bit buffer using BRAM.

*/

`default_nettype none

module bram_buffer (
  input clk,
  input reset,
  input [6:0] row,          // 0 to 127 
  input [6:0] col,          // 0 to 127
  input oe,                 // output enable
  output reg [15:0] rgb         // RGB556 
);

// declare a reg from which 
// block RAM will be inferred 
// 128 * 128 * 16-bit = 262144
parameter SZ = 128 * 128;
reg [15:0] buffer[SZ];

// initialize RAM 
integer k;
initial begin
    for (k = 0; k < SZ; k++) begin
        if (k < SZ/2)  
            buffer[k] = 16'h000F;
        else 
            buffer[k] = 16'h0F00;
    end
end

// compute read address 
wire [17:0] read_addr = 8'd128 * row + col;

// define read access 
always @ (posedge clk) begin
    if (oe)
        rgb <= buffer[read_addr];
end

endmodule
