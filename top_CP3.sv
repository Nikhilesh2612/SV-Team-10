module top;

  logic CLK = '0;
  logic RESET = '0;
  Intel8088Pins Pins(CLK,RESET);

  logic cs1,cs2,cs3,cs4;
  logic [19:0] Address;
  wire [7:0]  Data;
  
  assign cs1 =  (~Pins.IOM && ~Address[19]);
  assign cs2 =   (~Pins.IOM && Address[19]) ;
  assign cs3 = (Pins.IOM && (&{(Address[15:8]),(~(Address[7:4]))}));
  assign cs4 = (Pins.IOM && (&{(~(Address[15:13])),Address[12:10],~Address[9]} ));

  Intel8088 P(.i(Pins.Processor));
  IOM #(2**19) Mem1(Pins.Peripheral,cs1,Address,Data);
  IOM #(2**19) Mem2(Pins.Peripheral,cs2,Address,Data);
  IOM #(2**4) IO1(Pins.Peripheral,cs3,Address,Data);
  IOM #(2**9) IO2(Pins.Peripheral,cs4,Address,Data);

  // 8282 Latch to latch bus address
  always_latch
    begin
      if (Pins.ALE)
        Address <= {Pins.A, Pins.AD};
    end

  // 8286 transceiver
  assign Data =  (Pins.DTR & ~Pins.DEN) ? Pins.AD   : 'z;
  assign Pins.AD   = (~Pins.DTR & ~Pins.DEN) ? Data : 'z;

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

interface Intel8088Pins(input logic CLK,RESET);
  
  logic MNMX='1;
  logic TEST='1;
  logic READY='1;
  logic NMI='0;
  logic INTR='0;
  logic HOLD='0;
  logic HLDA;
  tri [7:0] AD;
  tri [19:8] A;
  logic IOM;
  logic WR;
  logic RD;
  logic SSO;
  logic INTA;
  logic ALE;
  logic DTR;
  logic DEN;
  
  modport Processor(inout AD,
                    output A,HLDA,IOM,WR,RD,SSO,INTA,ALE,DTR,DEN,
                    input CLK,HOLD,READY,RESET,NMI,INTR,MNMX,TEST);
  
  modport Peripheral(input CLK,RESET,ALE,RD,WR);
  
endinterface
                      
  
  
                     
                     

