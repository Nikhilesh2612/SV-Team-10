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

logic rd,wr;

logic SSO;
logic INTA;
logic ALE;
logic DTR;
logic DEN;


logic [19:0] Address;
wire [7:0]  Data;
logic css;
assign css = IOM ? Address[16] : Address[19] ;
logic [3:0] cs;

always_comb
 begin
  unique case({IOM,css})
   2'b00 : cs[0] = 1'b1; 
   2'b01 : cs[1] = 1'b1;  
   2'b10 : cs[2] = 1'b1;  
   2'b11 : cs[3] = 1'b1;  
  endcase
 end

Intel8088 P(CLK, MNMX, TEST, RESET, READY, NMI, INTR, HOLD, AD, A, HLDA, IOM, WR, RD, SSO, INTA, ALE, DTR, DEN);

  hehe #(0) gnb1(Data,Address,IOM,CLK,RESET,RD,WR,ALE,cs[0]);
  hehe #(1) gnb2(Data,Address,IOM,CLK,RESET,RD,WR,ALE,cs[1]);
  hehe #(2) gnb3(Data,Address,IOM,CLK,RESET,RD,WR,ALE,cs[2]);
  hehe #(3) gnb4(Data,Address,IOM,CLK,RESET,RD,WR,ALE,cs[3]);

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

repeat(500) @(posedge CLK);
$finish();
end

endmodule
