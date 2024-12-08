module  MAC( ConstData , VarData , Result , ResultAddressMS , Control , 
             Clock , State , WriteEnable , Reset );
    input  [31:0]       ConstData;
    input  [31:0]       VarData;
    output [31:0]       Result;
    output [ 3:0]       ResultAddressMS;
    input  [ 1:0]       Control;
    input               Clock;
    input  [ 1:0]       State;
    output              WriteEnable;
    input               Reset;
    
    reg  [31:0]         ConstHold;
    reg  [31:0]         VarHold;
    reg                 EndOfEquation;
    reg  [31:0]         Accumulator;
    reg  [ 3:0]         ResultAddressCount;
    
    wire [31:0]         Product;
    wire [31:0]         Sum;
    mul                 M1      ( ConstHold , VarHold , Product );
    add1                A1      ( Product , Accumulator , Sum );
    
    wire                S0;
    wire                S2;
    wire                S3;
//    wire                ClearAcc;
    
    and             ResultBuf       [31:0] ( Result          , Accumulator        , WriteEnable );
    and                 ResultAddressBuf[ 3:0] ( ResultAddressMS , ResultAddressCount , S3          );

    assign  S0              =   ~( State[1] | State[0]);
    assign  S2              =   State[1] & ~State[0];
    assign  S3              =   State[1] & State[0];
    assign  WriteEnable     =   S3 & EndOfEquation;
//    assign  ClearAcc      =   S0 & Control[1];
    
    always @( negedge Reset , posedge Clock )
    begin
        if(!Reset)
        begin
            ConstHold           <=  32'h0000_0000;
            VarHold             <=  32'h0000_0000;
            EndOfEquation       <=  1'b0;
            Accumulator         <=  32'h0000_0000;
            ResultAddressCount  <=  4'b1111;
        end
/*        else if(!ClearAcc)
        begin
            ConstHold       <=  ConstHold;
            VarHold         <=  VarHold;
            EndOfEquation   <=  EndOfEquation;
            Accumulator     <=  32'h0000_0000;
            ResultAddressMS <=  ResultAddressMS;
        end */
        else
        begin
            if(S0)
            begin
                ConstHold           <=  ConstData;
                VarHold             <=  VarData;
                EndOfEquation       <=  Control[0];
                Accumulator         <=  Control[1] ? 32'h0000_0000 : Accumulator;
                ResultAddressCount  <=  Control[1] ? ResultAddressCount + 1'b1 : ResultAddressCount;
            end
            else if(S2)
            begin
                ConstHold           <=  ConstHold;
                VarHold             <=  VarHold;
                EndOfEquation       <=  EndOfEquation;
                Accumulator         <=  Sum;
                ResultAddressCount  <=  ResultAddressCount;
            end
            else
            begin
                ConstHold           <=  ConstHold;
                VarHold             <=  VarHold;
                EndOfEquation       <=  EndOfEquation;
                Accumulator         <=  Accumulator;
                ResultAddressCount  <=  ResultAddressCount;
            end
        end
    end
endmodule
