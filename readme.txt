				---------------------------- FOUR WAY TRAFFIC SIGNAL LIGHTS -----------------------------------------

 * Four way traffic signaling is the implementation of traffic lights to cross a intersection point by reducing collisions between vehicles while entering into different directions via junction.
 
 * A four way junction has vehicles coming from 4 direction. So, consider those directions as
	- NORTH
	- SOUTH
	- EAST
	- WEST
  
 * In everydirection, inorder to instruct vehicles, different coloured signals are entertained and those signal colours are
     	- RED - STOP
     	- GREEN - GO
     	- YELLOW - SLOW DOWN FOR STOP
  
 * In this model inorder to enchance the clarity and understanding of signals
    	-  signals are specified with direction and direction which they intented to go

 * Therefore, signals in each direction are 8, which includes
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

 * Other than left_green all other signals have to be controlled.
 * Controlling signals can be achieved through "FINATE STATE MACHINE".
 *
 * 						<---------------- STATES & DESCRIPTION ----------------------->
   - STATE 0: s0: Allow north direction vehicles straight & right for 30sec
		As vehicles move from north -> south & north -> west, East side pedistrian signal can be activated
		therefore, signals 	north_straight_green=1, 	north_right_green=1,		east_pedistrian_green=1,
					south_straight_red=1,		south_right_red=1,		east_straight_red=1,
					east_right_red=1,		west_staright_red=1,		west_right_red=1,
					north_pedistrian_red=1,		south_pedistrian_red=1,		west_pedistrian_red=1
		Remaining all signals are to be deasserted i.e., 0
   	Done with allowing north_straight for 30sec and north_right for 30sec

   - STATE 1: s1: Allow north direction straight & west direction right for 30sec
		As vehicles move from north -> south & west -> south, East side pedistrian signal can be activated
		therefore, signals 	north_straight_green=1, 	west_right_green=1,		east_pedistrian_green=1,
					north_right_red=1,		south_straight_red=1,		south_right_red=1,
					east_straight_red=1,		east_right_red=1,		west_staright_red=1,
					north_pedistrian_red=1,		south_pedistrian_red=1,		west_pedistrian_red=1
		Remaining all signals are to be deasserted i.e., 0
	Done with allowing north_straight for 60sec; north_right & west_right for 30sec

   - STATE 2: s2: Activate north_yellow signal for 10sec
		Vehicles moving from north -> south has to slowdown since red is going to be asserted
		therefore, signals	north_yellow=1,			north_right_red=1,		south_straight_red=1,
					south_right_red=1,		east_straight_red=1		east_right_red=1,
					west_straight_red=1,		west_right_red=1		north_pedistrian_red=1,
					west_pedistrian_red=1,		east_pedistrian_red=1,		west_pedistrian_red=1	
		Remaining all signals are to be deasserted i.e., 0
	Done with allowing north_straight for 60sec; north_right & west_right for 30sec; north_yellow for 10sec

   - STATE 3: s3: Allow south direction vehicles straight & right for 30sec
		As vehicles move from south -> north & south -> east, West side pedistrian signal can be activated
		therefore, signals 	south_straight_green=1, 	south_right_green=1,		west_pedistrian_green=1,
					north_straight_red=1,		north_right_red=1,		east_straight_red=1,
					east_right_red=1,		west_staright_red=1,		east_right_red=1,
					north_pedistrian_red=1,		south_pedistrian_red=1,		east_pedistrian_red=1
		Remaining all signals are to be deasserted i.e., 0
	Done with allowing north_straight for 60sec; south_straight, south_right, north_right, west_right for 30sec
   
   - STATE 4: s4: Allow south direction straight & east direction right for 30sec
		As vehicles move from south -> north & east -> north, West side pedistrian signal can be activated
		therefore, signals 	south_straight_green=1, 	east_right_green=1,		west_pedistrian_green=1,
					south_right_red=1,		north_straight_red=1,		north_right_red=1,
					west_straight_red=1,		west_right_red=1,		east_staright_red=1,
					north_pedistrian_red=1,		south_pedistrian_red=1,		east_pedistrian_red=1
		Remaining all signals are to be deasserted i.e., 0
	Done with allowing north_straight south_straight for 60sec; north_right,south_right & west_right for 30sec

   - STATE 5: s5: Activate south_yellow signal for 10sec
		Vehicles moving from south -> north has to slowdown since red is going to be asserted
		therefore, signals	south_yellow=1,			south_right_red=1,		north_straight_red=1,
					north_right_red=1,		east_straight_red=1		east_right_red=1,
					west_straight_red=1,		west_right_red=1		north_pedistrian_red=1,
					west_pedistrian_red=1,		east_pedistrian_red=1,		west_pedistrian_red=1	
		Remaining all signals are to be deasserted i.e., 0
	Done with allowing north_straight, south_straight for 60sec; north_right, south_right, east_right & west_right for 30sec; north & south_yellow for 10sec

   - STATE 6: s6: Allow east & west direction straight for 60sec
		As vehicles moving from east to west and viceversa, North & south side pedistrian signals can be activated
		therefore, signals	east_straight_green=1,		west_straight_green=1,		east_right_red=1,
					west_right_red=1,		north_straight_red=1,		north_right_red=1,
					south_straight_red=1,		south_right_red=1,		north_pedistrian_green=1,
					south_pedistrian_green=1,	east_pedistrian_red=1,		west_pedistrian_red=1
		Remaining all signals are to be deasserted i.e., 0
	Done with allowing all directions straight for 60sec; right for 30 sec; north_yellow, south_yellow for 10sec;  pedistrians for 60sec

   - STATE 7: s7: Activate east_yellow & west_yellow for 10sec
		Vehicles moving from east to west and vice versa has to slowdown since red is going to be asserted
		therefore, signals	east_yellow=1,			west_yellow=1,			north_straight_red=1,
					north_right_red=1,		south_straight_red=1		south_right_red=1,
					east_right_red=1,		west_right_red=1		north_pedistrian_red=1,
					west_pedistrian_red=1,		east_pedistrian_red=1,		west_pedistrian_red=1	
		Remaining all signals are to be deasserted i.e., 0
	Done with alowing all directions straight for 60sec, right for 30sec, yellow for 10sec & pedistrians for 60sec

<-------------------- STATES & DESCRIPTION -------------------------->
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

