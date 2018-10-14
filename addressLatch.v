

// AddressLatch,
module addressLatch (
	input clk,    // Clock
	input clk_en, // Clock Enable
	input [7:0] d,  // Data in
	output reg [7:0] q // Data out

);

	always @(posedge clk ) begin
		if(clk_en) begin
			q <= d;
		end
	end
endmodule
