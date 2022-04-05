// MUX for exceptions
module mux_Except(
    input   wire    [2:0],       ExcptCtrl,
//  input   wire    [31:0]     Data_0, 
//  input   wire    [31:0]      Data_1, 
    output  wire    [31:0]      Data_out    
);

    parameter OPCODE    = 32'd253;
    parameter Overflow  = 32'd254;
    parameter Div0      = 32'255;

    wire [31:0] Aux1;

    assign Aux1     =   (ExcptCtrl[0])? Overflow : OPCODE;     // if true receives 254, otherwise receives 253
    assign Data_out =   (ExcptCtrl[1])? Div0 : Aux1;         // if true receives 255, otherwise receives Aux1

endmodule