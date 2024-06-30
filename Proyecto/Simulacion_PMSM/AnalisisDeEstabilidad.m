clear all
clc
%syms  s r b_eq J_eq Pp lam_m Rs Lq Lls Ld;

%%
% PARAMETROS DEL SISTEMA
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
J_eq_nom    = Jm + Jl_nom/(r^2);

%%
%RANGOS DE bl y Jl para mapa de polos y ceros

%bl_values = linspace(bl_nom - 0.03, bl_nom + 0.03, 5);
%Jl_values = linspace(Jl_nom, Jl_nom + 0.375, 50);
%Rs_values = [Rsref*(1 - alpha_cu*(40 + 15)), Rsref, 1.32];
%Ts_values  = [-15, 40, 115];

%%
% SISTEMA EN SIMBÓLICO
syms J_eq b_eq

A       = [ 0        1               0         
            0  -b_eq/J_eq    1.5*Pp*lam_m/J_eq 
            0  -Pp*lam_m/Lq         -Rs/Lq    ];
        
B       = [0              0
           0          -1/(r*J_eq)
           1/Lq           0      ];
       
C       = [1 0 0];

D       = [0 0];

%% Vectores con los polos, parte real e imaginaria, y zita y frecuencia.
%{
poles_imag  = [];
poles_real  = [];
zitas       = [];
frecuencias = [];
%}

colors      = {'black';'red'; 'blue'; 'green'; 'cyan'; 'black';'magenta'};

