`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:54:22 03/15/2022 
// Design Name: 
// Module Name:    HO_Wrapper 
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
module HO_Wrapper(
	input		System_Enable,
   input    CLK,  // System clock
   input    RSTn, // Reset (Low active)
	input		RxD,
	output	TxD,	
	output	reg	done = 1'b0
    );


//AES I/O
	(* KEEP = "TRUE" *)	reg  			[127:0] 	Kin = 128'd0;  // AES Key input
   (* KEEP = "TRUE" *)	reg 			[127:0]  Din = 128'd0;  // AES Data input
   (* KEEP = "TRUE" *)	wire 	 		[127:0] 	Dout; // AES Data output
   (* KEEP = "TRUE" *)	reg      	 	   	Krdy = 1'b0; // AES Key input ready
   (* KEEP = "TRUE" *)	reg      	  	  		Drdy = 1'b0; // AES Data input ready
   (* KEEP = "TRUE" *)	wire         			Kvld; // AES Data output valid
	(* KEEP = "TRUE" *)	wire         			Dvld; // AES Data output valid
	(* KEEP = "TRUE" *)	reg	          		EN = 1'b0;   // AES circuit enable
   (* KEEP = "TRUE" *)	wire	         		BSY;  // AES Busy signal 


//Obfuscation I/O

	(* KEEP = "TRUE" *)	reg			[63:0]	S_Key = 64'd0;	//static Obfuscation Key
	(* KEEP = "TRUE" *)	reg						reseed = 1'b0; // key generator 
	(* KEEP = "TRUE" *)	reg			[79:0]	newseed = 80'h0053A6F94C9FF24598EB; // key generator 
	(* KEEP = "TRUE" *)	reg			[79:0]	newIV = 80'h0D74DB42A91077DE45AC;	// key generator 
	(* KEEP = "TRUE" *)	reg			[79:0]	Ukey_seed = 80'd0; // key generator 
	(* KEEP = "TRUE" *)	reg			[79:0]	User_IV = 80'd0;	// key generator 
	(* KEEP = "TRUE" *)	reg						Key_ready_user = 1'b0; // key generator 
	(* KEEP = "TRUE" *)  wire 						out_valid;
	(* KEEP = "TRUE" *)  wire 						temp;
	(* KEEP = "TRUE" *)	reg						transmit = 1'b0;
	



//UART Reciever

	(* KEEP = "TRUE" *) wire RxD_data_ready;
	(* KEEP = "TRUE" *) wire [7:0] RxD_data;

//UART Transmitter
	(* KEEP = "TRUE" *) reg [7:0] 	TxD_data = 8'd0;
	(* KEEP = "TRUE" *) reg 			TxD_start = 1'b0;
	(* KEEP = "TRUE" *) wire 			TxD_busy;
   (* KEEP = "TRUE" *) reg [127:0] 	Dout_transmit; // Obfuscated output to be transmitted

	(* KEEP = "TRUE" *) reg [4:0]   count = 5'd0;
	(* KEEP = "TRUE" *) reg [3:0]   State = 8'd0;
	
	parameter st0 = 5'd0, st1 = 5'd1, st2 = 5'd2, st3 = 5'd3, st4 = 5'd4, st5 = 5'd5, st6 = 5'd6, st7 = 5'd7, st8 = 5'd8, st9 = 5'd9, st10 = 5'd10, st11 = 5'd11, st12 = 5'd12, st13 = 5'd13, st14 = 5'd14, st15 = 5'd15, st16 = 5'd16;
	
//FSM


	always @(posedge CLK)
	begin
		if(~RSTn)
			begin
			
				Kin <= 128'd0;  
				Din <= 128'd0;  
				Krdy <= 1'b0; 
				Drdy <= 1'b0; 
				EN <= 1'b0;
				
				S_Key <= 64'd0;
				reseed <= 1'b0;
				newseed <= 80'd0;
				newIV <= 80'd0;	
				Ukey_seed <= 80'd0; 
				User_IV <= 80'd0;
				Key_ready_user <= 1'b0; 
				
				count <= 5'd0;				
				done <= 1'b0;
			
			end



			
		else
			begin
			
				case (State)
					
					default: State <= st0;
					
					st0: begin //input AES Kin
					
						if (count == 16)
							begin
								count <= 0;
//								Krdy <= 1'b1; // AES key ready
								State <= st1;
//								done <= 1'b1;
							end		
						
						else if (System_Enable && RxD_data_ready && (count < 16))
							begin			
								
								Kin 	<= {Kin[119:0], RxD_data};
								count <= count +1'b1;
								State <= st0;
//								EN <= 1'b1;
							end
							
							else
								State <= st0;

					end
				
					
					st1: begin //input AES Din
					
						if (count == 16)
							begin
								count <= 0;
								State <= st2;
//								Drdy <= 1'b1;
							end		
						
						else if (System_Enable && RxD_data_ready && count < 16)
							begin			
								
								Din <= {Din[119:0], RxD_data};
								count <= count +1'b1;
								State <= st1;
//								Krdy <= 1'b0;
								
							end
							
							else
								State <= st1;
					
					end
					
					
					st2: begin //input Static  Obfuscation Key
					
						if (count == 8)
							begin
								count <= 0;
								State <= st3;
							end		
						
						else if (System_Enable && RxD_data_ready && count < 8)
							begin			
								
								S_Key <= {S_Key[55:0], RxD_data};
								count <= count +1'b1;
								State <= st2;
	//							Drdy <= 1'b0;
							end
							
							else
								State <= st2;
					
					end
					
					
					st3: begin //input User seed
					
						if (count == 10)
							begin
								count <= 0;
								State <= st4;
							end		
						
						else if (System_Enable && RxD_data_ready && count < 10)
							begin			
								
								Ukey_seed <= {Ukey_seed[71:0], RxD_data};
								count <= count +1'b1;
								State <= st3;
							end
							
							else
								State <= st3;
					
					end
					
					
					
					st4: begin //input User IV
					
						if (count == 10)
							begin
								count <= 0;					
								State <= st5;
							end		
						
						else if (System_Enable && RxD_data_ready && count < 10)
							begin			
								
								User_IV  <= {User_IV [71:0], RxD_data};
								count <= count +1'b1;
								State <= st4;
							end
							
							else
								State <= st4;
					
					end
				


					st5: begin //input New Seed
					
						if (count == 10)
							begin
								count <= 0;
								State <= st6;
							end		
						
						else if (System_Enable && RxD_data_ready && count < 10)
							begin			
								
								newseed <= {newseed[71:0], RxD_data};
								count <= count +1'b1;
								State <= st5;
							end
							
							else
								State <= st5;
					
					end
					
					
					st6: begin ////input New IV
					
						if (count == 10)
							begin
								count <= 0;
								State <= st11;
//								reseed <= 1'b1;
								done <= 1'b1;
								EN <= 1'b1;
								
								
							end		
						
						else if (System_Enable && RxD_data_ready && count < 10)
							begin			
								
								newIV <= {newIV[71:0], RxD_data};
								count <= count +1'b1;
								State <= st6;
							end
							
							else
								State <= st6;	
					end

///////////////////////////////////
				st11: begin
					
					if(EN)
						begin
							Krdy <= 1'b1;
							State <= st12;
						end
						
					else
						State <= st11;
				
				end
				
				st12: begin
					
					if(Kvld)
						begin
							Krdy <= 1'b0;
							State <= st13;
						end
						
					else
						State <= st12;
				
				end
				
				st13: begin
							reseed <= 1'b1;
							Drdy <= 1'b1;
							State <= st14;
				end
				
				st14: begin
				
						Drdy <= 1'b0;
						reseed <= 1'b0;
						if (Dvld)
							begin
								
								Key_ready_user <= 1'b1;
								State <= st15;
							end
						else
								State <= st14;
						
				end
				
				st15: begin
					
					Key_ready_user <= 1'b0;	
					//State <= st7;
					
					
					if (out_valid)
						begin
							transmit <= 1'b1;
							State <= st7;
							Dout_transmit <= Dout;
							
						end
					
					else
						State <= st15;

				end
				

///////////////////////////////////////////////
					
					st7: begin

					
					//Key_ready_user <= 1'b0;	
						if(count == 16)
						begin
							count <= 0;
							State <= st10;
							TxD_start <= 1'b0;

						end
						else if (!TxD_busy && transmit)
							begin
								
								TxD_start <= 1'b1;
								TxD_data <= Dout_transmit[127:120];
								Dout_transmit <= {Dout_transmit[119:0],Dout_transmit[127:120]};
								State <= st8;
							end		
							
						else 
							begin
								State <= st7;
							end
						
					end
					
					st8: begin
					
						if(TxD_busy)
						begin
							TxD_start <= 1'b0;
							State <= st9;
						end
						
						else
							State <= st8;
							
					end

					st9: begin

					if(count == 16)
						begin
							count <= 0;
							State <= st10;

						end
					
					else if(count < 16)
						begin							
							count <= count +1'b1;
							State <= st7;
						end
							
						else
							State <= st9;

					end
					
					
					
					st10: begin
							done <= 1'b1;							
					end
				


				endcase
			end // else block ends
	end // always block ends 




//HO Module
	async_receiver R1 (
		 .clk(CLK), 
		 .RxD(RxD), 
		 .RxD_data_ready(RxD_data_ready), 
		 .RxD_data(RxD_data), 
		 .RxD_idle(), 
		 .RxD_endofpacket()
		 );
	 
	 
	HO_main HWOB(
		 .Kin(Kin), 
		 .Din(Din), 
		 .Dout(Dout), 
		 .Krdy(Krdy), 
		 .Drdy(Drdy), 
		 .Kvld(Kvld), 
		 .Dvld(Dvld), 
		 .EN(EN), 
		 .BSY(BSY), 
		 .CLK(CLK), 
		 .RSTn(RSTn), 
		 .Key(S_Key), 
		 .reseed(reseed), 
		 .newseed(newseed), 
		 .newIV(newIV), 
		 .Ukey_seed(Ukey_seed), 
		 .User_IV(User_IV), 
		 .Key_ready_user(Key_ready_user),
		 .done(temp),
		 .Valid_Data(out_valid)
		 );

	async_transmitter T1 (
    .clk(CLK), 
    .TxD_start(TxD_start), 
    .TxD_data(TxD_data), 
    .TxD(TxD), 
    .TxD_busy(TxD_busy)
    );


endmodule
