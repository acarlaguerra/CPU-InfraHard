// MUX for exceptions
module mux_Except(
    input   wire    [1:0]       ExcptCtrl,
//  input   wire    [31:0]     Data_0, 
//  input   wire    [31:0]      Data_1, 
    output  wire    [31:0]      Data_out    
);

    parameter OPCODE    = 32'd253;
    parameter Overflow  = 32'd254;
    parameter Div0      = 32'd255;

    wire [31:0] out1;

    /*
        OPCODE   -- 0|
        OVERFLOW -- 1| -- out1 -- 0\
                                    | -- Data_out ->
        DIV0     ---------------- 1/
    */

    assign out1     =   (ExcptCtrl[0]) ? Overflow : OPCODE;     // if true receives 254, otherwise receives 253
    assign Data_out =   (ExcptCtrl[1]) ? Div0 : out1;         // if true receives 255, otherwise receives Aux1

endmodule