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
K_l = 2.452;%+[0...7.355]

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
%}

%% CURVAS DE OPERACIÓN CUASI-ESTACIONARIA
%{
% Definir la función no lineal f(x, u)
f = [omega_m;
    (1/J_eq)*(1.5*Pp*i_qs*(lambda_m + (L_d - L_q)*i_ds) - (K_l/r)*sin(theta_m/r) - T_d/r);
    (1/L_q)*(-R_s*i_qs + v_qs);
    (1/L_d)*(-R_s*i_ds + v_ds);
    (1/L_ls)*(-R_s*i_0s);
    ((1.5*R_s)/C_ts)*(i_qs^2 + i_ds^2 + 2*i_0s^2) + (T_amb - T_s)/(R_ts_amb*C_ts)];

% Igualar la ecuación de estado al vector nulo y resolver
eqns = f == [0; 0; 0; 0; 0; 0];
vars = x.'
solutions = solve(eqns, vars);
disp('Soluciones para i_qs:');
disp(solutions.i_qs);
disp('Soluciones para i_ds:');
disp(solutions.i_ds);
disp('Soluciones para i_0s:');
disp(solutions.i_0s);

%}

%% PUNTO DE OPERACIÓN TRIVIAL

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

%% Matrices del modelo LVP
%{
A = [0,1,0,0,0,0;
    -(K_l/(J_eq*r^2))*cos(theta_m/r),-b_eq/J_eq,3*Pp*(lambda_m+(L_d-L_q)*i_ds)/(2*J_eq),3*Pp*(L_d-L_q)*i_qs/(2*J_eq),0,0;
    0,-3*Pp*(lambda_m+L_d)*i_ds/(2*L_q),-R_sref*(1+alpha_cu*(T_s-T_sref))/L_q,-Pp*L_d*omega_m/L_q,0,-R_sref*alpha_cu*i_qs/L_q;
    0,L_q*i_qs*Pp/L_d,L_q*Pp*omega_m/L_d,-R_sref*(1+alpha_cu*(T_s-T_sref))/L_d,0,-R_sref*alpha_cu*i_ds/L_d;
    0,0,0,0,-R_sref*(1+alpha_cu*(T_s-T_sref))/L_ls,-R_sref*alpha_cu*i_os/L_ls;
    0,0,3*i_qs*R_sref*(1+alpha_cu*(T_s-T_sref))/C_ts,3*i_ds*R_sref*(1+alpha_cu*(T_s-T_sref))/C_ts,6*i_os*R_sref*(1+alpha_cu*(T_s-T_sref))/C_ts,3*(i_qs^2+i_ds^2+2*i_os^2)*R_sref*alpha_cu/(2*C_ts)-1/(C_ts*R_ts_amb)];
B = [0,0,0,0,0;
     0,0,0,-1/(r*J_eq),0;
     1/L_q,0,0,0,0;
     0,1/L_d,0,0,0;
     0,0,1/L_ls,0,0;
     0,0,0,0,1/(C_ts*R_ts_amb)];
C = eye(6);
D = zeros(6,5);
%}