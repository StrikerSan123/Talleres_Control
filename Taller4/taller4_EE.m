%Parámetros del circuito

R = 100; % Resistencia (ohmios)
L = 0.1; % Inductancia (henrios)
Cap = 1e-6; % Capacitancia (faradios)
A = [0 1; -1/(L*Cap) -R/L]; % Matriz de Estado
B = [0; 1/L]; % Matriz de Entrada
C = [1/Cap 0    ]; % Matriz de Salida
D = 0; % Matriz de Transferencia directa
Ci = [1/Cap 0; 0 1];

sys = ss(A,B,C,D);
%sys2 = ss(A,B,Ci,D); si quiero  2 tfun.
subplot(2,1,1);
step(sys);
xlabel('Time [s]'); ylabel('Vc [V]');
subplot(2,1,2);
impulse(sys);
xlabel('Time [s]'); ylabel('Vc [V]');


%PARTE 2 ODE45

ts = 0.015; % Tiempo de simulación
tspan = [0 ts];
u = 1; % Voltaje de entrada
x0 = [0; 0]; % Condiciones iniciales
[t, X] = ode45(@(t,x) modelRLC(t, x, A, B, u), tspan, x0);
y = C * X.' + D * u;

figure;
plot(t,y)
xlabel('Time [s]'); ylabel('Vc [V]');


% PARTE 3 - RESPUESTA A SEÑALES ARBITRARIAS (CORREGIDO)

tpaso = 0.0001;
time = 0:tpaso:0.05;
time = time';
N = length(time);

% Crear la señal escalonada por tramos
sizev = floor(N / 3);
s1 = zeros(sizev, 1);
s2 = ones(sizev, 1) * 5;
s3 = ones(N - 2 * sizev, 1) * 10;
arbsig = [s1; s2; s3];

% Inicializar vector de estados
X1 = zeros(N, 2);  % Dos estados
x_prev = [0; 0];   % Estado inicial

% Iteración para resolver el sistema paso a paso
for k = 2:N
    u_k = arbsig(k - 1);  % Entrada constante en este intervalo
    t_local = [time(k-1), time(k)];
    
    % Resolver ecuación diferencial para este paso
    [~, Xk] = ode45(@(t, x) modelRLC(t, x, A, B, u_k), t_local, x_prev);
    
    % Guardar último estado y usarlo como inicial para el siguiente paso
    x_prev = Xk(end, :)';
    X1(k, :) = x_prev';
end

y1 = (C * X1')' + D * arbsig;
%y1 = lsim(sys, arbsig, time); tambien se puede usar este comando

% Graficar salida
figure;
plot(time, y1, 'LineWidth', 1.5);
xlabel('Time [s]');
ylabel('Vc [V]');
title('Respuesta del sistema RLC a señal escalonada por tramos');
grid on;


function dx = modelRLC(t, x, A, B, u)
dx = A * x + B * u; % Ecuación de Estado
end



