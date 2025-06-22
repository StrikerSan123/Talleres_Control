clc; clear; close all;

% Parámetros del sistema RLC
R = 10;
L = 1e-3;
C = 100e-6;

% Definición de la función de transferencia
s = tf('s');
G = (1/(L*C)) / (s^2 + R*s/L + 1/(L*C));

% Obtener coeficientes numéricos del numerador y denominador
[num, den] = tfdata(G, 'v');

% Crear el eje de frecuencia logarítmico
N=1000;

w= logspace(1,7,N);%/(2*pi);
jw = 1j * w;

% Evaluar numerador y denominador en s = jω
N = polyval(num, jw);
D = polyval(den, jw);

% Evaluar G(jw)
Gjw = N ./ D;

% Magnitud en dB
mag = 20 * log10(abs(Gjw));

% Fase en grados
phase = angle(Gjw) * (180 / pi);

% Graficar Bode
f=w/(2*pi); % si queremos en Hz colocar 'f' en la grafica.
figure;

subplot(2,1,1);
semilogx(w, mag, 'k', 'LineWidth', 1.5);
grid on;
ylabel('Magnitud (dB)');
title('Diagrama de Bode (sin usar bode())');

subplot(2,1,2);
semilogx(w, phase, 'k', 'LineWidth', 1.5);
grid on;
ylabel('Fase (°)');
xlabel('Frecuencia (rad/s)');
