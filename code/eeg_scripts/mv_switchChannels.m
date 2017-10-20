function EEG = mv_switchChannels(EEG,p)
%% Function that switches 3 and 4 of the EEG-channel group
% Only neccessary for VP04S01passive

if ~strcmp(p.filename,'VP04S01passive.cnt')
    return%error('Only valid for selected Sessions :) Ask Bene')
end
%Switch the Data using an switch Indexing.

% begI = [1,32,67,99]; % Begin of Connectors
% endI = [32,64,98,130];%End of Connectors
newIdx = [1:66 99:130 67:98];
data_new(newIdx,:) = EEG.data(:,:);
EEG.data = data_new;
EEG.preprocessInfo.switchChannel = 'Switched 3 and 4';
EEG.preprocessInfo.switchDate = datestr(now);