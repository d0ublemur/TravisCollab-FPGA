//version 2016-07-15

/*
* Good God this needs help with indentation.
* Edited by Murphy
*/


module message_printer (

        input clk,
        input tx_busy,
	input [7:0] rx_data,
	input new_rx_data,
        input rst,

        output [7:0] tx_data,
        output reg new_tx_data,
	output [3:0] addr

);

        localparam STATE_SIZE = 1;
        localparam IDLE = 0, PRINT_MESSAGE = 1;
        localparam MESSAGE_LEN = 10;


        reg byte_out_d, byte_out_q;
        wire byte_out;



        reg [3:0] addr_d, addr_q;
        reg [3:0]counter_q, counter_d;
        reg state_d, state_q;

        assign addr = addr_q;

//use counter in this module for incrementation in message_ram
        assign counter = counter_q;

 message_ram message_ram1 (
        .clk(clk),
        .addr(addr_q),

//connect the keyboard input of this module to the message_ram "byte_in"
        .byte_in(byte_out_q),
        .data(tx_data),
        .new_rx_data(new_rx_data),
        .rst(rst)
);

        localparam READY = 1,
                   N_READY = 0;


        always @(*) begin
                byte_out_d = byte_out_q;
		addr_d = addr_q;
		new_tx_data = 1'b0;

                if(new_rx_data)
                       state_d = READY; 

                if (rst) begin
                        addr_d = 4'b0;
                        state_d = N_READY;
                end
		
	        if (addr_d == 4'd8 && !tx_busy)
	        begin
                        new_tx_data = 1'b1;

		        if (addr_d > 10)
			        addr_d = 4'd0;

                        else 
			        addr_d = 4'd0;
                       
	        end
	
	        else if(state_q)
	        begin
			if (rx_data == "0") begin
				byte_out_d = 0;
                                addr_d = addr_q + 1;
                                state_d = N_READY;
			end

			else if(rx_data == "1") begin
                                addr_d = addr_q + 1;
				byte_out_d = 1;
                                state_d = N_READY;
			end
			
			else begin
				
                                byte_out_d = byte_out_q;
			end
	        end

	 end


        always @(posedge clk) begin
                if (rst) begin
                        byte_out_q <= 1'd0;
		        addr_q <= 4'd0;
                        state_q <= 0;
                end
     
                else begin
                        byte_out_q <= byte_out_d;
                        state_q <= state_d;
                        addr_q <= addr_d;
	        end
        end

endmodule
