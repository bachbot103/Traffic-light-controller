module led7thanh_anode(
	input wire[3:0] bcd,
	output reg[6:0] seg
);

always @(bcd) 
begin
	case(bcd)
		4'd0: seg = 7'b000_0001;
		4'd1: seg = 7'b100_1111;
		4'd2: seg = 7'b001_0010;
		4'd3: seg = 7'b000_0110;
		4'd4: seg = 7'b100_1100;
		4'd5: seg = 7'b010_0100;
		4'd6: seg = 7'b010_0000;
		4'd7: seg = 7'b000_1111;
		4'd8: seg = 7'b000_0000;
		4'd9: seg = 7'b000_0100;
		default: seg = 7'b111_1111;
	endcase
end
endmodule
