/* 

    Testbench for UART. 

*/


// Never forget this!
`default_nettype none

module tb();

reg clk;
reg resetn;
wire w_resetn = resetn;
reg [7:0] data;
wire w_data = data;
reg data_ready;
wire w_data_ready = data_ready;
wire busy;  
wire tx;

uart_tx u1 (
    .clk_25mhz(clk),
    .resetn(resetn),
    .data(data),
    .start_tx(w_data_ready),
    .busy(busy),
    .tx(tx)
);

initial begin
    
    // initialise values
    clk = 1'b0;

    data_ready = 1'b0;
    
    // reset 
    resetn = 1'b1;
    #5
    resetn = 1'b0;
    #5
    resetn = 1'b1;

    data = 8'd0;
    

end

// generate clk
always @ ( * ) begin
    #1
    clk <= ~clk; 
end


parameter sIDLE         = 2'b00;
parameter sSET_DATA     = 2'b01;
parameter sWAIT         = 2'b10;

reg [1:0] curr_state;
reg [7:0] cwait;

// send data via uart
reg [21:0] counter1;
always @ (posedge clk) begin

    if (!resetn) begin 
        counter1 <= 0;
        data <= 8'd0;
        data_ready <= 1'b0;
        curr_state <= sIDLE;
        cwait <= 8'd0;
    end
    else begin 

        case (curr_state)
            
            sIDLE: begin 

                if (!busy) begin
                    // set data 
                    curr_state <= sSET_DATA;
                end
                else begin 

                    // reset data ready flag
                    data_ready <= 1'b0;
                end

            end 

            sSET_DATA: begin 

                // set data
                data <= data + 1;

                // switch to wait curr_state
                curr_state <= sWAIT;

            end

            sWAIT: begin 

                cwait <= cwait + 1;

                if (cwait == 8'd7) begin 

                    // set data as ready
                    data_ready <= 1'b1;

                    // go to idle curr_state
                    curr_state <= sIDLE;

                    // reset wait
                    cwait <= 8'd0;
                end

            end

            default: 
                curr_state <= sIDLE;

        endcase


    end
end

initial begin
    $dumpfile("testbench.vcd");
    $dumpvars;
    #10000
    $finish;
end
endmodule