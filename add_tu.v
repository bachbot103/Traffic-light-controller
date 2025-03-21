module add_tu(
	input reg sel_mode,
	input wire[3:0]ten, unit,
	input wire[3:0]value_ten, value_unit,
	output reg[3:0]result_ten, result_unit
);

reg[4:0] unit_temp;
reg carry;
reg[3:0]added_ten, added_unit;
reg borrow;
always @(*) begin
	if(sel_mode) begin
		//handle carry
		unit_temp = unit + value_unit; 
		carry = (unit_temp > 9) ? 1:0;
		added_unit = (unit_temp > 9) ? unit_temp - 10 :  unit_temp[3:0];
		added_ten = ten + value_ten + carry;

		//handle borrow
		borrow = (added_unit == 4'd0) ? 1:0;
		result_unit = (added_unit == 4'd0) ? 4'b1001 : added_unit - 1;
		result_ten = added_ten - borrow;
	end
	else begin
		borrow = (unit == 4'd0) ? 1:0;
		result_unit = (unit == 4'd0) ? 4'b1001 : unit - 1;
		result_ten = ten - borrow;
	end
end
endmodule