/*---------------------------- FOUR WAY TRAFFIC SIGNAL LIGHTS -----------------------------------------*/
/* In this model inorder to enchance the clarity and understanding of signals
    	-  signals are specified with direction and direction which they intented to go

		<---------------------------------------- SIGNALS & DESCRIPTION -------------------------------->

 * Signals in each direction are 8, which includes
    	- straight_red		- straight_green	- left_green		- pedistrian_red
    	- right_red		- right_green		- yellow		- pedistrian_green

 * In the following implementation, all signals that are in a particular direction are represented in a vector form
 	- signals towards north direction: [7:0]north
	- signals towards south direction: [7:0]south
	- signals towards east direction: [7:0]east
	- signals towards west direction: [7:0]west
    where,
	north[0], south[0], east[0], west[0] ---> straight_red signals
	north[1], south[1], east[1], west[1] ---> right_red signals
	north[2], south[2], east[2], west[2] ---> yellow signals
	north[3], south[3], east[3], west[3] ---> straight_green signals
	north[4], south[4], east[4], west[4] ---> right_green signals
	north[5], south[5], east[5], west[5] ---> left_green signals
	north[6], south[6], east[6], west[6] ---> pedistrian_red signals
	north[7], south[7], east[7], west[7] ---> pedistrian_green signals
    and
	Signal assertion / Signal Activation = 1
	signal Deassertion / Signal Deactivation = 0

 * In any direction, if a vehicle wants to turn "LEFT" -  Vehicle need not pass through the intersection point. So, "FREE LEFT" can be granted.
 	north_left_green=1	south_left_green=1	east_left_green=1	west_left_green=1

 * In this program, Asserting time for signals:
		STRAIGHT_GREEN	: 60sec
		RIGHT_GREEN	: 30sec
		YELLOW		: 10sec
		PEDISTRIAN	: 60sec
 * Input Signals are:
 	- Clock
	- Asynchronous Active Low Reset

 * Other than left_green all other signals have to be controlled.
 * Controlling signals can be achieved through "FINATE STATE MACHINE".
 *
 * 							<-------------------- STATES & DESCRIPTION -------------------------->
_________________________________________________________________________________________________________________________________________________________________________________
			|					ALLOWED DIRECTIONS & SIGNALS								|			|
	STATE		|-------------------------------------------------------------------------------------------------------------------------------|	TIME DELAY	|
			|		NORTH		|		SOUTH		|		EAST		|		WEST		|			|
________________________|_______________________________|_______________________________|_______________________________|_______________________________|_______________________|
			|	Left (North -> East)	|				|				|				|			|
	STATE 0		|   Straight (North -> South)	|	Left (South -> West)	|	Pedistrian Signal	|	Left (West -> North)	|	30sec		|
			|     Right (North -> West)	|				|	Left (East -> South)	|				|			|
------------------------|-------------------------------|-------------------------------|-------------------------------|-------------------------------|-----------------------|
			|				|				|				|				|			|
	STATE 1		|   Straight (North -> South)	|	Left (South -> West)	|	Pedistrian Signal	|	Right (West -> South)	|	30sec		|
			|	Left (North -> East)	|				|	Left (East -> South)	|	Left (West -> North)	|			|
------------------------|-------------------------------|-------------------------------|-------------------------------|-------------------------------|-----------------------|
			|				|				|				|				|			|
	STATE 2		|		Yellow		|	Left (South -> West)	|	Left (East -> South)	|	Left (West -> North)	|	10sec		|
			|	Left (North -> East)	|				|				|				|			|
------------------------|-------------------------------|-------------------------------|-------------------------------|-------------------------------|-----------------------|
			|				|	Left (South -> West)	|				|				|			|
	STATE 3		|	Left (North -> East)	|   Straight (South -> North)	|	Left (East -> South)	|	Pedistrian Signal	|	30sec		|
			|				|	Right (South -> East)	|				|	Left (West -> North)	|			|
------------------------|-------------------------------|-------------------------------|-------------------------------|-------------------------------|-----------------------|
			|				|				|				|				|			|
	STATE 4		|	Left (North -> East)	|   Straight (South -> North)	|	Right (East -> North)	|	Pedistrian Signal	|	30sec		|
			|				|	Left (South -> West)	|	Left (East -> South)	|	Left (West -> North)	|			|
------------------------|-------------------------------|-------------------------------|-------------------------------|-------------------------------|-----------------------|
			|				|				|				|				|			|
	STATE 5		|	Left (North -> East)	|		Yellow		|	Left (East -> South)	|	Left (West -> North)	|	10sec		|
			|				|	Left (South -> West)	|				|				|			|
------------------------|-------------------------------|-------------------------------|-------------------------------|-------------------------------|-----------------------|
			|				|				|				|				|			|
	STATE 6		|	Pedistrian Signal	|	Pedistrian Signal	|   Straight (East -> West)	|   Straight (West -> East)	|	60sec		|
			|	Left (NOrth -> East)	|	Left (South -> West)	|	Left (East -> South)	|	Left (West -> North)	|			|
------------------------|-------------------------------|-------------------------------|-------------------------------|-------------------------------|-----------------------|
			|				|				|	Left (East -> South)	|	Left (West -> North)	|			|
	STATE 7		|	Left (North -> East)	|	Left (South -> West)	|		Yellow		|		Yellow		|	10sec		|
________________________|_______________________________|_______________________________|_______________________________|_______________________________|_______________________|
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
module traffic_lights_fsm#(parameter s0 = 3'd0,		//Declaration of states as parameters
				parameter s1=3'd1,	//State Assignments is given using Binary coding
				parameter s2=3'd2,	
				parameter s3=3'd3,
				parameter s4=3'd4,
				parameter s5=3'd5,
				parameter s6=3'd6,
				parameter s7=3'd7)
			(output [7:0]north_sgnl_out,	// North Signals
			 output [7:0]south_sgnl_out,	// South Signals
			 output [7:0]east_sgnl_out,	// East Signals
			 output [7:0]west_sgnl_out,	// West Signals
			 input rst_n_in,		// Reset Signal
			 input clk_in);			// Clock Signal

//Declaration of required registers for output wires
reg [7:0]north,south,east,west;

//Declaration of registers for Next state and Present State
reg [3:0]ps,ns;

//Declaration of integer for time counting
integer count_st=60;
integer count_rt=30;
integer count_yellow=0;

//State Register
always@(posedge clk_in,negedge rst_n_in)
begin
	if(!rst_n_in)	ps<=s0;			//Reseting System
	else		
		begin
			ps<=ns;			//Assigning next state to present state  at every posedge (clk)
			if(count_st>0)		count_st<=count_st-1;		// While Assigning time count gets incremented by 1
			else			count_st<=0;
			if(count_rt>0)		count_rt<=count_rt-1;
			else			count_rt<=0;
			if(count_yellow>0)	count_yellow<=count_yellow-1;
			else			count_yellow<=0;
		end
end

always@(ps,count_st,count_rt,count_yellow)
begin
	case(ps)
		s0:	begin				//State 0
				north=8'b0111_1000;
				south=8'b0110_0011;
				east=8'b1010_0011;
				west=8'b0110_0011;
				if(count_st>30 && count_rt>0)		// upto right_time_count completes 30sec and straight_time_count completes 60 to 30sec, state will be same i.e., s0
					ns=s0;
				else
				begin
					ns=s1;		// At time_count = 30sec, state changes to s0 state changes to s1
					count_rt=30;	// Before changing state right_time_count will be made to 30
				end
			end
		s1:	begin				//State 1
				north=8'b0110_1010;
				south=8'b0110_0011;
				east=8'b1010_0011;
				west=8'b0111_0001;
				if(count_st>0 && count_rt>0)		// upto straight_time_count completes 60sec and right_time_count completes 30sec, state will be same i.e., s1
					ns=s1;
				else
				begin
					ns=s2;		// At time_count = 30sec, state changes to s1 state changes to s2
					count_yellow=10;// Before changing state yellow_time_count will be made to 10
				end
			end
		s2:	begin				//State 2
				north=8'b0110_0110;
				south=8'b0110_0011;
				east=8'b0110_0011;
				west=8'b0110_0011;
				if(count_yellow>0)		// upto yellow_time_count completes 10sec, state will be same i.e., s2
					ns=s2;
				else
				begin
					ns=s3;		// At time_count = 30sec, state changes to s2 state changes to s3
					count_rt=30;	// Before changing state right_time_count will be made to 30
					count_st=60;	// Before changing state straight_time_count will be made to 60
				end
			end
		s3:	begin				//State 3
				north=8'b0110_0011;
				south=8'b0111_1000;
				east=8'b0110_0011;
				west=8'b1010_0011;
				if(count_st>30 && count_rt>0)		// upto straight_time_count completes 30sec and right_time_count completes 30sec, state will be same i.e., s3
					ns=s3;
				else
				begin
					ns=s4;		// At time_count = 30sec, state changes to s3 state changes to s4
					count_rt=30;	// Before changing state right_time_count will be made to 30
				end
			end
		s4:	begin				//State 4
				north=8'b0110_0011;
				south=8'b0110_1010;
				east=8'b0111_0001;
				west=8'b1010_0011;
				if(count_st>0 && count_rt>0)		// upto straight_time_count completes 60sec and right_time_count completes 30, state will be same i.e., s4
					ns=s4;
				else
				begin
					ns=s5;		// At time_count = 30sec, state changes to s2 state changes to s5
					count_yellow=10;// Before changing state yellow_time_count will be made to 10
				end
			end
		s5:	begin				//State 5
				north=8'b0110_0011;
				south=8'b0110_0110;
				east=8'b0110_0011;
				west=8'b0110_0011;
				if(count_yellow>0)		// upto yellow_time_count completes 10sec, state will be same i.e., s5
					ns=s5;
				else
				begin
					ns=s6;		// At time_count = 60sec, state changes to s5 state changes to s6
					count_st=60;	// Before changing state straight_time_count will be made to 60
				end
			end
		s6:	begin				//State 6
				north=8'b1010_0011;
				south=8'b1010_0011;
				east=8'b0110_1010;
				west=8'b0110_1010;
				if(count_st>0)		// upto straight_time_count completes 60sec, state will be same i.e., s6
					ns=s6;
				else
				begin
					ns=s7;		// At straight_time_count = 0sec, state changes to s6 state changes to s7
					count_yellow=10;// Before changing state yellow_time_count will be made to 10
				end
			end
		s7:	begin				//state 7
				north=8'b1010_0011;
				south=8'b1010_0011;
				east=8'b0110_0110;
				west=8'b0110_0110;
				if(count_yellow>0)		// upto yellow_time_count completes 10sec, state will be same i.e., s7
					ns=s7;
				else
				begin
					ns=s0;		// At time_count = 30sec, state changes to s7 state changes to s8
					count_st=60;	// Before changing state straight_time_count will be made to 60
					count_rt=30;	// Before changing state right_time_count will be made to 30
				end
			end
	endcase
end
//Assigning values to outputs
assign north_sgnl_out=north;
assign south_sgnl_out=south;
assign east_sgnl_out=east;
assign west_sgnl_out=west;
endmodule
