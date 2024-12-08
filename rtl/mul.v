module mul(in1,in2,result);
    input[31:0]in1,in2;
    output[31:0] result;
    wire[23:0]pro,carry;
    reg[23:0]a1,a2;
    reg[22:0]sum2;
    reg[7:0]e1,e2,sum3,sum4;
    reg s;
    wire[7:0]sum;
    assign {carry,pro}=a1[23:0]*a2[23:0];
    assign sum=e1+e2-8'd127;
    assign result={s,sum4,sum2};

    always@(in1,in2)
    begin
        if(!(in1[30]|in1[29]|in1[28]|in1[27]|in1[26]|in1[25]|in1[24]|in1[23]))
        begin
            a1={1'b0,in1[22:0]};
            e2=8'h7f;
        end
        else
        begin
            a1={1'b1,in1[22:0]};
            e2=in2[30:23];
        end

        if(!(in2[30]|in2[29]|in2[28]|in2[27]|in2[26]|in2[25]|in2[24]|in2[23]))
        begin
            a2={1'b0,in2[22:0]};
            if(!(in1[30]|in1[29]|in1[28]|in1[27]|in1[26]|in1[25]|in1[24]|in1[23]))                e1=8'h00;            else                e1=8'h7f;
        end
        else
        begin
            a2={1'b1,in2[22:0]};
            e1=in1[30:23];
        end
       
        if(in1[31]==in2[31])
            s=1'b0;
        else
            s=1'b1;
    end

    always @(carry,sum,pro)
    begin
        sum3=sum;

        if(carry[23]==0)
        begin
            sum2={carry[21:0],pro[23]};
            sum4 = sum3;
        end
        else
        begin
            sum2=carry[22:0];
            sum4=sum3+1;
        end
    end
endmodule
