function [hsD,dataD,hsS,dataS] = sarcSimDriver(t,delta_f_activated,delta_cdl)
time_step = t(2)-t(1);
CHECK_SLACK = 1;  

% Make a half-sarcomere
hsD = halfSarcBag();
hsS = halfSarcChain();

% Loop through the time-steps
for a = 1
    for i=1:numel(t)
%       h =   waitbar(i/numel(t));
        
        
        if CHECK_SLACK
%             slack_mode = 0;
            %CHECK IF SLACK
            %ADJUST HS LENGTH SO FORCE IS BACK TO 0
%             hs.hs_force = 0;
            xD = find_hsl_from_force(hsD,0.0);
            xS = find_hsl_from_force(hsS,0.0);
          
            
            if hsD.cmd_length<xD
                hsD.hs_force = 0;
                slack_modeD = 1;
%                 new_length = max(x,hs.cmd_length);
                adj_lengthD = xD - hsD.hs_length;
                hsD.forwardStep(0.0,adj_lengthD,0,0,0,1);
            else
                slack_modeD = 0;
            end
            
            if hsS.cmd_length<xS
                hsS.hs_force = 0;
                slack_modeS = 1;
                adj_lengthS = xS - hsS.hs_length;
                hsS.forwardStep(0.0,adj_lengthS,0,0,0,1);
            else
                slack_modeS = 0;
            end
            
            if slack_modeD
               %CROSS BRIDGE EVOLUTION TAKES UP SLACK  
               % Any cb cycling here must be applied to shortening
               % against zero load.
                
               % First, we evolve the distribution
                hsD.forwardStep(time_step,0.0,0.0,delta_f_activated(a,i),1,0)
                
               % Next, we iteratively search for the sarcomere length
               % that would give us zero load
                xD = find_hsl_from_force(hsD,0);
                
               % We then compute the new hs length applied to the
               % sarcomere based on whether the command length is now
               % greater than the sarcomere length (back into
               % length-control) or not (still in isotonic mode). The
               % length adjustment is the the calculated new length - the 
               % current measurement of hs length. 
               
                new_lengthD = max(xD,hsD.cmd_length);
                adj_lengthD = new_lengthD - hsD.hs_length;
                
               % Finally, we shift the distribution by the adjusted length
                hsD.forwardStep(time_step,adj_lengthD,delta_cdl(a,i),0,0,1);
                
            else %length control
                delta_hslD = delta_cdl(a,i);
                hsD.forwardStep(time_step,delta_hslD,delta_cdl(a,i),delta_f_activated(a,i),1,1);
            end
            
            if slack_modeS
                %CROSS BRIDGE EVOLUTION TAKES UP SLACK
                % Any cb cycling here must be applied to shortening
                % against zero load.
                
                % First, we evolve the distribution
                hsS.forwardStep(time_step,0.0,0.0,delta_f_activated(a,i),1,0)
                
                % Next, we iteratively search for the sarcomere length
                % that would give us zero load
                xS = find_hsl_from_force(hsS,0);
                
                % We then compute the new hs length applied to the
                % sarcomere based on whether the command length is now
                % greater than the sarcomere length (back into
                % length-control) or not (still in isotonic mode). The
                % length adjustment is the the calculated new length - the
                % current measurement of hs length.
                
                new_lengthS = max(xS,hsS.cmd_length);
                adj_lengthS = new_lengthS - hsS.hs_length;
                
                % Finally, we shift the distribution by the adjusted length
                hsS.forwardStep(time_step,adj_lengthS,delta_cdl(a,i),0,0,1);
                
            else %length control
                delta_hslS = delta_cdl(a,i);
                hsS.forwardStep(time_step,delta_hslS,delta_cdl(a,i),delta_f_activated(a,i),1,1);
            end
        end
        
        % Store data
        
        dataD(a).f_activated(i) = hsD.f_activated;
        dataD(a).f_bound(i) = hsD.f_bound;
        dataD(a).f_overlap(i) = hsD.f_overlap;
        dataD(a).cb_force(i) = hsD.cb_force;
        
        
        dataD(a).passive_force(i) = hsD.passive_force;
        dataD(a).hs_force(i) = hsD.hs_force;
        dataD(a).hs_length(i) = hsD.hs_length;
        dataD(a).cmd_length(i) = hsD.cmd_length;
        dataD(a).Ca(i) = hsD.Ca;
        dataD(a).slack(i) = hsD.slack;
        dataD(a).bin_pops(:,i) = hsD.bin_pops;
        dataD(a).no_detached(i) = hsD.no_detached;
        
        dataS(a).f_activated(i) = hsS.f_activated;
        dataS(a).f_bound(i) = hsS.f_bound;
        dataS(a).f_overlap(i) = hsS.f_overlap;
        dataS(a).cb_force(i) = hsS.cb_force;
        
        
        dataS(a).passive_force(i) = hsS.passive_force;
        dataS(a).hs_force(i) = hsS.hs_force;
        dataS(a).hs_length(i) = hsS.hs_length;
        dataS(a).cmd_length(i) = hsS.cmd_length;
        dataS(a).Ca(i) = hsS.Ca;
        dataS(a).slack(i) = hsS.slack;
        dataS(a).bin_pops(:,i) = hsS.bin_pops;
        dataS(a).no_detached(i) = hsS.no_detached;
        
    end
    dataD(a).t = t;
    dataS(a).t = t;
end

