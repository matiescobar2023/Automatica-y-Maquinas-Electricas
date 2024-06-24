clear all
clc
%syms  s r b_eq J_eq Pp lam_m Rs Lq Lls Ld;

bl_nom    = 0.1;    %+-0.03
Jl_nom    = 0.0833; %+[0...0.375]
Jm    = 1.4e-5;
bm    = 1.5e-5;
Pp    = 3;
Rs    = 1.02;
Ld    = 5.8e-3;
Lq    = 6.6e-3;
lam_m = 0.016;
Lls   = 0.8e-3;

r           = 120;
alpha_cu    = 3.9e-3;
Tref        = 25;
Rsref       = 1.02;
Rts         = 146.7;
Cts         = 0.818;


bl_values = linspace(bl_nom - 0.03, bl_nom + 0.03, 5);
%bl_values = linspace(bl_nom - 0.03, bl_nom + 0.03, 50);
%bl_values = 0.1;
Jl_values = linspace(Jl_nom, Jl_nom + 0.375, 50);
%Jl_values = linspace(Jl_nom, Jl_nom + 0.375, 5);
%Jl_values = Jl_nom;

syms J_eq b_eq

A       = [ 0        1               0         
            0  -b_eq/J_eq    1.5*Pp*lam_m/J_eq 
            0  -Pp*lam_m/Lq         -Rs/Lq    ];
        
B       = [0              0
           0          -1/(r*J_eq)
           1/Lq           0      ];
       
C      = [1 0 0];

D      = [0 0];

poles_imag = [];
poles_real = [];

figure;
hold on;
grid on;

%title('Mapa de polos y ceros: migracion de propiedades ante variacion de $J_l$ y $b_l = b_{lnom}$', 'Interpreter', 'latex', 'Fontsize', 16);
%xlabel('Eje Real [$\frac{rad}{s}$]',  'interpreter', 'latex', 'Fontsize', 14);
%ylabel('Eje Imaginario [$\frac{rad}{s}$]', 'interpreter', 'latex', 'Fontsize', 14);

% title('Mapa de polos complejos: migracion de propiedades ante variacion de $J_l$ y $b_l$', 'Interpreter', 'latex', 'Fontsize', 16);
% xlabel('Eje Real [$\frac{rad}{s}$]',  'interpreter', 'latex', 'Fontsize', 14);
% ylabel('Eje Imaginario [$\frac{rad}{s}$]', 'interpreter', 'latex', 'Fontsize', 14);

% title('$\omega_n$: migracion de propiedades ante variacion de $J_l$ y $b_l$', 'Interpreter', 'latex', 'Fontsize', 16);
% xlabel('$J_l[kg \cdot m^2$]',  'interpreter', 'latex', 'Fontsize', 14);
% ylabel('$\omega_n [\frac{rad}{s}$]', 'interpreter', 'latex', 'Fontsize', 14);

title('$\zeta$: migracion de propiedades ante variacion de $J_l$ y $b_l$', 'Interpreter', 'latex', 'Fontsize', 16);
xlabel('$J_l[kg \cdot m^2$]',  'interpreter', 'latex', 'Fontsize', 14);
ylabel('$\zeta$', 'interpreter', 'latex', 'Fontsize', 14);


i      = 0;
colors = {'red'; 'blue'; 'green'; 'cyan'; 'black';'magenta'};
zitas  = [];
frecuencias = [];

for bl = bl_values
% for Jl = Jl_values
    i = i + 1;
    j = 0;
    c = colors{i};
    
    for Jl = Jl_values
