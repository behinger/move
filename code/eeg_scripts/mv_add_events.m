function EEG = mv_add_events(EEG,p)
%% Adds the neccessary Event information to the file

addpath('/net/store/projects/move/move_svn/code/psyPhy/')
if ~check_EEG(EEG.preprocess,'VRevents')
    sT = mv_vrDatExtract(p);
    [trialNr,inconsistendTrial,eegEvents] = mv_eeg_eventConsistency(EEG);
    badTrialVR = sT.trialNumbers(sT.badEEG == 2 | isnan(sT.errors_T));
    
    %%
    idxList = find(eegEvents>150 & eegEvents <211);
    for trEv =  idxList
        
        for k = 1:100
            if eegEvents(trEv+k)>150 &&eegEvents(trEv+k)<211
                fprintf('another trial started before finding event 4 \n not adding any events \n')
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
        
        if inconsistendTrial(trEv==idxList)
            fprintf('EEG events are bad: %i \n',find(trEv==idxList))
            EEG.event(trEv+k).rejectEventCheck =  2;
            continue
        end
        currTr = eegEvents(trEv)-150;
        if ismember(currTr,[badTrialVR])
            EEG.event(trEv+k).rejectEventCheck = 3;
            continue
        end
        % If we are here, neither EEG-event check, nor VR-Event Check threw
        % the trial out, yeah!
        
%         % find next Trigger 4 to save the stuff in
%         for k = 1:30
%             if eegEvents(trEv+k)>150 &&eegEvents(trEv+k)<211
%                 error('big problem,another trial started before finding event 4, this should not happen if the checks before are valid')
%             end
%             if eegEvents(trEv+k) == 4
%                 break
%             end
%         end

        
        EEG.event(trEv+k).turningAnglePerfect = sT.turningAnglePerfect(sT.trialNumbers == currTr);
        EEG.event(trEv+k).error_T = sT.errors_T(sT.trialNumbers == currTr);
        EEG.event(trEv+k).error_NT = sT.errors_NT(sT.trialNumbers == currTr);
        EEG.event(trEv+k).trialNumber = sT.trialNumbers(sT.trialNumbers == currTr);
        EEG.event(trEv+k).trialDuration = sT.trialDuration(sT.trialNumbers == currTr);
        EEG.event(trEv+k).commentBadEEG = sT.badEEG(sT.trialNumbers == currTr);
        EEG.event(trEv+k).rejectEventCheck = 0;
    end
    
    
        %%
        EEG = eeg_checkset(EEG,'eventconsistency');
        EEG.preprocess = [EEG.preprocess 'VRevents'];
        EEG.preprocessInfo.eventsDate = datestr(now);
end