clear all
clc
b_l = 0.1%+0.03;%+-0.03
J_l = 0.0833 %+ 0.375;%+[0...0.375]
K_l = 2.452;%+[0...7.355]

r = 120;
J_m = 1.4e-5;
b_m = 1.5e-5;
P_p = 3;
Pp = 3;
lambda_m = 0.01546;
L_q = 5.8/1000;
L_d = 6.6/1000;
L_ls = 0.8/1000;
alpha_cu = 3.9e-3;
C_ts = 0.818;
R_ts_amb = 146.7;
T_sREF = 40;
R_sREF = 1.02;
R_s = 1.02;
T_amb = 25;

J_eq = J_m + J_l/(r^2);
b_eq = b_m + b_l/(r^2);
%Variables controlador
Rqp = 5000*L_q;
Rdp = 5000*L_d;
R0p = 5000*L_ls;
w_pos = 800;
n = 2.5;

Ksia = J_eq*w_pos^3;
Ksa = J_eq*n*w_pos^2;
ba = J_eq*n*w_pos;

P_o = 3200;
%Sin integrador
Ke_omega = P_o^2;
Ke_theta = 2*P_o;

%Con integrador
% Ke_theta = 3*P_o;
% Ke_omega = 3*P_o^2;
% Ke_omega_i = P_o^3;

%syms dtheta_m(t) omega_m(t) J_eq domega_m(t) T_m(t) b_eq T_l(t) v_{qs}^r(t) R_s(t) i_{qs}^r(t) L_q di_{qs}^r(t) lambda_{m}^r L d_i_dsr(t) omega_r(t) v_{ds}^r(t) i_{ds}^r(t) id_s(t) Lls di0_s(t) T_perd(t) Cts dT0_s(t) Rts_amb Tamb(t) i_0s(t) i_2as(t) i_2bs(t) i_2cs(t) i_2qs(t) i_2ds(t) i_20s(t) Pp Rs_REF alpha_Cu Ts_REF;

% Ecuaciones
% eqn1 = dtheta_m(t) == omega_m(t);
% eqn2 = J_eq * diff(omega_m(t), t) == T_m(t) - b_eq * omega_m(t) - T_l(t);
% eqn3 = v_qsr(t) == Rs(t) * i_qsr(t) + Lq * diff(i_qsr(t), t) + (lambda_m_r + L * diff(i_dsr(t), t)) * omega_r(t);
% eqn4 = v_dsr(t) == Rs(t) * i_dsr(t) + L * diff(i_dsr(t), t) - Lq * i_qsr(t) * omega_r(t);
% eqn5 = v_0s(t) == Rs(t) * id_s(t) + Lls * diff(i0_s(t), t);
% eqn6 = T_m(t) == (3/2) * Pp * (lambda_m_r * i_qsr(t) + (L - Lq) * i_dsr(t) * i_qsr(t));
% eqn7 = Rs(t) == Rs_REF * (1 + alpha_Cu * (Ts(t) - Ts_REF));
% eqn8 = Ps_perd(t) == Cts * diff(Ts(t), t) + (1/Rts_amb) * (Ts(t) - Tamb(t));
% eqn9 = Ps_perd(t) == Rs(t) * (i_2as(t) + i_2bs(t) + i_2cs(t)) == (3/2) * Rs(t) * (i_2qs(t) + i_2ds(t) + 2 * i_20s(t));
% 

