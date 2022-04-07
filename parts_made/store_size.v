module store_size(
    input   wire       [1:0]  SSCtrl,
    input   wire       [31:0] Data_MDR,
    input   wire       [31:0] Data_B,
    output  wire       [31:0] Data_out
);

always @ (*) begin
    case(SSCtrl)
        2'b01:  Data_out    =   Data_B;                             // word
        2'b10:  Data_out    =   {Data_MDR[31:16], Data_B[15:0]};     // halfword
        2'b11:  Data_out    =   {Data_MDR[31:8], Data_B[7:0]};       // byte
    endcase

end