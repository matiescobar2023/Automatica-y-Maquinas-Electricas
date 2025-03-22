import numpy as np

# Parámetros de la LUT
N = 2500  # Número de puntos
A = 100  # Amplitud
C = 100  # Centro
theta = np.linspace(0, 2*np.pi, N, endpoint=False)  # Ángulos de 0 a 2pi

# Generar las tres fases defasadas 120° y 240°
lut = (A * np.sin(theta) + C).astype(np.uint16)

# Escribir la LUT en un archivo C
with open("lut.h", "w") as f:
    f.write("#ifndef LUT_H\n#define LUT_H\n\n")
    f.write("#include <stdint.h>\n\n")
    f.write(f"#define LUT_SIZE {N}\n\n")
    
    # Escribir los valores de la LUT en tres arreglos
    f.write("static const uint16_t lut[LUT_SIZE] = {")
    f.write(", ".join(map(str, lut)) + "};\n\n")
    f.write("#endif // LUT_H\n")

print("Archivo lut.h generado correctamente.")
