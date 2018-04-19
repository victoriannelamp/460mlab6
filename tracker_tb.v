module tracker_tb();

reg step_clk, reset;
wire si, bcd3, bcd2, bcd1, bcd0;

initial begin
step_clk = 1'b0;
forever #5 step_clk = ~step_clk;
end

initial begin
reset = 1;
#30
reset = 0;
#300
$finish;
end

tracker tracker_module(step_clk, reset, si, bcd3, bcd2, bcd1, bcd0);

endmodule