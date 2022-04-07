module mux_Sa (
    input wire  [1:0] selector,    // SHIFTAmt
    input wire  [31:0] Data_0,      // BOut (rt)
    input wire  [15:0] Data_1,      // IMMEDIATE (shamt)
    input wire  [31:0] Data_2,       // MDROut (Mem[offset+rs])
    output wire [4:0] Data_out     // N (Quantidade de vezes que vai haver o deslocamento)
);

    wire [4:0] out;

    assign out = (selector[0]) ? Data_1[10:6] : Data_0[4:0];
    assign Data_out = (selector[1]) ? Data_2[4:0] : out;

    /*

        Data_0 ---- 0 |
        Data_1 ---- 1 | --- out --- 0 \
        Data_2 -------------------- 1 / --- Data_out ->

    */
    
endmodule