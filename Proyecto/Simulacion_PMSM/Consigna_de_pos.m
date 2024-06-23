
%syms t_1 t_2 theta_m1 theta_m2
t_1 = 1;
t_2 = 6;
theta_m1 = 0;
theta_m2 = 2*pi;
A = [t_1^3,t_1^2,t_1,1;
     t_2^3,t_2^2,t_2,1;
     3*t_1^2,2*t_1,1,0;
     3*t_2^2,2*t_2,1,0]
B = [theta_m1; theta_m2; 0 ;0]

sol = inv(A)*B

t_1 = 11;
t_2 = 16;
theta_m1 = 2*pi;
theta_m2 = 0;
A = [t_1^3,t_1^2,t_1,1;
     t_2^3,t_2^2,t_2,1;
     3*t_1^2,2*t_1,1,0;
     3*t_2^2,2*t_2,1,0]
B = [theta_m1; theta_m2; 0 ;0]

sol2 = inv(A)*B


%latex(sol)

% t=linspace(0,20,1000);
% for i=1:1000
%     if (t(i)>= 1) && (t(i)<= 6)
%         y(i) = sol(1)*t(i)^3 +sol(2)*t(i)^2+ sol(3)*t(i) + sol(4);
%     elseif (t(i)> 6) && (t(i)< 11)
%         y(i) = 2*pi;
%     elseif (t(i)>= 11) && (t(i)<= 16)
%         y(i) = sol2(1)*t(i)^3 +sol2(2)*t(i)^2+ sol2(3)*t(i) + sol2(4);
%     else
%         y(i) = 0;
%     end
% end
%  plot(t,y*120)