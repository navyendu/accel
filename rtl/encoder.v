module encoder(encod_in,encod_out);
    input [24:0] encod_in;
    output reg[4:0]encod_out;

    always @(encod_in)
    begin
        if(encod_in[24])
            encod_out=5'b00000;
        else if(encod_in[23])
            encod_out=5'b00001;
        else if(encod_in[22])
            encod_out=5'b00010;
        else if(encod_in[21])
            encod_out=5'b00011;
        else if(encod_in[20])
            encod_out=5'b00100;
        else if(encod_in[19])
            encod_out=5'b00101;
        else if(encod_in[18])
            encod_out=5'b00110;
        else if(encod_in[17])
            encod_out=5'b00111;
        else if(encod_in[16])
            encod_out=5'b01000;
        else if(encod_in[15])
            encod_out=5'b01001;
        else if(encod_in[14])
            encod_out=5'b01010;
        else if(encod_in[13])
            encod_out=5'b01011;
        else if(encod_in[12])
            encod_out=5'b01100;
        else if(encod_in[11])
            encod_out=5'b01101;
        else if(encod_in[10])
            encod_out=5'b01110;
        else if(encod_in[09])
            encod_out=5'b01111;
        else if(encod_in[08])
            encod_out=5'b10000;
        else if(encod_in[07])
            encod_out=5'b10001;
        else if(encod_in[06])
            encod_out=5'b10010;
        else if(encod_in[05])
            encod_out=5'b10011;
        else if(encod_in[04])
            encod_out=5'b10100;
        else if(encod_in[03])
            encod_out=5'b10101;
        else if(encod_in[02])
            encod_out=5'b10110;
        else if(encod_in[01])
            encod_out=5'b10111;
        else if(encod_in[00])
            encod_out=5'b11000;
        else
            encod_out=5'b00001;
    end                                      
endmodule