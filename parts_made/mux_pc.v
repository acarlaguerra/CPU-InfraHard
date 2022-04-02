module mux_pc(
    input wire [1:0] PCSrc;
    input wire [31:0] Data_0, // ALU result (PC+4)  //  00
    input wire [31:0] Data_1, // ALUOut             //  01
    input wire [31:0] Data_2, // offset (formato J) //  10
    input wire [31:0] Data_3, // EPC                //  11  
    output wire [31:0] Data_out      
);

    wire [31:0] out1, out2;

    /*
        Data_0 -- 0|
        Data_1 -- 1| -- out1 -- 0\
        Data_2 -- 0|              | -- Data_out ->
        Data_3 -- 1| -- out2 -- 1/ 
    */

    assign out1 = (PCSrc[0]) ? Data_1 : Data_0;
    assign out2 = (PCSrc[0]) ? Data_3 : Data_2;
    assign Data_out = (PCSrc[1]) ? out2 : out1;

endmodule