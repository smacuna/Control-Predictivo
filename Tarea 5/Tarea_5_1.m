
%% Modelo no lineal de la planta

nx = 1;  % Número de estados
ny = 1;  % Número de salidas
nu = 1;  % Número de entradas
% El modelo no tiene perturbaciones externas

Controlador = nlmpc(nx, ny, nu);

%% Se definen propiedades del modelo
Controlador.Model.StateFcn = @funcion_estados;  % Se define función de estados
Controlador.Model.OutputFcn = @funcion_salida;  % Se define función de salida

Controlador.Model.IsContinuousTime = false;  % El modelo es discreto

Controlador.PredictionHorizon = 3;  % Horizonte de predicción
Controlador.ControlHorizon = 2;  % Horizonte de control

%% Valor de Lambda

lambda = 200;

Controlador.Weights.ManipulatedVariablesRate = lambda; 

%% Parámetros adicionales

Controlador.OutputVariables.Name = "pH";

Controlador.ManipulatedVariables.Name = "Flujo de NaOH";


%% Restricción sobre u(k)

%% Funciones

function z = funcion_estados(x,u)  % x(1) = y(k), x(2) = y(k-1)   
z = 0.8*x + 1.2 + 50*u - 250*u^2;
end

function y = funcion_salida(x,u)  % x representa y(k-1)
y = x;
end

function [c,ceq]=modelo_planta(x)
    y = x(1);
    y_old = x(2);
    u = x(3);  % u_old
    ceq = y - 1.2 - 0.8*y_old - 50 * u + 250 * u^2;
end

