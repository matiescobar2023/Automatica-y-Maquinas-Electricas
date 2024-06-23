parametros
%Funcion de transferencia sistema original

%Funcion de transferencia del controlador de corriente
H = tf([1],[L_d/Rdp 1])

%Funcion de transferencia del PID
H1 = tf([1],[J_eq ba Ksa Ksia])

%Funcion de transferencia del PID con valores maximos
J_l = 0.0833 + 0.375;%+[0...0.375]
J_eq = J_m + J_l/(r^2);
H2 = tf([1],[J_eq ba Ksa Ksia])
pzmap(H,H1,H2)
grid on