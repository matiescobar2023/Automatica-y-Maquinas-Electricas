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
     
%C = [1,0,0,0,0];
C = [0,1,0];

% Obs = [ C;
%      C*A;
%      C*A*A;
%      C*A*A*A;
%      C*A^4];
Obs = [ C;
       C*A;
       C*A*A];
     
Obs = simplify(Obs);
disp(Obs)
disp(det(Obs))
latex(det(Obs))
