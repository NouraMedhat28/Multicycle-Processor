//Ports & Parameters
module ProgramCounter #(
    parameter PC_width = 'd32
) (
    input  wire   [PC_width-1:0] NextInstruction,
    input  wire                  CLK,
    input  wire                  RST,
    output reg    [PC_width-1:0] CurrentInstruction
);

//PC logic
always @(posedge CLK or negedge RST) begin
    if(!RST) begin
        CurrentInstruction <= 'b0;
    end

    else begin
        CurrentInstruction <= NextInstruction;
    end
end
    
endmodule