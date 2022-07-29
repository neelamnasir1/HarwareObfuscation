`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:28:53 12/21/2021 
// Design Name: 
// Module Name:    Mux2x1 
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
module Mux2x1(
    input Valid,
    input Invalid,
    output Out,
    input Key
    );


assign Out = Key ? Valid : Invalid;

endmodule
