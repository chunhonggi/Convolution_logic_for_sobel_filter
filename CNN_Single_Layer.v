`timescale 1ns / 1ps

module CNN_Single_Layer(
clk, rst_n, Start, Image, Filter, ReadEn, ConvResult

    );
    
    
    input clk;
    input rst_n;
    input Start;
    input [71:0] Image;
    input [35:0] Filter;
    input ReadEn;
    output signed   [15:0] ConvResult;
    
//    reg [7:0] Image   [1023:0];
//    reg [71:0] Filter;
    
//    initial begin 
//    $readmemh("rom1.mem", Image);
////    $readmemh("rom2.mem", Filter);
//    end
    
    wire    [7:0]   image_00, image_01, image_02;
    wire    [7:0]   image_10, image_11, image_12;
    wire    [7:0]   image_20, image_21, image_22;
    
    assign  image_00   = Image[71:64];
    assign  image_01   = Image[63:56];
    assign  image_02   = Image[55:48];
    assign  image_10   = Image[47:40];
    assign  image_11   = Image[39:32];
    assign  image_12   = Image[31:24];
    assign  image_20   = Image[23:16];
    assign  image_21   = Image[15:8];
    assign  image_22   = Image[7:0];

    wire    [3:0]   filter_00, filter_01, filter_02;
    wire    [3:0]   filter_10, filter_11, filter_12;
    wire    [3:0]   filter_20, filter_21, filter_22;
    
    assign  filter_00 = Filter[35:32];
    assign  filter_01 = Filter[31:28];
    assign  filter_02 = Filter[27:24];
    assign  filter_10 = Filter[23:20];
    assign  filter_11 = Filter[19:16];
    assign  filter_12 = Filter[15:12];
    assign  filter_20 = Filter[11:8];
    assign  filter_21 = Filter[7:4];
    assign  filter_22 = Filter[3:0];

    wire [11:0] MultValue_0_00, MultValue_0_01, MultValue_0_02;
    wire [11:0] MultValue_0_10, MultValue_0_11, MultValue_0_12;
    wire [11:0] MultValue_0_20, MultValue_0_21, MultValue_0_22;
    
    wire [14:0] WriteRegCnt;
    wire [3:0] WriteReg;
    
//    wire [14:0] ReadRegCnt1, ReadRegCnt2, ReadRegCnt3;
    wire [3:0] ReadReg1, ReadReg2, ReadReg3, ReadReg4, ReadReg5, ReadReg6, ReadReg7, ReadReg8, ReadReg9;
    wire [11:0] ReadData1, ReadData2, ReadData3, ReadData4, ReadData5, ReadData6, ReadData7, ReadData8, ReadData9;

    wire delayed_WriteEn_0;
    
    // Instantiate the D Flip-Flop
    DFlipFlop buffer0 (
        .clk(Start),
        .q(delayed_WriteEn_0)
    );    
    // °ö¼À °è»ê, Ãâ·Â bit¼ö À¯ÀÇ
    // MultValue = Image * Filter
    Multiplicator Multiplicator_0_00 (.Start(Start), .din0(image_00), .din1(filter_00), .dout(MultValue_0_00));   // °ö¼À °á°ú = Partial Sum (PSum)
    Multiplicator Multiplicator_0_01 (.Start(Start), .din0(image_01), .din1(filter_01), .dout(MultValue_0_01));   // °ö¼À °á°ú = Partial Sum (PSum)
    Multiplicator Multiplicator_0_02 (.Start(Start), .din0(image_02), .din1(filter_02), .dout(MultValue_0_02));   // °ö¼À °á°ú = Partial Sum (PSum)
    Multiplicator Multiplicator_0_10 (.Start(Start), .din0(image_10), .din1(filter_10), .dout(MultValue_0_10));   // °ö¼À °á°ú = Partial Sum (PSum)
    Multiplicator Multiplicator_0_11 (.Start(Start), .din0(image_11), .din1(filter_11), .dout(MultValue_0_11));   // °ö¼À °á°ú = Partial Sum (PSum)
    Multiplicator Multiplicator_0_12 (.Start(Start), .din0(image_12), .din1(filter_12), .dout(MultValue_0_12));   // °ö¼À °á°ú = Partial Sum (PSum)
    Multiplicator Multiplicator_0_20 (.Start(Start), .din0(image_20), .din1(filter_20), .dout(MultValue_0_20));   // °ö¼À °á°ú = Partial Sum (PSum)
    Multiplicator Multiplicator_0_21 (.Start(Start), .din0(image_21), .din1(filter_21), .dout(MultValue_0_21));   // °ö¼À °á°ú = Partial Sum (PSum)
    Multiplicator Multiplicator_0_22 (.Start(Start), .din0(image_22), .din1(filter_22), .dout(MultValue_0_22));   // °ö¼À °á°ú = Partial Sum (PSum)
   // Register File Read/Write ÁÖ¼Ò °è»ê 


    RegisterFile #(.M(4), .N(9), .W(12))
        RegisterFile_0 (.clk(clk), .rst_n(rst_n), .WriteEn(delayed_WriteEn_0), 
        //.WriteReg(WriteReg), 
        .WriteData1(MultValue_0_00),
        .WriteData2(MultValue_0_01), .WriteData3(MultValue_0_02), .WriteData4(MultValue_0_10), .WriteData5(MultValue_0_11), 
        .WriteData6(MultValue_0_12), .WriteData7(MultValue_0_20), .WriteData8(MultValue_0_21), .WriteData9(MultValue_0_22), 
        .ReadEn(1), 
        //.ReadReg1(ReadReg1), .ReadReg2(ReadReg2), .ReadReg3(ReadReg3), .ReadReg4(ReadReg4), 
        //.ReadReg5(ReadReg5), .ReadReg6(ReadReg6), .ReadReg7(ReadReg7), .ReadReg8(ReadReg8), .ReadReg9(ReadReg9),
        .ReadData1(ReadData1), .ReadData2(ReadData2), .ReadData3(ReadData3), .ReadData4(ReadData4), 
        .ReadData5(ReadData5), .ReadData6(ReadData6), .ReadData7(ReadData7), .ReadData8(ReadData8), .ReadData9(ReadData9));
    
    // µ¡¼À °è»ê, Ãâ·Â bit¼ö À¯ÀÇ
    // ConvResult = ReadData1 + ReadData2 + ReadData3
    ADDER ADDER_0(.clk(clk), .rst_n(rst_n), .data1(ReadData1), .data2(ReadData2), .data3(ReadData3), 
    .data4(ReadData4), .data5(ReadData5), .data6(ReadData6), 
    .data7(ReadData7), .data8(ReadData8), .data9(ReadData9), .out(ConvResult)); 
    
endmodule
