module add1(adder_in1,adder_in2,adder_sum);
    input[31:0]adder_in1,adder_in2;
    output[31:0]adder_sum;
    wire sign1,sign2;
    reg[24:0] mant1_t,mant2_t;
    wire[7:0] Ex1_t,Ex2_t;
    wire[24:0]  dataout1_t,dataout2_t,xor1,xor2;
    wire[7:0] exponent,finalex;
    wire[24:0]finalsum;
    wire[24:0]encod_in;
    wire[4:0] encod_out;
    wire comp,sign;
    reg s1,s2;
    wire p1,p2;

    //Equaliser for equalising exponent
    equaliser  e1(.Ex1(Ex1_t),.Ex2(Ex2_t), .mant1(mant1_t), .mant2(mant2_t),
                  .dataout1(dataout1_t),.dataout2(dataout2_t),.Ex(exponent),.comp(comp));
    assign p1=comp?s2:s1;
    assign p2=comp?s1:s2;		
    
    //Encoder for leading zero detector
    encoder   enc1(.encod_in(encod_in),.encod_out(encod_out));
    wire compbit; 
    wire[24:0]  result;
    wire [24:0] adderout,sum;
    wire[24:0]  complement;
    xor x1[24:0](xor1,dataout1_t,p1);     //Complementing in case of subtraction.
    xor x2[24:0](xor2,dataout2_t,p2);
    assign sign1=adder_in1[31];
    assign sign2=adder_in2[31];


    always@(adder_in1,adder_in2)                 //Concatenating 0 or 1.
    begin
    	if((!(adder_in1[30]|adder_in1[29]|adder_in1[28]|adder_in1[27]|
	          adder_in1[26]|adder_in1[25]|adder_in1[24]|adder_in1[23])))
        	mant1_t={2'b00,adder_in1[22:0]};
    	else
	        mant1_t={2'b01,adder_in1[22:0]};

	    if(!(adder_in2[30]|adder_in2[29]|adder_in2[28]|adder_in2[27]|
	         adder_in2[26]|adder_in2[25]|adder_in2[24]|adder_in2[23]))
        	mant2_t={2'b00,adder_in2[22:0]};
    	else
        	mant2_t={2'b01,adder_in2[22:0]};
    end

    assign sum=xor1+xor2+p1;
    assign adderout=sum+p2;//adder|subtractor.
    assign Ex1_t=adder_in1[30:23];
    assign Ex2_t=adder_in2[30:23];
    assign compbit=(s1|s2)&(adderout[24]);  //Condition for complementing the result.
    xor x3[24:0](complement,adderout,compbit);//Complementing the result.
    assign result=complement+compbit;
    assign finalex=exponent-encod_out+1'b1;
    assign sign=(sign1&sign2)|compbit;        //final exponent
    assign adder_sum={sign,finalex,finalsum[23:1]};  //final sum
    assign finalsum =result<<encod_out;                               //left shift the exponent
    assign encod_in=result;

    always@(sign1,sign2)
    begin

        if(sign1==sign2)
        begin
            s1=1'b0;
            s2=1'b0;
        end
        else
        begin
            s1=sign1;
            s2=sign2;
        end
    end
    //result sent to encoder if carry not set in case of addition
endmodule
