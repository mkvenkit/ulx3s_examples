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
    .clk(clk_25mhz),
    .clk_stb(clk_stb),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos),
    .vpos(vpos)
);

// set pattern 
wire r1 = display_on && (((hpos&7)==0) || ((vpos&7)==0));
wire g1 = display_on && vpos[4];
wire b1 = display_on && hpos[4];  
// assign RGB out 
assign R = {4{r1}};
assign G = {4{g1}};
assign B = {4{b1}};


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
