module counter_decrement
(
	input wire clk, reset_n, enable,
	input wire[3:0] val_ten, val_unit,
	output wire done,
	output reg[3:0] ccount_unit, ccount_ten,
	output wire [6:0] seg_unit, seg_ten
);

//reg[3:0] count_unit, count_ten;

led7thanh_anode unit(.bcd(ccount_unit),.seg(seg_unit));
led7thanh_anode ten (.bcd(ccount_ten),.seg(seg_ten));
always @(posedge clk, negedge reset_n) begin
	if(!reset_n && !enable) begin
		ccount_unit <= 10;
		ccount_ten <= 10;
	end
	else if(enable) begin
		if(done || (ccount_unit == 10)) begin
			ccount_unit <= val_unit;
			ccount_ten <= val_ten;
		end
		else begin
			if(ccount_unit == 4'd0) begin
				ccount_unit <= 4'd9;
				ccount_ten <= ccount_ten - 1;
			end
			else begin
				ccount_unit <= ccount_unit - 1;
				ccount_ten <= ccount_ten;
			end	
		end
	end
end

assign done = (ccount_ten == 4'd0 && ccount_unit == 4'd1);
endmodule
