% Definición de la función de transferencia
%-------------------------------------------------
s= tf('s')
G= (s+3)/(s*(s+1)*(s^2+4*s+16))
%-------------------------------------------------

coefnum=G.num{1}
coefden=G.den{1}

% Polos y ceros
zs = roots (coefnum)
ps = roots (coefden)
% Graficar los polos y ceros de lazo abierto
figure
v = [-6 6 -6 6]; axis (v); axis('square')
hold on; grid on;

yline(0, 'Color', 'k', 'LineWidth', 0.75);
xline(0, 'Color', 'k', 'LineWidth', 0.75);

plot(real(zs), imag(zs),'bo','Linewidth',2);
plot(real(ps), imag(ps),'rx','Linewidth',2);


%asintotas

n=length(ps)
m=length(zs)

k= 0:1:n-m-1

angulos= pi* (2*k+1)/(n-m);
angulosgrados=rad2deg(angulos)

%centroide
sigma0= (sum(real(ps))-sum(real(zs)))/(n-m)
plot(sigma0,0,'g-o');


%----------| ASINTOTAS | ------------------------------------------------

%CORTES DE LA ASINTOTA EN EJE IMAG
%-----------------------------------
x= 0;
y1_ejeimag= sqrt(3)*(x-sigma0)
y2_ejeimag=-y1_ejeimag

plot(0,y1_ejeimag,'kd');
plot(0,y2_ejeimag,'kd');
%-----------------------------------

%grafica de lineas de asintotas
%-----------------------------------
x=sigma0:0.1:6;

xa=-6:0.1:sigma0; % asintota horizontal
ya= zeros(1, length(xa));

y1=sqrt(3)*(x-sigma0);
y2=-y1;

plot(x,y1,'k-.');
plot(x,y2,'k-.');
plot(xa,ya,'k-.');
%-----------------------------------


%------------ | DERIVAR POLINOMIO |---------------------------------------
% se determina con ROUTH el valor de K para q este en eje imag
% luego se grafican los cortes en el eje con ese K.
%-----------------------------------
[B,A]= tfdata(G,'v');

term1= conv(B,polyder(A));
term2= conv(A,polyder(B));
max_length= max(length(term1),length(term2));

term1= [zeros(1,max_length-length(term1)),term1];
term2= [zeros(1,max_length-length(term2)),term2];


adyacentes= term1-term2;
psks=roots(adyacentes);
psks= psks(imag(psks)==0);
plot(real(psks),imag(psks),'ks');


jwint= roots([1 7 -1344]);
jwpol= [(84-jwint(2))/5 0 3*jwint(2)];

jwints= roots(jwpol);
%plot(real(jwints), imag(jwints),'ks');

%%-----------------------angulos de salida--------------------------------

pcc= ps(imag(ps)>0); 

angzs= zeros(1,length(zs));
angps= zeros(1,length(ps)-1);

j=1;

for i=1:length(ps)
    psi=ps(i);
    x=real(pcc)-real(psi);
    y=imag(pcc)-imag(psi);
    
    if (x==0)&& (y==0)
        continue;
    end
    
rel = y/x;
ang =rad2deg(atan(rel));
if ang<0
    ang=ang+180; 
end
angps(j)=ang;
j=j+1;

end

for i=1:length(zs)
    zsi=zs(i);
    x=real(pcc)-real(zsi);
    y=imag(pcc)-imag(zsi);
    
    if (x==0)&& (y==0)
        continue;
    end
    
rel = y/x;
ang =rad2deg(atan(rel));
if ang<0
    ang=ang+180;
    
end
angzs(j)=ang;
j=j+1;

end
tetha= 180-sum(angps)+sum(angzs)

%%-------------------fin-angulos de salida--------------------------------


%%----------------------| RLOCUS |-----------------------------------------
%--------------------------------------------------------------------------
r= rlocus(coefnum,coefden);
plot(r,'-','Linewidth',1.5)
title('Lugar geométrico de raíces')
xlabel('Real')
ylabel('Imaginario')
%--------------------------------------------------------------------------
