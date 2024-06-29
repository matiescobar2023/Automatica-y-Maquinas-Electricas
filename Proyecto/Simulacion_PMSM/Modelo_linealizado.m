clear all
clc

%% VARIABLES SIMBÓLICAS DE ESTADO
%{
syms i_qs i_ds i_0s T_s
x       = [i_qs; i_ds; i_0s; T_s];
theta_m = pi/3; % Imponemos esta condición directamente
omega_m = 0;    % Imponemos esta condición directamente

% Entrada de perturbación
syms T_d T_amb
u_d = [T_d; T_amb];

% Entradas de control
syms v_qs v_ds
u_c     = [v_qs; v_ds];
v_0s    = 0; % Imponemos esta condición directamente

% Entradas del sistema
u = [u_c; u_d];
%}

%% PARAMETROS SIMBÓLICOS DEL SISTEMA FÍSICO
%{
syms K_l r b_eq J_eq Pp
syms lambda_m L_q L_ls L_d
syms alpha_cu R_sref T_sref
syms R_ts_amb C_ts
syms R_s

% Definción de la evolución de R_S
R_s = R_sref*(1 + alpha_cu*(T_s - T_sref));
%}

%% PARAMETROS DEL MODELO FÍSICO

b_l = 0.1;%+-0.03
J_l = 0.0833;%+[0...0.375]
K_l = 2.452 + 7.355;%+[0...7.355]

r = 120;

J_m         = 1.4e-5;
b_m         = 1.5e-5;
Pp          = 3;
lambda_m    = 0.016;

L_q         = 5.8/1000;
L_d         = 6.6/1000;
L_ls        = 0.8/1000;

alpha_cu    = 3.9e-3;
%R_s         = 1.02;
T_sref      = 40;
R_sref      = 1.02;

C_ts        = 0.818;
R_ts_amb    = 146.7;

J_eq = J_m + J_l/(r^2);
b_eq = b_m + b_l/(r^2);

%% DINAMICA DE CEROS
%{
z       = -60;
z       = -R_s/L_q;
L_q    = -R_s/z;
R_s    = -L_q*z;
%}

%% CURVAS DE OPERACIÓN LPV
%{
i_max   = linspace(0, sqrt(2)*0.4, 100);
T_amb_o = -15:10:40;
beta    = 0:pi/4:2*pi;
%}


%% PUNTOS DE OPERACIÓN

% Entradas en el punto de operación y omega_mo
syms i_qso i_dso i_0so T_so omega_mo v_qso
vars         = [i_qso i_dso i_0so T_so omega_mo v_qso];

%%
% SIMULACIÓN 1. Enrealidad despues de la 3 con menos variación
%{
theta_m_o    = r*pi/12;
T_amb_o      = 25;
T_d_o        = 1;


v_ds_o       = 0; 
v_0s_o       = 0;

v_ds         = v_ds_o;
v_0s         = v_0s_o;
T_d          = T_d_o*(1 + 0.01);%    50% encima del punto de operación.
T_amb        = T_amb_o + 5;   % +10 °C encima del punto de operación.
%}
%%
% SIMULACIÓN 2 T_d \notequal 0
%{
theta_m_o    = r*pi/12;
T_amb_o      = 25;
T_d_o        = 1;
v_ds_o       = 0;
v_0s_o       = 0;

v_ds         = v_ds_o;
v_0s         = v_0s_o;
T_d          = T_d_o;
T_amb        = T_amb_o;
%}

%%
% SIMULACIÓN 3 deltaX_o \notqeual 0

theta_m_o    = r*pi/12;
T_amb_o      = 25;
T_d_o        = 1;


v_ds_o       = 0; 
v_0s_o       = 0;

v_ds         = v_ds_o;
v_0s         = v_0s_o;
T_d          = T_d_o*(1 + 0.1);%    50% encima del punto de operación.
T_amb        = T_amb_o + 5;   % +10 °C encima del punto de operación.
%}

