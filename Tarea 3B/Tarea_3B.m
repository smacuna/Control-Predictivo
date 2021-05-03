%% Parámetros
a = 0.9;
b = 0.1;
c = 0.1;


%% Definición de u(t)
NN = 300;  % 300 muestras
rng(100);  % Seed = 100
u = randi([0 1],NN,1);  % prbs

% t = (1:1:300)';
% figure
% stairs(t, u)

%% Definición de v(t)
% sigma = 0.1
sigma = 0.01;
rng(100);  % Seed = 100

%v = sigma * wgn(NN,1,1);
v = sigma*randn(NN,1);

mean(v)
std(v)

%% Obtención de y(t)

d = 1;

y = zeros(NN,1);
y(1) = 0;  % Condición inicial
for t = (d+1:NN-1)
    y(t+1) = a*y(t) + b*u(t-d) + c*v(t);
end

t = (1:1:300);
figure
subplot(1,2,1)
stairs(t, [u,v])
legend({'u(t)', 'v(t)'})
xlabel('N° de muestra') 
ylabel('Entradas') 
subplot(1,2,2)
stairs(t, y)
legend({'y(t)'})
xlabel('N° de muestra') 
ylabel('y(t)') 


%% One shot
N = 200;
ventana = 100;
d_test = 1;

theta_hat_1 = one_shot(y,u,v,d_test,N,ventana);

tt = (1+d_test:N-ventana);
figure
stairs(tt,theta_hat_1)
title('Estimación de valores de \theta (one shot)')
legend({'a(t)','b(t)','c(t)'})
xlabel('N° de muestra')
ylabel('Estimación de \theta(t)')

theta_est_1 = mean(theta_hat_1)

%% Cálculo de error

error = calcular_error(y, u, v, theta_est_1, d_test);
ttt = (201:300);

ISE = sum(error.^2)
RMSE = sqrt(mean(error.^2))

figure
plot(ttt,error)
title('Error de estimación (one shot)')
legend({'Error = y_{real} - y_{estimado}'})
xlabel('N° de muestra')
ylabel('Error de estimación') 



%% Recursiva
N = 200;
lambda = 0.9;
d_test = 2;
theta_hat = recursiva(lambda, y, u, v, d_test, N);

theta_est = sum(theta_hat(1+d_test+1:N,:))/(N-(1+d_test+1))

% Gráfico (recursiva)
tt = (1:N);
figure
stairs(tt,theta_hat)
title(['Estimación de valores de \theta (recursivo con \lambda = ', num2str(lambda), ')'])
legend({'a(t)','b(t)','c(t)'})
xlabel('N° de muestra')
ylabel('Estimación de \theta(t)')

%% Cálculo de error
error = calcular_error(y, u, v, theta_est, d_test);
ttt = (201:300);

ISE = sum(error.^2)
RMSE = sqrt(mean(error.^2))

figure
plot(ttt,error)
title(['Error de estimación (recursivo con \lambda = ', num2str(lambda), ')'])
legend({'Error = y_{real} - y_{estimado}'})
xlabel('N° de muestra')
ylabel('Error de estimación') 

%% Cálculos para d = 1
d = 1;

fprintf('\n--------  sigma = 0.01  --------\n');
sigma = 0.01; lambda = 1; d_test = 1; 
mostrar_datos(sigma, lambda, d_test, d, 1);

sigma = 0.01; lambda = 0.99; d_test = 1; 
mostrar_datos(sigma, lambda, d_test, d, 1);

sigma = 0.01; lambda = 0.95; d_test = 1; 
mostrar_datos(sigma, lambda, d_test, d, 1);

sigma = 0.01; lambda = 0.9; d_test = 1; 
mostrar_datos(sigma, lambda, d_test, d, 1);


fprintf('\n--------  sigma = 0.1  --------\n');
sigma = 0.1; lambda = 1; d_test = 1; 
mostrar_datos(sigma, lambda, d_test, d, 1);

sigma = 0.1; lambda = 0.99; d_test = 1; 
mostrar_datos(sigma, lambda, d_test, d, 1);

sigma = 0.1; lambda = 0.95; d_test = 1; 
mostrar_datos(sigma, lambda, d_test, d, 1);

sigma = 0.1; lambda = 0.9; d_test = 1; 
mostrar_datos(sigma, lambda, d_test, d, 1);


