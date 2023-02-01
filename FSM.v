module FSM (
    input  wire               CLK,
    input  wire               RST,
    input  wire [5:0]         OpCode,
    output reg                ALUSrcA,
    output reg  [1:0]         ALUSrcB,
    output reg                IorD,
    output reg                IRWrite,
    output reg                RegWrite,
    output reg                MemWrite,
    output reg                Branch,
    output reg                PCWrite,
    output reg  [1:0]         PCSrc,
    output reg                MemToReg,
    output reg  [1:0]         ALUOp,
    output reg                RegDst
);

reg [3:0] PresentState, NextState;

//States Encoding
localparam Fetch  = 4'b0000,
           Decode = 4'b0001,
           MemAdr = 4'b0011,
           MemRead= 4'b0010,
           MemWriteBack = 4'b0110,
           MemWriteSW = 4'b0100,
           Execute = 4'b1100,
           ALUWriteBack = 4'b1000,
           BranchState = 4'b1010,
           ADDIEx = 4'b1011,
           ADDIWr = 4'b1111,
           Jump   = 4'b1110;

//State Transition (Sequential Always)
always @(posedge CLK or negedge RST) begin
    if(!RST) begin
        PresentState <= Fetch;
    end
    else begin
        PresentState <= NextState;
    end
end 


always @(*) begin
        ALUSrcA  = 'b0;
        ALUSrcB  = 'b00;
        IorD     = 'b0;
        IRWrite  = 'b0;
        RegWrite = 'b0;
        MemWrite = 'b0;
        Branch   = 'b0;
        PCWrite  = 'b0;
        MemToReg = 'b0;
        RegDst   = 'b0;
        PCSrc    = 'b00;
        ALUOp    = 'b00;
    case (PresentState)
      Fetch  : begin
        ALUSrcA  = 'b0;
        ALUSrcB  = 'b01;
        PCSrc    = 'b00;
        IorD     = 'b0;
        IRWrite  = 'b1;
        PCWrite  = 'b1;
        ALUOp    = 'b00;
        NextState = Decode;
      end 
      Decode  : begin
        ALUSrcA  = 'b0;
        ALUSrcB  = 'b11;
        ALUOp    = 'b00;
        case (OpCode)
         'b100011, 'b101011   : begin
            NextState = MemAdr;
         end 
         'b000000  : begin
            NextState = Execute;
         end
         'b000100  : begin
            NextState = BranchState;
         end
         'b001000 : begin
            NextState = ADDIEx;
         end
         'b000010 : begin
           NextState = Jump;
         end
            default: NextState = Fetch;
        endcase
      end
      MemAdr  : begin
        ALUSrcA = 'b1;
        ALUSrcB = 'b10;
        ALUOp   = 'b00; 
        if (OpCode == 'b100011) begin
            NextState = MemRead;
        end
        else begin
            NextState = MemWriteSW;
        end
      end
      MemRead  : begin
        IorD = 'b1;
        NextState = MemWriteBack;
      end
      MemWriteBack : begin
        RegDst    = 'b0;
        MemToReg  = 'b1;
        RegWrite  = 'b1;
        NextState = Fetch; 
      end
      MemWriteSW  : begin
        IorD = 'b1;
        MemWrite = 'b1;
        NextState = Fetch;
      end
      Execute  : begin
        ALUSrcA = 'b1;
        ALUSrcB = 'b00;
        ALUOp   = 'b10;
        NextState = ALUWriteBack;
      end
      ALUWriteBack  : begin
        RegDst    = 'b1;
        MemToReg  = 'b0;
        RegWrite  = 'b1;
        NextState = Fetch;
      end
      BranchState  : begin
        ALUSrcA = 'b1;
        ALUSrcB = 'b00;
        ALUOp   = 'b01;
        PCSrc   = 'b01;
        Branch  = 'b1;
        NextState = Fetch;
      end
      ADDIEx  : begin
        ALUSrcA = 'b1;
        ALUSrcB = 'b10;
        ALUOp   = 'b00;
        NextState = ADDIWr; 
      end
      ADDIWr  : begin
        RegDst = 'b0;
        MemToReg = 'b0;
        RegWrite = 'b1;
        NextState = Fetch;
      end
      Jump    : begin
        PCSrc   = 'b10;
        PCWrite = 'b1;
        NextState = Fetch;
      end

        default: NextState = Fetch;
    endcase
end
    
endmodule