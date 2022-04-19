/*

    uart_tx.v

    UART Transmitter module.

*/

module uart_tx (
    input clk_25mhz,    // input clock 
    input resetn,       // active low reset 
    input [7:0] data,   // 8 bit input data 
    input start_tx,     // flag to start TX
    output busy,        // high when TX is busy 
    output rx           // serial output data 
);

// baud rate generator 


// Controller Module  


// Datapath module 

endmodule