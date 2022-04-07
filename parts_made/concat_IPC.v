// this module concatenates the Instructions that come from
// Shift Left 2 with what comes from PC and head to MUX

module concat_IPC(
    input   wire    [27:0]   Data_Instr,
    input   wire    [31:0]   Data_PC,
    output  wire    [31:0]   Data_out
);

    assign Data_out = {Data_PC[31:28], Data_Instr};

endmodule