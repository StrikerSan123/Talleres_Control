import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# --- Parámetros-----
t_step = 0.0001 # Paso de tiempo
t_total = 0.05  # Tiempo total
time = np.arange(0, t_total + t_step, t_step)
N = len(time)

# Crear señal arbitraria
sizev = N // 3
s1 = np.zeros(sizev)
s2 = np.ones(sizev)*5
s3 = np.ones(N - 2 * sizev) * 10
signal = np.concatenate([s1, s2, s3])

# --- Guardar en archivo CSV ---
data = pd.DataFrame({
    'time': time,
    'signal': signal
})

csv_filename = 'senal_arbitraria.csv'
data.to_csv(csv_filename, index=False)

print(f"Archivo guardado como '{csv_filename}'")

# -- Gráfico de chequeo --
plt.plot(time, signal)
plt.xlabel('Time [s]')
plt.ylabel('Signal [V]')
plt.title('Señal arbitraria generada')
plt.grid(True)
plt.show()
