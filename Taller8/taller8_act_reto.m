% Definición de la función de transferencia
%-------------------------------------------------
s= tf('s')
R=22;
L=500E-6;
C=220E-6;

G= (1/(L*C))/(s^2 + R*s/L + 1/(L*C))
%-------------------------------------------------
num= G.num{1};
den=G.den{1};

%open loop
zerosol= roots(num);
polosol=roots(den);


figure;
subplot(2,1,1)
step(G);grid on;
title('Respuestra transitoria RLC');
subplot(2,1,2)
rlocus(G);
title('LGR del circuito RLC');
% Se quiere un Mp=25% y un ts=50ms
Mp=0.25;
ts=50E-3;

sera= (log(1/Mp))/(sqrt(pi^2+log(1/Mp)^2))

wn= 4/(ts*sera)

% polonomio caracteristico cl del compensador

raizcompen=roots([1 2*sera*wn wn^2])


%ejercicio 2.2 Replicar grafica
figure;

plot(real(raizcompen), imag(raizcompen),'rx','Linewidth',2); hold on;
rlocus(G)
title('LGR del circuito RLC');

%ejercicio 2.3 Compensador adelanto

% se coloca el cero en el polo mas lejano.

polocompen= raizcompen(imag(raizcompen)>0)
zerocompen= min(real(polosol))
angzcompen= zeros(1,1);

angpol= zeros(1,length(G.den{1})-1);

j=1;
%polos
for i=1:length(angpol)
    psi=polosol(i);
    x=real(polocompen)-real(psi);
    y=imag(polocompen)-imag(psi);
    
    if (x==0)&& (y==0)
        continue;
    end
    
rel = y/x;
ang =rad2deg(atan(rel));
if ang<0
    ang=ang+180; 
end
angpol(j)=ang;
j=j+1;

end

%cero del compensador situado en el polo mas lejano
for i=1:length(angzcompen)
    zsi=zerocompen(i);
    x=real(polocompen)-real(zsi);
    y=imag(polocompen)-imag(zsi);
    
    if (x==0)&& (y==0)
        continue;
    end
    
rel = y/x;
ang =rad2deg(atan(rel));
if ang<0
    ang=ang+180;
    
end
angzcompen(j)=ang;
j=j+1;

end
tetha4= 180-sum(angpol)+sum(angzcompen)

%%-------------------fin-angulos para compen--------------------------------


%--------------distancia polo y cero del compensador en adelanto-----------

dispolocompen = -abs(imag(polocompen))/tan(deg2rad(tetha4)) + real(polocompen)

zerocompen;
%----------------------------------------------------------------------------


%TF DEL COMPENSADOR

Kcunit=1;
Gc= Kcunit* (s-zerocompen)/(s-dispolocompen)


%grafica 2
figure;
G1= series(G,Gc);
plot(real(raizcompen), imag(raizcompen),'rx','Linewidth',2); hold on
rlocus(G1)
title('LGR del circuito RLC ya compensado');
% obtener Kc
% usando condicion de magnitud |G*Gc*H|=1 donde H es Kb
Gmag= G1*1;
Kc= 1/ abs(evalfr(Gmag,polocompen)) 


%finalmente se obtiene la funcion de transferencia compensada

Gfinal= feedback(series(Kc,G1),1);

 figure;
 step(Gfinal);
title('Respuestra transitoria RLC con compensador');
    





