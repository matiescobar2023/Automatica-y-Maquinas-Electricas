import numpy as np
import matplotlib.pyplot as plt

def plot_poles(coefficients):
    """
    Grafica los polos de un polinomio característico dado por sus coeficientes.

    Parameters:
    coefficients (list or array-like): Coeficientes del polinomio característico,
                                       ordenados desde el término de mayor grado hasta el término independiente.
    """
    # Encontrar las raíces del polinomio (los polos)
    poles = np.roots(coefficients)
    
    # Configurar la figura y los ejes
    plt.figure(figsize=(8, 8))
    plt.axhline(0, color='black', linewidth=0.5)
    plt.axvline(0, color='black', linewidth=0.5)
    plt.grid(True, which='both', linestyle='--', linewidth=0.5)

    # Graficar los polos
    plt.plot(poles.real, poles.imag, 'x', markersize=10, label='Polos')

    # Añadir etiquetas y título
    plt.xlabel('Parte Real')
    plt.ylabel('Parte Imaginaria')
    plt.title('Polos del Polinomio Característico')
    plt.legend()
    plt.show()

# Ejemplo de uso
coefficients = [1, -3, 2]  # Coeficientes del polinomio característico: s^2 - 3s + 2
plot_poles(coefficients)
