`timescale 1ns / 1ps

module RegisterFile(clk, rst_n, 
WriteEn, WriteData1, WriteData2, WriteData3, WriteData4, WriteData5, WriteData6, WriteData7, WriteData8, WriteData9, 
ReadEn, ReadData1, ReadData2, ReadData3, ReadData4, ReadData5, ReadData6, ReadData7, ReadData8, ReadData9);
    parameter M = 4;   // number of address bits
    parameter N = 9;  // number of words, N = 2**M
    parameter W = 12;   // number of bits in a word
    input   clk, rst_n;
    input   WriteEn;     // RegWrite가 High일 때 register file에 data를 저장
    input   [W-1:0] WriteData1, WriteData2, WriteData3, WriteData4, WriteData5, WriteData6, WriteData7, WriteData8, WriteData9; // Register file에 저장할 data
    output reg [W-1:0] ReadData1, ReadData2, ReadData3, ReadData4, ReadData5, ReadData6, ReadData7, ReadData8, ReadData9;  // Register file에서 읽은 data
    input   ReadEn;
//    input   [M-1:0] ReadReg1, ReadReg2, ReadReg3, ReadReg4, ReadReg5, ReadReg6, ReadReg7, ReadReg8, ReadReg9; // Register file에서 읽을 주소
//    input   [M-1:0] WriteReg; // Register file에서 data를 저장할 주소   
    reg [W-1:0] mem [N-1:0];    //register대용
    // 코드 작성
    wire    [3:0]   write1, write2, write3, write4, write5, write6, write7, write8, write9;
    wire    [3:0]   ReadReg1, ReadReg2, ReadReg3, ReadReg4, ReadReg5, ReadReg6, ReadReg7, ReadReg8, ReadReg9;
    assign  write1 = 4'b0000;
    assign  write2 = 4'b0001;
    assign  write3 = 4'b0010;
    assign  write4 = 4'b0011;
    assign  write5 = 4'b0100;
    assign  write6 = 4'b0101;
    assign  write7 = 4'b0110;
    assign  write8 = 4'b0111;
    assign  write9 = 4'b1000;   
    
    assign  ReadReg1 = 4'b0000;
    assign  ReadReg2 = 4'b0001;
    assign  ReadReg3 = 4'b0010;
    assign  ReadReg4 = 4'b0011;
    assign  ReadReg5 = 4'b0100;
    assign  ReadReg6 = 4'b0101;
    assign  ReadReg7 = 4'b0110;
    assign  ReadReg8 = 4'b0111;
    assign  ReadReg9 = 4'b1000;  
    
    always @(posedge    clk, negedge rst_n) begin
        if (!rst_n) begin
        end
        else    begin
            if(WriteEn) begin
                mem[write1] <= WriteData1;
                mem[write2] <= WriteData2;
                mem[write3] <= WriteData3;
                mem[write4] <= WriteData4;
                mem[write5] <= WriteData5;
                mem[write6] <= WriteData6;
                mem[write7] <= WriteData7;
                mem[write8] <= WriteData8;
                mem[write9] <= WriteData9;
            end
        end
    end
    
    always @(posedge    clk, negedge rst_n) begin
        if (!rst_n) begin
            ReadData1 <= {W{1'b0}};     //초기화
            ReadData2 <= {W{1'b0}};
            ReadData3 <= {W{1'b0}};    
            ReadData4 <= {W{1'b0}};     //초기화
            ReadData5 <= {W{1'b0}};
            ReadData6 <= {W{1'b0}};    
            ReadData7 <= {W{1'b0}};     //초기화
            ReadData8 <= {W{1'b0}};
            ReadData9 <= {W{1'b0}};    
        end
        else    begin
            if(ReadEn)  begin
                ReadData1   <= mem[ReadReg1];
                ReadData2   <= mem[ReadReg2];
                ReadData3   <= mem[ReadReg3];
                ReadData4   <= mem[ReadReg4];
                ReadData5   <= mem[ReadReg5];
                ReadData6   <= mem[ReadReg6];
                ReadData7   <= mem[ReadReg7];
                ReadData8   <= mem[ReadReg8];
                ReadData9   <= mem[ReadReg9];
            end
        end
    end
endmodule
