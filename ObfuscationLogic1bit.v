`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:20:41 12/21/2021 
// Design Name: 
// Module Name:    ObfuscationLogic 
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
// This is one bit obfuscation logic 
module ObfuscationLogic1bit(
	 input Valid,
    input Invalid,
    output Out,
    input Key,
	 input GKey
    );

wire D1, D2;
wire K1;
assign K1 = ~Key;

Mux2x1 M1 (
    .Valid(Valid), 
    .Invalid(Invalid), 
    .Out(D1), 
    .Key(Key)
    );
Mux2x1 M2 (
    .Valid(Valid), 
    .Invalid(Invalid), 
    .Out(D2), 
    .Key(K1)
    );
Mux2x1 M3 (
    .Valid(D1), 
    .Invalid(D2), 
    .Out(Out), 
    .Key(GKey)
    );


endmodule
