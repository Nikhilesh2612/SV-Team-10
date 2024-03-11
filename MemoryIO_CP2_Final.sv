module MEM_IO1(CLK,WD,OE,Add_Reg,data,tri_buff);
  parameter Add_width=20;
  parameter Data_width=8;
  parameter Mem_Width=2**19;
  parameter IO_width=32;
  //parameter sel=0;
  input logic CLK,WD,OE;
  input logic [19:0] Add_Reg;
  inout logic [Data_width-1:0] data;
  output logic [Data_width-1:0] tri_buff;

  logic [7:0] Mem1 [2**19-1:0];
  logic [7:0] temp;

  initial
    begin
      $readmemh("Mem1.txt", Mem1);
    end
	
  always_ff@(posedge CLK)
    begin
      if(WD)
        Mem1[Add_Reg] <= data;
      else
        temp <= Mem1[Add_Reg];
    end

  assign tri_buff = OE ? temp : 'z;

 endmodule

module MEM_IO2(CLK,WD,OE,Add_Reg,data,tri_buff);
  parameter Add_width=20;
  parameter Data_width=8;
  parameter Mem_Width=2**19;
  parameter IO_width=32;
  //parameter sel=1;
  input logic CLK,WD,OE;
  input logic [19:0] Add_Reg;
  inout logic [Data_width-1:0] data;
  output logic [Data_width-1:0] tri_buff;

  logic [7:0] Mem2 [2**20-1:2**19] ;
 
  logic [7:0] temp;

  always_ff@(posedge CLK)
    begin
      if(WD)
        Mem2[Add_Reg] <= data;
      else
        temp <= Mem2[Add_Reg];
    end

  assign tri_buff = OE ? temp : 'z;

 endmodule

module MEM_IO3(CLK,WD,OE,Add_Reg,data,tri_buff);
  parameter Add_width=20;
  parameter Data_width=8;
  parameter Mem_Width=2**19;
  parameter IO_width=32;
  //parameter sel=2;
  input logic CLK,WD,OE;
  input logic [19:0] Add_Reg;
  inout logic [Data_width-1:0] data;
  output logic [Data_width-1:0] tri_buff;

  logic [7:0] IO1 [65295:65280] ;
 
  logic [7:0] temp;

  always_ff@(posedge CLK)
    begin
      if(WD)
        IO1[Add_Reg] <= data;
      else
        temp <= IO1[Add_Reg];
    end

  assign tri_buff = OE ? temp : 'z;

 endmodule

module MEM_IO4(CLK,WD,OE,Add_Reg,data,tri_buff);
  parameter Add_width=20;
  parameter Data_width=8;
  parameter Mem_Width=2**19;
  parameter IO_width=32;
  //parameter sel=3;
  input logic CLK,WD,OE;
  input logic [19:0] Add_Reg;
  inout logic [Data_width-1:0] data;
  output logic [Data_width-1:0] tri_buff;

  logic [7:0] IO2 [7424:7168] ;
 
  logic [7:0] temp;

  always_ff@(posedge CLK)
    begin
      if(WD)
        IO2[Add_Reg] <= data;
      else
        temp <= IO2[Add_Reg];
    end
  
  assign tri_buff = OE ? temp : 'z;

 endmodule





