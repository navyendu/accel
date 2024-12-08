module  VarMemory ( ReadAddress , WriteAddress , DataOut , DataIn , WriteEnable , MLX , Clock , Reset);
    parameter           Size    =   64;
    
    input  [ 5:0]       ReadAddress;
    input  [ 5:0]       WriteAddress;
    output [31:0]       DataOut;
    input  [31:0]       DataIn;
    input               WriteEnable;
    input               MLX;
    input               Clock;
    input               Reset;
    
    reg  [31:0]         Previous[Size-1:0];
    reg  [31:0]         Current [Size-1:0];
    
    assign  DataOut     =   Previous[ReadAddress];
    
    always @(negedge Reset , posedge Clock)
    begin
        if(!Reset)
        begin
            Previous[0]     <=  32'h0000_0000;      // 0
            Previous[1]     <=  32'h3F80_0000;      // 1
            Previous[2]     <=  32'h4000_0000;      // 2
            Previous[3]     <=  32'h4040_0000;      // 3
            Previous[4]     <=  32'h4080_0000;      // 4
            Previous[5]     <=  32'hC0A0_0000;      // -5
            Previous[6]     <=  32'hC080_0000;      // -4
            Previous[7]     <=  32'hC040_0000;      // -3
            Previous[8]     <=  32'hC000_0000;      // -2
            Previous[9]     <=  32'hBF80_0000;      // -1
            Previous[10]    <=  32'h3F80_0000;
            Previous[11]    <=  32'h3F80_0000;
            Previous[12]    <=  32'h3F80_0000;
            Previous[13]    <=  32'h3F80_0000;
            Previous[14]    <=  32'h3F80_0000;
            Previous[15]    <=  32'h3F80_0000;
            Previous[16]    <=  32'h3F80_0000;
            Previous[17]    <=  32'h3F80_0000;
            Previous[18]    <=  32'h3F80_0000;
            Previous[19]    <=  32'h3F80_0000;
            Previous[20]    <=  32'h3F80_0000;
            Previous[21]    <=  32'h3F80_0000;
            Previous[22]    <=  32'h3F80_0000;
            Previous[23]    <=  32'h3F80_0000;
            Previous[24]    <=  32'h3F80_0000;
            Previous[25]    <=  32'h3F80_0000;
            Previous[26]    <=  32'h3F80_0000;
            Previous[27]    <=  32'h3F80_0000;
            Previous[28]    <=  32'h3F80_0000;
            Previous[29]    <=  32'h3F80_0000;
            Previous[30]    <=  32'h3F80_0000;
            Previous[31]    <=  32'h3F80_0000;
            Previous[32]    <=  32'h3F80_0000;
            Previous[33]    <=  32'h3F80_0000;
            Previous[34]    <=  32'h3F80_0000;
            Previous[35]    <=  32'h3F80_0000;
            Previous[36]    <=  32'h3F80_0000;
            Previous[37]    <=  32'h3F80_0000;
            Previous[38]    <=  32'h3F80_0000;
            Previous[39]    <=  32'h3F80_0000;
            Previous[40]    <=  32'h3F80_0000;
            Previous[41]    <=  32'h3F80_0000;
            Previous[42]    <=  32'h3F80_0000;
            Previous[43]    <=  32'h3F80_0000;
            Previous[44]    <=  32'h3F80_0000;
            Previous[45]    <=  32'h3F80_0000;
            Previous[46]    <=  32'h3F80_0000;
            Previous[47]    <=  32'h3F80_0000;
            Previous[48]    <=  32'h3F80_0000;
            Previous[49]    <=  32'h3F80_0000;
            Previous[50]    <=  32'h3F80_0000;
            Previous[51]    <=  32'h3F80_0000;
            Previous[52]    <=  32'h3F80_0000;
            Previous[53]    <=  32'h3F80_0000;
            Previous[54]    <=  32'h3F80_0000;
            Previous[55]    <=  32'h3F80_0000;
            Previous[56]    <=  32'h3F80_0000;
            Previous[57]    <=  32'h3F80_0000;
            Previous[58]    <=  32'h3F80_0000;
            Previous[59]    <=  32'h3F80_0000;
            Previous[60]    <=  32'h3F80_0000;
            Previous[61]    <=  32'h3F80_0000;
            Previous[62]    <=  32'h3F80_0000;
            Previous[63]    <=  32'h3F80_0000;

            Current[0]      <=  32'h3F80_0000;
            Current[1]      <=  32'h3F80_0000;
            Current[2]      <=  32'h3F80_0000;
            Current[3]      <=  32'h3F80_0000;
            Current[4]      <=  32'h3F80_0000;
            Current[5]      <=  32'h3F80_0000;
            Current[6]      <=  32'h3F80_0000;
            Current[7]      <=  32'h3F80_0000;
            Current[8]      <=  32'h3F80_0000;
            Current[9]      <=  32'h3F80_0000;
            Current[10]     <=  32'h3F80_0000;
            Current[11]     <=  32'h3F80_0000;
            Current[12]     <=  32'h3F80_0000;
            Current[13]     <=  32'h3F80_0000;
            Current[14]     <=  32'h3F80_0000;
            Current[15]     <=  32'h3F80_0000;
            Current[16]     <=  32'h3F80_0000;
            Current[17]     <=  32'h3F80_0000;
            Current[18]     <=  32'h3F80_0000;
            Current[19]     <=  32'h3F80_0000;
            Current[20]     <=  32'h3F80_0000;
            Current[21]     <=  32'h3F80_0000;
            Current[22]     <=  32'h3F80_0000;
            Current[23]     <=  32'h3F80_0000;
            Current[24]     <=  32'h3F80_0000;
            Current[25]     <=  32'h3F80_0000;
            Current[26]     <=  32'h3F80_0000;
            Current[27]     <=  32'h3F80_0000;
            Current[28]     <=  32'h3F80_0000;
            Current[29]     <=  32'h3F80_0000;
            Current[30]     <=  32'h3F80_0000;
            Current[31]     <=  32'h3F80_0000;
            Current[32]     <=  32'h3F80_0000;
            Current[33]     <=  32'h3F80_0000;
            Current[34]     <=  32'h3F80_0000;
            Current[35]     <=  32'h3F80_0000;
            Current[36]     <=  32'h3F80_0000;
            Current[37]     <=  32'h3F80_0000;
            Current[38]     <=  32'h3F80_0000;
            Current[39]     <=  32'h3F80_0000;
            Current[40]     <=  32'h3F80_0000;
            Current[41]     <=  32'h3F80_0000;
            Current[42]     <=  32'h3F80_0000;
            Current[43]     <=  32'h3F80_0000;
            Current[44]     <=  32'h3F80_0000;
            Current[45]     <=  32'h3F80_0000;
            Current[46]     <=  32'h3F80_0000;
            Current[47]     <=  32'h3F80_0000;
            Current[48]     <=  32'h3F80_0000;
            Current[49]     <=  32'h3F80_0000;
            Current[50]     <=  32'h3F80_0000;
            Current[51]     <=  32'h3F80_0000;
            Current[52]     <=  32'h3F80_0000;
            Current[53]     <=  32'h3F80_0000;
            Current[54]     <=  32'h3F80_0000;
            Current[55]     <=  32'h3F80_0000;
            Current[56]     <=  32'h3F80_0000;
            Current[57]     <=  32'h3F80_0000;
            Current[58]     <=  32'h3F80_0000;
            Current[59]     <=  32'h3F80_0000;
            Current[60]     <=  32'h3F80_0000;
            Current[61]     <=  32'h3F80_0000;
            Current[62]     <=  32'h3F80_0000;
            Current[63]     <=  32'h3F80_0000;
        end
        else
        begin
            if(MLX)
            begin
                Previous[0]     <=  Current[0];
                Previous[1]     <=  Current[1];
                Previous[2]     <=  Current[2];
                Previous[3]     <=  Current[3];
                Previous[4]     <=  Current[4];
                Previous[5]     <=  Current[5];
                Previous[6]     <=  Current[6];
                Previous[7]     <=  Current[7];
                Previous[8]     <=  Current[8];
                Previous[9]     <=  Current[9];
                Previous[10]    <=  Current[10];
                Previous[11]    <=  Current[11];
                Previous[12]    <=  Current[12];
                Previous[13]    <=  Current[13];
                Previous[14]    <=  Current[14];
                Previous[15]    <=  Current[15];
                Previous[16]    <=  Current[16];
                Previous[17]    <=  Current[17];
                Previous[18]    <=  Current[18];
                Previous[19]    <=  Current[19];
                Previous[20]    <=  Current[20];
                Previous[21]    <=  Current[21];
                Previous[22]    <=  Current[22];
                Previous[23]    <=  Current[23];
                Previous[24]    <=  Current[24];
                Previous[25]    <=  Current[25];
                Previous[26]    <=  Current[26];
                Previous[27]    <=  Current[27];
                Previous[28]    <=  Current[28];
                Previous[29]    <=  Current[29];
                Previous[30]    <=  Current[30];
                Previous[31]    <=  Current[31];
                Previous[32]    <=  Current[32];
                Previous[33]    <=  Current[33];
                Previous[34]    <=  Current[34];
                Previous[35]    <=  Current[35];
                Previous[36]    <=  Current[36];
                Previous[37]    <=  Current[37];
                Previous[38]    <=  Current[38];
                Previous[39]    <=  Current[39];
                Previous[40]    <=  Current[40];
                Previous[41]    <=  Current[41];
                Previous[42]    <=  Current[42];
                Previous[43]    <=  Current[43];
                Previous[44]    <=  Current[44];
                Previous[45]    <=  Current[45];
                Previous[46]    <=  Current[46];
                Previous[47]    <=  Current[47];
                Previous[48]    <=  Current[48];
                Previous[49]    <=  Current[49];
                Previous[50]    <=  Current[50];
                Previous[51]    <=  Current[51];
                Previous[52]    <=  Current[52];
                Previous[53]    <=  Current[53];
                Previous[54]    <=  Current[54];
                Previous[55]    <=  Current[55];
                Previous[56]    <=  Current[56];
                Previous[57]    <=  Current[57];
                Previous[58]    <=  Current[58];
                Previous[59]    <=  Current[59];
                Previous[60]    <=  Current[60];
                Previous[61]    <=  Current[61];
                Previous[62]    <=  Current[62];
                Previous[63]    <=  Current[63];
            end
            else if(WriteEnable)
            begin
                Current[WriteAddress]   <=  DataIn;
            end
            else
            begin
                Previous[0]     <=  Previous[0];
                Previous[1]     <=  Previous[1];
                Previous[2]     <=  Previous[2];
                Previous[3]     <=  Previous[3];
                Previous[4]     <=  Previous[4];
                Previous[5]     <=  Previous[5];
                Previous[6]     <=  Previous[6];
                Previous[7]     <=  Previous[7];
                Previous[8]     <=  Previous[8];
                Previous[9]     <=  Previous[9];
                Previous[10]    <=  Previous[10];
                Previous[11]    <=  Previous[11];
                Previous[12]    <=  Previous[12];
                Previous[13]    <=  Previous[13];
                Previous[14]    <=  Previous[14];
                Previous[15]    <=  Previous[15];
                Previous[16]    <=  Previous[16];
                Previous[17]    <=  Previous[17];
                Previous[18]    <=  Previous[18];
                Previous[19]    <=  Previous[19];
                Previous[20]    <=  Previous[20];
                Previous[21]    <=  Previous[21];
                Previous[22]    <=  Previous[22];
                Previous[23]    <=  Previous[23];
                Previous[24]    <=  Previous[24];
                Previous[25]    <=  Previous[25];
                Previous[26]    <=  Previous[26];
                Previous[27]    <=  Previous[27];
                Previous[28]    <=  Previous[28];
                Previous[29]    <=  Previous[29];
                Previous[30]    <=  Previous[30];
                Previous[31]    <=  Previous[31];
                Previous[32]    <=  Previous[32];
                Previous[33]    <=  Previous[33];
                Previous[34]    <=  Previous[34];
                Previous[35]    <=  Previous[35];
                Previous[36]    <=  Previous[36];
                Previous[37]    <=  Previous[37];
                Previous[38]    <=  Previous[38];
                Previous[39]    <=  Previous[39];
                Previous[40]    <=  Previous[40];
                Previous[41]    <=  Previous[41];
                Previous[42]    <=  Previous[42];
                Previous[43]    <=  Previous[43];
                Previous[44]    <=  Previous[44];
                Previous[45]    <=  Previous[45];
                Previous[46]    <=  Previous[46];
                Previous[47]    <=  Previous[47];
                Previous[48]    <=  Previous[48];
                Previous[49]    <=  Previous[49];
                Previous[50]    <=  Previous[50];
                Previous[51]    <=  Previous[51];
                Previous[52]    <=  Previous[52];
                Previous[53]    <=  Previous[53];
                Previous[54]    <=  Previous[54];
                Previous[55]    <=  Previous[55];
                Previous[56]    <=  Previous[56];
                Previous[57]    <=  Previous[57];
                Previous[58]    <=  Previous[58];
                Previous[59]    <=  Previous[59];
                Previous[60]    <=  Previous[60];
                Previous[61]    <=  Previous[61];
                Previous[62]    <=  Previous[62];
                Previous[63]    <=  Previous[63];

                Current[0]      <=  Current[0];
                Current[1]      <=  Current[1];
                Current[2]      <=  Current[2];
                Current[3]      <=  Current[3];
                Current[4]      <=  Current[4];
                Current[5]      <=  Current[5];
                Current[6]      <=  Current[6];
                Current[7]      <=  Current[7];
                Current[8]      <=  Current[8];
                Current[9]      <=  Current[9];
                Current[10]     <=  Current[10];
                Current[11]     <=  Current[11];
                Current[12]     <=  Current[12];
                Current[13]     <=  Current[13];
                Current[14]     <=  Current[14];
                Current[15]     <=  Current[15];
                Current[16]     <=  Current[16];
                Current[17]     <=  Current[17];
                Current[18]     <=  Current[18];
                Current[19]     <=  Current[19];
                Current[20]     <=  Current[20];
                Current[21]     <=  Current[21];
                Current[22]     <=  Current[22];
                Current[23]     <=  Current[23];
                Current[24]     <=  Current[24];
                Current[25]     <=  Current[25];
                Current[26]     <=  Current[26];
                Current[27]     <=  Current[27];
                Current[28]     <=  Current[28];
                Current[29]     <=  Current[29];
                Current[30]     <=  Current[30];
                Current[31]     <=  Current[31];
                Current[32]     <=  Current[32];
                Current[33]     <=  Current[33];
                Current[34]     <=  Current[34];
                Current[35]     <=  Current[35];
                Current[36]     <=  Current[36];
                Current[37]     <=  Current[37];
                Current[38]     <=  Current[38];
                Current[39]     <=  Current[39];
                Current[40]     <=  Current[40];
                Current[41]     <=  Current[41];
                Current[42]     <=  Current[42];
                Current[43]     <=  Current[43];
                Current[44]     <=  Current[44];
                Current[45]     <=  Current[45];
                Current[46]     <=  Current[46];
                Current[47]     <=  Current[47];
                Current[48]     <=  Current[48];
                Current[49]     <=  Current[49];
                Current[50]     <=  Current[50];
                Current[51]     <=  Current[51];
                Current[52]     <=  Current[52];
                Current[53]     <=  Current[53];
                Current[54]     <=  Current[54];
                Current[55]     <=  Current[55];
                Current[56]     <=  Current[56];
                Current[57]     <=  Current[57];
                Current[58]     <=  Current[58];
                Current[59]     <=  Current[59];
                Current[60]     <=  Current[60];
                Current[61]     <=  Current[61];
                Current[62]     <=  Current[62];
                Current[63]     <=  Current[63];
            end
        end
    end
endmodule
