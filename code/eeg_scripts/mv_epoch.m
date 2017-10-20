function EEG = mv_epoch(EEG,p)
if nargin > 2 
    error('Bad input number')
end

        EEG = eeg_checkset(EEG,'eventconsistency');
        times = [-20 12];
        trig = 4;
        EEG = pop_epoch( EEG, {  trig  }, times,  'epochinfo', 'yes','newname',EEG.preprocess);
        trialDelete = [];
        for l = 1:EEG.trials
            tmpEventtype = (deblank(EEG.epoch(l).eventtype));
%             tmpeventCheck = EEG.epoch(l).eventtrialDuration;
%             if isempty(tmpeventCheck{1})
%                 trialDelete = [trialDelete l];
%                 continue
%             end
            if isempty(strmatch('4',tmpEventtype,'exact')) || isempty(strmatch('5',tmpEventtype,'exact'))% || ...
%                length(strmatch('4',tmpEventtype,'exact'))>1 || length(strmatch('5',tmpEventtype,'exact'))>1  
                trialDelete = [trialDelete l];
            end
%             
%             
        end
        trialDeleteFull = zeros(1,EEG.trials);
        trialDeleteFull(trialDelete) = 1;
%         
        EEG = pop_rejepoch(EEG, trialDeleteFull, 0);
        EEG.preprocess = [EEG.preprocess 'Epoch'];
        EEG.preprocessInfo.epochTrig = trig;
        EEG.preprocessInfo.epochTimes = times;
        EEG.preprocessInfo.epochAutoRemove = trialDelete;
        fprintf('Deleted trials where Trigger 5 was not in Epoch \n');
end