%% TÍTULOS PARA CADA GRÁFICA
%{
%{
title('Mapa de polos y ceros: migracion de propiedades ante variacion de $J_l$, $R_s$ y $b_l = b_{lnom}$', 'Interpreter', 'latex', 'Fontsize', 16);
xlabel('Eje Real [$\frac{rad}{s}$]',  'interpreter', 'latex', 'Fontsize', 14);
ylabel('Eje Imaginario [$\frac{rad}{s}$]', 'interpreter', 'latex', 'Fontsize', 14);
xlim ([-210 0]);
daspect([1 1 1]);
%}
%{
title('Mapa de polos complejos: migracion de propiedades ante variacion de $J_l$ y $b_l$', 'Interpreter', 'latex', 'Fontsize', 16);
xlabel('Eje Real [$\frac{rad}{s}$]',  'interpreter', 'latex', 'Fontsize', 14);
ylabel('Eje Imaginario [$\frac{rad}{s}$]', 'interpreter', 'latex', 'Fontsize', 14);
%}
%{
title('$\omega_n$: migracion de propiedades ante variacion de $J_l$, $R_s$ y $b_l = b_{lnom}$', 'Interpreter', 'latex', 'Fontsize', 16);
xlabel('$J_l[kg \cdot m^2$]',  'interpreter', 'latex', 'Fontsize', 14);
ylabel('$\omega_n [\frac{rad}{s}$]', 'interpreter', 'latex', 'Fontsize', 14);
%}
% title('$\zeta$: migracion de propiedades ante variacion de $J_l$, $R_s$ y $b_l = b_{lnom}$', 'Interpreter', 'latex', 'Fontsize', 16);
% xlabel('$J_l[kg \cdot m^2$]',  'interpreter', 'latex', 'Fontsize', 14);
% ylabel('$\zeta$', 'interpreter', 'latex', 'Fontsize', 14);
%}
%% ITERACIÓN PRINCIPAL PARA EL MAPA DE POLOS POR VARIACIÓN DE PARAMETROS
%{
k = 0;
%for Rs_value = Rs_values
    k           = k + 1;
    i           = 0;
    c = colors{k};
    for bl = bl_values
    % for Jl = Jl_values
        i = i + 1;
        j = 0;

        for Jl = Jl_values
    %     for bl = bl_values
            j = j + 1;

            J_eq_value = Jm + Jl/(r^2);
            b_eq_value = bm + bl/(r^2);

%             A_subs = double(subs(A, {b_eq, J_eq}, {b_eq_value, J_eq_value}));
%             B_subs = double(subs(B, J_eq, J_eq_value));
            A_subs = double(subs(A, {b_eq, J_eq, Rs}, {b_eq_value, J_eq_value, Rs_value}));
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
                    plot(preal, -im,'x', 'color', c, 'markersize', 10 , 'HandleVisibility', 'off')
                    if k == 2
                        %plot(preal, im,'x', 'color', c, 'markersize', 10 , 'HandleVisibility', 'off')
%                     text(preal + 0.035, im-8, '\leftarrow min J_l', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Fontsize', 12);
                        text(preal + 70, im-12, '\leftarrow min J_l', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Fontsize', 12);
                    end
                elseif j == length(Jl_values)
                    plot(preal, im,'x', 'color', c, 'markersize', 10 , 'HandleVisibility', 'off')
                    plot(preal, -im,'x', 'color', c, 'markersize', 10 , 'HandleVisibility', 'off')
                    if k == 2
                        %plot(preal, im,'x', 'color', c, 'markersize', 10 , 'HandleVisibility', 'off');
                        text(preal + 70, im-9, '\leftarrow max J_l', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Fontsize', 12);
%                     text(preal + 0.035, im-8, '\leftarrow max J_l', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Fontsize', 12);
                    end
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
        %plot(poles_real, poles_imag, '-', 'color', c, 'Displayname',['$b_l\left[\frac{N \cdot m}{rad \cdot s}\right] \, =$ ', num2str(bl)])
        %plot(poles_real, poles_imag, '-', 'color', c, 'Displayname',['$R_s \left[ \Omega \right] \, =$', num2str(Rs_value),'(', num2str(Ts_values(k)),'$^\circ C$',')']);
        %plot(poles_real, -poles_imag, '-', 'color', c ,'HandleVisibility', 'off');
        poles_real = [];
        poles_imag = [];
        
        %{
        if bl == 0.1
            %plot(Jl_values, frecuencias, '-', 'color', c ,'Displayname', '$b_{lnom}\left[\frac{N \cdot m}{rad \cdot s}\right] \, = 0.1$');
            plot(Jl_values, zitas, '-', 'color', c ,'Displayname', '$b_{lnom}\left[\frac{N \cdot m}{rad \cdot s}\right] \, = 0.1$');
        else
            %plot(Jl_values, frecuencias, '-', 'color', c ,'Displayname', ['$b_l\left[\frac{N \cdot m}{rad \cdot s}\right] \, =$ ', num2str(bl)]);
            plot(Jl_values, zitas, '-', 'color', c ,'Displayname', ['$b_l\left[\frac{N \cdot m}{rad \cdot s}\right] \, =$ ', num2str(bl)]);
        end
        %}

        %plot(Jl_values, zitas, '-', 'color', c ,'Displayname', ['$b_l =$ ', num2str(bl), '$\frac{N \cdot m}{rad \cdot s}$']);
        %plot(bl_values, zitas, '-', 'color', c ,'Displayname', ['$J_l =$ ', num2str(Jl), '$kg \cdot m^2$']);
        %plot(bl_values, frecuencias, '-', 'color', c ,'Displayname', ['$J_l =$ ', num2str(Jl), '$kg \cdot m^2$']);
        plot(Jl_values, frecuencias, '-', 'color', c ,'Displayname', ['$R_s \left[ \Omega \right] \, =$', num2str(Rs_value),'(', num2str(Ts_values(k)),'$^\circ C$',')']);
        %plot(Jl_values, zitas, '-', 'color', c ,'Displayname', ['$R_s \left[ \Omega \right] \, =$', num2str(Rs_value),'(', num2str(Ts_values(k)),'$^\circ C$',')']);
        zitas       = [];
        frecuencias = [];
    end
    %plot(-Rs_value/Lq, 0,'o', 'color', c, 'markersize', 10 , 'HandleVisibility', 'off');
end

%plot(0,0,'x', 'color', 'black', 'markersize', 10 , 'HandleVisibility', 'off');
%legend ('show', 'Interpreter', 'latex', 'Fontsize', 12);
%}

%% COMPARACIÓN CON LOS POLOS DEL CONTROLADOR DE MOVIMIENTO
bl_values = linspace(bl_nom - 0.03, bl_nom + 0.03, 5);
Jl_values = linspace(Jl_nom, Jl_nom + 0.375, 50);

%% PARAMETROS DEL CONTROLADOR
omega_pos   = 800;
n           = 2.5;
b_a         = n*omega_pos*J_eq_nom;
K_sa        = n*(omega_pos^2)*J_eq_nom;
K_sia       = (omega_pos^3)*J_eq_nom;

%% FUNCIONES DE TRANSFERENCIA
num_set_point     = [0 b_a K_sa K_sia];
num_disturbance   = [0 0 -1 0];
den               = [J_eq b_a K_sa K_sia];


polos_planta_re_all = zeros(length(bl_values), length(Jl_values));% En columnas para J_l
polos_planta_im_all = zeros(length(bl_values), length(Jl_values));% En filas para b_l

polos_controlador_re_all = zeros(length(bl_values), length(Jl_values));% En columnas para J_l
polos_controlador_im_all = zeros(length(bl_values), length(Jl_values));% En filas para b_l
zeros_controlador_re_all = zeros(length(bl_values), length(Jl_values));
zeros_controlador_im_all = zeros(length(bl_values), length(Jl_values));


i          = i + 1;
j          = 0;
b_eq_value = bm + bl_nom/(r^2);

mapa_polos_planta      = zeros(2, length(Jl_values));
mapa_polos_controlador = zeros(6, length(Jl_values));


for Jl = Jl_values
    j = j + 1;
    J_eq_value = Jm + Jl/(r^2);
    
    A_subs = double(subs(A, {b_eq, J_eq}, {b_eq_value, J_eq_value}));
    B_subs = double(subs(B, J_eq, J_eq_value));
    den_subs = double(subs(den, {J_eq}, {J_eq_value}));

    sys_ss                    = ss(A_subs, B_subs, C, D); % Espacio de estados
    polos_planta              = pole(sys_ss);
    mapa_polos_planta(1, j)   = real(polos_planta(2));
    mapa_polos_planta(2, j)   = imag(polos_planta(2));
    
    controlador_set_point_tf   = tf(num_set_point, den_subs);
    controlador_disturbance_tf = tf(num_disturbance, den_subs);
    
    if j == 1
        [polos_controlador, zeros_controlador]          = pzmap(controlador_set_point_tf);
    else
        polos_controlador = pole(controlador_set_point_tf);
    end
    
    for i = 1:length(polos_controlador)
        mapa_polos_controlador(i, j) = real(polos_controlador(i));
        mapa_polos_controlador(i + length(polos_controlador), j) = imag(polos_controlador(i));
    end
end

figure;
hold on;
grid on;

c = colors{i};
plot(mapa_polos_planta(1,:), mapa_polos_planta(2,:), '-', 'color', c, 'Displayname', 'Polos/Ceros - Planta.');
plot(mapa_polos_planta(1,:), -mapa_polos_planta(2,:), '-', 'color', c, 'HandleVisibility', 'off');
plot(0,0, 'x', 'color', c, 'HandleVisibility', 'off');
plot(-Rs/Lq, 0, 'o', 'color', c, 'markersize', 10, 'HandleVisibility', 'off');

re_init = mapa_polos_planta(1, 1);
im_init = mapa_polos_planta(2, 1);

re_end  = mapa_polos_planta(1, end);
im_end  = mapa_polos_planta(2, end);

plot(re_init, im_init,'x', 'color', c, 'markersize', 10 , 'HandleVisibility', 'off')
plot(re_init, -im_init,'x', 'color', c, 'markersize', 10 , 'HandleVisibility', 'off')
plot(re_end, im_end,'x', 'color', c, 'markersize', 10 , 'HandleVisibility', 'off')
plot(re_end, -im_end,'x', 'color', c, 'markersize', 10 , 'HandleVisibility', 'off')
text(re_init + 60, im_init - 50, '\leftarrow  J_{lnom}', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Fontsize', 12);
text(re_end + 60, -im_end - 50, '\leftarrow  J_{lmax}', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Fontsize', 12);
text(re_init + 60, -im_init - 50, '\leftarrow  J_{lnom}', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Fontsize', 12);
text(re_end + 60, im_end - 50, '\leftarrow  J_{lmax}', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Fontsize', 12);


aux = mapa_polos_controlador(:,1);
mapa_polos_controlador(1:2, 1) = aux(2:3);
mapa_polos_controlador(3, 1)   = aux(1);
mapa_polos_controlador(4:5, 1) = aux(5:6);
mapa_polos_controlador(6, 1)   = aux(4);

for i = 1:3
    re_init = mapa_polos_controlador(i, 1);
    im_init = mapa_polos_controlador(i + 3, 1);

    re_end  = mapa_polos_controlador(i, end);
    im_end  = mapa_polos_controlador(i + 3, end);
    
    plot(re_init, im_init,'xr', 'markersize', 10 , 'HandleVisibility', 'off')
    plot(re_end, im_end,'xr', 'markersize', 10 , 'HandleVisibility', 'off')
    text(re_init + 60, im_init - 50, '\leftarrow  J_{lnom}', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Fontsize', 12);
    text(re_end + 60, im_end - 50, '\leftarrow  J_{lmax}', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Fontsize', 12);
    if i == 1
        plot(mapa_polos_controlador(i, :), mapa_polos_controlador(i + 3, :), '-r','linewidth', 1, 'Displayname', 'Polos/Ceros - Controlador.');
    else
        plot(mapa_polos_controlador(i, :), mapa_polos_controlador(i + 3, :), '-r','linewidth', 1, 'HandleVisibility', 'off');
    end
end
for zero = zeros_controlador
    plot(real(zero), imag(zero), 'or', 'markersize', 10, 'HandleVisibility', 'off');
end
plot(0,0, 'or','markersize', 10, 'HandleVisibility', 'off');

% plot(Jl_values, zitas, '-', 'color', c ,'Displayname', '$b_{lnom}\left[\frac{N \cdot m}{rad \cdot s}\right] \, = 0.1$');
% text(preal + 0.035, im-8, '\leftarrow max J_l', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Fontsize', 12);
%plot(-Rs_value/Lq, 0,'o', 'color', c, 'markersize', 10 , 'HandleVisibility', 'off');
%}
legend ('show', 'Interpreter', 'latex', 'Fontsize', 12);