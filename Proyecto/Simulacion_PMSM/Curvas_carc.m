syms omega_m i_qs i_ds %v_qs v_ds P_p lambda_m L_q L_d R_s 
P_p = 3;
lambda_m = 0.01546;
L_q = 5.8/1000;
L_d = 6.6/1000;
R_s = 1.02;
v_qs = -10;
v_ds= 10;
omega_m = linspace(0,100,100);
for i=1:100
    eq1 = v_ds - R_s*i_ds + L_q*P_p*omega_m(i)*i_qs == 0
    sol_i_ds = solve(eq1,i_ds)
    eq2 = v_qs - R_s*i_qs - lambda_m*P_p*omega_m(i) + L_d*P_p*omega_m(i)*sol_i_ds == 0

    sol_i_qs = solve(eq2,i_qs)

    eq3 = v_ds - R_s*i_ds + L_q*P_p*omega_m(i)*sol_i_qs == 0

    sol_i_ds = solve(eq3,i_ds)

    Tm(i) = 1.5*(lambda_m*sol_i_qs + (L_d-L_q)*sol_i_ds*sol_i_qs)
end


latex(Tm)