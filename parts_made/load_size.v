module load_size (
    input   wire       [1:0]  LSCtrl,
    input   wire       [31:0] Data_MDR, 
    output  wire       [31:0] Data_out
);

always @ (*) begin
    case(LSCtrl)
        2'b01: Data_out     =   Data_MDR;                    // word
        2'b10: Data_out     =   {16'b0, Data_MDR[15:0]};    // halfword
        2'b11: Data_out     =   {24'b0, Data_MDR[7:0]};     //  byte
    endcase

end

endmodule