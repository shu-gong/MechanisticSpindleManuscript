%% mtu isometric force pulse simulation
clear,clc
tic
time_step = 0.001; %Temporal precision
t = 0:time_step:15; % Time vector

delta_f_activated = zeros(size(t));
delta_cdl = zeros(size(t));
delta_f_activated(1) = 0.1;

act_dura = 1000;
act_height = 0.4;
act_width = 0.3;
delta_act = gausswin(act_dura,1/act_width)*act_height;
act_start = 2000;
act_start2 = 6000;
act_start3 = 8000;

delta_f_activated(act_start:act_start+act_dura-2) = diff(delta_act);
delta_f_activated(act_start2:act_start2+act_dura-2) = diff(delta_act);
delta_f_activated(act_start3:act_start3+act_dura-2) = diff(delta_act)/2;

%     delta_cdl(6500:6900) = 0.3;

mtData = musTenDriver(t,delta_f_activated,delta_cdl);

%     mtData.pm_force = 1e3 * (mtData.cmd_length - 1200) + 1e-10 * exp(mtData.cmd_length/40); %perimysium


beep; toc;

%% plot mtu as sanity check

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



%% Run spindle portion of simulation

tic;

delta_cdl = [0 diff(mtData.hs_length)];


delta_f_activated = zeros(size(delta_f_activated));
delta_f_activated(1) = 0.1;

act_start = 4000;
act_start2 = 6000;
act_start3 = 8e3;

delta_f_activated(act_start:act_start+act_dura-2) = diff(delta_act)/2;
delta_f_activated(act_start2:act_start2+act_dura-2) = diff(delta_act)/2;
delta_f_activated(act_start3:act_start3+act_dura-2) = diff(delta_act);



[hsB,dataB,hsC,dataC] = sarcSimDriver(t,delta_f_activated,delta_cdl);

toc; beep;


%% Plot overall pulse results as sanity check 
time_step = 0.001; %Temporal precision
t = 0:time_step:15; % Time vector

% load('mtSim_isoPulses.mat')

[r,rs,rd] = sarc2spindle(dataB,dataC,1,2,0.1,0.5,0.01); 

mtData.pm_force = 1e3 * (mtData.cmd_length - 1200) + 1e-10 * exp(mtData.cmd_length/40); %perimysium

figure(1);
set(gcf,'Renderer','Painters')
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
plot(t,rd)
plot(t,rs)
legend('Ia firing rate','Bag comp.','Chain comp.')

%% Generate spikes with Bernoulli process

n = ones(size(t)); %Bernoulli "trials", which should be 1 for each time point
p = (r-0.02)*0.5; %probability of a spike at any time point (based on spindle rate)
p(p<0) = 0;

subplot(3,1,1); hold on
for trial = 1:100
    spikes(trial,:) = binornd(n,p);
    sIdx = find(spikes(trial,:) == 1); %get time indices of spikes
    st = t(sIdx);
    plot([st; st],[trial-1; trial],'k'); hold on;
end

subplot(3,1,2)
plot(t,smooth(mean(spikes),100))

subplot(3,1,3)
plot(t,r)


%% Generate spikes with Integrate and fire neuron
time_step = 1e-4; %Temporal precision
t = 0:time_step:15; % Time vector


clear v
v_reset = -0.08; %reset voltage
E_l = -0.07; %Nernst leak potential in V
g_l = 2.5e-8; %leak conductance in S
tau = 2e-2; %time constant (s)
v(1) = -0.07; %initial condition
u = (r-0.03)*5e-1; %scale r from spindle model into current
u = interp1(0:0.001:15,u,t); %upsample to higher precision

v_th = -0.0;   %threshold voltage for spike
tsim = t;
dt = 1e-4; %

for i = 1:1:length(t)-1
    
    v(i+1) = v(i) + dt*((u(i) - g_l*(v(i) - E_l))/tau);
 
    if v(end) >= v_th
        spike(i+1) = 1;
        v(end) = v_reset;
    else
        spike(i+1) = 0;
    end
    
end
sIdx = find(spike==1);
st = tsim(sIdx);
ISI = diff(st);
IFR = 1./ISI;

subplot(4,1,1)
hold on;
% plot(st(2:end),IFR,'k.')
plot(t(1:10:end),mtData.hs_force/1e4)
plot([st; st],[5 10],'k')


subplot(4,1,2)
hold on;
plot(t(1:10:end),r)

subplot(4,1,3)
hold on;
plot(t(1:10:end),mtData.hs_length)

subplot(4,1,4)
hold on;
plot(t(1:10:end),mtData.hs_force)
% plot(t,v)