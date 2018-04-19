module tracker(step_clk, reset, si, bcd3, bcd2, bcd1, bcd0); 
input step_clk;
input reset;
output si;
output [4:0] bcd3, bcd2, bcd1, bcd0;

reg [30:0] step_counter; 
reg [31:0] shift_register;
wire [4:0] step_counter_bcd3, step_counter_bcd2, step_counter_bcd1, step_counter_bcd0;
wire [4:0] distance_covered_bcd3, distance_covered_bcd2, distance_covered_bcd1, distance_covered_bcd0; 

/*******Part 1: Total Step Count***********/
always @(posedge step_clk or posedge reset) 
begin
	if(reset == 1'b1) step_counter <= 31'b0;
	else step_counter <= step_counter + 1;
end

assign si = (step_counter > 9999) ?	1'b1 : 1'b0;
assign step_counter_bcd0 = (step_counter > 9999) ? 5'd9 : (step_counter % 10); 
assign step_counter_bcd1 = (step_counter > 9999) ? 5'd9 : ((step_counter/10) % 10);
assign step_counter_bcd2 = (step_counter > 9999) ? 5'd9 : ((step_counter/100) % 10);
assign step_counter_bcd3 = (step_counter > 9999) ? 5'd9 : ((step_counter/1000) % 10);



/***********Part 2: Distance Covered**********/
always @(posedge step_clk)
begin
	shift_register <= {11'b0, step_counter[30:10]}; //right shifts the step_counter by 11 bits	
end													//shift_register will hold the whole number of miles in bits [31:1]
													// and the fractional number of miles in bit 0

//the seven segment displays will show distance covered in the form of 0W_F
// where W is the whole number of miles and F is the fractional number of miles								
assign distance_covered_bcd3 = 5'd0;
assign distance_covered_bcd2 = shift_register[5:1]; //whole number of miles
assign distance_covered_bcd1 = 5'h1F; //TODO: make sure the seven seg display module decodes this as an "_"
assign distance_covered_bcd0 = (step_counter[0] == 1'b1) ? 5'd5 : 5'd0;


endmodule 