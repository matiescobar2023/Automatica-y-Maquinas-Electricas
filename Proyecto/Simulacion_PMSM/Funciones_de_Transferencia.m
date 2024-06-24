%parametros
clc; clear;
syms s Theta_m Omega_m I_qs T_l V_qs J_eq b_eq P_p lambda_m r L_q R_s
A = [ 0         1                           0
      0     -b_eq/J_eq         3*P_p*lambda_m/(2*J_eq)
      0  -P_p*lambda_m/L_q             -R_s/L_q      ];
[P, D] = eig(A);

syms Z1 Z2
z1 = D(2,2);
z2 = D(3,3);
% P = subs(P, z1, Z1);
% P = subs(P, z2, Z2);

omega_n = ((R_s*b_eq + (3/2)*P_p^2*lambda_m^2)/(J_eq*L_q))^(1/2);
zita    = (J_eq*R_s + L_q*b_eq)/(2*(J_eq*L_q*(R_s*b_eq + (3/2)*P_p^2*lambda_m^2))^(1/2));
zero    = -R_s/L_q;

syms OMEGA_N ZITA
P = subs(P, omega_n, OMEGA_N);
P = subs(P, zita, ZITA);


% eq1 = s*Theta_m == Omega_m
% 
% sol_1 = solve(eq1,Omega_m)
% 
% eq3 = s*I_qs == -R_s*I_qs/L_q - P_p*sol_1*lambda_m/L_q +V_qs/L_q
% 
% sol_3 = solve(eq3,I_qs)
% 
% eq2 = s*sol_1 == 1.5*(P_p*sol_3*lambda_m)/J_eq - b_eq*sol_1/J_eq - T_l/(r*J_eq)
% 
% sol_2 = solve(eq2,Theta_m)
% 
% sol_2 = simplify(sol_2)*(0.5/0.5)
% latex(sol_2)

% pol_c = J_eq*L_q*s^3 + (J_eq*R_s+L_q*b_eq)*s^2 + (R_s*b_eq+(3*P_p^2*lambda_m^2)/2)*s==0
% polos = solve(pol_c,s)
% polos =  simplify(polos)
% polos_l = latex(polos(3))
