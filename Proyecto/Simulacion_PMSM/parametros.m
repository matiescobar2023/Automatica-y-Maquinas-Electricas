clear all
Jm = 3.1e-6;
bm = 1.5e-5;
Pp = 3;
rs = 1.02;
Ld = 6.6/1000;
Lq = 5.8/1000;
lam = 0.01546;
Lls = 0.8/1000;
Kl = 1;
Jl = 1;
r = 120;
aa = 1;
Tref = 25;
Rsref = 10;
Rts = 10;
Cts = 10;
bl = 1;
Jeq = Jm+Jl/(r^2);
beq = bm+bl/(r^2);
%Variables controlador
Rqp = 2;
Rdp = 3;
Ksiq = 1;
Ksa = 1;
ba = 1;
