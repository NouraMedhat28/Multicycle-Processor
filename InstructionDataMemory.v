module InstructionDataMemory #(
    parameter MemoryWidth = 'd32,
              MemoryDepth = 'd200
) (
    input  wire                   CLK,
    input  wire                   RST,
    input  wire                   WE,
    input  wire [MemoryWidth-1:0] A,
    input  wire [MemoryWidth-1:0] WD,
    output reg  [MemoryWidth-1:0] RD,
    output reg  [31:0]            TestValue
);

reg [MemoryWidth-1:0] Mem [MemoryDepth-1:0];
integer i;
initial begin
    $readmemb ("Machine_Code.txt", Mem);
end
//Read Combinationally
always @(*) begin
    RD        = Mem[A];
end

always @(*) begin
    TestValue = Mem['d101];
end

always @(posedge CLK or negedge RST) begin
    //Asynchronous RST
    if(!RST) begin
        for (i =100 ; i<MemoryDepth ; i = i+1 ) begin
            Mem[i] <= 'b0;
        end
    end

    else if (WE) begin
           Mem[A] <= WD;
    end
end
endmodule