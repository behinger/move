function [sTcut] = behav_returnTrialSt(sT,trials)
%% function to easily have a look at all values of sT of some trials
t = fieldnames(sT);
for k = 1:length(t)
    if length(sT.(t{k}))>trials
        sTcut.(t{k}) =  sT.(t{k})(trials);
        
    else
        sTcut.(t{k}) =  sT.(t{k});
    end
    if size(sTcut.(t{k}),2) == 1
        sTcut.(t{k})= sTcut.(t{k})';
        
    end
end


