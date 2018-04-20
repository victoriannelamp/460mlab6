module pulse_gen_clk_div(clk,rst,start,mode, pulse, clk_1hz); 
input clk, rst, start; 
input [1:0] mode; 
output pulse, clk_1hz; 

reg [31:0] clk_var, hybrid;  
reg p_out; 
reg [7:0] r_reg, r_reg_1hz;
wire [7:0] r_nxt, r_nxt_1hz;
reg clk_track, clk_track_1hz;
reg [31:0] hybrid_array [8:0]; 
reg [31:0] hybrid_cnt; 
reg [31:0] hybrid_loop; 
reg [7:0] i; 

initial 
begin 
hybrid_array[0] = 20; // 20 
hybrid_array[1] = 32; 
hybrid_array[2] = 66; 
hybrid_array[3] = 26; 
hybrid_array[4] = 70; 
hybrid_array[5] = 30; 
hybrid_array[6] = 20; 
hybrid_array[7] = 30; 
hybrid_array[8] = 32; 

end 

// choose output based on mode 

always @(posedge clk)
begin 
case (mode)
	2'b00: clk_var = 16;   //32hz 100e6hz / 32hz = 0x170784
	2'b01: clk_var = 32;   //64hz 100e6hz/ 64hz = 
	2'b10: clk_var = 64;   //128hz 100e6hz / 128hz = 
	2'b11: begin clk_var = hybrid; end 
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

//hybrid generate 
always @(posedge clk_1hz)
begin 
//TODO: intialize hybrid count somehow 
if(hybrid_cnt <= 9) begin i = 0; hybrid = hybrid_loop; end
else if(hybrid_cnt < 74) begin hybrid = 70; end 
else if(hybrid_cnt < 80) begin hybrid = 34; end 
else if(hybrid_cnt < 144) begin hybrid = 124; end 
else hybrid = 0; 

for(i = 0 ; i < 10; i = i + 1)
begin 
hybrid_loop = hybrid_array[i];
end 

end 

//1Hz clk div 
 assign r_nxt_1hz = r_reg_1hz+1;   	      
 assign clk_1hz =  clk_track_1hz; 

always @(posedge clk)
begin 
  if (rst)
     begin
        r_reg_1hz <= 0;
	clk_track_1hz <= 1'b0;
     end
 
  else if (r_nxt_1hz == 64'd100000000) //1hz: 100000000/100000000 
 	   begin
	     r_reg_1hz <= 0;
	     clk_track_1hz <= ~clk_track_1hz;
	   end
 
  else 
      r_reg_1hz <= r_nxt_1hz;
end 


endmodule 

