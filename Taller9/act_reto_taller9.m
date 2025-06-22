

R = 100;         
L = 112.54E-3;      
C = 22.55E-6;       

s = tf('s');
H_hp = (L*C*s^2) / (L*C*s^2 + R*C*s + 1);  % Filtro pasa altas


H_pb = (R*C*s) / (L*C*s^2 + R*C*s + 1);    % Filtro pasa banda


w = logspace(1, 5, 1000);
figure;


h = bodeplot(H_pb,w);
setoptions(h, 'FreqUnits', 'Hz');  % Esto cambia las unidades del eje a Hz


[Gm, Pm, Wcg, Wcp] = margin(H_hp);
fprintf('Gain Margin = %.2f dB at ω = %.2f rad/s\n', 20*log10(Gm), Wcg);
fprintf('Phase Margin = %.2f° at ω = %.2f rad/s\n', Pm, Wcp);


% Obtener coeficientes numéricos del numerador y denominador
[num, den] = tfdata(H_pb, 'v');

% Crear el eje de frecuencia logarítmico
N=1000;
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
subplot(2,1,2);


% figura
subplot(2,1,1);
semilogx(f, mag, 'k', 'LineWidth', 1.5);
grid on;
ylabel('Magnitud (dB)');
title('Diagrama de Bode (sin usar bode())');

subplot(2,1,2);
semilogx(f, phase, 'k', 'LineWidth', 1.5);
grid on;
ylabel('Fase (°)');
xlabel('Frecuencia (Hz)');