%%
% SIMULACIÓN 4.1 reforzamiento de campo
%{
syms i_tot v_dso
beta = deg2rad(80);
i_dso        = i_tot*cos(beta);
i_qso        = i_tot*sin(beta);

theta_m_o    = r*pi/12;
T_amb_o      = 25;
T_d_o        = 1;
v_0s_o       = 0;


v_0s         = v_0s_o;
T_d          = T_d_o;%    50% encima del punto de operación.
T_amb        = T_amb_o;   % +10 °C encima del punto de operación.

vars         = [i_tot i_0so T_so omega_mo v_qso v_dso];
%}

%%
% SIMULACIÓN 4.2 debilitamiento de campo
%{
syms i_tot v_dso
beta = deg2rad(100);
i_dso        = i_tot*cos(beta);
i_qso        = i_tot*sin(beta);

theta_m_o    = r*pi/12;
T_amb_o      = 25;
T_d_o        = 1;
v_0s_o       = 0;


v_0s         = v_0s_o;
T_d          = T_d_o;%    50% encima del punto de operación.
T_amb        = T_amb_o;   % +10 °C encima del punto de operación.

vars         = [i_tot i_0so T_so omega_mo v_qso v_dso];
%}

%%
R_sf         = @(T) R_sref*(1 + alpha_cu*(T - T_sref));

% Definir la función no lineal f(x, u)
f = [omega_mo;
    (1/J_eq)*(1.5*Pp*i_qso*(lambda_m + (L_d - L_q)*i_dso) - b_eq*omega_mo - (K_l/r)*sin(theta_m_o/r) - T_d_o/r);
    (1/L_q)*(-R_sref*(1 + alpha_cu*(T_so - T_sref))*i_qso - Pp*omega_mo*(lambda_m + i_dso*L_d) + v_qso);
    (1/L_d)*(-R_sref*(1 + alpha_cu*(T_so - T_sref))*i_dso + Pp*omega_mo*i_qso*L_q + v_ds_o);
    (1/L_ls)*(-R_sref*(1 + alpha_cu*(T_so - T_sref))*i_0so + v_0s_o);
    ((1.5*R_sref*(1 + alpha_cu*(T_so - T_sref)))/C_ts)*(i_qso^2 + i_dso^2 + 2*i_0so^2) + (T_amb_o - T_so)/(R_ts_amb*C_ts)];

% Igualar la ecuación de estado al vector nulo y resolver
eqns      = f == [0; 0; 0; 0; 0; 0];

solutions = vpasolve(eqns.', vars);


%% SIMULACIÓN 1
%{
i_qs_o    = double(solutions.i_qso);
i_ds_o    = double(solutions.i_dso);
i_0s_o    = double(solutions.i_0so);
v_qs_o    = double(solutions.v_qso);
omega_m_o = double(solutions.omega_mo);
T_s_o     = double(solutions.T_so);
R_s_o     = R_sf(T_s_o);
R_s       = R_s_o;
v_qs      = v_qs_o*(1 + 0.01); %20% por encima del punto de equilibrio
%}
%% SIMULACIÓN 2
%{
i_qs_o    = double(solutions.i_qso);
i_ds_o    = double(solutions.i_dso);
i_0s_o    = double(solutions.i_0so);
v_qs_o    = double(solutions.v_qso);
omega_m_o = double(solutions.omega_mo);
T_s_o     = double(solutions.T_so);
R_s_o     = R_sf(T_s_o);
R_s       = R_s_o;
v_qs      = v_qs_o;
%}
%% SIMULACIÓN 3

i_qs_o    = double(solutions.i_qso);
i_ds_o    = double(solutions.i_dso);
i_0s_o    = double(solutions.i_0so);
v_qs_o    = double(solutions.v_qso);
omega_m_o = double(solutions.omega_mo);
T_s_o     = double(solutions.T_so);
R_s_o     = R_sf(T_s_o);
R_s       = R_s_o;
v_qs      = v_qs_o*(1 + 0.1); %20% por encima del punto de equilibrio
%}
%}

