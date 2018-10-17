

// A Simple D Filp Flop
module dff (
	input clk,    // Clock
	input clk_en, // Clock Enable
	input d,  // Data in
	output reg q // Data out
	
);


	always @(posedge clk ) begin 
		if(clk_en) begin
			q <= d;
		end
	end

endmodule
