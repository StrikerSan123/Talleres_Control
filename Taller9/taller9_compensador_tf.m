%taller 9 - compensador en retraso.
s= tf('s');

R4=10E3;
R3=10E3;
R2=10E3;
R1=10E3;

C1= 1E-12;
C2= 1E-6;

G= R4/R3 * R2/R1 * (R1*C1*s+1)/(R2*C2*s+1);
w = logspace(1, 7, 1000);  
h = bodeplot(G,w);
setoptions(h, 'FreqUnits', 'Hz');  % Esto cambia las unidades del eje a Hz

[Gm, Pm, Wcg, Wcp] = margin(G);
fprintf('Gain Margin = %.2f dB at ω = %.2f rad/s\n', 20*log10(Gm), Wcg);
fprintf('Phase Margin = %.2f° at ω = %.2f rad/s\n', Pm, Wcp);