%% SIMLUACIÓN 4.1 reforzamiento de campo
%{
i_qs_o    = double(solutions.i_tot(1)*sin(beta));
i_ds_o    = double(solutions.i_tot(1)*cos(beta));
i_0s_o    = double(solutions.i_0so(1));
v_qs_o    = double(solutions.v_qso(1));
v_ds_o    = double(solutions.v_dso(1));
omega_m_o = double(solutions.omega_mo(1));
T_s_o     = double(solutions.T_so(1));
R_s_o     = R_sf(T_s_o);

R_s       = R_s_o;
v_qs      = v_qs_o;
v_ds      = v_ds_o;


%}

%% SIMLUACIÓN 4.2 debilitamiento de campo
%{
i_qs_o    = double(solutions.i_tot(1)*sin(beta));
i_ds_o    = double(solutions.i_tot(1)*cos(beta));
i_0s_o    = double(solutions.i_0so(1));
v_qs_o    = double(solutions.v_qso(1));
v_ds_o    = double(solutions.v_dso(1));
omega_m_o = double(solutions.omega_mo(1));
T_s_o     = double(solutions.T_so(1));
R_s_o     = R_sf(T_s_o);

R_s       = R_s_o;
v_qs      = v_qs_o;
v_ds      = v_ds_o;


%}
%% Matrices del modelo LVP

A = [0                                                       1                                   0                                           0                             0                                             0
    -(K_l/(J_eq*r^2))*cos(theta_m_o/r)                 -b_eq/J_eq                      3*Pp*(lambda_m + (L_d-L_q)*i_ds_o)/(2*J_eq)    3*Pp*(L_d-L_q)*i_qs_o/(2*J_eq)       0                                             0
     0                                     -Pp*(lambda_m + L_d*i_ds_o)/L_q                  -R_s_o/L_q                                 -Pp*L_d*omega_m_o/L_q               0                             -R_sref*alpha_cu*i_qs_o/L_q
     0                                             L_q*i_qs_o*Pp/L_d                      L_q*Pp*omega_m_o/L_d                           -R_s_o/L_d                        0                             -R_sref*alpha_cu*i_ds_o/L_d
     0                                                       0                                   0                                           0                       -R_s_o/L_ls                         -R_sref*alpha_cu*i_0s_o/L_ls
     0                                                       0                            3*i_qs_o*R_s_o/C_ts                          3*i_ds_o*R_s_o/C_ts        6*i_0s_o*R_s_o/C_ts     3*(i_qs_o^2 + i_ds_o^2 + 2*i_0s_o^2)*R_sref*alpha_cu/(2*C_ts)-1/(C_ts*R_ts_amb)];
B = [0      0       0           0           0
     0      0       0       -1/(r*J_eq)     0
     1/L_q  0       0           0           0
     0    1/L_d     0           0           0
     0      0      1/L_ls       0           0
     0      0       0           0   1/(C_ts*R_ts_amb)];
C = eye(6);
D = zeros(6,5);
%}
%% PUNTO DE OPERACIÓN TRIVIAL
%{
theta_m_o   = 0;
omega_m_o   = 0;
R_s_o       = R_s;
V_qs_o      = 0;
V_ds_o      = 0;
V_os_o      = 0;
i_qs_o      = V_qs_o/R_s_o;
i_ds_o      = V_ds_o/R_s_o;
i_os_o      = V_os_o/R_s_o;
T_s_o       = 40;
%}

