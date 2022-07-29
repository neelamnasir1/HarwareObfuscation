`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:54:35 02/23/2022
// Design Name:   HO_main
// Module Name:   D:/neelam/Thesis/Development/HOProject_23-2-22/tb_main.v
// Project Name:  HOProject_23-2-22
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: HO_main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_main;

	// Inputs
	reg [127:0] Kin;
	reg [127:0] Din;
	reg Krdy;
	reg Drdy;
	reg EN;
	reg CLK;
	reg RSTn;
	reg [63:0] Key;
	reg reseed;
	reg [79:0]	newseed;
	reg [79:0]	newIV;
	reg [79:0]	Ukey_seed;
	reg [79:0]	User_IV;
	reg 			Key_ready_user;

	// Outputs
	wire [127:0] Dout;
	wire Kvld;
	wire Dvld;
	wire BSY;
	wire done;

	// Instantiate the Unit Under Test (UUT)
	HO_main 	uut (
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
		.Key(Key),
		.reseed(reseed),
		.newseed(newseed),
		.newIV(newIV),
		.Ukey_seed(Ukey_seed),
		.User_IV(User_IV),
		.Key_ready_user(Key_ready_user),
		.done(done)
	);

	
reg [3:0]A=0;

	always@(posedge CLK)begin
	A<=A+1;
	end
   SRL16E #(.INIT(16'hAAAA)) SRL16E_inst (
      .Q(Q),       // SRL data output
      .A0(A[0]),     // Select[0] input
      .A1(A[1]),     // Select[1] input
      .A2(A[2]),     // Select[2] input
      .A3(A[3]),     // Select[3] input
      .CE(CLK ),    	 // Clock enable input
      .CLK(CLK),   // Clock input
      .D(Q)        // SRL data input
   );
	
	initial begin
		CLK = 0;
	forever	CLK = #5 ~CLK;
	end


	initial begin
		// Initialize Inputs
		Kin = 0;
		Din = 0;
		Krdy = 0;
		Drdy = 0;
		EN = 1;
		RSTn = 1;
		Key = 0;
		reseed = 0;
		newseed =  80'h00000000000000000000;
		newIV =  80'h00000000000000000000;
		Ukey_seed =  80'h00000000000000000000;
		User_IV =  80'h00000000000000000000;
		Key_ready_user = 0;
	
		// Wait 100 ns for global reset to finish
		#100;
      RSTn = 0;
		
		#100;
      RSTn = 1;
		reseed = 1;
		newseed =  80'h0053A6F94C9FF24598EB;
		newIV =  80'h0D74DB42A91077DE45AC;
		#10;
		reseed = 0;
       #100;
		 
		// Add stimulus here
		
		Kin = 128'h000102030405060708090A0B0C0D0E0F;
		

		@(posedge CLK) Krdy = 1;
		//repeat (2)@(posedge CLK) Krdy = 0;
		wait (Kvld);
		Krdy = 0;
		Din = 128'h000102030405060708090A0B0C0D0E0F;
		@(posedge CLK) Drdy = 1;
		@(posedge CLK) Drdy = 0;



#100;
	Din = 128'h000102030405060708090A0B0C0D0E0F;
	wait(Dvld);


 //54 68 61 74 73 20 6D 79 real static key
 //20 4B 75 6E 67 20 46 75 Dynamic


Key_ready_user = 1;
#10;
Key_ready_user = 0;
Ukey_seed = 80'h0053A6F94C9FF24598EB; 
User_IV		= 80'h0D74DB42A91077DE45AC;
Key = 64'h5468617473206D79; 

#50;
Key_ready_user = 1;
#10;
Key_ready_user = 0;



Ukey_seed = 80'h9953A6F94C9FF24598EB; 
User_IV		= 80'h0D74DB42A91077DE45AC;
Key = 64'h204B756E67204675; 
#50;
Key_ready_user = 1;
#10;
Key_ready_user = 0;

Ukey_seed = 80'h0053A6F94C9FF24598EB; 
User_IV		= 80'h0D74DB42A91077DE45AC;
Key = 64'h5468617473206D79;
#100;
Key_ready_user = 1;
#10;
Key_ready_user = 0;
#50;

reseed = 1;
newseed =  80'h0053A6F94C9FF24598EB;
newIV =  80'h0D74DB42A91077DE45AC;
#10;
Ukey_seed = 80'h9953A6F94C9FF24598EB; 
User_IV		= 80'h0D74DB42A91077DE45AC;
Key = 64'h204B756E67204675; 
reseed = 0;
Key_ready_user = 1;
#10;
Key_ready_user = 0;
#100;

reseed = 1;
newseed =  80'h9953A6F94C9FF24598EB;
newIV =  80'h0D74DB42A91077DE45AC;
#10;
reseed = 0;
Key_ready_user = 1;
#10;
Key_ready_user = 0;
#50;


Ukey_seed = 80'h9953A7F94C0FF24598EB; 
User_IV		= 80'h0D74DB42A91077DE45AC;
Key = 64'h204B756E67204675; 
Key_ready_user = 1;
#10;
Key_ready_user = 0;
#100;

Ukey_seed = 80'h0053A7F94C0FF24598EB; 
User_IV		= 80'h0D74DB42A91077DE45AC;
Key = 64'h204B756E67204675; 
Key_ready_user = 1;
#10;
Key_ready_user = 0;
#100;

Ukey_seed = 80'h9953A6F94C9FF24598EB; 
User_IV		= 80'h0D74DB42A91077DE45AC;
Key = 64'h204B756E67204675; 
Key_ready_user = 1;
#10;
Key_ready_user = 0;
#100;

end

endmodule

