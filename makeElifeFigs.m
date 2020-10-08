%% Figure 4: A
load(['..' filesep 'data' filesep 'Fig5ACD.mat']); %Just used data from dynamic index sims
idx = 6000:9500;
time = dataS(1).t(idx);
dataY = dataD(1);
dataF = dataS(1);
L0 = dataF.hs_length(1);

hfig = figure;
set(hfig,'Color','White')

haff = subplot(2,2,1:2); hold on;
set(haff,'TickDir','out','FontName','Arial','FontSize',10,...
    'xtick',[],'NextPlot','add')
ylabel('Firing Rate (au)')
axis([time(1) time(end) 0 0.25])

hlen = subplot(2,2,3:4); hold on;
set(hlen,'TickDir','out','FontName','Arial','FontSize',10,'NextPlot','add')
ylabel('Applied Length (L0)'), xlabel('time (s)')
axis([time(1) time(end) 1300/L0 1400/L0])

% Dynamic parameters
kFs_dyn = 1;
kFd_dyn = 1;
kY_dyn = 0.03;
[r,rs,rd] = sarc2spindle(dataY,dataF,kFs_dyn,kFd_dyn,kY_dyn,1,0);

% Static Parameters
% kFs_stat = 1.5;
% kFd_stat = 0.8;
% kY_stat = 0.01;
% [r,rs,rd] = sarc2spindle(dataY,dataF,kFs_stat,kFd_stat,kY_stat,0.3,0);

lineStyles = linspecer(3);
lineStyles = lineStyles - 0.1;
lineStyles(lineStyles<0) = 0;


h_r = line(time,r(idx),'Parent',haff,'color',lineStyles(1,:),'LineWidth',1.5);
h_sC = line(time,rs(idx),'Parent',haff,'color',lineStyles(2,:),'LineWidth',1.5);
h_dC = line(time,rd(idx),'Parent',haff,'color',lineStyles(3,:),'LineWidth',1.5);

h_cdl = line(time,dataF.cmd_length(idx)/L0,'Parent',hlen,'color','k','LineWidth',1.5);

%% Figure 4: D
load(['..' filesep 'data' filesep 'Fig4D.mat']);
time = dataC(1).t;
dataD = dataB(1);
dataS = dataC(1);
L0 = dataS.hs_length(1);

% vertical lines corresponding to xb distributions in figure
% Note: did not use 55e2 or 655e1 in figure (too crowded)
idx_vline = [45e2 50e2 55e2 56e2 57e2 61e2 65e2 655e1 66e2 68e2 1025e1 104e2 11e3 13e3 18e3]/1e3 - 5;


hfig = figure;
set(hfig,'Color','white')

hForce = subplot(2,2,1:2); hold on;
set(hForce,'TickDir','out','FontName','Arial','FontSize',10,...
    'xtick',[],'NextPlot','add')
ylabel('Stress (MPa)')
axis([time(1) time(end) 0 0.2])

hlen = subplot(2,2,3:4); hold on;
set(hlen,'TickDir','out','FontName','Arial','FontSize',10,'NextPlot','add')
ylabel('applied length (L0)'), xlabel('time (s)')
% axis([time(1) time(end) 1300/L0 1400/L0])

lineStyles = linspecer(2);
lineStyles = lineStyles - 0.1;
lineStyles(lineStyles<0) = 0;



h_D = line(time,dataD.hs_force/10^6,'Parent',hForce,'color',lineStyles(1,:),'LineWidth',1.5);
h_S = line(time,dataS.hs_force/10^6,'Parent',hForce,'color',lineStyles(2,:),'LineWidth',1.5);

h_cdl = line(time,dataS.cmd_length/L0,'Parent',hlen,'color','k','LineWidth',1.5);
h_hslS = line(time,dataS.hs_length/L0,'Parent',hlen,'color',lineStyles(2,:),'LineWidth',1.5);
h_hslD = line(time,dataD.hs_length/L0,'Parent',hlen,'color',lineStyles(1,:),'LineWidth',1.5);

for i = 1:numel(idx_vline)
    line([idx_vline(i) idx_vline(i)], [1300/L0 1400/L0],'Parent',hlen,'color','k'), hold on
