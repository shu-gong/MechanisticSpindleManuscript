%% Start by running MTU simulations

clear,clc
tic
time_step = 0.001; %Temporal precision
t = 0:time_step:4; %Time vector in seconds

% Set up MTU activation. Can be any arbitrary waveform bounded by [0, 1]
delta_f_activated = zeros(size(t)); %change in muscle activation
delta_f_activated(1) = 0.4; %step change

% Set up MTU length change. Muscle is single half-sarcomere, with L0 of
% 1300 nm. Convert to normalized units using this value. 
delta_cdl = zeros(size(t)); %change in musculotendon length (applied)
delta_cdl(2000:2250) = 0.1; %ramp length change (units of nm/time-step) 

% Run the simulation. mtData is struct containing time series data from
% simulations. 
mtData = musTenDriver(t,delta_f_activated,delta_cdl);
beep; toc;

%% Next, run spindle portion using MTU length as applied intrafusal length

tic;

% Use extrafusal muscle length as "applied" spindle length
delta_cdl_spindle = [0 diff(mtData.hs_length)];

% Set up gamma activation. Currently, both static and dynamic are same,
% but this will be changed in future version. 
delta_f_activated_spindle = zeros(size(delta_f_activated));
delta_f_activated_spindle(1) = 0.3;

% Run the spindle simulation. Returns the bag and chain objects, as well as
% time-series data structs for each. 
[hsB,dataB,hsC,dataC] = sarcSimDriver(t,delta_f_activated_spindle,delta_cdl_spindle);

% Convert force & yank time-series into continuous firing rate
[r,rs,rd] = sarc2spindle(dataB,dataC,1,2,0.1,0.5,0.01); 

toc; beep;

%% Plot results

figure; set(gcf, 'color','white')
hold on;
set(gca,'tickdir','out','xticklabel',[])
axis([0 t(end) 0 0.5])
plot(t,r,t,rd,t,rs)
