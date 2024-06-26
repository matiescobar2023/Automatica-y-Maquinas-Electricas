function y = c_posicion(t,sol,sol2,r)
if (t>= 1) && (t< 6)
    y = sol(1)*t^5 + sol(2)*t^4 + sol(3)*t^3 + sol(4)*t^2 + sol(5)*t + sol(6);
elseif (t>= 6) && (t< 11)
    y = 2*pi;
elseif (t>= 11) && (t<= 16)
    y = sol2(1)*t^5 + sol2(2)*t^4 + sol2(3)*t^3 + sol2(4)*t^2 + sol2(5)*t + sol2(6);
else
    y = 0;
end
y = r*y;
end
    
