// RS (SR) Flip Flop (Flip Flip)

// https://www.tutorialspoint.com/compilers/online-verilog-compiler.htm
// https://coderpad.io/languages/verilog/

// https://en.wikipedia.org/wiki/Verilog

// https://electronics.stackexchange.com/questions/710735/modeling-flip-flops-rs-t-jk-in-verilog
// https://circuitfever.com/sr-flip-flop-in-verilog
// https://circuitcove.com/design-examples-flip-flops/
// https://technobyte.org/sr-flip-flop-verilog-gate-dataflow-behavioral/
// https://gist.github.com/Shashi18/97b037f56aa9585e469e2c1b1b0996be
// https://en.wikipedia.org/wiki/Flip-flop_(electronics)

module Four_bits_Up_Counter(input CLK, R, output [3:0] Q);
    wire d0;
    wire t1; 
    wire j2, k2;
    wire r3, s3;

    RS_FF RS3 (.R(r3), .S(s3), .CLK(CLK), .Q(Q[3]));

    assign d0 = (~R) & (~Q[0]); 
    assign t1 = (R & Q[1]) | (~R & Q[0]);
    assign j2 = (~R & Q[1] & Q[0]);
    assign k2 = (R | (Q[1] & Q[0]));
    assign r3 = R | (Q[3] & Q[2] & Q[1] & Q[0]);    
    assign s3 = (~R & Q[2] & Q[1] & Q[0]);
endmodule

module RS_FF(input CLK, R, S, output reg Q);
    initial Q = 1'b0;
    always @ (posedge CLK)
    begin
        if (~R && S)
            Q <= 1'b1;
        else if (R && ~S)
            Q <= 1'b0;
        if (R && S)
            Q <= 1'b0;
    end
endmodule

module clock_gen ( input enable, output reg clk);
  parameter integer FREQ = 100000; // Frequency in kHz
  parameter integer PHASE = 0;
  parameter integer DUTY = 50;

  real clk_pd, clk_on, clk_off, quarter, start_dly;

  reg start_clk;

  initial begin
    clk_pd    = 1.0 / (FREQ * 1e3) * 1e9; // Clock period in ns
    clk_on    = DUTY / 100.0 * clk_pd;
    clk_off   = (100.0 - DUTY) / 100.0 * clk_pd;
    quarter   = clk_pd / 4;
    start_dly = quarter * PHASE / 90;

    $display("FREQ      = %0d kHz", FREQ);
    $display("PHASE     = %0d deg", PHASE);
    $display("DUTY      = %0d %%",  DUTY);
    $display("PERIOD    = %0.3f ns", clk_pd);    
    $display("CLK_ON    = %0.3f ns", clk_on);
    $display("CLK_OFF   = %0.3f ns", clk_off);
    $display("QUARTER   = %0.3f ns", quarter);
    $display("START_DLY = %0.3f ns", start_dly);
  end

  initial begin
    clk = 0;
    start_clk = 0;
  end

  always @ (posedge enable or negedge enable) begin
    if (enable) begin
      #(start_dly) start_clk = 1;
    end else begin
      #(start_dly) start_clk = 0;
    end      
  end

  always @ (posedge start_clk) begin
    if (start_clk) begin
        clk = 1;
      
        while (start_clk) begin
            #(clk_on)  clk = 0;
            #(clk_off) clk = 1;
        end

        clk = 0;
    end
  end 
endmodule

`timescale 1ns / 1ps
module Four_bits_Up_Counter_TB();
  reg RESET;
  wire [3:0] Q;
  reg en;
  wire CLK;

  clock_gen clk(.enable(en), .clk(CLK));
  Four_bits_Up_Counter TB(.CLK(CLK), .R(RESET), .Q(Q));

  initial
  begin
    en = 1;
    RESET = 0;  
    #20;
    RESET = 1;
    #10;
    RESET = 0;
    #297;
    RESET = 1;
    #100;
    RESET = 0;
    #100;
    $finish;
  end
endmodule
