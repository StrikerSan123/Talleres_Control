num=[3.5];
den=[1 2 3.5];
tpaso=2;
Gs=tf(num,den,'InputDelay',tpaso); 


[y1,t1] = step(Gs);
[y2,t2]= impulse(Gs);

% ymax, indice
[my1,id1]= max(step(Gs)); 
mx1=t1(id1);
[my2,id2]= max(impulse(Gs));
mx2=t2(id2);

%posiciones para encontrar t
pos1= find(y1 ~= 0, 1);
pos2= find(y2 ~= 0, 1);
%tiempo el que sistemas responden
inicio1= t1(pos1);
inicio2= t2(pos2);

%graficas
%  subplot(2,1,1);
%  plot(t1,y1);
%  hold on;
%  plot(mx1,my1,'o-r')
%  title('Respuesta al escalón');
%  subplot(2,1,2);
%  plot(t2,y2);
%  hold on;
%  plot(mx2,my2,'o-r')
% title('Respuesta al impulso');
% xlabel('Tiempo');


%parte 2 s arbitrarias

tpaso=0.1;
time=0:tpaso:30;
time=time';
N=length(time);
sizev= int32(N/3);

%s arbitraria
s1=zeros(1,sizev);
s2=ones(1,sizev)*5;
s3=ones(1,sizev+1)*10;

arbsig= [s1 s2 s3]';

retoarb=lsim(Gs,arbsig,time);

figure;
subplot(1,2,1);
plot(time,arbsig,'--b','LineWidth',1.5);
grid on;
title('Señal arbitraria vs. Tiempo');
xlabel('Tiempo [s]');
ylabel('Señal');
subplot(1,2,2);
plot(time,retoarb,'-r','LineWidth',1.5);
hold on;
plot(time,arbsig,'--b','LineWidth',1.5);
grid on;
title('Respuesta a la señal arbitraria');
legend( 'Respuesta del proceso','Señal arbitraria');
xlabel('Tiempo [s]');
ylabel('Señal');


%segunda s arbitraria
tpaso=0.1;
time=0:tpaso:40;
time=time';
N=length(time);
sizev= round(N/4);

%s arbitraria
s4=zeros(1,sizev);
s5=ones(1,sizev)*5;
s6=linspace(15,25,sizev);
s7=ones(1,sizev+1)*25;
arbsig= [s4 s5 s6 s7]';

retoarb=lsim(Gs,arbsig,time);

figure;
subplot(1,2,1);
plot(time,arbsig,'--b','LineWidth',1.5);
grid on;
title('Señal arbitraria vs. Tiempo');
xlabel('Tiempo [s]');
ylabel('Señal');
subplot(1,2,2);
plot(time,retoarb,'-r','LineWidth',1.5);
hold on;
plot(time,arbsig,'--b','LineWidth',1.5);
grid on;
title('Respuesta a la señal arbitraria');
legend( 'Respuesta del proceso','Señal arbitraria');
xlabel('Tiempo [s]');
ylabel('Señal');



%actividad reto


tpaso=0.1;
time=0:tpaso:50;
time=time';
N=length(time);
sizev= round(N/5);

%s arbitraria
b1=linspace(0,10,sizev);
b2=linspace(10,5,sizev);
b3=ones(1,sizev)*10;
b4=zeros(1,sizev+1);
b5=linspace(2,1,sizev);
arbsig= [b1 b2 b3 b4 b5]';

retoarb=lsim(Gs,arbsig,time);

figure;
subplot(1,2,1);
plot(time,arbsig,'--b','LineWidth',1.5);
grid on;
title('Señal arbitraria vs. Tiempo');
xlabel('Tiempo [s]');
ylabel('Señal');
subplot(1,2,2);
plot(time,retoarb,'-r','LineWidth',1.5);
hold on;
plot(time,arbsig,'--b','LineWidth',1.5);
grid on;
title('Respuesta a la señal arbitraria');
legend( 'Respuesta del proceso','Señal arbitraria');
xlabel('Tiempo [s]');
ylabel('Señal');

