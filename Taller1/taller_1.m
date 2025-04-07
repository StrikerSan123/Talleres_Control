% Importar datos
data = readtable('data_motor.csv');
 
% Extraer señales
time = data.time;        % eje x
in = data.ex_signal;     % eje y - entrada
out = data.system_response; % eje y - Respuesta del proceso


%cuerpo

%sacar datos mediante media. (señal 100)
maximos = data.system_response(data.time>=2);
media = mean(maximos);
senal100 = mean(maximos) * ones(size(time));

%sacar señal base
senal0 = min(out) * ones(size(time));

%valor en que inicia el experimento
inicio= data.time(find(data.ex_signal ~= 0, 1));
%puntos arbitrarios para pendiente
x1= 0.5;
x2= 0.4;
y2=data.system_response(x2-0.01<=data.time & data.time <=x2+0.01);
y1=data.system_response(x1-0.01<=data.time & data.time<=x1+0.01);
pendiente= (y2-y1)/(x2-x1);

%recta tangente
xhigh=(media-y1)/pendiente +x1 -inicio;
xlow=(min(out)-y1)/pendiente +x1 -inicio;
t= linspace(xlow,xhigh,100);
rtan = pendiente*(t-x1)+y1;

%Ziegler y nichols
K= media/max(in);
theta= xlow;
tau=xhigh-xlow;
G = tf(K,[tau 1], 'InputDelay', theta);
y = lsim(G,in, time);

%miller

ymiller=0.6321*media;
taumiller= data.time(data.system_response>= ymiller-0.01 & data.system_response<= ymiller+0.01)-theta;
G2 =  tf(K,[taumiller 1], 'InputDelay', theta);
y2 = lsim(G2,in, time);

%analitico
yan= 0.284*media;
x63= data.time(data.system_response>= ymiller-0.01 & data.system_response<= ymiller+0.01)-inicio;
x28= data.time(data.system_response>= yan-0.01 & data.system_response<= yan+0.01)-inicio;
tauan=1.5*(x63-x28);
thetan= x63-tauan;
G3 =  tf(K,[tauan 1], 'InputDelay', thetan);
y3 = lsim(G3,in, time);


% Plot 
figure;
plot(time, in, 'Color',	"#77AC30", 'LineWidth', 1.5); % entrada
hold on;
plot(time, out, 'Color', '#FF5733', 'LineWidth', 1.5); % salida

plot(time, senal100, '--k', 'LineWidth', 1); % señal 100
plot(time, senal0, '--r', 'LineWidth', 1); % señal 0
plot(t, rtan, '--b','LineWidth', 1.5); % salida

plot(time, y, 'Color',	"#9200FF",'LineWidth', 1.5); % salida
plot(time, y2, 'Color',	"#EDB000",'LineWidth', 1.5); % salida
plot(time, y3, 'Color',	"#4DBFEE",'LineWidth', 1.5); % salida

% Labels
title('Señales vs. Tiempo');
xlabel('Tiempo [s]');
ylabel('Señales');
%legend('Escalón', 'Respuesta del proceso');
legend('Escalón', 'Respuesta del proceso',['Línea Estable: '  num2str(mean(maximos))],['Línea Base: ' num2str(min(out)) ],'Tangente','Ziegler y Nichols', 'Miller','Analítico');
grid on;