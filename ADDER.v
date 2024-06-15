`timescale 1ns / 1ps

module ADDER(
clk, rst_n, data1, data2, data3, data4, data5, data6,
data7, data8, data9,
out
    );

    input clk;
    input rst_n;
    input [11 : 0] data1, data2, data3;
    input [11 : 0] data4, data5, data6;
    input [11 : 0] data7, data8, data9;
    output reg [15 : 0] out;
    
    wire    [12:0]   o_0, o_1, o_2;
    wire    [13:0]   o1_0, o1_1, o1_2;
    
    wire    [13:0]  o2_0;
    wire    [13:0]  o3_0;
    
    wire    [13:0]  two1_0, two1_1, two1_2;
    wire    [14:0]  twotwo1_2;
    
    assign  o_0 = data1 + data2;
    assign  o1_0 = (data3 >= o_0) ? data3-o_0:  o_0-data3;
    
    assign  two1_0 = (data3 >= o_0) ? o1_0 : ~o1_0 + 1;
    
    assign  o_1 = data4 + data5;
    assign  o1_1 = (data6 >= o_1) ? data6-o_1:  o_1-data6;
    
    assign  two1_1 = (data6 >= o_1) ? o1_1 : ~o1_1 + 1;

    assign  o_2 = data7 + data8;
    assign  o1_2 = (data9 >= o_2) ? data9-o_2:  o_2-data9;
    
    assign  two1_2 = (data9 >= o_2) ? o1_2 : ~o1_2 + 1;  
    assign  twotwo1_2 = {two1_2[13], two1_2};  
    
    assign  o2_0 = two1_0 + two1_1;
    assign  o3_0 = o2_0 + twotwo1_2;
    
    always  @(posedge clk, negedge rst_n)   begin
        if (!rst_n) out <= 16'b0;
        else    out <= {{2{o3_0[13]}}, o3_0};
    end
 
endmodule
