module IOM(CLK,rst,ALE,cs,RD,WR,Addr,data);
  parameter Add_width=20;
  parameter Data_width=8;
  parameter Mem_Width=2**19;
  parameter IO_width=32;
  parameter sel=0;

  input logic CLK,RD,WR,rst,ALE;
  input logic [19:0] Addr;
  input logic cs;
  inout logic [Data_width-1:0] data;
  logic [Data_width-1:0] tri_buff;


  logic OE,WD,LA;

  //wire [Data_width-1:0] Memio_data;
  wire [Data_width-1:0] temp;
  reg [19:0] Add_Reg;

  always_ff@(posedge CLK)
    begin
      if(LA)
        Add_Reg <= Addr;
      else
        Add_Reg <= Add_Reg ;
    end
  
  assign temp = WD ? data : 'z;
  //assign Memio_data = WD ? data : Memio_data ;
  assign data = OE ? tri_buff : temp;
  
  
  Control_sig FSM (CLK,rst,RD,WR,ALE,cs,OE,WD,LA);
  generate
    if(sel==0)
      MEM_IO1 Mem1_inst(CLK,WD,OE,Add_Reg,temp,tri_buff);
    else if(sel==1)
      MEM_IO2 Mem2_inst(CLK,WD,OE,Add_Reg,temp,tri_buff);
    else if(sel==2)
      MEM_IO3 IO1_inst(CLK,WD,OE,Add_Reg,temp,tri_buff);
    else if(sel==3)
      MEM_IO4 IO2_inst(CLK,WD,OE,Add_Reg,temp,tri_buff);
  endgenerate
      
  

endmodule

