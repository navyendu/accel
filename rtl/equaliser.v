
module equaliser(Ex1,Ex2,mant1,mant2,dataout1,dataout2,Ex,comp);
input[7:0]Ex1,Ex2;
input[24:0]mant1,mant2;
output[7:0]Ex;
output[24:0] dataout1,dataout2;
output comp;                                 //Comparator for comparing exponents
wire[24:0] datain_t;
wire[4:0]shift_t;
wire[7:0]s1,s2,s3;
assign s1=comp?Ex1:Ex2;
assign s2=comp?Ex2:Ex1;
assign comp=Ex1>Ex2;
assign s3 =s1-s2;
assign shift_t=(s3>5'd24)?5'd24:s3;
assign datain_t=comp?mant2:mant1;
assign dataout2=~comp?mant2:mant1;
assign Ex=comp?Ex1:Ex2;
assign dataout1=datain_t>>shift_t;


endmodule
