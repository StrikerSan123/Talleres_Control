import numpy as np
import matplotlib.pyplot as plt
from control import tf, tfdata, rlocus
from numpy import roots, real, imag, polyder, convolve, pad, pi, rad2deg

# Definición de la función de transferencia
#-------------------------------------------------
s = tf('s')
G = (s + 3) / (s * (s + 1) * (s**2 + 4*s + 16))
#-------------------------------------------------

# Crear figura antes de llamar rlocus
plt.figure(figsize=(8, 8))
plt.axis([-6, 6, -6, 6])
plt.axis('square')
plt.grid(True)
plt.axhline(0, color='k', linewidth=0.75)
plt.axvline(0, color='k', linewidth=0.75)

# Llamar rlocus y dejar que grafique sobre la figura actual
rlocus(G)  # grafica directamente en la figura activa

# Obtener coeficientes en forma de arrays
num, den = tfdata(G)
coefnum = np.array(num[0][0])
coefden = np.array(den[0][0])

# Polos y ceros
zs = roots(coefnum)
ps = roots(coefden)

# Graficar polos y ceros
plt.plot(real(zs), imag(zs), 'bo', ms=8, label='Ceros ')
plt.plot(real(ps), imag(ps), 'rx', ms=8, label='Polos ')

# Asíntotas
n = len(ps)
m = len(zs)
num_asint = n - m
k_indices = np.arange(num_asint)
ang_asint = pi * (2*k_indices + 1) / num_asint
ang_asint_deg = rad2deg(ang_asint)
print("Ángulos de asíntotas (en grados):", ang_asint_deg)

# Centroide
sigma0 = (np.sum(real(ps)) - np.sum(real(zs))) / num_asint
plt.plot(sigma0, 0, 'go', ms=8, label='Centroide (σ₀)')

# Dibujar asíntotas
longitud = 10
for ang in ang_asint:
    x_vals = np.linspace(0, longitud, 100)
    x_eje = sigma0 + x_vals * np.cos(ang)
    y_eje = x_vals * np.sin(ang)
    plt.plot(x_eje, y_eje, 'k--', linewidth=1)

# Cortes con eje imaginario aproximados
y1 = np.sqrt(3) * (0 - sigma0)
y2 = -y1
plt.plot(0, y1, 'kd', ms=6, label='Intersecciones eje jω')
plt.plot(0, y2, 'kd', ms=6)

# Derivada  para puntos reales

# se encuentran los puntos de llegada (eje real)
term1 = convolve(coefnum, polyder(coefden))
term2 = convolve(coefden, polyder(coefnum))
max_len = max(len(term1), len(term2))
term1 = pad(term1, (max_len - len(term1), 0))
term2 = pad(term2, (max_len - len(term2), 0))
adyacentes = term1 - term2
psks = roots(adyacentes)
psks_reales = psks[np.isreal(psks)].real
plt.plot(psks_reales, np.zeros_like(psks_reales), 'ks', ms=8, label='P-llegada e intersección')

# Cortes eje jw de las geometrias.
jwint = roots([1, 7, -1344])
jwpol = [ (84 - jwint[1]) / 5, 0, 3 * jwint[1] ]
jwints = roots(jwpol)
plt.plot(jwints.real, jwints.imag, 'ks', ms=8)

# Ángulo de salida
pcc_list = ps[np.imag(ps) > 0]
if pcc_list.size > 0:
    pcc = pcc_list[0]
    ang_contrib_p = []
    ang_contrib_z = []
    for p in ps:
        if np.isclose(p, pcc):
            continue
        dx, dy = np.real(pcc - p), np.imag(pcc - p)
        ang = rad2deg(np.arctan2(dy, dx))
        if ang < 0:
            ang += 180
        ang_contrib_p.append(ang)
    for z in zs:
        dx, dy = np.real(pcc - z), np.imag(pcc - z)
        ang = rad2deg(np.arctan2(dy, dx))
        if ang < 0:
            ang += 180
        ang_contrib_z.append(ang)
    theta = 180 - sum(ang_contrib_p) + sum(ang_contrib_z)
    print("Ángulo de salida (θ) para el polo complejo:", theta)
else:
    print("No hay polos complejos en semiplano superior para calcular ángulo de salida.")

# Etiquetas finales
plt.legend(loc='upper right')
plt.title("Lugar geométrico de las raíces G(s)")
plt.xlabel("Re(s)")
plt.ylabel("Im(s)")
plt.show()
