`timescale  1ns/1ps

`include    "cmem.v"
`include    "varmem.v"
`include    "accel.v"
`include    "encoder.v"
`include    "equaliser.v"
`include    "adder.v"
`include    "mul.v"
`include    "mac.v"

module TestBench;
    reg                 TestBenchPOR;
    reg                 TestBenchClock;
    
    AccelChip           ChipInstance( .PowerOnReset(TestBenchPOR) , .Clock(TestBenchClock));
    
    initial
    begin
        $dumpfile("wavedump.vcd");
        $dumpvars;
    end
    
    initial
    begin
        #0      TestBenchPOR    <=  1'b0;
                TestBenchClock  <=  1'b1;

        #17     TestBenchPOR    <=  1'b1;
    end

    initial
    begin
        #10000  $finish;
    end
    always
    begin
        #5      TestBenchClock  <= ~TestBenchClock;
    end
endmodule
