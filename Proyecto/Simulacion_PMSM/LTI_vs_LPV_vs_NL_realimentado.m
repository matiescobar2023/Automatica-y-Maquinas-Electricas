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
P_p         = Pp;
lambda_m    = 0.016;

L_q         = 5.8/1000;
L_d         = 6.6/1000;
L_ls        = 0.8/1000;

alpha_cu    = 3.9e-3;
%R_s         = 1.02;
T_sref      = 40;
T_sREF      = T_sref;
R_sref      = 1.02;
R_sREF      = R_sref;

C_ts        = 0.818;
R_ts_amb    = 146.7;

J_eq = J_m + J_l/(r^2);
b_eq = b_m + b_l/(r^2);

R_sf         = @(T) R_sref*(1 + alpha_cu*(T - T_sref));

%% PUNTOS DE OPERACIÓN

% Entradas en el punto de operación y omega_mo
syms i_qso i_dso i_0so T_so omega_mo v_qso
vars = [i_qso i_dso i_0so T_so omega_mo v_qso];

%%
%PUNTO DE OPERACIÓN TRIVIAL
theta_m_o    = 0;
T_amb_o      = -15;
T_l_o        = 0;
omega_m_o    = 0;
v_ds_o       = 0; 
v_0s_o       = 0;
v_qs_o       = 0;

v_qs         = v_qs_o;
v_ds         = v_ds_o;
v_0s         = v_0s_o;
i_qs_o       = 0;
i_ds_o       = 0;
i_0s_o       = 0;
T_l          = T_l_o;
T_amb        = T_amb_o;
T_s_o        = T_amb_o;
R_s_o        = R_sf(T_s_o);
R_s          = R_s_o;
%}
%%
% REFORZAMIENTO/DEBILITAMIENTO DE CAMPO
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
% OBTENCIÓN DE PUNTO DE OPERACIÓN
%{
% Definir la función no lineal f(x, u)
f = [omega_mo;
    (1/J_eq)*(1.5*Pp*i_qso*(lambda_m + (L_d - L_q)*i_dso) - b_eq*omega_mo - (K_l/r)*sin(theta_m_o/r) - T_d_o/r);
    (1/L_q)*(-R_sref*(1 + alpha_cu*(T_so - T_sref))*i_qso - Pp*omega_mo*(lambda_m + i_dso*L_d) + v_qso);
    (1/L_d)*(-R_sref*(1 + alpha_cu*(T_so - T_sref))*i_dso + Pp*omega_mo*i_qso*L_q + v_dso);
    (1/L_ls)*(-R_sref*(1 + alpha_cu*(T_so - T_sref))*i_0so + v_0s_o);
    ((1.5*R_sref*(1 + alpha_cu*(T_so - T_sref)))/C_ts)*(i_qso^2 + i_dso^2 + 2*i_0so^2) + (T_amb_o - T_so)/(R_ts_amb*C_ts)];

% Igualar la ecuación de estado al vector nulo y resolver
eqns      = f == [0; 0; 0; 0; 0; 0];

solutions = vpasolve(eqns.', vars);
%}

%% REFORZAMIENTO DE CAMPO
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
     0                                                  -b_eq/J_eq                      3*Pp*(lambda_m + (L_d-L_q)*i_ds_o)/(2*J_eq)    3*Pp*(L_d-L_q)*i_qs_o/(2*J_eq)       0                                             0
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



