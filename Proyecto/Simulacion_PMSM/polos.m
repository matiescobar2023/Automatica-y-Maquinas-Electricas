% Definir el rango de tiempo
t = linspace(0, 10, 100); % de 0 a 10 segundos, con 100 puntos

% Inicializar matrices para almacenar los polos
all_poles = [];

for i = 1:length(t)
    % Definir los coeficientes del polinomio característico en función del tiempo t
    % Por ejemplo, un polinomio de tercer grado: a3*t^2 + a2*t + a1 + a0
    a3 = 1; % Coeficiente constante
    a2 = 2 * t(i); % Ejemplo: coeficiente lineal en t
    a1 = 3 * t(i)^2; % Ejemplo: coeficiente cuadrático en t
    a0 = 4; % Coeficiente constante

    % Crear el vector de coeficientes del polinomio
    p = [a3 a2 a1 a0];
    
    % Calcular las raíces del polinomio (los polos)
    poles = roots(p);
    
    % Almacenar los polos
    all_poles = [all_poles; poles.'];
end

% Graficar los polos en el plano complejo
figure;
hold on;
for i = 1:length(t)
    plot(real(all_poles(i,:)), imag(all_poles(i,:)), 'o');
end
xlabel('Parte Real');
ylabel('Parte Imaginaria');
title('Polos del Polinomio Característico en el Plano Complejo');
grid on;
hold off;

% Añadir una leyenda y etiquetas si es necesario
legend('Polos en diferentes tiempos');
