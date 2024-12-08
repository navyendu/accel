module AccelChip( PowerOnReset , Clock );
    input               PowerOnReset;
    input               Clock;

    //-------------------------------------------------------------------------------//

    reg  [47:0]         TimeCount;

    wire                SimClock;
    wire                SimEnable;
    reg                 SimSync;

    //-------------------------------------------------------------------------------//

    reg  [ 7:0]         ConstPointer;
    wire [ 7:0]         ConstAddressBus;
    wire [47:0]         ConstDataBus;
    wire                ConstWriteEnable;
    ConstMemory         ConstMemInstance  ( .Data         ( ConstDataBus     ),
                                            .Address      ( ConstAddressBus  ),
                                            .WriteEnable  ( ConstWriteEnable ),
                                            .Clock        ( Clock            ),
                                            .Reset        ( PowerOnReset     ));

    //-------------------------------------------------------------------------------//

    wire [ 5:0]         VarReadAddressBus;
    wire [ 5:0]         VarWriteAddressBus;
    wire [31:0]         VarReadDataBus;
    wire [31:0]         VarWriteDataBus;
    wire                VarWriteEnable;
    wire                VarMLX;
    VarMemory           VarMemInstance  ( .ReadAddress  ( VarReadAddressBus  ),
                                          .WriteAddress ( VarWriteAddressBus ),
                                          .DataOut      ( VarReadDataBus     ),
                                          .DataIn       ( VarWriteDataBus    ),
                                          .WriteEnable  ( VarWriteEnable     ),
                                          .MLX          ( VarMLX             ),
                                          .Clock        ( Clock              ),
                                          .Reset        ( PowerOnReset       ));

    //-------------------------------------------------------------------------------//

    wire                MacReset;
    reg  [ 1:0]         Mac00TaskState;
    wire                Mac00WriteEnable;
    wire [31:0]         Mac00Result;
    wire [ 3:0]         Mac00ResultAddressMS;
    MAC                 MacInstance00   ( .ConstData        ( ConstDataBus[31:0]   ),
                                          .VarData          ( VarReadDataBus       ),
                                          .Result           ( Mac00Result          ),
                                          .ResultAddressMS  ( Mac00ResultAddressMS ),
                                          .Control          ( ConstDataBus[47:46]  ),
                                          .Clock            ( SimClock             ),
                                          .State            ( Mac00TaskState       ),
                                          .WriteEnable      ( Mac00WriteEnable     ),
                                          .Reset            ( MacReset             ));

    reg  [ 1:0]         Mac01TaskState;
    wire                Mac01WriteEnable;
    wire [31:0]         Mac01Result;
    wire [ 3:0]         Mac01ResultAddressMS;
    MAC                 MacInstance01   ( .ConstData        ( ConstDataBus[31:0]   ),
                                          .VarData          ( VarReadDataBus       ),
                                          .Result           ( Mac01Result          ),
                                          .ResultAddressMS  ( Mac01ResultAddressMS ),
                                          .Control          ( ConstDataBus[47:46]  ),
                                          .Clock            ( SimClock             ),
                                          .State            ( Mac01TaskState       ),
                                          .WriteEnable      ( Mac01WriteEnable     ),
                                          .Reset            ( MacReset             ));

    reg  [ 1:0]         Mac02TaskState;
    wire                Mac02WriteEnable;
    wire [31:0]         Mac02Result;
    wire [ 3:0]         Mac02ResultAddressMS;
    MAC                 MacInstance02   ( .ConstData        ( ConstDataBus[31:0]   ),
                                          .VarData          ( VarReadDataBus       ),
                                          .Result           ( Mac02Result          ),
                                          .ResultAddressMS  ( Mac02ResultAddressMS ),
                                          .Control          ( ConstDataBus[47:46]  ),
                                          .Clock            ( SimClock             ),
                                          .State            ( Mac02TaskState       ),
                                          .WriteEnable      ( Mac02WriteEnable     ),
                                          .Reset            ( MacReset             ));

    reg  [ 1:0]         Mac03TaskState;
    wire                Mac03WriteEnable;
    wire [31:0]         Mac03Result;
    wire [ 3:0]         Mac03ResultAddressMS;
    MAC                 MacInstance03   ( .ConstData        ( ConstDataBus[31:0]   ),
                                          .VarData          ( VarReadDataBus       ),
                                          .Result           ( Mac03Result          ),
                                          .ResultAddressMS  ( Mac03ResultAddressMS ),
                                          .Control          ( ConstDataBus[47:46]  ),
                                          .Clock            ( SimClock             ),
                                          .State            ( Mac03TaskState       ),
                                          .WriteEnable      ( Mac03WriteEnable     ),
                                          .Reset            ( MacReset             ));

    //-------------------------------------------------------------------------------//

    assign  SimClock                =   Clock & SimSync;
    assign  SimEnable               =   1'b1;

    assign  VarWriteDataBus         =   Mac00Result | Mac01Result |
                                        Mac02Result | Mac03Result;
    assign  ConstWriteEnable        =   0;
    assign  ConstAddressBus         =   ConstPointer;
    assign  VarReadAddressBus       =   ConstDataBus[41:32];
    assign  VarWriteAddressBus[5:2] =   Mac00ResultAddressMS |
                                        Mac01ResultAddressMS |
                                        Mac02ResultAddressMS |
                                        Mac03ResultAddressMS ;
    assign  VarWriteAddressBus[1:0] =   Mac00TaskState + 1'b1;
    assign  VarMLX                  =   ConstDataBus[45];
    assign  VarWriteEnable          =   MacReset & ( Mac00WriteEnable |
                                                     Mac01WriteEnable |
                                                     Mac02WriteEnable |
                                                     Mac03WriteEnable);
    assign  MacReset                =   PowerOnReset & ~VarMLX;

    //===============================================================================//

    always @(negedge PowerOnReset , posedge SimClock)
    begin
        if(!PowerOnReset)
        begin
            ConstPointer    <=  8'hFF;
            Mac00TaskState  <=  2'b11;
            Mac01TaskState  <=  2'b10;
            Mac02TaskState  <=  2'b01;
            Mac03TaskState  <=  2'b00;
            TimeCount       <=  48'h10;
        end
        else
        begin
            ConstPointer    <=  VarMLX ? 8'h00 : ConstPointer + 1'b1;
            Mac00TaskState  <=  VarMLX ? 2'b00 : Mac00TaskState + 1'b1;
            Mac01TaskState  <=  VarMLX ? 2'b11 : Mac01TaskState + 1'b1;
            Mac02TaskState  <=  VarMLX ? 2'b10 : Mac02TaskState + 1'b1;
            Mac03TaskState  <=  VarMLX ? 2'b01 : Mac03TaskState + 1'b1;
            TimeCount       <=  VarMLX ? TimeCount - 1'b1 : TimeCount;
        end
    end

    always @(negedge PowerOnReset , negedge Clock)
    begin
        if(!PowerOnReset)
        begin
            SimSync         <=  1'b0;
        end
        else
        begin
            SimSync         <=  SimEnable & (|TimeCount) & PowerOnReset;
        end
    end
endmodule