end


%% Figure 5: A,C,D
load(['..' filesep 'data' filesep 'Fig5A.mat']);
time = dataS(1).t;
L0 = dataS(1).hs_length(1);
idx = 6500:8000;


hfig = figure;
set(hfig,'Color','White')


kFs = 1;
kFd = 1;
kY = 0.03;

haff = subplot(2,2,1:2); hold on;
set(haff,'TickDir','out','FontName','Arial','FontSize',10,...
    'xtick',[],'NextPlot','add')
ylabel('Firing Rate (au)')
axis([time(idx(1)) time(idx(end)) 0 0.35])

hlen = subplot(2,2,3:4); hold on;
set(hlen,'TickDir','out','FontName','Arial','FontSize',10,'NextPlot','add')
ylabel('Applied Length (L0)'), xlabel('time (s)')
axis([time(idx(1)) time(idx(end)) 1300/L0 1400/L0])


lineStyles = linspecer(numel(dataS));
lineStyles = lineStyles - 0.1;
lineStyles(lineStyles<0) = 0;


for a = numel(dataS):-1:1
    dataY = dataD(a);
    dataF = dataS(a);
    [r,rs,rd] = sarc2spindle(dataY,dataF,kFs,kFd,kY,1,0.09);
    h_r = line(time(idx),r(idx),'Parent',haff,'Color',lineStyles(a,:),'linewidth',1.5); hold on;
    h_cdl = line(time(idx),dataF.cmd_length(idx)/L0,'Parent',hlen,'Color',lineStyles(a,:),'linewidth',1.5); hold on;
end

load(['..' filesep 'data' filesep 'Fig5CD.mat']);
hfig2 = figure;
set(hfig2,'Color','White')

hDI = subplot(2,2,1:2); hold on;
set(hDI,'TickDir','out','FontName','Arial','FontSize',10,...
    'NextPlot','add')
plot(vel,DI,'.','MarkerSize',10)

hIB = subplot(2,2,3:4); hold on;
set(hIB,'TickDir','out','FontName','Arial','FontSize',10,'NextPlot','add')
plot(acc,IB,'.','MarkerSize',10)

%% Figure 6: A
load(['..' filesep 'data' filesep 'Fig6A.mat']);
idx = 4000:17000;
time = dataS(1).t(idx);
L0 = dataS(1).hs_length(1);

hfig = figure;
set(hfig,'Color','White')


kFs = 1;
kFd = 1;
kY = 0.03;

haff = subplot(2,2,1:2); hold on;
set(haff,'TickDir','out','FontName','Arial','FontSize',10,...
    'xtick',[],'NextPlot','add')
ylabel('Firing Rate (au)')
axis([time(1) time(end) 0 0.1])

hlen = subplot(2,2,3:4); hold on;
set(hlen,'TickDir','out','FontName','Arial','FontSize',10,'NextPlot','add')
ylabel('Applied Length (L0)'), xlabel('time (s)')
axis([time(1) time(end) 1300/L0 1400/L0])


lineStyles = linspecer(numel(dataS));
lineStyles = lineStyles - 0.1;
lineStyles(lineStyles<0) = 0;


for a = 1:numel(dataS)
    dataY = dataD(a);
    dataF = dataS(a);
    [r,rs,rd] = sarc2spindle(dataY,dataF,kFs,kFd,kY,1,0.09);
    h_r = line(time,r(idx),'Parent',haff,'Color',lineStyles(a,:),'linewidth',1.5);
    h_cdl = line(time,dataF.cmd_length(idx)/L0,'Parent',hlen,'Color',lineStyles(a,:),'linewidth',1.5);
%     h_sC = line(time,sC,'Parent',h1);
%     h_dC = line(time,dC,'Parent',h1);

end

%% Fig 6: B

load(['..' filesep 'data' filesep 'test4.mat']);
time = dataS(1).t;

hfig = figure;
set(hfig,'Color','White')


kFs = 1.8;
kFd = 2;
kY = 0.15;


