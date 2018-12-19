function [hsB,dataB,hsC,dataC] = sarcSimDriver(t,delta_f_activated,delta_cdl)
time_step = t(2)-t(1);
CHECK_SLACK = 1;  

% Make a half-sarcomere
hsB = halfSarcBag();
hsC = halfSarcChain();

% Loop through the time-steps
for a = 1
    for i=1:numel(t)
%       h =   waitbar(i/numel(t));
        
        
        if CHECK_SLACK
%             slack_mode = 0;
            %CHECK IF SLACK
            %ADJUST HS LENGTH SO FORCE IS BACK TO 0
%             hs.hs_force = 0;
            xD = find_hsl_from_force(hsB,0.0);
            xS = find_hsl_from_force(hsC,0.0);
          
            
            if hsB.cmd_length<xD
                hsB.hs_force = 0;
                slack_modeD = 1;
%                 new_length = max(x,hs.cmd_length);
                adj_lengthD = xD - hsB.hs_length;
                hsB.forwardStep(0.0,adj_lengthD,0,0,0,1);
            else
                slack_modeD = 0;
            end
            
            if hsC.cmd_length<xS
                hsC.hs_force = 0;
                slack_modeS = 1;
                adj_lengthS = xS - hsC.hs_length;
                hsC.forwardStep(0.0,adj_lengthS,0,0,0,1);
            else
                slack_modeS = 0;
            end
            
            if slack_modeD
               %CROSS BRIDGE EVOLUTION TAKES UP SLACK  
               % Any cb cycling here must be applied to shortening
               % against zero load.
                
               % First, we evolve the distribution
                hsB.forwardStep(time_step,0.0,0.0,delta_f_activated(a,i),1,0)
                
               % Next, we iteratively search for the sarcomere length
               % that would give us zero load
                xD = find_hsl_from_force(hsB,0);
                
               % We then compute the new hs length applied to the
               % sarcomere based on whether the command length is now
               % greater than the sarcomere length (back into
               % length-control) or not (still in isotonic mode). The
               % length adjustment is the the calculated new length - the 
               % current measurement of hs length. 
               
                new_lengthD = max(xD,hsB.cmd_length);
                adj_lengthD = new_lengthD - hsB.hs_length;
                
               % Finally, we shift the distribution by the adjusted length
                hsB.forwardStep(time_step,adj_lengthD,delta_cdl(a,i),0,0,1);
                
            else %length control
                delta_hslD = delta_cdl(a,i);
                hsB.forwardStep(time_step,delta_hslD,delta_cdl(a,i),delta_f_activated(a,i),1,1);
            end
            
            if slack_modeS
                %CROSS BRIDGE EVOLUTION TAKES UP SLACK
                % Any cb cycling here must be applied to shortening
                % against zero load.
                
                % First, we evolve the distribution
                hsC.forwardStep(time_step,0.0,0.0,delta_f_activated(a,i),1,0)
                
                % Next, we iteratively search for the sarcomere length
                % that would give us zero load
                xS = find_hsl_from_force(hsC,0);
                
                % We then compute the new hs length applied to the
                % sarcomere based on whether the command length is now
                % greater than the sarcomere length (back into
                % length-control) or not (still in isotonic mode). The
                % length adjustment is the the calculated new length - the
                % current measurement of hs length.
                
                new_lengthS = max(xS,hsC.cmd_length);
                adj_lengthS = new_lengthS - hsC.hs_length;
                
                % Finally, we shift the distribution by the adjusted length
                hsC.forwardStep(time_step,adj_lengthS,delta_cdl(a,i),0,0,1);
                
            else %length control
                delta_hslS = delta_cdl(a,i);
                hsC.forwardStep(time_step,delta_hslS,delta_cdl(a,i),delta_f_activated(a,i),1,1);
            end
        end
        
        % Store data
        
        dataB(a).f_activated(i) = hsB.f_activated;
        dataB(a).f_bound(i) = hsB.f_bound;
        dataB(a).f_overlap(i) = hsB.f_overlap;
        dataB(a).cb_force(i) = hsB.cb_force;
        
        
        dataB(a).passive_force(i) = hsB.passive_force;
        dataB(a).hs_force(i) = hsB.hs_force;
        dataB(a).hs_length(i) = hsB.hs_length;
        dataB(a).cmd_length(i) = hsB.cmd_length;
        dataB(a).Ca(i) = hsB.Ca;
        dataB(a).slack(i) = hsB.slack;
        dataB(a).bin_pops(:,i) = hsB.bin_pops;
        dataB(a).no_detached(i) = hsB.no_detached;
        
        dataC(a).f_activated(i) = hsC.f_activated;
        dataC(a).f_bound(i) = hsC.f_bound;
        dataC(a).f_overlap(i) = hsC.f_overlap;
        dataC(a).cb_force(i) = hsC.cb_force;
        
        
        dataC(a).passive_force(i) = hsC.passive_force;
        dataC(a).hs_force(i) = hsC.hs_force;
        dataC(a).hs_length(i) = hsC.hs_length;
        dataC(a).cmd_length(i) = hsC.cmd_length;
        dataC(a).Ca(i) = hsC.Ca;
        dataC(a).slack(i) = hsC.slack;
        dataC(a).bin_pops(:,i) = hsC.bin_pops;
        dataC(a).no_detached(i) = hsC.no_detached;
        
    end
    dataB(a).t = t;
    dataC(a).t = t;
end

