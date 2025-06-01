import numpy as np
import matplotlib.pyplot as plt
import control as ctrl

#---- Parámetros del PID--------------
Kp = 14.65
Ki = 1138.92
Kd = 0.0355
# ------------------------------------
#-- Parámetros del sistema RLC serie--
R = 5
L = 0.1
Cap = 220e-6
# ------------------------------------
# Función de transferencia de la planta
num = [1 / (L * Cap)]
den = [1, R / L, 1 / (L * Cap)]
Gplanta = ctrl.tf(num, den)
# ------------------------------------

# Controlador PID (Proporcional, Integral, Derivativo)
Gp = ctrl.tf([Kp], [0, 1])
Gi = ctrl.tf([Ki], [1, 0])
Gd = ctrl.tf([Kd, 0], [1])

G1 = ctrl.parallel(Gp, Gi)
G2 = ctrl.parallel(G1, Gd)

#  lazo abierto: PID * planta
G3 = ctrl.series(G2, Gplanta)

#  lazo cerrado 
Gs = ctrl.feedback(G3, 1)
# ------------------------------------


# Obtener polos y ceros
polos = ctrl.poles(Gs)
ceros = ctrl.zeros(Gs)
coefsden = Gs.den[0][0]
polos2 = np.roots(coefsden)

print("Polos:", polos)
print("Polos (usando np.roots):", polos2)

# GRAFICO
fig, axs = plt.subplots(1, 2, figsize=(12, 5))

# Subplot 1: Respuesta al escalón
t, y = ctrl.step_response(Gs)
axs[0].plot(t, y)

axs[0].axhline(0, color='black', linewidth=0.75) #modifica color y grosor de ejes
axs[0].axhline(1, linestyle='--',color='black', linewidth=0.75)
axs[0].axvline(0, color='black', linewidth=0.75)

axs[0].set_title('Respuesta al Escalón')
axs[0].set_xlabel('Tiempo [s]')
axs[0].set_ylabel('Salida')
axs[0].grid(True)

# Subplot 2: Mapa de polos y ceros

# ctrl.pzmap(Gs, plot=True, grid=False) #hace el mapa, pero no se puede poner en subplots.

# ----- Calcular límites con margen ------
real_parts = np.real(np.concatenate((polos, ceros)))
imag_parts = np.imag(np.concatenate((polos, ceros)))

real_margin =  np.max(np.abs(real_parts)) + 10
imag_margin = np.max(np.abs(imag_parts)) + 500

axs[1].set_xlim(np.min(real_parts) - real_margin, np.max(real_parts) + real_margin)
axs[1].set_ylim(np.min(imag_parts) - imag_margin, np.max(imag_parts) + imag_margin)
# ---- Fin Calcular límites con margen ------


axs[1].scatter(np.real(polos2), np.imag(polos2), marker='x', color='red', label='Polos')
axs[1].scatter(np.real(ceros), np.imag(ceros), marker='o', color='blue', label='Ceros')

axs[1].axhline(0, color='black', linewidth=0.75)#modifica color y grosor de ejes
axs[1].axvline(0, color='black', linewidth=0.75)

axs[1].set_title('Mapa de Polos y Ceros')
axs[1].set_xlabel('Re')
axs[1].set_ylabel('Im')
axs[1].legend()
axs[1].grid(True)


plt.tight_layout()
plt.show()