haff = subplot(1,2,1:2); hold on;
set(haff,'TickDir','out','FontName','Arial','FontSize',10,'NextPlot','add')
ylabel('Normalized firing rate')
axis([-1 11.5 -0.5 0.5])


dataY = dataD;
dataF = dataS;
[r,rs,rd] = sarc2spindle(dataY,dataF,kFs,kFd,kY,0,0.09);
h_r = line(time,r,'Parent',haff);
h_cdl = line(time,dataF.cmd_length/1300-1,'Parent',haff);


%% Fig 7: A,B,C
clear, clc

load(['..' filesep 'data' filesep 'Fig7A.mat']);
% load(['..' filesep 'data' filesep 'test4.mat']);

time = dataS(1).t;
L0 = dataS(1).hs_length(1);

hfig = figure;
set(hfig,'Color','White')


kFs = 1.5;
kFd = 0.8;
kY = 0.03;


haff = subplot(2,2,1:2); hold on;
set(haff,'TickDir','out','FontName','Arial','FontSize',10,...
    'xtick',[],'NextPlot','add')
ylabel('Firing Rate (au)')
axis([-1 2 0.0 0.3])

hlen = subplot(2,2,3:4); hold on;
set(hlen,'TickDir','out','FontName','Arial','FontSize',10,'NextPlot','add')
ylabel('Applied Length (L0)'), xlabel('time (s)')
axis([-1 2 1300/L0 1400/L0])


BR = []; %baseline rate
DR = []; %dynamic response
PR = []; %plateau rate
%This part is for static
% for a = 3
%     for b = [2:8]
%This part is for dynamic
for a = [2:8]
    for b = [3]
        dataY = dataD(a);
        dataF = dataS(b);
        [r,rs,rd] = sarc2spindle(dataY,dataF,kFs,kFd,kY,1,0.09);
        h_r = line(time,r,'Parent',haff,'Color',[b/8 0 a/8],'LineWidth',1.5);
        h_cdl = line(time,dataF.cmd_length/L0,'Parent',hlen,'Color','k','LineWidth',1.5);
        
        BR(end+1) = r(4000);
        DR(end+1) = r(5599);
        PR(end+1) = r(6199);
        
    end
end

hfig2 = figure; 
set(hfig2,'Color','White'), hold on
plot(1:length(DR),DR,'.','MarkerSize',25)
plot(1:length(PR),PR,'.','MarkerSize',25)
plot(1:length(BR),BR,'.','MarkerSize',25)

hfig3 = figure;
set(hfig3,'Color','White')

for i = length(BR)
    dataY = dataD(a);
    dataF = dataS(b);
    [r,rs,rd] = sarc2spindle(dataY,dataF,kFs,kFd,kY,1,0.09);
end

plot(0.3:0.1:0.9,DR-PR,'.','MarkerSize',25)


%% Spindle model - XB Distribution
load(['..' filesep 'data' filesep '2018-08-23' filesep 'THD 2018-08-23.mat']);
hfig = figure;
set(hfig,'Color','White')

%Dynamic
data = dataD(1);
hs = hsD(1);

%Static
data = dataS(1);
hs = hsS(1);

xbl = hs.x_bins;
pops = data.bin_pops(:,1:100:end);

lineStyles = linspecer(2);
lineStyles = lineStyles - 0.1;
lineStyles(lineStyles<0) = 0;

idx = [45e2 50e2 55e2; 56e2 57e2 61e2; 65e2 655e1 66e2; 68e2 1025e1 104e2; 11e3 13e3 18e3];
counter = 0;
for i = 1:5
    for j = 1:3
        counter = counter + 1;
        pops = data.bin_pops(:,idx(i,j));
        subplot(5,3,counter), hold on
        set(gca,'FontName','Arial','FontSize',8)
        axis([-20 20 0 0.2])
        title(num2str(idx(i,j)/1000))
        plot(xbl,pops,'Color',lineStyles(2,:))
    end
end


%% Spindle Model - Alpha-gamma coactivation
% load(['..' filesep 'data' filesep '2018-08-23' filesep 'Alpha-gamma ramp 2018-09-21.mat'])
load(['..' filesep 'data' filesep '2018-08-23' filesep 'alphaGamma2018-10-23.mat'])
idx = 4000:9000;
time = dataS(1).t(idx);
L0 = dataS(1).hs_length(1);

