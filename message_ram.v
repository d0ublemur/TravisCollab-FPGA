//version 2016-07-15


/*
* Edited by Murphy
*/


module message_ram (
        input clk,
        input byte_in,
        input [3:0] addr,
        output [7:0] data,
        input [3:0] counter,
	input new_rx_data,
	input rst
);

        wire [7:0] ram_wire [0:9];
        reg [7:0] ram_data_d [0:7];
        reg [7:0] ram_data_q [0:7];
        reg [1:0] ctr_d, ctr_q;
        reg [9:0] data_d, data_q;

/*
* this is the element selector variable that the module needs to know 
* which ram_wire element to output.
*/

        assign data = data_q;

/* 
*  THIS BLOCK KEEPS ADDING ALL SIGNALS TO SENSITIVITY LIST BUT I DON'T 
*  WANT THEM ALL IN SENSITIVITY LIST
*/

/*
* when you get a keyboard value, increment a counter and assign those 8 
* byte (fram byte_in) to a register
*/

        always @(*) begin

                if (rst) begin
                        ram_data_d[0] = 8'b0;
                        ram_data_d[1] = 8'b0;
                        ram_data_d[2] = 8'b0;
                        ram_data_d[3] = 8'b0;
                        ram_data_d[4] = 8'b0;
                        ram_data_d[5] = 8'b0;
                        ram_data_d[6] = 8'b0;
                        ram_data_d[7] = 8'b0;
                end
	 
	        if (new_rx_data) begin
	 
	                if (byte_in == 1)
                                ram_data_d[counter - 1] = "1";
	 
                        else if (byte_in == 0)
                                ram_data_d[counter - 1] = "0";
	 
                        else
                                ram_data_d[counter] = ram_data_q[counter];
                end

	 
	        else if (counter < 4'b0001) begin
	                ram_data_d[0] = ram_data_q[0];
	                ram_data_d[1] = ram_data_q[1];
	                ram_data_d[2] = ram_data_q[2];
	                ram_data_d[3] = ram_data_q[3];
	                ram_data_d[4] = ram_data_q[4];
	                ram_data_d[5] = ram_data_q[5];
	                ram_data_d[6] = ram_data_q[6];
	                ram_data_d[7] = ram_data_q[7];
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
        assign ram_wire[8] = "\n";
        assign ram_wire[9] = "\r";



        always @(*) begin
                if (addr > 4'd9)
                        data_d = " ";

                else
                        data_d = ram_wire[addr];
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
	        end
        end

endmodule
