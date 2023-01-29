module ExtendedSign (
    input  wire [15:0] InstructionOffset,
    output reg  [31:0] SignImm
);

always @(*) begin
    SignImm = {{16{InstructionOffset[15]}},InstructionOffset};
end
    
endmodule