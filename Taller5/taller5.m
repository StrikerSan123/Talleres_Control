%RLC serie
R = 5;
L = 0.1;
Cap = 220e-6;
%Vc como salida

num= 1/(L*Cap);

den=[1 R/L 1/(L*Cap)];


tf(num,den)



