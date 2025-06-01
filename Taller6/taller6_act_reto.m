Kp=14.65;
Ki= 1138.92;
Kd= 0.0355;
%RLC serie
R = 5;
L = 0.1;
Cap = 220e-6;
%Vc como salida
num= 1/(L*Cap);
den=[1 R/L 1/(L*Cap)];
Gplanta=tf(num,den)


Gp=tf(Kp,[0 1]) %proporcional
Gi=tf(Ki,[1 0]) % integral
Gd=tf([Kd 0],[0 1]) % derivartivo

G1= parallel(Gp,Gi);
G2= parallel(G1,Gd);

G3= series(G2,Gplanta) %tf lazo abierto

Gs=feedback(G3,1) % tf de lazo cerrado

subplot(1,2,1);   
step(Gs)

polos=pole(Gs)
polos2= roots(Gs.den{1})%saca los polos. La entrada es el denominador.

subplot(1,2,2);
pzmap(Gs);

%para sacar polos
coefsden=Gs.den{1}

