module mux_Sa (
    input wire  [1:0] selector,    // SHIFTAmt
    input wire  [4:0] Data_0,      // rt
    input wire  [4:0] Data_1,      // shamt
    input wire  [4:0] Data_2       // Mem [offset + rs]

    output wire [4:0] Data_out     // N (Quantidade de vezes que vai haver o deslocamento)
);

    wire [4:0] out;

    assign out = (selector[0]) ? Data_1 : Data_0;
    assign Data_out = (selector[1]) ? Data_2 : out;

    /*

    Data_0 ---- 0 |
    Data_1 ---- 1 | --- out --- 0 \
    Data_2 -------------------- 1 / --- Data_out ->

    */
    
endmodule