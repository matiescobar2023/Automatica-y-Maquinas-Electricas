clear all
b_l = 0.1;%+-0.03
J_l = 0.0833;%+[0...0.375]
K_l = 2.452;%+[0...7.355]

r = 120;
aa = 3.9e-3;
Tref = 40;
Rsref = 1.02;
Rts = 146.7;
Cts = 0.818;
bl = 1;
Jeq = Jm+Jl/(r^2);
beq = bm+bl/(r^2);
%Variables controlador
Rqp = 2;
Rdp = 3;
Ksiq = 1;
Ksa = 1;
ba = 1;