hfig = figure;
set(hfig,'Color','White')

kFs = 1;
kFd = 1;
kY = 0.03;

haff = subplot(3,2,1:2); hold on;
set(haff,'TickDir','out','FontName','Arial','FontSize',10,...
    'xtick',[],'NextPlot','add')
ylabel('Firing Rate (au)')
axis([time(1) time(end) 0 0.25])

hlen = subplot(3,2,3:4); hold on;
set(hlen,'TickDir','out','FontName','Arial','FontSize',10,'NextPlot','add')
ylabel('Applied Length (L0)'), xlabel('time (s)')
axis([time(1) time(end) 1250/L0 1300/L0])

hact = subplot(3,2,5:6); hold on;
set(hact,'TickDir','out','FontName','Arial','FontSize',10,'NextPlot','add')
ylabel('Gamma Activation (normalized)'), xlabel('time (s)')
axis([time(1) time(end) 0 1])

lineStyles = linspecer(numel(dataS));
lineStyles = lineStyles - 0.1;
lineStyles(lineStyles<0) = 0;


for a = 1:numel(dataS)
    dataY = dataD(a);
    dataF = dataS(a);
    [r,rs,rd] = sarc2spindle(dataY,dataF,kFs,kFd,kY,1,0.05);
    h_r = line(time,r(idx),'Parent',haff,'Color',lineStyles(a,:),'linewidth',1.5);
    h_cdl = line(time,dataF.cmd_length(idx)/L0,'Parent',hlen,'Color',lineStyles(a,:),'linewidth',1.5);
    h_act = line(time,dataF.f_activated(idx),'Parent',hact,'Color',lineStyles(a,:),'linewidth',1.5);
%     h_sC = line(time,sC,'Parent',h1);
%     h_dC = line(time,dC,'Parent',h1);

end


%% Musculotendon simulations

load(['..' filesep 'data' filesep 'mt_sim_data_lA_lG.mat'])

[r,rs,rd] = sarc2spindle(dataB,dataC,1,1,0.03,1,0.05); 


t = 0:0.001:10;

figure(1); set(gcf, 'Color', 'White')
clf;
% Musculotendon 
subplot(4,1,1); hold on
set(gca,'FontName','Helvetica','FontSize',8,'XTick',[])
plot(t,mtData.cmd_length - 1300)
plot(t,mtData.hs_length - 1300)
plot(t,mtData.cmd_length - mtData.hs_length)
legend('\Delta MT len.','\Delta fas. len.','\Delta ten. len.','Location','northwest','box','off')

% Musculotendon Force
subplot(4,1,2); hold on
set(gca,'FontName','Helvetica','FontSize',8,'XTick',[])
plot(t,mtData.hs_force)
plot(t,mtData.pm_force + mtData.hs_force)
plot(t,mtData.pm_force)
legend('Fiber force','MTU force','Perimysial force','Location','northwest','box','off')

%Extrafusal vs. intrafusal force
subplot(4,1,3); hold on
set(gca,'FontName','Helvetica','FontSize',10)
rectangle('Position',[6.4 0 1.6 4e5],'FaceColor',[0.9 0.9 0.9],...
     'EdgeColor',[0.9 0.9 0.9]);

plot(t,mtData.hs_force)
plot(t,dataB.hs_force)
legend('Extrafusal','Intrafusal','Location','northwest','box','off')
corr_coef = corrcoef(mtData.hs_force(6400:8000),dataB.hs_force(6400:8000));
text(7,1.75e5,['r = ' num2str(round(corr_coef(2)*1000)/1000)],'FontName','Helvetica','FontSize',10);




% Spindle rate
subplot(4,1,4); hold on
set(gca,'FontName','Helvetica','FontSize',10)
plot(t,r)
% plot(t,rd - 0.05)
% plot(t,rs - 0.05)
legend('Ia firing rate','Location','northwest','box','off')


%% Fig 8&9 are generated in their respective scripts



