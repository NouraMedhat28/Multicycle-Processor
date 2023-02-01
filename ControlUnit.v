module ControlUnit (
    input  wire       CLK,
    input  wire       RST,
    input  wire [5:0] Funct,
    input  wire [5:0] OpCode,
    output wire [2:0] ALUControl,
    output wire       MemToReg,
    output wire       RegDst,
    output wire       IorD,
    output wire [1:0] PCSrc,
    output wire [1:0] ALUSrcB,
    output wire       ALUSrcA,
    output wire       IRWrite,
    output wire       MemWrite,
    output wire       PCWrite,
    output wire       Branch,
    output wire       RegWrite
);
wire  [1:0] ALUOp;

ALUDecoder                           ALUDecoderControl
(.ALUOp              (ALUOp),
 .Funct              (Funct),
 .CLK                (CLK),
 .RST                (RST),
 .ALU_Control        (ALUControl)
);

FSM                                 MainDecoder
(.CLK                (CLK),
 .RST                (RST),
 .OpCode             (OpCode),
 .ALUSrcA            (ALUSrcA),
 .ALUSrcB            (ALUSrcB),
 .IorD               (IorD),
 .IRWrite            (IRWrite),
 .RegWrite           (RegWrite),
 .MemWrite           (MemWrite),
 .Branch             (Branch),
 .PCWrite            (PCWrite),
 .PCSrc              (PCSrc),
 .MemToReg           (MemToReg),
 .ALUOp              (ALUOp),
 .RegDst             (RegDst)
);
endmodule