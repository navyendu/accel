component vdc < t0, t1> ( V )
{
    voltage <t0, t1> = V;
}

component resistor < t0, t1> ( R )
{
    voltage <t0, t1> = current <t0> * R;
}

component capacitor <t0, t1> ( C , V0 )
{
    current <t0> = C * diff( voltage<t1, t2> , V0);
}

main
{
    node        n1, n2, n3;
    
    vdc         < n1, gnd>  Vs  ( 5 );
    resistor    < n1, n3>   R1  ( 1e3 );
    capacitor   < n3, n2>   C1 ( 23, 8);
    resistor    < n2, gnd>  R2  ( 2e3 );
    capacitor   < n2, gnd>  C   ( 1e-6, 2);
    
    probe       voltage <n2, gnd>;
    probe       current <R1.t0>;
    probe       current <R2.t0>;
    probe       current <C.t0>;
}
