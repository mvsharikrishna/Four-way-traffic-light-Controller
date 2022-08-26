// 				----------------------- TRAFFIC LIGHTS - TEST BENCH MODULE -------------------------------
`timescale 100ms/1ms
module traffic_lights_fsm_tb;

//Declaration of inputs to design as reg & outputs from design as wires
reg clk_in_tb;
reg rst_n_in_tb;
wire [7:0]north_sgnl_out_tb;
wire [7:0]south_sgnl_out_tb;
wire [7:0]east_sgnl_out_tb;
wire [7:0]west_sgnl_out_tb;

//Mapping Test Bench to DUT via name mapping
traffic_lights_fsm DUT(.north_sgnl_out(north_sgnl_out_tb),
			.south_sgnl_out(south_sgnl_out_tb),
			.east_sgnl_out(east_sgnl_out_tb),
			.west_sgnl_out(west_sgnl_out_tb),
			.clk_in(clk_in_tb),
			.rst_n_in(rst_n_in_tb));

//Clock Generation
initial
begin
	clk_in_tb=0;
	forever #5	clk_in_tb=~clk_in_tb;
end

//Generation of Reset
initial
begin
	rst_n_in_tb=0;
#5	rst_n_in_tb=1;
end

//Monitoring input & outputs
initial
begin
$monitor($time,/*"clk=%b*/ " rst=%b north: Straight_Red=%b right_red=%b yellow=%b Straight_green=%b right_green=%b left_green=%b pedistrian_red=%b pedistrian_green=%b \n \t South: Straight_Red=%b right_red=%b yellow=%b Straight_green=%b right_green=%b left_green=%b pedistrian_red=%b pedistrian_green=%b \n \t East: Straight_Red=%b right_red=%b yellow=%b Straight_green=%b right_green=%b left_green=%b pedistrian_red=%b pedistrian_green=%b \n \t West: Straight_Red=%b right_red=%b yellow=%b Straight_green=%b right_green=%b left_green=%b pedistrian_red=%b pedistrian_green=%b count_st=%d count_rt=%d count_yellow=%d",/*clk_in_tb*/rst_n_in_tb,north_sgnl_out_tb[0],north_sgnl_out_tb[1],north_sgnl_out_tb[2],north_sgnl_out_tb[3],north_sgnl_out_tb[4],north_sgnl_out_tb[5],north_sgnl_out_tb[6],north_sgnl_out_tb[7],south_sgnl_out_tb[0],south_sgnl_out_tb[1],south_sgnl_out_tb[2],south_sgnl_out_tb[3],south_sgnl_out_tb[4],south_sgnl_out_tb[5],south_sgnl_out_tb[6],south_sgnl_out_tb[7],east_sgnl_out_tb[0],east_sgnl_out_tb[1],east_sgnl_out_tb[2],east_sgnl_out_tb[3],east_sgnl_out_tb[4],east_sgnl_out_tb[5],east_sgnl_out_tb[6],east_sgnl_out_tb[7],west_sgnl_out_tb[0],west_sgnl_out_tb[1],west_sgnl_out_tb[2],west_sgnl_out_tb[3],west_sgnl_out_tb[4],west_sgnl_out_tb[5],west_sgnl_out_tb[6],west_sgnl_out_tb[7],DUT.count_st,DUT.count_rt,DUT.count_yellow);
//$monitor($time,"clk=%b rst=%b north: %b south=%b east=%b west=%b count=%d",clk_in_tb,rst_n_in_tb,north_sgnl_out_tb,south_sgnl_out_tb,east_sgnl_out_tb,west_sgnl_out_tb,DUT.count);
#2300	$finish;
end
endmodule
