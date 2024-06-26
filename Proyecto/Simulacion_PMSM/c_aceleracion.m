function y = c_aceleracion(t,sol,sol2,r)
if (t>= 1) && (t< 6)
    y = 20*sol(1)*t^3 + 12*sol(2)*t^2 + 6*sol(3)*t + 2*sol(4);
elseif (t>= 6) && (t< 11)
    y = 0;
elseif (t>= 11) && (t<= 16)
    y = 20*sol2(1)*t^3 + 12*sol2(2)*t^2 + 6*sol2(3)*t + 2*sol2(4);
else
    y = 0;
end
y = r*y;
end