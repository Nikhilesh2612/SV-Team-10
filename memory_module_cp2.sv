module hehe(data,Address,IOM,clk,rst,RD,WR,ALE,CS);
 parameter chip_select=0;
 inout [7:0] data;
 input logic IOM;
 wire [7:0]data;
 input logic [19:0]Address;
 logic [7:0]mem1[2**19-1:0];
 logic [7:0]mem2[2**20-1:2**19];
 logic [7:0]io1[65295:65280];
 logic [7:0]io2[7424:7168];
 logic [19:0]Address_reg;
 input logic clk,rst,RD,WR,ALE,CS;
 logic OE,WD,LoadAddress;
//tri-state buffer
 logic [7:0]i,o;

fsm d1(clk,rst,,RD,WR,ALE,CS,OE,WD,LoadAddress);

assign data = (~OE) ? i : 'bz;

always_comb
 begin
  if(LoadAddress)
   Address_reg = Address;
  else
   Address_reg = 'bz;
 end
 /*
always_comb
 begin
  if(~WD)
    mem[Address_reg] = data;
  else if(WD)
    i = mem[Address_reg];
  else if(~OE)
    i = data;
 end 
*/

always_comb
 begin
  if(chip_select == 0)
   begin
    if(~WD)
     mem1[Address_reg] = data;
    else if(WD)
     i = mem1[Address_reg];
    else if(~OE)
     i = data;
   end
  else if(chip_select == 1)
   begin
    if(~WD)
     mem2[Address_reg] = data;
    else if(WD)
     i = mem2[Address_reg];
    else if(~OE)
     i = data;
   end
  else if(chip_select == 2)
   begin
    if(~WD)
     io1[Address_reg] = data;
    else if(WD)
     i = io1[Address_reg];
    else if(~OE)
     i = data;
   end
  else if(chip_select == 3)
   begin
    if(~WD)
     io2[Address_reg] = data;
    else if(WD)
     i = io2[Address_reg];
    else if(~OE)
     i = data;
   end
 end
endmodule
