
% NN = 150;
% rng(0);  % Seed = 25
sigma = 0.01;
% e = sigma*randn(NN,1);

%% Importar datos de simulink
S = load('datos_simulink.mat');
h = S.y(2,:)';
h = h(1:100);


%% Modelo de respuesta al impulso N = 20

M = 4;  % Largo del u_p
N = 20;  

NN = 100;

u_p = zeros(M,1);  % impulso en la entrada
u_p(1) = 1;
u_N = zeros(NN,1);
u_N(1) = 1;

H_N = matriz_H_N(h, N, M);

y_p_N = H_N*u_p;

y_p_N = [y_p_N(1:N); ones(NN-N,1)*y_p_N(N)];

H = matriz_H(h, NN);
y_p_P = H*u_N;

t_N = (0: NN-1);

orange = [0.85 0.33 0.10];
figure
stairs(t_N,y_p_P, 'LineWidth', 2); hold on;
stairs(t_N,y_p_N, 'Color', orange,'LineWidth', 2); hold on;
stairs(t_N, u_N,'LineWidth', 2);

title(['Modelo truncado con N = ',num2str(N)])
legend({'y(t)','y_{hat}(t)','u(t)'})
xlabel('N° de muestra')
ylabel('Amplitud')


%% Modelo de respuesta al impulso N = 25

M = 4;  % Largo del u_p
N = 25;  

NN = 100;

u_p = zeros(M,1);  % impulso en la entrada
u_p(1) = 1;
u_N = zeros(NN,1);
u_N(1) = 1;

H_N = matriz_H_N(h, N, M);

y_p_N = H_N*u_p;

y_p_N = [y_p_N(1:N); ones(NN-N,1)*y_p_N(N)];

H = matriz_H(h, NN);
y_p_P = H*u_N;

t_N = (0: NN-1);

orange = [0.85 0.33 0.10];
figure
stairs(t_N,y_p_P, 'LineWidth', 2); hold on;
stairs(t_N,y_p_N, 'Color', orange,'LineWidth', 2); hold on;
stairs(t_N, u_N,'LineWidth', 2);

title(['Modelo truncado con N = ',num2str(N)])
legend({'y(t)','y_{hat}(t)','u(t)'})
xlabel('N° de muestra')
ylabel('Amplitud')


%% Modelo de respuesta al impulso N = 30

M = 4;  % Largo del u_p
N = 30;  

NN = 100;

u_p = zeros(M,1);  % impulso en la entrada
u_p(1) = 1;
u_N = zeros(NN,1);
u_N(1) = 1;

H_N = matriz_H_N(h, N, M);

y_p_N = H_N*u_p;

y_p_N = [y_p_N(1:N); ones(NN-N,1)*y_p_N(N)];

H = matriz_H(h, NN);
y_p_P = H*u_N;

t_N = (0: NN-1);

orange = [0.85 0.33 0.10];
figure
stairs(t_N,y_p_P, 'LineWidth', 2); hold on;
stairs(t_N,y_p_N, 'Color', orange,'LineWidth', 2); hold on;
stairs(t_N, u_N,'LineWidth', 2);

title(['Modelo truncado con N = ',num2str(N)])
legend({'y(t)','y_{hat}(t)','u(t)'})
xlabel('N° de muestra')
ylabel('Amplitud')


%% Pregunta 2
% Obtención de G
g = h_a_g(h);
P = 4;  % Horizonte de predicción
M = 3;  % Horizonte de control
G = matriz_G(g,P,M);

d = 0;
N = 30;

lambda = 200;

% En base a lo visto en clases se obtiene K para solución óptima
K = inv(G'*G + lambda*eye(M)) * G';

%% Importar datos de simulink
S2 = load('datos_simulink_2.mat');
ee = S2.datos(2,:)';
ee = ee(1:1000);

u = S2.datos(3,:)';
u = u(1:1000);

J1 = ee'*ee + lambda * u'*u


%% Pregunta 2
% Obtención de G
g = h_a_g(h);
P = 4;  % Horizonte de predicción
M = 3;  % Horizonte de control
G = matriz_G(g,P,M);

d = 0;
N = 30;

lambda = 2;

% En base a lo visto en clases se obtiene K para solución óptima
K = inv(G'*G + lambda*eye(M)) * G';


%% Funciones

function H = matriz_H_N(h, N, M)
    H = zeros(N,M);
    for i=(1:M)
        for j=(i:N)
            H(j,i) = h(j-(i-1));
        end
    end
end

function H = matriz_H(h, P)
    H = zeros(P,P);
    for i=(1:P)
        for j=(i:P)
            H(j,i) = h(j-(i-1));
        end
    end
end

function g = h_a_g(h)
    L = length(h);
    g = zeros(L,1);
    for i=(1:L)
        suma = 0;
        for j=(1:i)
            suma = suma + h(j);
        end
        g(i) = suma;
    end
end

function G = matriz_G(g, P, M)
    G = zeros(P,M);
    for i=(1:M)
        for j=(i:P)
            G(j,i) = g(j-(i-1));
        end
    end
end

% function J = calcular_J(u, y_ref, P, M, lambda, G, f)
%     T = length(u);
%     J = zeros(T-P,1);
%     y_hat = G*u + f;
%     for t=(1:T)
%         for i=(1:P)
%             J(t) = J(t) + (y_hat(i) - y_ref(t+i))^2;
%         end
%     end
% end

function J = calcular_J(e, u, lambda)
    J = e'*e + lambda * u'*u;
end
