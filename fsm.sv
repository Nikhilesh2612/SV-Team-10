module fsm(input logic clk,rst,cs,io,RD,WR,ALE,output logic rd,wr);
//logic clk,rst,cs,io,RD,WR,ALE;
//logic rd,wr;

 enum logic [5:0]{t1 = 6'b000001,
                  IO = 6'b000010,
                   M = 6'b000100,
                   R = 6'b001000,
                   W = 6'b010000,
                  t4 = 6'b100000}crs,ns;

 always_ff@(posedge clk)
  begin
   if(rst)
    crs <= t1;
   else
    crs <= ns; 
  end

 always_comb
  begin
   {rd,wr} = 2'b11;
   ns = crs;
   case(crs)
    t1 : begin
          if(ALE && io)
           ns = IO;
          else if(ALE && ~io)
           ns = M;
          else
           ns = t1;
         end
    IO : begin
          if(!RD)
           ns = R;
          else if(!WR)
           ns = W;
          else
           ns = IO;
         end
     M : begin
          if(!RD)
           ns = R;
          else if(!WR)
           ns = W;
          else
           ns = M;
         end
     R : begin
          rd = 1'b0;

          ns = t4;
         end
     W : begin
          wr = 1'b0;

          ns = t4;
         end 
    t4 : ns = t1;
   endcase
  end

endmodule

