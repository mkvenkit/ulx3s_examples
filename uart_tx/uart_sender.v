/*

    uart_sender.v


*/

module uart_sender(
    input clk,
    input resetn,
    input busy,
    output reg [7:0] data,
    output data_ready        //
);

parameter sIDLE         = 2'b00;
parameter sSET_DATA     = 2'b01;
parameter sWAIT         = 2'b10;

reg [1:0] curr_state;
reg [7:0] cwait;
reg data_ready;

// send data via uart
always @ (posedge clk) begin
    // reset regs
    if (!resetn) begin 
        data <= 8'hab;
        data_ready <= 1'b0;
        curr_state <= sIDLE;
        cwait <= 8'd0;
    end
    else begin 
        case (curr_state)
            sIDLE: begin 
                if (!busy)
                    // set data 
                    curr_state <= sSET_DATA;
                else 
                    // reset flag
                    data_ready <= 1'b0;
            end 

            sSET_DATA: begin 
                // set data
                //data <= data + 1;
                // switch to wait curr_state
                curr_state <= sWAIT;
            end

            sWAIT: begin 
                cwait <= cwait + 1;
                if (cwait == 8'd7) begin 
                    // set flag to tx
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

endmodule