function y = c_velocidad(t,sol,sol2,r)
if (t>= 1) && (t< 6)
    y = 5*sol(1)*t^4 + 4*sol(2)*t^3 + 3*sol(3)*t^2 + 2*sol(4)*t + sol(5);
elseif (t>= 6) && (t< 11)
    y = 0;
elseif (t>= 11) && (t<= 16)
    y = 5*sol2(1)*t^4 + 4*sol2(2)*t^3 + 3*sol2(3)*t^2 + 2*sol2(4)*t + sol2(5);
else
    y = 0;
end
y = r*y;
end