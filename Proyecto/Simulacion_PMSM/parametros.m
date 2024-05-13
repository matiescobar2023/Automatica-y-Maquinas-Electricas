clear all
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
R_ts_amb = 146.7;
T_sref = 40;
R_sref = 1.02;

J_eq = J_m+J_l/(r^2);
b_eq = b_m+b_l/(r^2);

%Variables controlador
Rqp = 2;
Rdp = 3;
Ksiq = 1;
Ksa = 1;
ba = 1;
