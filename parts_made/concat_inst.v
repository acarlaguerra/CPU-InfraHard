// this module concatenates the Instructions that come from
// IR and head to Shift Left 2 [25:0] -> [27:0]

module concat_inst(
    input   wire    [4:0]   Instr_25_21,
    input   wire    [4:0]   Instr_20_26,
    input   wire    [15:0]  Instr_31_26,
    output  wire    [25:0]  Data_out
);

    assign Data_out = {Instr_25_21, Instr_20_26, Instr_31_26};

endmodule