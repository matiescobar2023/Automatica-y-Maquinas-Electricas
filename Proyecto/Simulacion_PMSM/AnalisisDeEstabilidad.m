clear all
clc
%syms  s r b_eq J_eq Pp lam_m Rs Lq Lls Ld;

Jm = 3.1e-6;
bm = 1.5e-5;
Pp = 3;
Rs = 1.02;
Ld = 6.6/1000;
Lq = 5.8/1000;
lam_m = 0.01546;
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
J_eq = Jm+Jl/(r^2);
b_eq = bm+bl/(r^2);


A = [0 ,       1      ,         0         ;
     0 , -b_eq/J_eq   , 1.5*Pp*lam_m/J_eq ;
     0 , -Pp*lam_m/Lq , -Rs/Lq            ];
B =[0,0;
    0,-1/(r*J_eq);
    1/Lq,0];
C = [1,0,0];
D=[0,0];
sys_ss = ss(A, B, C, D);
sys_tf = tf(sys_ss);
G1 = zpk(sys_tf);
% Funcion de transferencia desde V_qs a Theta_m
% num = [1.5*Pp*lam_m/J_eq];
% den = [J_eq , J_eq*Rs/Lq+b_eq , b_eq*Rs/Lq+1.5*Pp^2*lam_m^2];
% G1 = tf(num,den);