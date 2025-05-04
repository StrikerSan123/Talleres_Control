import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.integrate import odeint
from scipy.signal import StateSpace, lsim, step, impulse

# --- PARTE 1: Parámetros del circuito ---
R = 100           # Ohmios
L = 0.1           # Henrios
Cap = 1e-6        # Faradios

# Matrices del sistema EE
A = np.array([[0, 1],
              [-1/(L*Cap), -R/L]])
B = np.array([[0],
              [1/L]])
C = np.array([[1/Cap, 0]])
D = 0

# Crear el sistema EE
sys = StateSpace(A, B, C, D)


# --- Gráficas de respuesta al escalón e impulso ---
t = np.linspace(0, 0.01, 1000)
_, y_step = step(sys, T=t)
_, y_imp = impulse(sys, T=t)

plt.figure(figsize=(10, 6))
plt.subplot(2, 1, 1)
plt.plot(t, y_step)
plt.xlabel('Time [s]')
plt.ylabel('Vc [V]')
plt.title('Respuesta al escalón')

plt.subplot(2, 1, 2)
plt.plot(t, y_imp)
plt.xlabel('Time [s]')
plt.ylabel('Vc [V]')
plt.title('Respuesta al impulso')
plt.tight_layout()
plt.grid()
plt.show()



# --- PARTE 2: Simulación con odeint---
def modelRLC(x, t, A, B, u):
    dex = A @ x + B.flatten() * u  # Multiplicación escalar por u
    return dex

ts = 0.015
tspan = np.linspace(0, ts, 1000)
x0 = [0, 0]
u_const = 1
X = odeint(modelRLC, x0, tspan, args=(A, B, u_const))
y = (C @ X.T).flatten() + D * u_const

plt.figure()
plt.plot(tspan, y)
plt.xlabel('Time [s]')
plt.ylabel('Vc [V]')
plt.title('Respuesta con entrada constante (1V)')
plt.grid()
plt.show()

# --- PARTE 3: Respuesta a señal arbitraria por tramos ---

datos= 'senal_arbitraria.csv'

# Leer el archivo
data = pd.read_csv(datos)

time=data['time']
arbsig=data['signal']
N=len(time)

# Simulación paso a paso con odeint
X1 = np.zeros((N, 2))
x_prev = np.array([0, 0])

for k in range(1, N):
    u_k = arbsig[k - 1]
    t_local = [time[k - 1], time[k]]
    Xk = odeint(modelRLC, x_prev, t_local, args=(A, B, u_k))
    x_prev = Xk[-1]
    X1[k, :] = x_prev

# Calcular la salida
y1 = (C @ X1.T).flatten() + D * arbsig

# Graficar resultado
plt.figure()
plt.plot(time, y1, linewidth=1.5)
plt.xlabel('Time [s]')
plt.ylabel('Vc [V]')
plt.title('Respuesta a señal escalonada por tramos')
plt.grid()
plt.show()
