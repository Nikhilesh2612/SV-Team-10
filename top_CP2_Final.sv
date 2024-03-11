module top;

  bit CLK = '0;
  bit MNMX = '1;
  bit TEST = '1;
  bit RESET = '0;
  bit READY = '1;
  bit NMI = '0;
  bit INTR = '0;
  bit HOLD = '0;

  wire logic [7:0] AD;
  logic [19:8] A;
  logic HLDA;
  logic IOM;
  logic WR;
  logic RD;
  logic SSO;
  logic INTA;
  logic ALE;
  logic DTR;
  logic DEN;
  logic OE,WD;
  logic cs1,cs2,cs3,cs4;
  logic [19:0] Address;
  logic t1,t2;
  wire [7:0]  Data;
  
  assign cs1 = (~IOM & ~Address[19]);
  assign cs2 = (~IOM & Address[19]);
  assign t1 =  (&{(Address[15:8]),(~(Address[7:4]))}) ;
  assign t2 = (&{(~(Address[15:13])),Address[12:10],~Address[9]} );
  assign cs3 = (IOM & t1);
  assign cs4 = (IOM & t2);

  Intel8088 P(CLK, MNMX, TEST, RESET, READY, NMI, INTR, HOLD, AD, A, HLDA, IOM, WR, RD, SSO, INTA, ALE, DTR, DEN);
  IOM #(.sel(0)) Mem1(CLK,RESET,ALE,cs1,RD,WR,Address,Data);
  IOM #(.sel(1)) Mem2(CLK,RESET,ALE,cs2,RD,WR,Address,Data);
  IOM #(.sel(2)) IO1(CLK,RESET,ALE,cs3,RD,WR,Address,Data);
  IOM #(.sel(3)) IO2(CLK,RESET,ALE,cs4,RD,WR,Address,Data);

  // 8282 Latch to latch bus address
  always_latch
    begin
      if (ALE)
        Address <= {A, AD};
    end

  // 8286 transceiver
  assign Data =  (DTR & ~DEN) ? AD   : 'z;
  assign AD   = (~DTR & ~DEN) ? Data : 'z;


  always #50 CLK = ~CLK;

  initial
    begin
      $dumpfile("dump.vcd"); $dumpvars;

      repeat (2) @(posedge CLK);
      RESET = '1;
      repeat (5) @(posedge CLK);
      RESET = '0;

      repeat(10000) @(posedge CLK);
      $finish();
    end

endmodule
