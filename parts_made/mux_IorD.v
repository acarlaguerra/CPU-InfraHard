module mux_IorD (

    input wire  [2:0] IorD,         // Selector
    input wire  [31:0] Data_0,      // Data from PC (Address)
    input wire  [31:0] Data_1,      // Exception
    input wire  [31:0] Data_2,      // ALUResult
    input wire  [31:0] Data_3,      // ALUOut
    input wire  [31:0] Data_4,      // ALUSrcA
    input wire  [31:0] Data_5,      // ALUSrcB

    output wire [31:0] Data_out     // Output from MUX
);
    
    wire [31:0] out1, out2, out3, out4;

    assign out1 = (selector[0]) ? Data_1 : Data_0;
    assign out2 = (selector[0]) ? Data_3 : Data_2;
    assign out3 = (selector[1]) ? out2 : out1;
    assign out4 = (selector[1]) ? Data_5 : Data_4;
    assign Data_out = (selector[2]) ? out4 : out3;

    /*

    Data_0 ---- 0|
    Data_1 ---- 1| --- out1 0\
    Data_2 ---- 0|            | out3 -- 0\
    Data_3 ---- 1| --- out2 1/            |
    Data_4 ---- 0|                        | --- Data_out ->
    Data_5 ---- 1| ------- out4 ------- 1/

    */

endmodule