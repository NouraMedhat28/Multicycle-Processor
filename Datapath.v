module Datapath #(
    parameter width = 'd32,
              address = 'd5,
              depth   = 'd200,
              ALUSignal = 'd3
) (
    input  wire                 CLKD,
    input  wire                 RSTD,
    input  wire [ALUSignal-1:0] ALUControlD,
    input  wire                 MemToRegD,
    input  wire  [1:0]          PCSrcD,
    input  wire                 PCEnD,
    input  wire  [width-1:0]    DataD,
    input  wire                 ALUSrcAD,
    input  wire [1:0]           ALUSrcBD,
    input  wire                 RegDstD,
    input  wire                 RegWriteD,
    input  wire [width-1:0]     InstructionD,
    output wire [width-1:0]     ALUOutD,
    output wire [width-1:0]     BData,
    output wire [width-1:0]     PCOutD,
    output wire                 zeroD
);

wire  [width-1:0]      PCIn;
wire  [address-1:0]    RegDstMuxOut;
wire  [width-1:0]      MemToRegMuxOut;
wire  [width-1:0]      Reg2In1;
wire  [width-1:0]      Reg2In2;
wire  [width-1:0]      AData;
wire  [width-1:0]      SrcAD;
wire  [width-1:0]      SrcBD;
wire  [width-1:0]      SignImmD;
wire  [width-1:0]      Sh1Out;
wire  [width-1:0]      ALUResultD;
wire  [width-1:0]      PCJumpD;
wire  [27:0]           Sh2Out;

assign PCJumpD = {PCOutD[31:28], Sh2Out};

ProgramCounter                 #(.PC_width(width))                             ProgramCounterData 
(.NextInstruction               (PCIn),             
 .CLK                           (CLKD),
 .RST                           (RSTD),
 .EN                            (PCEnD),
 .CurrentInstruction            (PCOutD)
);

MUX2                           #(.MUXInputWidth(address))                      RegDstMux
(.MUXIn1                        (InstructionD[20:16]),
 .MUXIn2                        (InstructionD[15:11]),
 .MUXSelection                  (RegDstD),
 .MUXOut                        (RegDstMuxOut)
);

MUX2                           #(.MUXInputWidth(width))                       MemToRegMux
(.MUXIn1                        (ALUOutD),
 .MUXIn2                        (DataD),
 .MUXSelection                  (MemToRegD),
 .MUXOut                        (MemToRegMuxOut)
);

RegisterFile                   #(.RegFile_width(width), .RegFileAdd(address)) RegisterFileData
(.A1                            (InstructionD[25:21]),
 .A2                            (InstructionD[20:16]),
 .A3                            (RegDstMuxOut),
 .CLK                           (CLKD),
 .RST                           (RSTD),
 .WE3                           (RegWriteD),
 .WD3                           (MemToRegMuxOut),
 .RD1                           (Reg2In1),
 .RD2                           (Reg2In2)
);

Register                       #(.Reg_width(width))                            AReg
(.RegIn                         (Reg2In1),
 .CLK                           (CLKD),
 .RST                           (RSTD),
 .RegOut                        (AData)
);

Register                       #(.Reg_width(width))                            BReg
(.RegIn                         (Reg2In2),
 .CLK                           (CLKD),
 .RST                           (RSTD),
 .RegOut                        (BData)
);

MUX2                           #(.MUXInputWidth(width))                        ALUSrcAMux
(.MUXIn1                        (PCOutD),
 .MUXIn2                        (AData),
 .MUXSelection                  (ALUSrcAD),
 .MUXOut                        (SrcAD)
);

ExtendedSign                                                                   ExtendedSignData
(.InstructionOffset             (InstructionD[15:0]),
 .SignImm                       (SignImmD)
);

LeftShift                      #(.widthIn(width), .widthOut(width))            LeftShiftData
(.ShiftIn                       (SignImmD),
 .ShiftOut                      (Sh1Out)
);

MUX4                           #(.MUXInputWidth(width))                        ALUSrcBDMUX
(.MUXIn1                        (BData),
 .MUXIn2                        (32'd1),
 .MUXIn3                        (SignImmD),
 .MUXIn4                        (Sh1Out),
 .MUXSelection                  (ALUSrcBD),
 .MUXOut                        (SrcBD)
);

ALU                            #(.ALU_Width(width), .ALU_Control_Signal(ALUSignal)) ALUData
(.SrcA                          (SrcAD),
 .SrcB                          (SrcBD),
 .ALUControl                    (ALUControlD),
 .ALUResult                     (ALUResultD),
 .Zero                          (zeroD)
);

Register                       #(.Reg_width(width))                            RegALURes
(.RegIn                         (ALUResultD),
 .CLK                           (CLKD),
 .RST                           (RSTD),
 .RegOut                        (ALUOutD)
);

MUX4                           #(.MUXInputWidth(width))                        PCSrcDMux
(.MUXIn1                        (ALUResultD),
 .MUXIn2                        (ALUOutD),
 .MUXIn3                        (PCJumpD),
 .MUXIn4                        (32'd0),
 .MUXSelection                  (PCSrcD),
 .MUXOut                        (PCIn)
);

LeftShift                      #(.widthIn(26), .widthOut(28))                  JumpShiftData
(.ShiftIn                       (InstructionD[25:0]),
 .ShiftOut                      (Sh2Out)
);
endmodule