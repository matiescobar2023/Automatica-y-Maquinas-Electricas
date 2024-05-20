clear all
clc
%syms b_eq J_eq Pp lambda_m R_sref R_ts_amb L_q L_ls L_d K_l r theta_m i_ds i_qs i_os alpha_cu T_s T_sref omega_m C_ts
%--------------------------------------------------
b_l = 0.1;%+-0.03
J_l = 0.0833;%+[0...0.375]
K_l = 2.452;%+[0...7.355]

r = 120;

J_m = 1.4e-5;
b_m = 1.5e-5;
Pp = 3;
lambda_m = 0.016;
L_q = 5.8/1000;
L_d = 6.6/1000;
L_ls = 0.8/1000;
alpha_cu = 3.9e-3;
C_ts = 0.818;
R_s = 1.02;
R_ts_amb = 146.7;
T_sref = 40;
R_sref = 1.02;

J_eq = J_m+J_l/(r^2);
b_eq = b_m+b_l/(r^2);

%-------------------------------------------
%Punto de operacion



theta_m_o = 0;
omega_m_o = 0;
R_s_o = R_s;
V_qs_o = 0;
V_ds_o = 0;
V_os_o = 0;
i_qs_o = V_qs_o/R_s_o;
i_ds_o = V_ds_o/R_s_o;
i_os_o = V_os_o/R_s_o;
T_s_o = 40;


%--------------------------------------------------
% A = [0,1,0,0,0,0;
%     -(K_l/(J_eq*r^2))*cos(theta_m/r),-b_eq/J_eq,3*Pp*(lambda_m+(L_d-L_q)*i_ds)/(2*J_eq),3*Pp*(L_d-L_q)*i_qs/(2*J_eq),0,0;
%     0,-3*Pp*(lambda_m+L_d)*i_ds/(2*L_q),-R_sref*(1+alpha_cu*(T_s-T_sref))/L_q,-Pp*L_d*omega_m/L_q,0,-R_sref*alpha_cu*i_qs/L_q;
%     0,L_q*i_qs*Pp/L_d,L_q*Pp*omega_m/L_d,-R_sref*(1+alpha_cu*(T_s-T_sref))/L_d,0,-R_sref*alpha_cu*i_ds/L_d;
%     0,0,0,0,-R_sref*(1+alpha_cu*(T_s-T_sref))/L_ls,-R_sref*alpha_cu*i_os/L_ls;
%     0,0,3*i_qs*R_sref*(1+alpha_cu*(T_s-T_sref))/C_ts,3*i_ds*R_sref*(1+alpha_cu*(T_s-T_sref))/C_ts,6*i_os*R_sref*(1+alpha_cu*(T_s-T_sref))/C_ts,3*(i_qs^2+i_ds^2+2*i_os^2)*R_sref*alpha_cu/(2*C_ts)-1/(C_ts*R_ts_amb)];
% B = [0,0,0,0,0;
%      0,0,0,-1/(r*J_eq),0;
%      1/L_q,0,0,0,0;
%      0,1/L_d,0,0,0;
%      0,0,1/L_ls,0,0;
%      0,0,0,0,1/(C_ts*R_ts_amb)];
% C = eye(6);
% D = zeros(6,5);
%latex(A)
% $\alpha_{1}$ \\
% $\beta_{2}$ \\
% $\gamma_{3}$ \\
% $\delta_{4}$ \\
% $\epsilon_{5}$ \\
% $\zeta_{6}$ \\
% $\eta_{7}$ \\
% $\theta_{8}$ \\
% $\iota_{9}$ \\
% $\kappa_{10}$ \\
% $\lambda_{11}$ \\
% $\mu_{12}$ \\
% $\nu_{13}$ \\
% $\xi_{14}$ \\
% $o_{15}$ \\
% $\pi_{16}$ \\
% $\rho_{17}$ \\
% $\sigma_{18}$ \\
% $\tau_{19}$ \\
% $\upsilon_{20}$ \\
% $\phi_{21}$ \\
% $\chi_{22}$ \\
% $\psi_{23}$ \\
% $\omega_{24}$ \\