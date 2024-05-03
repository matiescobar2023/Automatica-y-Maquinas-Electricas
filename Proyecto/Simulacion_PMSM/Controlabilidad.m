clear all
clc
syms b_eq J_eq Pp lam_m Rs Lq Lls Ld;
% A = [0 ,       1      ,         0         ,    0, 0 ;
%      0 , -b_eq/J_eq   , 1.5*Pp*lam_m/J_eq ,    0, 0 ;
%      0 , -Pp*lam_m/Lq , -Rs/Lq            ,    0, 0 ;
%      0 ,     0        ,         0         ,-Rs/Ld, 0 ;
%      0 ,     0        ,         0         ,0  ,-Rs/Lls];
A = [0 ,       1      ,         0         ;
     0 , -b_eq/J_eq   , 1.5*Pp*lam_m/J_eq ;
     0 , -Pp*lam_m/Lq , -Rs/Lq            ];
     
%B = [0;0;1/Lq;0;0];
B = [0;0;1/Lq];

%Cont = [B, A*B, (A^2)*B,(A^3)*B,(A^4)*B];
Cont = [B, A*B, (A^2)*B];
     
Cont = simplify(Cont);
disp(Cont)
disp(det(Cont))
