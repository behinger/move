function [fullsT] = behav_fullRespFile(sT)
%% behav_fullRespFile
% This function takes a normal sT file from behav_processPsyPhy and adds
% the missing / empty / removed trials as NANs so it is easier for further
% analysis to work with.

%first of all, find out if there should be 60 or 30 trials
if sT.numTrials > 30
    end_trials = 60;
else
    end_trials = 30;
end
if sT.trialNumbers(1) > 30
    begin_Trial = 31;
else
    begin_Trial = 1;
end



fn = fieldnames(sT);
% for each trial do it for each field
for tr = [1:length(begin_Trial:end_trials+begin_Trial-1);begin_Trial:end_trials+begin_Trial-1]
    
    %go over all available fields
    for k =fn'
        %constant fields
        if tr(1) == 1 && (length(sT.(k{:}))==1 || ischar(sT.(k{:}))) %do it only once for the fields that have only constant content
            fullsT.(k{:}) = sT.(k{:});
        elseif (length(sT.(k{:}))==1 || ischar(sT.(k{:})))
            
        else
            % check if the trial is already in sT
            [idx] = find((sT.trialNumbers == tr(2)));
            %if not, fill the new thing with NAN
            if isempty(idx)
                fullsT.(k{:})(tr(1)) = nan;
            else
                %else fill it with the value
                fullsT.(k{:})(tr(1)) = sT.(k{:})(idx);
            end
        end
        
    end
end
fullsT.trialNumbers = begin_Trial:end_trials+begin_Trial-1;