module top(clk, rst,start, si, a,b,c,d,e,f,g,an); 
input clk,rst,start; 
output si, a,b,c,d,e,f,g,an; 

pulse_gen_clk_div pulse_clk_div_inst(clk,rst,start,mode, pusle, clk_60hz);

endmodule 