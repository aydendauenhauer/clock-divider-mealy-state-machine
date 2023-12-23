module lab9_fsm (CLK, RST, PR, CNT, Max_Val, CntEn, S);
	input CLK, RST;			// Clock and Reset
	input PR;					// Pause/Reset
	input [5:0] CNT;			// current counter value
	input [5:0] Max_Val;		// counter maximum value

	output reg CntEn;			// output, CntEn: counter enable


	output reg [1:0] S; 	// current state
	reg [1:0] S_star; 	// next state
	parameter [1:0] S_RUN=3'b00, S_PAUSED=3'b01, S_MAX=3'b10;


	// Flip-flops for state (state memory)
	always @(posedge CLK or posedge RST)
		if (RST == 1) S <= S_RUN;	// initialization (to S_RUN)
		else S <= S_star;
		
	// Next state logics 
	// input: S, PR, CNT, Max_Val
	// output: S_star
	always@(S,PR, CNT, Max_Val)
	begin
	  case(S)
		 S_RUN:
			if (PR==1)
				S_star = S_PAUSED;
			else if (CNT >= Max_Val)
            S_star = S_MAX;
			else
            S_star = S_RUN;

		 S_PAUSED:
				if (PR == 1)
					S_star = S_RUN;
				else
					S_star = S_PAUSED;

		 S_MAX:
				if (CNT >= Max_Val)
					S_star = S_MAX;
				else
					S_star = S_RUN;

		 default:
				S_star = S_RUN;
	  endcase
end


// Output logics 
// input: S, PR, CNT, Max_Val
// output: CntEn
always@(S, PR,CNT, Max_Val)
begin
	case(S)
		S_RUN:
			if (PR==1)
				CntEn = 1'b0;
			else if (CNT >= Max_Val)
            CntEn = 1'b0;
			else
            CntEn = 1'b1;

		S_PAUSED:
				if (PR == 1)
					CntEn = 1'b0;
				else
					CntEn = 1'b0;	 
		S_MAX:
				if (CNT >= Max_Val)
					CntEn = 1'b0;	
				else
					CntEn = 1'b1;	
		default:
			CntEn = 1'b0;
	endcase
end

endmodule
