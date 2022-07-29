`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:21:25 12/26/2021 
// Design Name: 
// Module Name:    StaticObfuscation 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module StaticObfuscation(
    input [63:0] DataIn,
    output reg [63:0] DataOut,
    input [63:0] InputKey,
	 input EN
	     );

//static obfuscation key is set to 54 68 61 74 73 20 6D 79  


parameter BitNo = 64;
wire [63:0] SKey = 64'h5468617473206D79;

	generate
	genvar i;

		for (i = 0; i< BitNo; i = i+1) 
			begin: gen1
				 always @*
				 begin
				 if(EN)begin
					 if(SKey[i])
						DataOut[i] = InputKey[i] ~^ DataIn[i];
					 else
						DataOut[i] = InputKey[i]  ^ DataIn[i];
				 end
				 end

			end
		endgenerate

endmodule
