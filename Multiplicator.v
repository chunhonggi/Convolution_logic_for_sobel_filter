`timescale 1ns / 1ps

module Multiplicator(Start, din0, din1, dout);

    input Start;
    input [7:0] din0;
    input [3:0] din1;
    output [11:0] dout;
    
    wire    [7:0]   for_din1;
    assign  for_din1 = {3'b000, din1};
    wire    [15:0]   result;
    assign  result = din0 * for_din1;
    assign  dout = (Start)  ?   result[11:0]  :   12'b0;
    
endmodule