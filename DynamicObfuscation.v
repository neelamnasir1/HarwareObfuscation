`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:36:51 01/13/2022 
// Design Name: 
// Module Name:    DynamicObfuscation 
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
module DynamicObfuscation(
 (* KEEP = "TRUE" *)    input 	[63:0] DataIn,
 (* KEEP = "TRUE" *)   	output reg	[63:0] DataOut,
 (* KEEP = "TRUE" *)  	input 	[63:0] InputKey,
 (* KEEP = "TRUE" *)	 	input 	[63:0] GKey,
 (* KEEP = "TRUE" *)	 	input 			 EN,
 (* KEEP = "TRUE" *) 	output	reg	 Data_valid
	 );

	parameter BitNo = 64;
	wire [63:0] Invalid;
	wire [63:0] out_data;
	InvalidData iData (
    .Dummy1(DataIn), 
    .Dummy2(GKey), 
    .Invalid(Invalid)
    );
		
	generate
	genvar i;

	for (i = 0; i< BitNo; i = i+1) 
		begin: gen1
			
					ObfuscationLogic1bit b0 (
						 .Valid		(DataIn	[i]), 
						 .Invalid	(Invalid	[i]), 
						 .Out			(out_data[i]), 
						 .Key			(InputKey[i]), 
						 .GKey		(GKey		[i])
						 );	
						 
		always @* begin
			if (EN==1) begin
			DataOut <= out_data;
			Data_valid <=1;
			
			end
			else begin
			//DataOut <= 0;
			Data_valid <=0;
			end
				
		end
					 
		end
		
	endgenerate

endmodule
