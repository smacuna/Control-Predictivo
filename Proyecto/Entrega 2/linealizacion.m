

S = load('lin_1 (u_2).mat');

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
y_id = [y_T', y_hK', y_hM', y_qf'];

data = iddata(y_id, u_id, Ts);

sys = n4sid(data);

%% save
save('entrega_2_variables (u_2).mat')

%% 


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
