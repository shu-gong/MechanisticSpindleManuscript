%% mtu ramps
clear,clc
tic
time_step = 0.001; %Temporal precision
t = 0:time_step:5.5; % Time vector

numSims = 4;

delta_f_activated = zeros(numSims,length(t));
delta_cdl = zeros(size(t));
delta_f_activated([1 3],1) = 0.1;
delta_f_activated([2 4],1) = 0.6;

delta_cdl(:,4200:4700) = 0.1;

mtData = struct('f_activated',[],'cb_force',[],'passive_force',[],...
    'hs_force',[],'hs_length',[],'cmd_length',[]);



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

delta_f_activated = zeros(size(delta_cdl));

delta_f_activated([1 2],1) = 0.3;
delta_f_activated([3 4],1) = 0.7;

for a = 1:numSims
    delta_cdl(a,:) = [0 diff(mtData(a).hs_length)];
end

% delta_cdl(:,1:1000) = 0; %this is to get rid of settling from mt sims

parfor a = 1:numSims
    [hsB(a),dataB(a),hsC(a),dataC(a)] = sarcSimDriver(t,delta_f_activated(a,:),delta_cdl(a,:));
end
toc;


%%
figure;
for a = 1:numSims
    plot(dataB(a).hs_force); hold on
end

figure;
for a = 1:numSims
    plot(dataB(a).cmd_length); hold on
end

%% Plot overall results

time_step = 0.001; %Temporal precision
t = 0:time_step:5.5; % Time vector

numSims = 4;

% load('mtSim_isoRamp_AGCoAct.mat')
load('../manuscript_data/Fig9.mat')

pltIdx = 3000:5500;

[r,rs,rd] = sarc2spindle(dataB,dataC,1,2,0.1,1,0.05); 

% mtData.pm_force = 1e3 * (mtData.cmd_length - 1200) + 1e-10 * exp(mtData.cmd_length/40); %perimysium

figure(1);
set(gcf,'Renderer','Painters','Color','White')
clf;

% gamma activation
subplot(5,6,[3 4]); hold on
set(gca,'XTick',[],'TickDir','out','FontName','Helvetica'), ylabel('gamma act.')
axis([3 5.5 0 1])
plot(t(pltIdx),zeros(size(dataB(1).f_activated(pltIdx))),'Color',[0 0 0])

subplot(5,6,[5 6]); hold on
set(gca,'XTick',[],'YTick',[],'TickDir','out','FontName','Helvetica')
axis([3 5.5 0 1])
plot(t(pltIdx),dataB(3).f_activated(pltIdx),'Color',[0 0 0],'LineWidth',2)

colors = [0.3 0.8 0.4; 0.7 0.3 0.7; 0.3 0.8 0.4; 0.7 0.3 0.7];

% Musculotendon 
subplot(5,6,[19 20 25 26]); hold on
set(gca,'XTick',[],'TickDir','out','FontName','Helvetica'), ylabel('length')
for a = [4]
    plot(t(pltIdx),mtData(a).hs_length(pltIdx) - mtData(a).hs_length(1),'Color',colors(a,:))
end
plot(t(pltIdx),mtData(a).cmd_length(pltIdx) - mtData(a).cmd_length(1),'Color',[0 0 0])

subplot(5,6,[7 8 13 14]); hold on
set(gca,'XTick',[],'TickDir','out','FontName','Helvetica'), ylabel('length')
for a = [1]
    plot(t(pltIdx),mtData(a).hs_length(pltIdx) - mtData(a).hs_length(1),'Color',colors(a,:))
end
plot(t(pltIdx),mtData(a).cmd_length(pltIdx) - mtData(a).cmd_length(1),'Color',[0 0 0])


%%% Generate spikes with Integrate and fire neuron
time_step = 1e-4; %Temporal precision
tnew = 3:time_step:5.5; % Time vector
t = 3:0.001:5.5;


for a = 1:numSims
    [r,rs,rd] = sarc2spindle(dataB(a),dataC(a),3,2,0.2,1,0.05);
    r = r(3001:end);

    clear v
    v_reset = -0.08; %reset voltage
    E_l = -0.07; %Nernst leak potential in V
    g_l = 2.5e-8; %leak conductance in S
    tau = 2e-2; %time constant (s)
    v(1) = -0.07; %initial condition
    u = (r-0.03)*8e-2; %scale r from spindle model into current
    u = interp1(t,u,tnew); %upsample to higher precision
    
    v_th = -0.04;   %threshold voltage for spike
    tsim = tnew;
    dt = 1e-4; %
    
    for i = 1:1:length(tnew)-1
        
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
    
    if a == 1
        subplot(5,6,[9 10 15 16])
        set(gca,'XTickLabels',[],'TickDir','out','FontName','Helvetica')
        
    elseif a == 2
        subplot(5,6,[21 22 27 28])
        set(gca,'TickDir','out','FontName','Helvetica')
        
    elseif a == 3
        subplot(5,6,[11 12 17 18])
        set(gca,'YTickLabels',[],'XTickLabels',[],'TickDir','out','FontName','Helvetica')
        
    elseif a == 4
        subplot(5,6,[23 24 29 30])
        set(gca,'YTickLabels',[],'TickDir','out','FontName','Helvetica')
    end
    
    axis([3 5.5 0 60])
    hold on;
    plot(st(2:end),IFR,'.','Color',colors(a,:))
    plot([st; st],[0 5],'Color',colors(a,:),'LineWidth',0.2)
    plot(t,r*40,'Color',colors(a,:),'LineStyle','-','LineWidth',2)
        
end
