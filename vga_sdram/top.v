/*

top.v

A simple test pattern using the hvsync_generator module.


*/


// Never forget this!
`default_nettype none

module top(
  input clk_25mhz,
  input  btn_reset,     // BTN_PWRn (btn[0])
  output hsync,     // hysnc 
  output vsync,     // vsync
  output [3:0] R, // red 
  output [3:0] G, // green 
  output [3:0] B, // blue 
  output [7:0] led   // LED 
);

wire clk_100mhz;
wire locked;
pll pll1 (
    .clkin(clk_25mhz),
    .clkout0(clk_100mhz),
    .locked(locked)
);

// reset signal for modules 
wire reset = btn_reset;

// ********************
// clock strobe 
// ********************
// create a clock strobe at 25 MHz
// https://zipcpu.com/blog/2017/06/02/generating-timing.html 
reg	[15:0]	clk_counter;
wire clk_stb;
always @(posedge clk_100mhz)
    {clk_stb, clk_counter} <= clk_counter + 16'h4000;


// **********
// VGA 
// **********
wire display_on;
wire [10:0] hpos;
wire [10:0] vpos;
// hook up hsync/vsync     
hvsync_generator hvsync_gen(
    .clk(clk_100mhz),
    .clk_stb(clk_stb),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos),
    .vpos(vpos)
);

// clocked VGA
reg [3:0] red;
reg [3:0] green;
reg [3:0] blue;
always @(posedge clk_100mhz) begin
    if (!reset) begin 
        red <= 4'd0;
        green <= 4'd0;
        blue <= 4'd0;
    end 
    else begin 
        if (clk_stb) begin
            red   <= {4{display_on && (((hpos&7)==0) || ((vpos&7)==0))}};
            green <= {4{display_on && vpos[4]}};
            blue  <= {4{display_on && hpos[4]}};
        end
    end 
end

// assign RGB out 
assign R = red;
assign G = green;
assign B = blue;

// **********
// LED blink 
// **********
reg LED;
reg [22:0] counter;
always @ (posedge clk_100mhz) begin
    if (!reset) 
        counter <= 23'd0;
    else begin 
        counter <= counter + 1;
        if (!counter)
            LED = ~LED;
    end
end 

// set LEDs
assign led[0] = LED;
assign led[7:1] = {7{0}};  

endmodule
