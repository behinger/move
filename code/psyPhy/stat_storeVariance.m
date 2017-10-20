function [behavResults] = stat_storeVariance(concPP, behavResults)
% Calculates the variances of each VP in each cond with outlierfree data


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Do it with unwinsorized errors
varVPsConds = [];
stdVPsConds = [];

for cond = 1:4
    for vp = 1:numel(unique(concPP.vp))
        err = concPP.errors_T;       
        varVPsConds = [varVPsConds, nanvar(err(concPP.vp == vp & concPP.condCoded == cond))];
        stdVPsConds = [stdVPsConds, nanstd(err(concPP.vp == vp & concPP.condCoded == cond))];
       
    end
end

varVPsConds = reshape(varVPsConds,5,4)
stdVPsConds = reshape(stdVPsConds,5,4)
