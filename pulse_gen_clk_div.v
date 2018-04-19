module pulse_gen_clk_div(clk,rst,start,mode, pulse, clk_1hz); 
input clk, rst, start; 
input [1:0] mode; 
output pulse, clk_1hz; 

reg [31:0] clk_var, hybrid;  
reg p_out; 
reg [7:0] r_reg;
wire [7:0] r_nxt;
reg clk_track;


// choose output based on mode 

always @(posedge clk)
begin 
case (mode)
	2'b00: clk_var = 16;   
	2'b01: clk_var = 32; 
	2'b10: clk_var = 64;
	2'b11: clk_var = hybrid;
endcase
end 

//varilabe clk generate
 assign r_nxt = r_reg+1;   	      
 assign pulse = (start == 1)? clk_track : 1'b0;
 
always @(posedge clk)
begin
  if (rst)
     begin
        r_reg <= 0;
	clk_track <= 1'b0;
     end
 
  else if (r_nxt == clk_var)
 	   begin
	     r_reg <= 0;
	     clk_track <= ~clk_track;
	   end
 
  else 
      r_reg <= r_nxt;
end



//1Hz clk div 
always @(posedge clk)
begin 

end 


endmodule 

