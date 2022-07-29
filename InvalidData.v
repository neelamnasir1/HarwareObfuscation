`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:03:10 01/13/2022 
// Design Name: 
// Module Name:    InvalidData 
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
module InvalidData(
	input		[63:0] 	Dummy1,
	input 	[63:0]	Dummy2,
	output	[63:0]	Invalid
    );

assign Invalid[63:0] = Dummy1[63:0] ^ (Dummy2[63:0]);
//assign Invalid[63:32] = ~Dummy1[63:32] ^ (Dummy2[63:32]);


endmodule
