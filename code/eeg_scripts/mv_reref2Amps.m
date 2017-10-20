function EEG =  mv_reref2Amps(EEG,p)
%only continuous with all channells
%this should fix the two different reference problem as both amplifier
%cover the whole head
if any( strcmp(p.folder,{'/net/store/projects/move/eeg/VP02/S01Passive','/net/store/projects/move/eeg/VP02/S01Proprio','/net/store/projects/move/eeg/VP02/S01Vest','/net/store/projects/move/eeg/VP02/S02Active'}))
    fprintf('Detected a Henning Session. Doing the reref2Amps! \n')
%     ppCmd = 'EEG = mv_reref2Amps(EEG);';
else
    return
end
split_idx = find(cellfun(@(x)strcmp(x,'HEOG'),{EEG.chanlocs.labels})); 
[EEG.data(1:split_idx,:) EEG.chanlocs(1:split_idx)] = reref(EEG.data(1:split_idx,:),[],'elocs',EEG.chanlocs(1:split_idx));
[EEG.data(split_idx+1:end,:) EEG.chanlocs(split_idx+1:end)] = reref(EEG.data(split_idx+1:end,:),[],'elocs',EEG.chanlocs(split_idx+1:end));
EEG.preprocessInfo.Amps2Reref = ['2AmpAv'];



%% Rereference each amplifier to the common reference

split_idx = find(cellfun(@(x)strcmp(x,'HEOG'),{EEG.chanlocs.labels})); 
[newdata(1:split_idx-1,:) newchanlocs(1:split_idx-1)] = reref(EEG.data(1:split_idx,:),16,'elocs',EEG.chanlocs(1:split_idx));
%
% [newdata(split_idx:2*split_idx-3,:),newchanlocs(split_idx:2*split_idx-3)] = reref(EEG.data(split_idx+1:end,:),31,'elocs',EEG.chanlocs(split_idx+1:end));
try
[newdata(split_idx+1:2*split_idx-3,:),newchanlocs(split_idx+1:2*split_idx-3)] = reref(EEG.data(split_idx+1:end,:),31,'elocs',EEG.chanlocs(split_idx+1:end));
catch
    try
    [newdata(split_idx:2*split_idx-3,:),newchanlocs(split_idx:2*split_idx-3)] = reref(EEG.data(split_idx+1:end,:),31,'elocs',EEG.chanlocs(split_idx+1:end));
    catch
        error('Could not finish reref2Amps')
    end
end
EEG.data = newdata;
EEG.chanlocs = newchanlocs;
EEG = eeg_checkset(EEG);
EEG.preprocessInfo.Amps2Reref = [EEG.preprocessInfo.Amps2Reref 'CZref'];

%%

