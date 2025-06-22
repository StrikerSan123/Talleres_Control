
%taller 9
s= tf('s')
R=10;
L=1E-3;
C=100E-6;
G= (1/(L*C))/(s^2 + R*s/L + 1/(L*C))


N=100;

w= logspace(-1,7,N);%/(2*pi);

bode(G,w);

