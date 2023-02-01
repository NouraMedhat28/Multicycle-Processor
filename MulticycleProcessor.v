module MulticycleProcessor #(
    parameter width_Top   = 'd32,
              Depth_Top   = 'd200,
              ALU_Top     = 'd3,
              Address_Top = 'd5
) (
    input  wire        CLKTop,
    input  wire        RSTTop,
    output wire [31:0] TestValueTop
);

 wire [ALU_Top-1:0]      ALUControlTop;
 wire                    MemToRegTop;
 wire [1:0]              PCSrcTop;
 wire                    PCEnTop;
 wire [width_Top-1:0]    DataTop;
 wire                    ALUSrcATop;
 wire [1:0]              ALUSrcBTop;
 wire                    RegDstTop;
 wire                    RegWriteTop;
 wire                    MemWriteTop;
 wire [width_Top-1:0]    InstructionTop;
 wire [width_Top-1:0]    ALUOutTop;
 wire [width_Top-1:0]    BTop;
 wire [width_Top-1:0]    PCOutTop;
 wire [width_Top-1:0]    Adr;
 wire                    zeroTop;
 wire                    IorDTop;
 wire                    PCWriteTop;
 wire                    IRWriteTop;
 wire                    BranchTop;
 wire [width_Top-1:0]    IRRegIn;

 assign PCEnTop = BranchTop & zeroTop | PCWriteTop;

Datapath                        #(.width(width_Top), .depth(Depth_Top), .address(Address_Top), .ALUSignal(ALU_Top))  DatapathTop
(.CLKD                           (CLKTop),
 .RSTD                           (RSTTop),
 .ALUControlD                    (ALUControlTop),
 .MemToRegD                      (MemToRegTop),
 .PCSrcD                         (PCSrcTop),
 .PCEnD                          (PCEnTop),
 .DataD                          (DataTop),
 .ALUSrcAD                       (ALUSrcATop),
 .ALUSrcBD                       (ALUSrcBTop),
 .RegDstD                        (RegDstTop),
 .RegWriteD                      (RegWriteTop),
 .InstructionD                   (InstructionTop),
 .ALUOutD                        (ALUOutTop),
 .BData                          (BTop),
 .PCOutD                         (PCOutTop),
 .zeroD                          (zeroTop)
);

ControlUnit                                                                                                          ControlUnitTop
(.CLK                            (CLKTop),
 .RST                            (RSTTop),
 .Funct                          (InstructionTop[5:0]),
 .OpCode                         (InstructionTop[31:26]),
 .ALUControl                     (ALUControlTop),
 .MemToReg                       (MemToRegTop),
 .RegDst                         (RegDstTop),
 .IorD                           (IorDTop),
 .PCSrc                          (PCSrcTop),
 .ALUSrcB                        (ALUSrcBTop),
 .ALUSrcA                        (ALUSrcATop),
 .IRWrite                        (IRWriteTop),
 .MemWrite                       (MemWriteTop),
 .PCWrite                        (PCWriteTop),
 .Branch                         (BranchTop),
 .RegWrite                       (RegWriteTop)
);

MUX2                           #(.MUXInputWidth(width_Top))                                                         IorDMux
(.MUXIn1                        (PCOutTop),
 .MUXIn2                        (ALUOutTop),
 .MUXSelection                  (IorDTop),
 .MUXOut                        (Adr)
);

InstructionDataMemory          #(.MemoryDepth(Depth_Top), .MemoryWidth(width_Top))                                  MemoryTop
(.CLK                           (CLKTop),
 .RST                           (RSTTop),
 .WE                            (MemWriteTop), 
 .A                             (Adr),
 .WD                            (BTop),
 .RD                            (IRRegIn),
 .TestValue                     (TestValueTop)
);

RegisterWithEN                 #(.Reg_width(width_Top))                                                            InstrReg
(.RegIn                         (IRRegIn),
 .EN                            (IRWriteTop),
 .CLK                           (CLKTop),
 .RST                           (RSTTop),
 .RegOut                        (InstructionTop)
);

Register                       #(.Reg_width(width_Top))                                                            DataTopReg
(.RegIn                         (IRRegIn),
 .CLK                           (CLKTop),
 .RST                           (RSTTop),
 .RegOut                        (DataTop)
);
endmodule