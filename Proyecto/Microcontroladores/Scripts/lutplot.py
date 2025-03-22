import numpy as np
import matplotlib.pyplot as plt

# Parámetros de la LUT
N = 1000  # Número de puntos
A = 1000  # Amplitud
C = 1000  # Centro
theta = np.linspace(0, 2*np.pi, N, endpoint=False)  # Ángulos de 0 a 2pi

# Generar las tres fases defasadas 120° y 240°
lut = (A * np.sin(theta) + C).astype(np.uint16)

plt.plot(lut)
plt.title('LUT Values')
plt.xlabel('Index')
plt.ylabel('Value')
plt.show()