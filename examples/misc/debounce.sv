module Debouncer (input i_switch, clk,
						output o_switch);

const int tick_no = 1000000;
reg state = 0;
reg [31:0] count = 0;

//register: wait for stable speed
always @ (posedge clk) 
	begin
	if(i_switch != state && count < tick_no)	//if the bounce happened during shift, ignore it.
		count <= count + 1;
	else if(count == tick_no)	//if bounce happens after the shift,
		state <= i_switch;	//pass the noisy value in.
	else
	   count <= 0;
end

assign o_switch = state;

endmodule