fprintf('\n--------  sigma = 1  --------\n');
sigma = 1; lambda = 1; d_test = 1; 
mostrar_datos(sigma, lambda, d_test, d, 1);

sigma = 1; lambda = 0.99; d_test = 1; 
mostrar_datos(sigma, lambda, d_test, d, 1);

sigma = 1; lambda = 0.95; d_test = 1; 
mostrar_datos(sigma, lambda, d_test, d, 1);

sigma = 1; lambda = 0.9; d_test = 1; 
mostrar_datos(sigma, lambda, d_test, d, 1);


%% Imprimir datos para crear tablas en Latex

d = 1
sigma = 0.01
imprimir_datos_latex(d,sigma);
sigma = 0.1
imprimir_datos_latex(d,sigma);
sigma = 1
imprimir_datos_latex(d,sigma);

d = 2
sigma = 0.01
imprimir_datos_latex(d,sigma);
sigma = 0.1
imprimir_datos_latex(d,sigma);
sigma = 1
imprimir_datos_latex(d,sigma);

d = 3
sigma = 0.01
imprimir_datos_latex(d,sigma);
sigma = 0.1
imprimir_datos_latex(d,sigma);
sigma = 1
imprimir_datos_latex(d,sigma);


%% Funciones

function theta_hat = one_shot(y,u,v,d_test,N,ventana)
    
    L = 3;
    datos_totales = N - ventana - (d_test);
    theta_hat = zeros(datos_totales,L);
    
    for i=(1:datos_totales)
        valor_inicial = i+d_test+1; 
        theta_hat(i,:) = one_shot_1_ventana(y,u,v,d_test,ventana,valor_inicial)';
    end
    
end

function theta = one_shot_1_ventana(y,u,v,d_test,ventana, valor_inicial)
    L = 3;
    theta = zeros(L,1);
    
    matriz = zeros(L,L);
    vector = zeros(L,1);
    
    for j=valor_inicial:valor_inicial+ventana-1
        phi_T_k = [-y(j-1) u(j-d_test-1) v(j-1)];
        phi_k = phi_T_k';
        
        matriz = matriz + phi_k*phi_T_k;
        vector = vector + phi_k*y(j);
    end
    theta = matriz\vector;
    
end


function theta_hat = recursiva(lambda, y, u, v, d_test, N)
    na = 1;  % Orden del sistema
    nb = 1;  % Retardo máximo en los u(t-d) para y(t)
    nc = 1;  % Retardo máximo en los v(t) para y(t)
    L = na+nb+nc;
    P = (10^6)*eye(L);

    theta_hat = zeros(N,L);

    for k = (d_test+1+nb:N)
        phi_k = [];
        for a = (1:na)
            phi_k = [phi_k -y(k-a)];
        end
        for b = (1:nb)
            phi_k = [phi_k u(k-d_test-b)];
        end
        for c = (1:nc)
            phi_k = [phi_k v(k-c)];
        end
        phi_k = phi_k';

        P_ant = P;
        num_P = P_ant*(phi_k)*(phi_k)'*P_ant;
        den_P = lambda + (phi_k)'*P_ant*(phi_k);
        P = 1/lambda *(P_ant - num_P/den_P);

        num_H = P_ant*phi_k;
        den_H = lambda + (phi_k)'*P_ant*(phi_k);
        H = num_H/den_H;

        theta_hat(k,:) = theta_hat(k-1,:) + (H*(y(k) - (phi_k)'*(theta_hat(k-1,:))'))';

    end

end


function error = calcular_error(y,u,v,th,d_est)
    
    y_pred = zeros(300);
    % y_pred(1:200) = y(1:200);
    a_est = th(1);
    b_est = th(2);
    c_est = th(3);


    for t = (200:299)
        y_pred(t+1) = -a_est*y_pred(t) + b_est*u(t-d_est) + c_est*v(t);
    end

    error = y(201:300)' - y_pred(201:300);

end


