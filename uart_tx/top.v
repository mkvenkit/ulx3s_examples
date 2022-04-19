/*

top.v

A Simple UART TX example.

*/

// Never forget this!
`default_nettype none

module top(
  input clk_25mhz,
  input  [6:0] btn,     // BTN_PWRn (btn[0])
  output ftdi_rxd,      // serial output 
  output [7:0] led   // LED 
);

// reset signal for modules 
wire resetn = btn[0];


// UART signals 
reg [7:0] data;
reg start_tx;
wire busy;

// UART module 
uart_tx uart1(
    .clk_25mhz(clk_25mhz),
    .resetn(resetn),
    .data(data),
    .start_tx(start_tx),
    .busy(busy),
    .rx(ftdi_rxd)
);


// LED blink
reg [22:0] counter;
reg RL;
always @ (posedge clk_25mhz)
    begin 
        counter <= counter + 1;
        if(!counter)
            RL = ~RL;
    end

// set LEDs
assign led[0] = RL;
assign led[7:1] = {7{0}};

endmodule
