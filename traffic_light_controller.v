module traffic_light_controller 
#(
	parameter T_REDU = 4'd0,
	parameter T_REDT = 4'd3,
	parameter T_YELLOWU = 4'd3,
	parameter T_YELLOWT = 4'd0,
	parameter T_GREENU = 4'd7,
	parameter T_GREENT = 4'd2
)(
	input wire clk, reset_n, enable,
	output reg[5:0]leds_EW, leds_SN 
);
//Road A: E-W
//Road B: S-N
reg[2:0] state, next_state;
reg[3:0] count_EU, count_ET;
reg[3:0] count_WU, count_WT;
reg[3:0] count_SU, count_ST;
reg[3:0] count_NU, count_NT;

wire n1,n2,n3,n4;
wire done_rA, done_rB;
//Leds params
parameter LED_R = 3'b100;
parameter LED_Y = 3'b010;
parameter LED_G = 3'b001;

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;

always @(*) begin
	case(state)
		S0: begin	
			leds_EW = {LED_Y,LED_Y};
			leds_SN = {LED_Y,LED_Y};
			next_state = enable ? S1 : S0;
		end
		S1: begin
			//{leds_EW, leds_SN} = {2{LED_R}, 2{LED_G}};
			leds_EW = {LED_R,LED_R};
			leds_SN = {LED_G,LED_G};
			next_state = done_rB ? S2 : S1;
		end
		S2: begin
			leds_EW = {LED_R,LED_R};
			leds_SN = {LED_Y,LED_Y};
			next_state = (done_rA && done_rB) ? S3 : S2;
		end
		S3: begin
			leds_EW = {LED_G,LED_G};
			leds_SN = {LED_R,LED_R};
			next_state = done_rA ? S4 : S3;
		end
		S4: begin
			leds_EW = {LED_Y,LED_Y};
			leds_SN = {LED_R,LED_R};
			next_state = (done_rA && done_rB) ? S1 : S4;
		end
		default: begin
			leds_EW = {LED_Y,LED_Y};
			leds_SN = {LED_Y,LED_Y};
		end 
	endcase
end


always @(posedge clk, negedge reset_n) begin
	if(!reset_n) begin
		//all roads with yellow light
		state <= S0;
	end
	else if(enable) begin
		state <= next_state;
	end
	else begin
		state <= S0;
	end
end

//Counter parts
wire[3:0] ccount_EU, ccount_ET;
wire[3:0] ccount_WU, ccount_WT;
wire[3:0] ccount_SU, ccount_ST;
wire[3:0] ccount_NU, ccount_NT;

counter_decrement count_E(
	.clk(clk),.reset_n(reset_n),.enable(enable),.seg_unit(),.seg_ten(),
	.val_ten(count_ET),.val_unit(count_EU),.done(n1),
	.ccount_ten(ccount_ET),.ccount_unit(ccount_EU)
);
counter_decrement count_W(
	.clk(clk),.reset_n(reset_n),.enable(enable),.seg_unit(),.seg_ten(),
	.val_ten(count_WT),.val_unit(count_WU),.done(n2),
	.ccount_ten(ccount_WT),.ccount_unit(ccount_WU)
);
counter_decrement count_S(
	.clk(clk),.reset_n(reset_n),.enable(enable),.seg_unit(),.seg_ten(),
	.val_ten(count_ST),.val_unit(count_SU),.done(n3),
	.ccount_ten(ccount_ST),.ccount_unit(ccount_SU)
);
counter_decrement count_N(
	.clk(clk),.reset_n(reset_n),.enable(enable),.seg_unit(),.seg_ten(),
	.val_ten(count_NT),.val_unit(count_NU),.done(n4),
	.ccount_ten(ccount_NT),.ccount_unit(ccount_NU)
);

assign done_rA = ((n1 == 1) && (n2 == 1));
assign done_rB = ((n3 == 1) && (n4 == 1));

