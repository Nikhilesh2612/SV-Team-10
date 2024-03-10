module fsm(input logic clk,rst,IOM,RD,WR,ALE,CS,output logic OE,WD,LoadAddress);
 parameter VALID = 0;
 typedef enum logic [4:0]{T1  = 5'b00001,
  	                  T2  = 5'b00010,
	                   R  = 5'b00100,
	                   W  = 5'b01000,
	                  T4  = 5'b10000}state;

 state crs,ns;

 always_ff@(posedge clk)
  begin
   if(rst)
    crs <= T1;
   else
    crs <= ns; 
end

//state transition and output logic
always_comb
begin
{OE,WD,LoadAddress} = 3'b111;
ns = crs;
unique case(crs)
T1 : begin
	  if(ALE && CS && (IOM == VALID))//ALE && ~CS
	   ns = T2;
	 end
	 
T2 : begin
          LoadAddress = 1'b1;
	  if(!RD)
	   ns = R;
	  else if(!WR)
	   ns = W;
     end
 
 R : begin
	  OE = 1'b0;
	  ns = T4;
     end
	 
 W : begin
	  WD = 1'b0;
	  ns = T4;
     end 
	 
T4 : ns = T1;
endcase
end

endmodule