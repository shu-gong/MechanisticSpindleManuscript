function mtData = musTenDriver(t,delta_f_activated,delta_cdl)

mt = mtu();

for i = 1:numel(t)
%     if mod(i,10)==0
%         disp(i)
%     end
    
    if i > 1
        time_step = t(i) - t(i-1);
    else
        time_step = t(2) - t(1);
        
        x_new = balanceForces(mt);
        x_adj = x_new - mt.hs_length;
        mt.forwardStep(0,x_adj,0,0,0,1);
        
    end
       
    
    mt.forwardStep(time_step,0,0,delta_f_activated(i),1,0)
    
    x_new = balanceForces(mt);
    x_adj = x_new - mt.hs_length;
    mt.forwardStep(0,x_adj,delta_cdl(i),0,0,1);


    
    
    mtData.f_activated(i) = mt.f_activated;
%     mtData.f_bound(i) = mt.f_bound;
%     mtData.f_overlap(i) = mt.f_overlap;
    mtData.cb_force(i) = mt.cb_force;
    
    
    mtData.passive_force(i) = mt.passive_force;
    mtData.hs_force(i) = mt.hs_force;
    mtData.hs_length(i) = mt.hs_length;
    mtData.cmd_length(i) = mt.cmd_length;
end

end

