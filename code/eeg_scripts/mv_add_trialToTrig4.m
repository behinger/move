function EEG = mv_add_trialToTrig4(EEG,p)
%% Adds the neccessary Event information to the file
error('deprecated, see mv_add_events')
addpath('/net/store/projects/move/move_svn/code/psyPhy/')
if ~check_EEG(EEG.preprocess,'Trig4')
    tmp = {EEG.event.type};
tmp2 = cellfun(@(x)str2num(deblank(x)),tmp,'UniformOutput',0);
eegEvents = cell2mat(tmp2);

    idxList = find(eegEvents>150 & eegEvents <211);
    for trEv =  idxList
        
        for k = 1:100
            if eegEvents(trEv+k)>150 &&eegEvents(trEv+k)<211
                fprintf('another trial started before finding event 4 \n not adding any events \n')
                try
                fprintf('%i, ',eegEvents(trEv-2:trEv+50));
                fprintf('\n');
                catch
                end
                  EEG.event(trEv).rejectEventCheck = 1;
                continue
            end
            if eegEvents(trEv+k) == 4
                break
            end
        end
        if k == 100
            error('big problem, no Event 4 found, 100 events after trialstart. This should not really happen if the checks before are valid')
        end
 
        currTr = eegEvents(trEv)-150;

        EEG.event(trEv+k).trialNumber = currTr;

    end
    
    
        %%
        EEG = eeg_checkset(EEG,'eventconsistency');
        EEG.preprocess = [EEG.preprocess 'Trig4'];
        EEG.preprocessInfo.eventsTrig4date = datestr(now);
end