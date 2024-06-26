parametros
t = linspace(0,20,1000);
for i=1:1000
    pos(i) = c_posicion(t(i),sol,sol2,r);
    vel(i) = c_velocidad(t(i),sol,sol2,r);
    ace(i) = c_aceleracion(t(i),sol,sol2,r);
end

% Crear una figura para las subplots
figure;

% Subplot para la posición
subplot(3, 1, 1);
plot(t, pos);
title('Posición motor vs Tiempo');
xlabel('Tiempo (s)');
ylabel('Posición (rad)');
grid on;

% Subplot para la velocidad
subplot(3, 1, 2);
plot(t, vel);
title('Velocidad motor vs Tiempo');
xlabel('Tiempo (s)');
ylabel('Velocidad (rad/s)');
grid on;

% Subplot para la aceleración
subplot(3, 1, 3);
plot(t, ace);
title('Aceleración motor vs Tiempo');
xlabel('Tiempo (s)');
ylabel('Aceleración (rad/s^2)');
grid on;

% Mostrar la gráfica
sgtitle('Posición, Velocidad y Aceleración vs Tiempo'); % Título general para todas las subplots