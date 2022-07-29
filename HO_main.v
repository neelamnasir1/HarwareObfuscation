`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:50:28 12/20/2021 
// Design Name: 
// Module Name:    HO_main 
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
module HO_main  (

	(* KEEP = "TRUE" *) input  		[127:0] 	Kin,  // Key input
   (* KEEP = "TRUE" *) input 			[127:0]  Din,  // Data input
   (* KEEP = "TRUE" *) output reg 	[127:0] 	Dout = 128'd0, // Data output
   (* KEEP = "TRUE" *) input       	   	Krdy, // Key input ready
   (* KEEP = "TRUE" *) input          		Drdy, // Data input ready
   (* KEEP = "TRUE" *) output         		Kvld, // Data output valid
	(* KEEP = "TRUE" *) output         		Dvld, // Data output valid

   (* KEEP = "TRUE" *) input          		EN,   // AES circuit enable
   (* KEEP = "TRUE" *) output         		BSY,  // Busy signal
   (* KEEP = "TRUE" *) input          		CLK,  // System clock
   (* KEEP = "TRUE" *) input          		RSTn, // Reset (Low active)
	(* KEEP = "TRUE" *) input			[63:0]	Key,	//Obfuscation Key
	(* KEEP = "TRUE" *) input 					   reseed,
	(* KEEP = "TRUE" *) input			[79:0]	newseed,
	(* KEEP = "TRUE" *) input			[79:0]	newIV,
	(* KEEP = "TRUE" *) input			[79:0]	Ukey_seed,
	(* KEEP = "TRUE" *) input			[79:0]	User_IV,
	(* KEEP = "TRUE" *) input						Key_ready_user,
	(* KEEP = "TRUE" *)	output reg				done = 1'b0,
	(* KEEP = "TRUE" *)	output reg 				Valid_Data = 1'b0
	 );
		
	parameter 	seed 		= 80'h0053A6F94C9FF24598EB; //orignal seed value of the system
	parameter 	IV			= 80'h0D74DB42A91077DE45AC; //IV
	
	(* KEEP = "TRUE" *)	reg 			[127:0] 	D;
	(* KEEP = "TRUE" *) wire			[63:0]	generator_key;//trivium
	(* KEEP = "TRUE" *) reg				[63:0]	user_key;//trivium
	(* KEEP = "TRUE" *) wire						out_valid;
	(* KEEP = "TRUE" *) reg							out_ready = 1'b0;
//							  reg						reset_GKey = 1'b1;
	(* KEEP = "TRUE" *) wire						valid_D;
	(* KEEP = "TRUE" *) wire 			[127:0] 	D_AES;
	(* KEEP = "TRUE" *) wire 			[63:0] 	Static_out;
	(* KEEP = "TRUE" *) wire 			[63:0] 	Dynamic_out;
	(* KEEP = "TRUE" *) reg							Static_EN;
	(* KEEP = "TRUE" *) wire						AES_BSY;

	

//to stop intermediate states of AES appearing on output

	always @* 
		begin
			if (Dvld)
				D <= D_AES;
		end

	always @*
		begin
			if(Key_ready_user) begin
				 out_ready <= 1;
				 Static_EN <=0;
				 end
			else begin
				out_ready <= 0;
				Static_EN <=1;
				end	
		end

	
	assign BSY = AES_BSY | ~out_valid;

// User key and dynamic key comparison

	always @ *
		begin
			if (out_valid) 
			begin

					if(Ukey_seed == newseed & IV == newIV)
						begin
							 user_key <= generator_key;
						end

					else
						begin
						 user_key <= Ukey_seed[63:0];
						end
			end
				
		end
	  	 	
	// obfuscation output valid logic
	always @* 
		begin
			if (~valid_D)	
				done <= 1'b1;
				
			 if (~RSTn | ~done ) begin
				Dout[127:0] <= 0;
			end
			
			else if (out_valid) begin
				Dout[63:0] <= Static_out;
				Dout[127:64] <=Dynamic_out;
				Valid_Data <= 1'b1;
				
			end
		end
	
	
	AES_Composite_enc En1 (
			 .Kin(Kin), 
			 .Din(Din), 
			 .Dout(D_AES), 
			 .Krdy(Krdy), 
			 .Drdy(Drdy), 
			 .Kvld(Kvld), 
			 .Dvld(Dvld), 
			
			 .EN(EN), 
			 .BSY(AES_BSY), 
			 .CLK(CLK), 
			 .RSTn(RSTn)
			 );
			 
	rng_trivium # (64,seed,IV) KGen (
		 .clk(CLK), 
		 .rst(~RSTn), 
		 .reseed(reseed), 
		 .newkey(newseed), 
		 .newiv(newIV), 
		 .out_ready(out_ready), 
		 .out_valid(out_valid), 
		 .out_data(generator_key)
		 );

	
	DynamicObfuscation D1 (
		 .DataIn(D[127:64]), 
		 .DataOut(Dynamic_out), 
		 .InputKey(user_key), 
		 .GKey(generator_key), 
		 .EN(Static_EN), 
		 .Data_valid(valid_D)
		 );
		
	StaticObfuscation C1 (
		 .DataIn(D[63:0]), 
		 .DataOut(Static_out), 
		 .InputKey(Key),
		 .EN(valid_D)
		 );
	
	
	
endmodule
