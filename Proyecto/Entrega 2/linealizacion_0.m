

S = load('lin_1 (u_0).mat');

t = S.u_y(1,:);
u_sa = S.u_y(2,:);
u_th = S.u_y(3,:);
u_egr = S.u_y(4,:);

y_T = S.u_y(5,:);
y_hK = S.u_y(6,:);
y_hM = S.u_y(7,:);
y_qf = S.u_y(8,:);

%% iddata
Ts = t(2);
u_id = [u_sa', u_th', u_egr'];
% y_id = [y_T', y_hK', y_hM', y_qf'];
y_id = [y_T', y_qf'];

data = iddata(y_id, u_id, Ts);
%%
sys = n4sid(data);


%% iddata 50%
Ts = t(2);
u_id = [u_sa', u_th', u_egr'];
y_id = [y_T', y_hK', y_hM', y_qf'];
% u_id2 = u_id(1:500000,:);
% y_id2 = y_id(1:500000,:);
% data2 = iddata(y_id2, u_id2, Ts);
%%
sys2 = n4sid(data2);



%% save
save('entrega_2_variables (u_0).mat')

%% Discretizar

A_1 = [0];
B_1 = [0 0 0];
C_1 = [0;0];
D_1 = [0.1577 6.775 0.2081;
    5.8115*10^(-12) 4.289*10^(-6) 1.4775*10^(-8)];
Ts_1 = 0.1;

sysc = ss(A_1, B_1, C_1, D_1);
sysd = c2d(sysc, Ts_1);

%% Leer MPC

MPC_1 = load('C:\Users\Seb\Documents\MATLAB\Control Predictivo\Proyecto\Entrega 2\MPCDesignerSession1.mat');
mpc_1 = MPC_1.MPCDesignerSession.AppData.Controllers.MPC;


%% Plots simulacion

figure
plot(t,u_sa);hold on;
plot(t,u_th);hold on;
plot(t,u_egr);

figure
plot(t,y_T);

figure
plot(t,y_hK);hold on;
plot(t,y_hM);
figure
plot(t,y_qf);
