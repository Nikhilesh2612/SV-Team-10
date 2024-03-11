module Control_sig(input logic clk,rst,RD,WR,ALE,CS,output logic OE,WD,LA); 

  enum logic [5:0]{T1 = 6'b000001,
                   T2 = 6'b000010,
                   R  = 6'b000100,
                   W  = 6'b001000,
                   T4 = 6'b010000}crs,ns;

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
      {OE,WD,LA} = 3'b000;
      ns = crs;
      case(crs)
        T1 : begin
          if(ALE && CS)
            ns = T2;
        end

        T2 : begin
          if(!RD)
            ns = R;
          else if(!WR)
            ns = W;
          LA=1;
        end

        R : begin
          OE = 1'b1;
          ns = T4;
        end

        W : begin
          WD = 1'b1;
          ns = T4;
        end 

        T4 : ns = T1;
      endcase
    end

endmodule
