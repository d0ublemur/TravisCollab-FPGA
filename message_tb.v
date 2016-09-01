module message_tb;

        initial begin
                $dumpfile("test.vcd");
                $dumpvars(0,message_tb);
                clk = 1'b0;
                rst = 1'b1;
                repeat(4) #10 clk = ~clk;
                new_rx_data = 0;
                rst = 1'b0;
	        tx_busy = 1'd0;
	        forever #10 clk = ~clk; // generate a clock

	        $finish;
        end

        initial begin

                #50
	        new_rx_data = 1;
	        rx_data = "1";          //1

                #50
                new_rx_data = 0;

	 //2
                #100
	        new_rx_data = 1;
                rx_data = "1";          //1 
	        #23
	        new_rx_data = 0;

	 //3
	        #100
	        new_rx_data = 1;
                rx_data = "1";          //1
	        #2
	        new_rx_data = 0;

	 //4
                #100
                new_rx_data = 1;
                rx_data = "1";          //1
	        #5
	        new_rx_data = 0;

	 //5
	        #100
	        new_rx_data = 1;
                rx_data = "0";          //0
	        #3
	        new_rx_data = 0;

	 //6
	        #100
	        new_rx_data = 1;
	        rx_data ="0";           //0
	        #9
	        new_rx_data = 0;

	 //7
	        #100
	        new_rx_data = 1;
	        rx_data = "0";          //0
	        #7
	        new_rx_data = 0;

	 //8
	        #100
	        new_rx_data = 1;
	        rx_data = "0";          //0
	        #5
	        new_rx_data = 0;

	        #6000
                $finish;
        end





        reg clk, rst;
        wire [7:0] tx_data;
        wire new_tx_data;
        reg tx_busy, new_rx_data;
        reg [7:0] rx_data;
        //reg [0:7] data;
        wire [3:0] addr;
        wire bytes;
        wire [7:0] data;
        wire state;





        message_printer message_printer1 (
                .clk(clk),
                .rst(rst),
                .tx_data(tx_data),
                .new_tx_data(new_tx_data),
                .tx_busy(tx_busy),
                .new_rx_data(new_rx_data),
                .rx_data(rx_data),
	        .addr(addr)
);

endmodule
