module IOM(Intel8088Pins.Peripheral i, 
           input logic CS,
		   input logic [19:0] Addr,
		   inout logic [7:0] data);
  parameter Mem_Width=2**19;

  //input logic CLK,RD,WR,RESET,ALE;
  //input logic [19:0] Addr;
  //input logic CS;
  //inout logic [7:0] data;

  logic OE,WD,LA;
  logic [$clog2(Mem_Width)-1:0] Add_Reg;//Add Reg
  logic [7:0] Mem [Mem_Width-1:0]; //Memory Array

  enum logic [5:0]{T1 = 6'b000001,
                   T2 = 6'b000010,
                   R  = 6'b000100,
                   W  = 6'b001000,
                   T4 = 6'b010000}crs,ns;
  initial
    begin
      $readmemh("Mem1.txt", Mem);
    end
  
  always_ff@(posedge i.CLK)
    begin
      if(i.RESET)
        crs <= T1;
      else
        crs <= ns; 
    end

  always_ff@(posedge i.CLK)
    begin
     if(LA)
       Add_Reg <= Addr;
      else
        Add_Reg <= Add_Reg ;
    end
  
  //Memory Write
  always_ff@(posedge i.CLK)
    begin
      if(WD)
        Mem[Add_Reg] <= data;
    end
  //Memory Read
  assign data = OE ? Mem[Add_Reg]: 'z;
  
  //state transition and output logic
  always_comb
    begin
      {OE,WD,LA} = 3'b000;
      ns = crs;
      unique case(crs)
        T1 : begin
          if(i.ALE && CS)
            ns = T2;
        end

        T2 : begin
          if(!i.RD)
            ns = R;
          else if(!i.WR)
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