wire[3:0] n5,n6,n7,n8,n9,n10,n11,n12;
reg sel_mode;
add_tu add1(
	.sel_mode(sel_mode),
	.ten(ccount_ST),.unit(ccount_SU),
	.value_ten(T_YELLOWT),.value_unit(T_YELLOWU),
	.result_ten(n5),.result_unit(n6)
);
add_tu add2(
	.sel_mode(sel_mode),
	.ten(ccount_NT),.unit(ccount_NU),
	.value_ten(T_YELLOWT),.value_unit(T_YELLOWU),
	.result_ten(n7),.result_unit(n8)
);
add_tu add3(
	.sel_mode(sel_mode),
	.ten(ccount_ET),.unit(ccount_EU),
	.value_ten(T_YELLOWT),.value_unit(T_YELLOWU),
	.result_ten(n9),.result_unit(n10)
);
add_tu add4(
	.sel_mode(sel_mode),
	.ten(ccount_WT),.unit(ccount_WU),
	.value_ten(T_YELLOWT),.value_unit(T_YELLOWU),
	.result_ten(n11),.result_unit(n12)
);
//Determine counter value
always @(*) begin
	if(state == S1) begin
		sel_mode = 1;
		if(done_rA && done_rB) begin
			{count_ET, count_EU} = {T_YELLOWT,T_YELLOWU};
			{count_WT, count_WU} = {T_YELLOWT,T_YELLOWU};
			{count_ST, count_SU} = {T_YELLOWT,T_YELLOWU};
			{count_NT, count_NU} = {T_YELLOWT,T_YELLOWU};
		end
		else if(done_rA && !done_rB) begin
			{count_ET, count_EU} = {n5,n6};
			{count_WT, count_WU} = {n7,n8};
		end
		else if(!done_rA && done_rB) begin
			{count_ST, count_SU} = {T_YELLOWT,T_YELLOWU};
			{count_NT, count_NU} = {T_YELLOWT,T_YELLOWU};
		end
		else begin
			{count_ET, count_EU} = {T_REDT,T_REDU};
			{count_WT, count_WU} = {T_REDT,T_REDU};
			{count_ST, count_SU} = {T_GREENT,T_GREENU};
			{count_NT, count_NU} = {T_GREENT,T_GREENU};
		end
	end
	else if((state == S2) || (state == S4)) begin
		sel_mode = 0;
		if(!done_rA && done_rB) begin
			{count_ST, count_SU} = {n9,n10};
			{count_NT, count_NU} = {n11,n12};
		end
		else if(done_rA && !done_rB) begin
			{count_ET, count_EU} = {n5,n6};
			{count_WT, count_WU} = {n7,n8};
		end
		else if(done_rA && done_rB) begin
			if(state == S2) begin
				{count_ET, count_EU} = {T_GREENT,T_GREENU};
				{count_WT, count_WU} = {T_GREENT,T_GREENU};
				{count_ST, count_SU} = {T_REDT,T_REDU};
				{count_NT, count_NU} = {T_REDT,T_REDU};
			end
			else begin
				{count_ET, count_EU} = {T_REDT,T_REDU};
				{count_WT, count_WU} = {T_REDT,T_REDU};
				{count_ST, count_SU} = {T_GREENT,T_GREENU};
				{count_NT, count_NU} = {T_GREENT,T_GREENU};
			end
		end
	end
	else if(state == S3) begin
		sel_mode = 1;
		if(done_rA && done_rB) begin
			{count_ET, count_EU} = {T_YELLOWT,T_YELLOWU};
			{count_WT, count_WU} = {T_YELLOWT,T_YELLOWU};
			{count_ST, count_SU} = {T_YELLOWT,T_YELLOWU};
			{count_NT, count_NU} = {T_YELLOWT,T_YELLOWU};
		end
		else if(!done_rA && done_rB) begin
			{count_ST, count_SU} = {n9,n10};
			{count_NT, count_NU} = {n11,n12};
		end
		else if(done_rA && !done_rB) begin
			{count_ET, count_EU} = {T_YELLOWT,T_YELLOWU};
			{count_WT, count_WU} = {T_YELLOWT,T_YELLOWU};
		end
		else begin
			{count_ET, count_EU} = {T_GREENT,T_GREENU};
			{count_WT, count_WU} = {T_GREENT,T_GREENU};
			{count_ST, count_SU} = {T_REDT,T_REDU};
			{count_NT, count_NU} = {T_REDT,T_REDU};
		end
	end
	else begin
		{count_ET, count_EU} = {T_REDT,T_REDU};
		{count_WT, count_WU} = {T_REDT,T_REDU};
		{count_ST, count_SU} = {T_GREENT,T_GREENU};
		{count_NT, count_NU} = {T_GREENT,T_GREENU};
	end
end
endmodule