%     for bl = bl_values
        j = j + 1;
        
        J_eq_value = Jm + Jl/(r^2);
        b_eq_value = bm + bl/(r^2);
        
        A_subs = double(subs(A, {b_eq, J_eq}, {b_eq_value, J_eq_value}));
        B_subs = double(subs(B, J_eq, J_eq_value));
        
        sys_ss = ss(A_subs, B_subs, C, D);
        
        %sys_tf = tf(sys_ss);
        %G1       = zpk(sys_tf);
        poles     = pole(sys_ss);
        
        
        preal     = real(poles(2));
        im        = imag(poles(2));

        poles_real = [poles_real; preal];
        poles_imag = [poles_imag; im];
        
        frecuencias = [frecuencias;abs(poles(2))];
        zitas       = [zitas; -cos(angle(poles(2)))];
        
        %{
        if i == 1
            if j == 1
                plot(preal, im,'x', 'color', c, 'markersize', 10 , 'HandleVisibility', 'off')
                text(preal + 0.035, im-8, '\leftarrow min J_l', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Fontsize', 12);
%                 text(preal + 12, im-8, '\leftarrow min J_l', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Fontsize', 12);
            elseif j == length(Jl_values)
                plot(preal, im,'x', 'color', c, 'markersize', 10 , 'HandleVisibility', 'off');
%                 text(preal + 12, im-8, '\leftarrow max J_l', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Fontsize', 12);
                text(preal + 0.035, im-8, '\leftarrow max J_l', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Fontsize', 12);
            end
        end
        %}
    end
    
    %{
    if bl == 0.1
        plot(poles_real, poles_imag, '-', 'color', c ,'Displayname', '$b_{lnom}\left[\frac{N \cdot m}{rad \cdot s}\right] \, = 0.1$');
    else
        plot(poles_real, poles_imag, '-', 'color', c, 'Displayname',['$b_l\left[\frac{N \cdot m}{rad \cdot s}\right] \, =$ ', num2str(bl)]);
    end
    %plot(poles_real, -poles_imag, '-', 'color', c ,'HandleVisibility', 'off');
    %}
    poles_real = [];
    poles_imag = [];
    
    if bl == 0.1
        %plot(Jl_values, frecuencias, '-', 'color', c ,'Displayname', '$b_{lnom}\left[\frac{N \cdot m}{rad \cdot s}\right] \, = 0.1$');
        plot(Jl_values, zitas, '-', 'color', c ,'Displayname', '$b_{lnom}\left[\frac{N \cdot m}{rad \cdot s}\right] \, = 0.1$');
    else
        %plot(Jl_values, frecuencias, '-', 'color', c ,'Displayname', ['$b_l\left[\frac{N \cdot m}{rad \cdot s}\right] \, =$ ', num2str(bl)]);
        plot(Jl_values, zitas, '-', 'color', c ,'Displayname', ['$b_l\left[\frac{N \cdot m}{rad \cdot s}\right] \, =$ ', num2str(bl)]);
    end
    
    %plot(Jl_values, zitas, '-', 'color', c ,'Displayname', ['$b_l =$ ', num2str(bl), '$\frac{N \cdot m}{rad \cdot s}$']);
    %plot(bl_values, zitas, '-', 'color', c ,'Displayname', ['$J_l =$ ', num2str(Jl), '$kg \cdot m^2$']);
    %plot(bl_values, frecuencias, '-', 'color', c ,'Displayname', ['$J_l =$ ', num2str(Jl), '$kg \cdot m^2$']);
    
    zitas       = [];
    frecuencias = [];
end


%plot(0,0,'x', 'color', 'black', 'markersize', 10 , 'HandleVisibility', 'off');
%plot(-Rs/Lq, 0,'o', 'color', 'black', 'markersize', 10 , 'HandleVisibility', 'off');
legend ('show', 'Interpreter', 'latex', 'Fontsize', 12);
%}
%legend ('show', 'Interpreter', 'latex', 'Fontsize', 12);
% Funcion de transferencia desde V_qs a Theta_m
% num = [1.5*Pp*lam_m/J_eq];
% den = [J_eq , J_eq*Rs/Lq+b_eq , b_eq*Rs/Lq+1.5*Pp^2*lam_m^2];
% G1 = tf(num,den);
