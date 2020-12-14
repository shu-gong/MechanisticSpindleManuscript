%% mtu isometric force pulse simulation
clear,clc
tic
time_step = 0.001; %Temporal precision
t = 0:time_step:3.5; % Time vector

numSims = 16;

delta_f_activated = zeros(numSims,length(t));
delta_cdl = zeros(size(t));
delta_f_activated(:,1) = 0.2;

act_dura = 2000;

delta_act = 1e-4;
act_start = 1500;

mtData = struct('f_activated',[],'cb_force',[],'passive_force',[],...
    'hs_force',[],'hs_length',[],'cmd_length',[]);

for a = 1:numSims
    delta_f_activated(a,act_start:act_start+act_dura-2) = delta_act*0.25*a;
end

parfor a = 1:numSims
    mtData(a) = musTenDriver(t,delta_f_activated(a,:),delta_cdl);
end

toc;

%% plot mtu as sanity check
figure; 
for a = 1:numSims
   plot(mtData(a).f_activated); hold on
end

figure;
for a = 1:numSims
    plot(mtData(a).hs_length); hold on
end


%% Run spindle portion of simulation

tic;

delta_cdl = zeros(numSims,length(t));

delta_act = 1e-4;
act_start = 1500;
delta_f_activated = zeros(size(t));
delta_f_activated(1) = 0.2;
delta_f_activated(act_start:act_start+act_dura-2) = delta_act*4;

for a = 1:4%1:numSims
    delta_cdl(a,:) = [0 diff(mtData(a).hs_length)];
end

delta_cdl(:,1:1000) = 0; %this is to get rid of settling from mt sims

parfor a = 1:4%:numSims
    [hsB(a),dataB(a),hsC(a),dataC(a)] = sarcSimDriver(t,delta_f_activated,delta_cdl(a,:));
end
toc;


%%
figure;
for a = 1:numSims
    plot(dataB(a).hs_force); hold on
end

figure;
for a = 1:numSims
    plot(dataB(a).hs_length); hold on
end

%% Plot overall results
time_step = 0.001; %Temporal precision
t = 0:time_step:3.5; % Time vector

numSims = 16;

% load('mtSim_isoRamp_AGCoAct.mat')
% load(['..' filesep 'data' filesep 'mtSim_isoRamp_noGamma.mat'])
load(['..' filesep 'data' filesep 'mtSim_isoRamp_AGCoAct.mat'])

pltIdx = 1250:3500;

[r,rs,rd] = sarc2spindle(dataB,dataC,1,2,0.1,1,0.05); 

% mtData.pm_force = 1e3 * (mtData.cmd_length - 1200) + 1e-10 * exp(mtData.cmd_length/40); %perimysium

figure(1);
set(gcf,'Renderer','Painters')
clf;
% Musculotendon 
subplot(4,1,1); hold on
for a = 1:numSims
%     plot(t,mtData(a).cmd_length - mtData(a).cmd_length(1))
    plot(t(pltIdx),mtData(a).hs_length(pltIdx) - mtData(a).hs_length(1),'Color',[0.5 0.5 0.5]/a)
%     plot(t,(mtData(a).cmd_length - mtData(a).cmd_length(1)) - (mtData(a).hs_length - mtData(a).hs_length(1)))
end
% legend('\Delta MT len.','\Delta fas. len.','\Delta ten. len.')

% Musculotendon Force
subplot(4,1,2); hold on
for a = 1:numSims
    plot(t(pltIdx),mtData(a).f_activated(pltIdx),'Color',[0.5 0.5 0.5]/a)
%     plot(t,mtData(a).pm_force + mtData(a).hs_force)
%     plot(t,mtData(a).pm_force)
end
% legend('Fiber force','MTU force','Perimysial force')

%Extrafusal vs. intrafusal force
subplot(4,1,3); hold on
for a = 1:numSims
%     plot(t,mtData(a).hs_force,'Color',[0.9 0.3 0.3])
    plot(t(pltIdx),dataB(a).hs_force(pltIdx),'Color',[0.5 0.5 0.5]/a)
end
% legend('Extrafusal','Intrafusal')



% Spindle rate
subplot(4,1,4); hold on
for a = 1:numSims
    [r,rs,rd] = sarc2spindle(dataB(a),dataC(a),1,2,0.1,1,0.05);
    plot(t(pltIdx),dataC(a).hs_force(pltIdx),'Color',[0.5 0.5 0.5]/a)
%     plot(t,rd - 0.05)
%     plot(t,rs - 0.05)
end
% legend('Ia firing rate','Bag comp.','Chain comp.')
