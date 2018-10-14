

// AddressLatch,
module addressLatch (
	input clk,    // Clock
	input clk_en, // Clock Enable
	input [7:0]d,  // Data in
	output [7:0]q, // Data out
	
);

	always @(posedge clk ) begin :
		if(clk_en) begin
			q[7:0] <= d[7:0];
		end
	end
endmodule