parametros
syms s %Theta_m Omega_m I_qs T_l V_qs J_eq b_eq P_p lambda_m r L_q R_s

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

pol_c = J_eq*L_q*s^3 + (J_eq*R_s+L_q*b_eq)*s^2 + (R_s*b_eq+(3*P_p^2*lambda_m^2)/2)*s==0
polos = solve(pol_c,s)
polos =  simplify(polos)
polos_l = latex(polos(3))
