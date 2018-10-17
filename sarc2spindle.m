function [r,rs,rd] = sarc2spindle(dataY,dataF,kFs,kFd,kY,competition,threshold)
t = dataF.t; %time

% Force-dominant fiber (static fiber)
Fs = dataF.hs_force;
Fs(Fs<0) = 0;



% Yank-dominant fiber (dynamic fiber)
Fd = dataY.hs_force; %force
Fd(Fd<0) = 0; %threshold
Y = diff(Fd)./diff(t); %yank
Y(Y<0) = 0; %threshold
Y(end+1) = Y(end); %make Y same length as F
Y(Fd<8e4) = 0; %Chirp
% Y(Fd<8e4) = 0; %Most of the simulations


rs = Fs*kFs; %static component
rd = Fd*kFd + Y*kY; %dynamic component

rs(rs<0) = 0;
rs = rs/(10^6);
rd = rd/(10^6);

if competition % Hypothesis that branches of Ia ending compete for total firing rate
    rsComp = rs;
    rsComp(rd>=rs) = 0.3*rsComp(rd>=rs);  % 0.3 chosen to match Banks et al. 1997
    
    rdComp = rd;
    rdComp(rs>rd) = 0.3*rdComp(rs>rd);
    
    r = rsComp + rdComp;
%     rs = rsComp;
%     rd = rdComp;
else
    r = rs + rd; %linear sum
end

%Firing Threshold
r = r - threshold;
r(r<0.0) = 0; 

end