%% Curvas de puntos de operación del 5.1.2.b creo, del LPV
%{
%{
T_m         = @(theta_l, T_d) K_l*sin(theta_l)/r + T_d/r;
theta_lr    = linspace(0, 2*pi, 100);
T_m1        = T_m(theta_lr, 5);
T_m2        = T_m(theta_lr, -5);
T_m3        = T_m(theta_lr, 0);

figure;

hold on;
plot(theta_lr, T_m1, 'r', 'LineWidth', 1); % Línea roja discontinua
plot(theta_lr, T_m2, 'g', 'LineWidth', 1); % Línea roja discontinua
plot(theta_lr, T_m3, 'b', 'LineWidth', 1); % Línea roja discontinua

% Agregar título y etiquetas
title('T_m respecto de \theta_l para T_d = [-5, 0, 5][N.m]');
xlabel('\theta_l [rad]');
ylabel('T_m[N.m]');

% Agregar una leyenda
legend('T_d = 5 N.m', 'T_d = -5 N.m', 'T_d = 0 N.m');

% Ajustar los límites del eje
xlim([0, 2*pi]);
hold off;
%}

% Generar puntos para la circunferencia
%{
theta = linspace(0, 2*pi, 100); % Ángulo de 0 a 2pi en 100 puntos
figure;
hold on; % Mantener la gráfica para añadir el segmento de recta
% Configuración de la gráfica
axis equal; % Escala igual en ambos ejes
grid on; % Mostrar cuadrícula
title('Círculos de corriente.');
xlabel('i_{ds} [A]');
ylabel('i_{qs} [A]');
for i = 1:length(i_max)
    radio = i_max(i);
    x = radio * cos(theta); % Coordenada x
    y = radio * sin(theta); % Coordenada y
    
    % Graficar la circunferencia
    if i == length(i_max)
        % Parámetro del ángulo beta
        beta = pi/4; % Ángulo beta en radianes (por ejemplo, pi/4 para 45 grados)
        % Coordenadas del punto en la circunferencia que forma un ángulo beta con el eje x
        x_beta = radio * cos(beta);
        y_beta = radio * sin(beta);
        plot(x_beta, y_beta, 'ro', 'MarkerFaceColor', 'r');
    end
    plot(x, y, 'LineWidth', 1); % Circunferencia en azul con grosor de línea 2
    

    % Graficar el segmento de recta
    if i == length(i_max)
        plot([0, x_beta], [0, y_beta], 'r', 'LineWidth', 1); % Segmento de recta en rojo con grosor de línea 2
        % Anotar el ángulo beta en la gráfica
        text(radio/3 * cos(beta/2), radio/3 * sin(beta/2), '\beta', 'FontSize', 12, 'HorizontalAlignment', 'right');
    end
end
%}
%{
figure;
hold on; % Mantener la gráfica para añadir el segmento de recta
grid on; % Mostrar cuadrícula
title('T^{\circ}_{s} vs i_{qd0s-o} con T^{\circ}_{amb} como parámetro');
xlabel('i_{qd0s-o} [A]');
ylabel('T^{\circ}_{s} [^{\circ} C]');

for i = 1:length(T_amb_o)
    numerador = (3/2) * R_sref * (alpha_cu * T_sref - 1) * (i_max).^2 - (T_amb_o(i) / R_ts_amb);
    denominador = (3/2) * R_sref * alpha_cu * (i_max).^2 - (1 / R_ts_amb);
    T_s0 = numerador ./ denominador;
    x_last = i_max(end);
    y_last = T_s0(end);
    text(x_last, y_last, [num2str(T_amb_o(i)), '^{\circ}C'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    plot(i_max, T_s0, 'LineWidth', 1, 'DisplayName', ['T_{amb-o} = ', num2str(T_amb_o(i)), '^{\circ}C']);
end
% Añadir una línea punteada horizontal a los 115 grados
yline(115, 'r--', 'LineWidth', 1, 'Label', '115^{\circ}C', 'LabelHorizontalAlignment', 'left', 'LabelVerticalAlignment', 'bottom');
%legend show;
%}
%{
figure;
hold on; % Mantener la gráfica para añadir el segmento de recta
grid on; % Mostrar cuadrícula
title('T_{m} vs i_{qd0s-o} con \beta como parámetro');
xlabel('i_{qd0s-o} [A]');
ylabel('T_{m} [N.m]');

for i = 1:length(beta)
    if (i ~= 5)&&(i ~= 9)
        Tm = (3/2) * Pp * sin(beta(i))*i_max.*(lambda_m + (L_d - L_q) * i_max * cos(beta(i)));
        %x_last = i_max(end);
        %y_last = Tm(end);
        %text(x_last, y_last, [num2str(rad2deg(beta(i))), '^{\circ}'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
        plot(i_max, Tm, 'LineWidth', 1, 'DisplayName', ['\beta = ', num2str(rad2deg(beta(i))), '^{\circ}']);
    end
end
legend show;

%}
%}


