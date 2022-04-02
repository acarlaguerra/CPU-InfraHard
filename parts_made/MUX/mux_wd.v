module mux_wd(
    input wire [3:0] DataSrc, 
    input wire [31:0] Data_0, // ALUOut     // 0000
    input wire [31:0] Data_1, // Load Size  // 0001
    input wire [31:0] Data_2, // HI         // 0010
    input wire [31:0] Data_3, // LO         // 0011
    //                Data_4, // 227 (sp)   // 0100
    input wire [31:0] Data_5, // SL16       // 0101
    input wire [31:0] Data_6, // LT         // 0110
    input wire [31:0] Data_7, // Shift Reg  // 0111  
    input wire [31:0] Data_8, // PC+4 (jal) // 1000
    output wire [31:0] Data_out
);

    wire [31:0] out1, out2, out3, out4, out5, out6, out7;
    parameter spAddr = 32'd227;

    /*
        Data_0 -- 0| 
        Data_1 -- 1| -- out1 -- 0\
        Data_2 -- 0|              | -- out5 -- 0\
        Data_3 -- 1| -- out2 -- 1/               \
        spAddr -- 0|                              | -- out7 -- 0\
        Data_5 -- 1| -- out3 -- 0\               /               \
        Data_6 -- 0|              | -- out6 -- 1/                 | -- Data_out ->
        Data_7 -- 1| -- out4 -- 1/                               /
        Data_8 ----------------------------------------------- 1/
    */

    assign out1 = (DataSrc[0]) ? Data_1 : Data_0;
    assign out2 = (DataSrc[0]) ? Data_3 : Data_2;
    assign out3 = (DataSrc[0]) ? Data_5 : spAddr;
    assign out4 = (DataSrc[0]) ? Data_7 : Data_6;
    assign out5 = (DataSrc[1]) ? out2 : out1;
    assign out6 = (DataSrc[1]) ? out4 : out3;
    assign out7 = (DataSrc[2]) ? out6 : out5;
    assign Data_out = (DataSrc[3]) ? Data_8 : out7;

endmodule