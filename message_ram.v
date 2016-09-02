//version 2016-07-15


/*
* Edited by Murphy
*/


module message_ram (
        input clk,
        input byte_in,
        input [3:0] addr,
        output [7:0] data,
	input new_rx_data,
	input rst
);

        wire [7:0] ram_wire;
        reg [7:0] ram_data_d ;
        reg [7:0] ram_data_q ;
        reg [1:0] ctr_d, ctr_q;
        reg [9:0] data_d, data_q;
        reg state_q, state_d;

/*
* this is the element selector variable that the module needs to know 
* which ram_wire element to output.
*/

        assign data = data_q;

/*
* I am creating a state machine, so that only one register of ram data
* is set per new_rx_data. This may fix some stuff.
*/

localparam READY = 1,
           N_READY = 0;

/* 
*  THIS BLOCK KEEPS ADDING ALL SIGNALS TO SENSITIVITY LIST BUT I DON'T 
*  WANT THEM ALL IN SENSITIVITY LIST
*/

/*
* when you get a keyboard value, increment a counter and assign those 8 
* byte (fram byte_in) to a register
*/


        always @(*) begin

                if(new_rx_data)
                        state_d = READY;

                if (rst) begin
                        ram_data_d[0] = 8'b0;
                        ram_data_d[1] = 8'b0;
                        ram_data_d[2] = 8'b0;
                        ram_data_d[3] = 8'b0;
                        ram_data_d[4] = 8'b0;
                        ram_data_d[5] = 8'b0;
                        ram_data_d[6] = 8'b0;
                        ram_data_d[7] = 8'b0;
                        state_d = N_READY;
                end
	 
	        else if (state_q) begin

                        ram_data_d[addr] = byte_in;
                        state_d = N_READY;
	 
                end

        end

//THIS IS WHERE THE BYTES GET REVERSED
 
/*
* continuously assign a value to the ram_wire.  When the full 3 bytes 
* have been stored, message_printer shoudl signal this module to output 
* them in reverse order
*/

        assign ram_wire[0] = ram_data_d[7];
        assign ram_wire[1] = ram_data_d[6];
        assign ram_wire[2] = ram_data_d[5];
        assign ram_wire[3] = ram_data_d[4];
        assign ram_wire[4] = ram_data_d[3];
        assign ram_wire[5] = ram_data_d[2];
        assign ram_wire[6] = ram_data_d[1];
        assign ram_wire[7] = ram_data_d[0];
        //assign ram_wire[8] = "\n";
        //assign ram_wire[9] = "\r";



        always @(*) begin
                if (addr > 4'd9)
                        data_d = "";

                else begin
                        if (ram_data_q[addr] == 1)
                                data_d = "1";
                        else if (ram_data_q[addr] == 0)
                                data_d = "0";
                end
        end

        always @(posedge clk) begin
	        if (rst) begin
	                ram_data_q[7] <= 8'd0;
                        ram_data_q[6] <= 8'd0;
                        ram_data_q[5] <= 8'd0;
                        ram_data_q[4] <= 8'd0;
                        ram_data_q[3] <= 8'd0;
                        ram_data_q[2] <= 8'd0;
                        ram_data_q[1] <= 8'd0;
                        ram_data_q[0] <= 8'd0;
	                data_q <= 8'd0;
	                ctr_q <= 4'b0000;
                        state_q <= 0;
	        end
	 
	        else begin
/*
* can't assign a packed type to unpacked type so individual 
* registers/elements must be selected for ram_data
*/

                        ram_data_q[7] <= ram_data_d[7];
                        ram_data_q[6] <= ram_data_d[6];
                        ram_data_q[5] <= ram_data_d[5];
                        ram_data_q[4] <= ram_data_d[4];
                        ram_data_q[3] <= ram_data_d[3];
                        ram_data_q[2] <= ram_data_d[2];
                        ram_data_q[1] <= ram_data_d[1];
                        ram_data_q[0] <= ram_data_d[0];
                        data_q <= data_d;
                        ctr_q <= ctr_d;
                        state_q <= state_d;
	        end
        end

endmodule