function a = mostrar_datos(sigma, lambda, d_test, d, latex)
    a = 0.9;
    b = 0.1;
    c = 0.1;

    NN = 300;  % 300 muestras
    rng(100);  % Seed = 100
    u = randi([0 1],NN,1);  % prbs
    rng(100);  % Seed = 100
    v = sigma*randn(NN,1);
    
    y = zeros(NN,1);
    y(1) = 0;  % Condición inicial
    for t = (d+1:NN-1)
        y(t+1) = a*y(t) + b*u(t-d) + c*v(t);
    end
    

    N = 200;
    theta_hat = recursiva(lambda, y, u, v, d_test, N);

    theta_est = sum(theta_hat(1+d_test+1:N,:))/(N-(1+d_test+1));
    error = calcular_error(y, u, v, theta_est, d_test);
    
    ISE = sum(error.^2);
    RMSE = sqrt(mean(error.^2));
    
    if (latex == 1)
        fprintf('$RLS$ & %d & - & %f & %f & %f \\\\ \\hline', [d_test, lambda, ISE, RMSE]);
        fprintf('\n');
    else
        fprintf('\n');fprintf('sigma = %f , lambda = %f, d_real = %d, d_test = %d', [sigma, lambda,d,d_test]);
        fprintf('\n');
        fprintf('ISE = %f, RMSE = %f', [ISE, RMSE]);

        fprintf('\n');


        fprintf('%f & %f & %d & %f & %f', [sigma, lambda, d_test, ISE, RMSE]);
        fprintf('\n');
    end
    
    
end

function a = mostrar_datos_oneshot(sigma, ventana, d_test, d)
    a = 0.9;
    b = 0.1;
    c = 0.1;

    NN = 300;  % 300 muestras
    rng(100);  % Seed = 100
    u = randi([0 1],NN,1);  % prbs
    rng(100);  % Seed = 100
    v = sigma*randn(NN,1);
    
    y = zeros(NN,1);
    y(1) = 0;  % Condición inicial
    for t = (d+1:NN-1)
        y(t+1) = a*y(t) + b*u(t-d) + c*v(t);
    end
    
    N = 200;

    theta_hat_1 = one_shot(y,u,v,d_test,N,ventana);
    
    theta_est_1 = mean(theta_hat_1);
    
    error = calcular_error(y, u, v, theta_est_1, d_test);

    ISE = sum(error.^2);
    RMSE = sqrt(mean(error.^2));
    
    fprintf('\\textit{One Shot} & %d & %d & - & %f & %f \\\\ \\hline', [d_test, ventana, ISE, RMSE]);
    fprintf('\n');

end

function a = imprimir_datos_latex(d,sigma)
    a = 1;
    ventana = 100;
    
    fprintf('\\begin{table}[]\n\\begin{tabular}{|1|l|l|l|l|l|}\n\\hline\n');
    fprintf('Método & $\\hat{d}$ & N & $\\lambda$ & ISE & RMSE \\\\ \\hline\n');
    
    d_test = 1;
    
    mostrar_datos_oneshot(sigma, ventana, d_test, d);
    
    lambda = 1; 
    mostrar_datos(sigma, lambda, d_test, d, 1);
    lambda = 0.99; 
    mostrar_datos(sigma, lambda, d_test, d, 1);
    lambda = 0.95; 
    mostrar_datos(sigma, lambda, d_test, d, 1);
    lambda = 0.9; 
    mostrar_datos(sigma, lambda, d_test, d, 1);
    
    d_test = 2;
    
    mostrar_datos_oneshot(sigma, ventana, d_test, d);
    
    lambda = 1; 
    mostrar_datos(sigma, lambda, d_test, d, 1);
    lambda = 0.99; 
    mostrar_datos(sigma, lambda, d_test, d, 1);
    lambda = 0.95; 
    mostrar_datos(sigma, lambda, d_test, d, 1);
    lambda = 0.9; 
    mostrar_datos(sigma, lambda, d_test, d, 1);
    
    d_test = 3;
    
    mostrar_datos_oneshot(sigma, ventana, d_test, d);
    
    lambda = 1; 
    mostrar_datos(sigma, lambda, d_test, d, 1);
    lambda = 0.99; 
    mostrar_datos(sigma, lambda, d_test, d, 1);
    lambda = 0.95; 
    mostrar_datos(sigma, lambda, d_test, d, 1);
    lambda = 0.9; 
    mostrar_datos(sigma, lambda, d_test, d, 1);

    
    fprintf('\\end{tabular}\n\\end{table}\n');

end