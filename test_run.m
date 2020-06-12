%% test of mtu simulation
    clear,clc
    tic
    time_step = 0.001; %Temporal precision
    t = 0:time_step:10; % Time vector
    
    delta_f_activated = zeros(size(t));
    delta_cdl = zeros(size(t));
    delta_f_activated(1) = 0.1;
    
%     act_dura = 500;
%     act_height = 0.001;
%     act_width = 0.3;
%     delta_act = gausswin(act_dura,1/act_width)*act_height;
%     act_start = 2000;
%     
%     delta_f_activated(act_start:act_start+act_dura-1) = delta_act;
    
    delta_cdl(6500:6900) = 0.3;
    
    mtData = musTenDriver(t,delta_f_activated,delta_cdl);
    
    mtData.pm_force = 1e3 * (mtData.cmd_length - 1200) + 1e-10 * exp(mtData.cmd_length/40); %perimysium

    
    beep; toc;
    
%% plot results

plot(mtData.hs_length);
hold on
plot(mtData.cmd_length);
plot(mtData.cmd_length - mtData.hs_length);

figure; hold on;
plot(mtData.hs_force)
plot(mtData.passive_force)
plot(mtData.hs_force + mtData.passive_force + mtData.pm_force)

figure; hold on;
plot(mtData.f_activated);



 %% Elek et al. 1990 simulations (need to load mtu data from other sim)
tic

delta_cdl = [0 diff(mtData.hs_length)];

delta_f_activated = delta_f_activated;

delta_f_activated = zeros(size(delta_f_activated));
delta_f_activated(1) = 0.3;


[hsB,dataB,hsC,dataC] = sarcSimDriver(t,delta_f_activated,delta_cdl);

toc


%% 
[r,rs,rd] = sarc2spindle(dataB,dataC,1,2,0.1,1,0.05); 

mtData.pm_force = 1e3 * (mtData.cmd_length - 1200) + 1e-10 * exp(mtData.cmd_length/40); %perimysium

figure(1);
clf;
% Musculotendon 
subplot(4,1,1); hold on
plot(t,mtData.cmd_length - mtData.cmd_length(1))
plot(t,mtData.hs_length - mtData.hs_length(1))
plot(t,(mtData.cmd_length - mtData.cmd_length(1)) - (mtData.hs_length - mtData.hs_length(1)))
legend('\Delta MT len.','\Delta fas. len.','\Delta ten. len.')

% Musculotendon Force
subplot(4,1,2); hold on
plot(t,mtData.hs_force)
plot(t,mtData.pm_force + mtData.hs_force)
plot(t,mtData.pm_force)
legend('Fiber force','MTU force','Perimysial force')

%Extrafusal vs. intrafusal force
subplot(4,1,3); hold on
plot(t,mtData.hs_force)
plot(t,dataB.hs_force)
legend('Extrafusal','Intrafusal')



% Spindle rate
subplot(4,1,4); hold on
plot(t,r)
plot(t,rd - 0.05)
plot(t,rs - 0.05)
legend('Ia firing rate','Bag comp.','Chain comp.')
