import numpy as np
import control as ctrl
import matplotlib.pyplot as plt


# Definir la función de transferencia del sistema
num = [3.5] 
den = [1, 2, 3.5]  # Denominador: s^2 + 2s + 3.5
Gs = ctrl.TransferFunction(num, den)

# Definir los parámetros del tiempo
tpaso = 0.1  
time = np.arange(0, 50 + tpaso, tpaso)  # Vector de tiempo desde 0 hasta 50 con paso de 0.1
N = len(time)  # Número de puntos
sizev = round(N / 5)  # nsegmentos 


# Crear la señal arbitraria
b1 = np.linspace(0, 10, sizev)#rampa up
b2 = np.linspace(10, 5, sizev)#rampa down
b3 = np.ones(sizev) * 10 #escalon up
b4 = np.zeros(sizev + 1)#cerosescalon down
b5 = np.linspace(2, 1, sizev) #rampa
arbsig = np.concatenate([b1, b2, b3, b4, b5])  # unir



# Obtener la respuesta del sistema a la señal arbitraria
tbase, retoarb = ctrl.forced_response(Gs, T=time, U=arbsig)

# Introducir un delay 
delay = 2  
delay_samples = int(delay / tpaso)  # Calcular el número de muestras correspondientes al retardo
#concatena, escoge los valores del inicio hasta la longitud de tiempo
retoarb = np.concatenate((np.zeros(delay_samples), retoarb))[:len(time)]  # Añadir ceros al inicio

# Graficar
plt.figure(figsize=(12, 6))

# Primer subplot: Señal arbitraria vs tiempo
plt.subplot(1, 2, 1)
plt.plot(time, arbsig, '--b', linewidth=1.5)
plt.grid()
plt.title('Señal arbitraria vs. Tiempo')
plt.xlabel('Tiempo [s]')
plt.ylabel('Señal')

# 2: Respuesta del sistema (con y sin delay) y señal arbitraria
plt.subplot(1, 2, 2)
plt.plot(time, retoarb, '-r', linewidth=1.5, label='Respuesta con delay (2 s)')
plt.plot(time, arbsig, '--b', linewidth=1.5, label='Señal arbitraria')
plt.grid()
plt.title('Respuesta a la señal arbitraria')
plt.xlabel('Tiempo [s]')
plt.ylabel('Señal')
plt.legend()

plt.tight_layout() #para que se visualicen bien labels,titulos.
plt.show()



