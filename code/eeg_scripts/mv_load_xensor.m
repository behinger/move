function EEG = mv_load_xensor(EEG,p)
%% Runs read_xensor and matches the electrode labels
% Updates the Paths
% Readout the Xensor
% adds the chanlocs to the file

p = mv_generate_paths(p);
addpath('/net/store/projects/move/move_svn/code/ressources/')
[electrodes elec] = read_xensor(p.full.xensor,1,0);

%data.elec.pnt   = zeros(length( EEG.chanlocs ), 3);
%clear chanlocs;


chanlocs = [];
for ind = 1:size(EEG.chanlocs,2)
    
    eegChanlocIdx = cellfun(@(x)strcmpi(x,{EEG.chanlocs(ind).labels}),electrodes.labels); % fint the corresponding channel of the electrode file in the chanloc
    if strcmp(EEG.chanlocs(ind).labels,'Cz_2_exIz') ||strcmp(EEG.chanlocs(ind).labels,'CzOtheram') % IZ is replaced by the cascading of the two amplifier, the amplifier need a common reference
%         if strcmp(EEG.chanlocs(ind).labels,'M1_1') % IZ is replaced

        eegChanlocIdx = cellfun(@(x)strcmpi(x,'IZ'),electrodes.labels); % because we replace IZ as the common ground in amplifier 2
    end
    
    
    
    if any(eegChanlocIdx)
        chanlocs(end+1).labels = electrodes.labels{eegChanlocIdx} ;
        chanlocs(end).X = elec.pnt(eegChanlocIdx,1);
        chanlocs(end).Y = elec.pnt(eegChanlocIdx,2);
        chanlocs(end).Z = elec.pnt(eegChanlocIdx,3);
        chanlocs(end).type = 'EEG';
        
    elseif strcmp(EEG.chanlocs(ind).labels,'VEOG')|| strcmp(EEG.chanlocs(ind).labels,'VEOGD')
        chanlocs(end+1).labels = 'VEOG';
        chanlocs(end).type = 'EYE';
    elseif strcmp(EEG.chanlocs(ind).labels,'HEOG') || strcmp(EEG.chanlocs(ind).labels,'VEOGU')
        chanlocs(end+1).labels = 'HEOG';
        chanlocs(end).type = 'EYE';
    elseif  strcmp(EEG.chanlocs(ind).labels,'TriggerCh')
        chanlocs(end+1).labels = 'TriggerCh';
    elseif  strcmp(EEG.chanlocs(ind).labels,'M1_1')
        chanlocs(end+1).labels = 'M1_1';
    else
        warning('no corresponding channel found %i name %s', ind,EEG.chanlocs(ind).labels);
    end
end;
if size(chanlocs)<120
    error('something went wrong with the loading of the xensor')
end

%fiducials
tmpFid = {'Nz','LPA','RPA'};
for k = 1:3
    chanlocs(end+1).labels =tmpFid{k};
    chanlocs(end).X = elec.pnt(k,1);
    chanlocs(end).Y = elec.pnt(k,2);
    chanlocs(end).Z = elec.pnt(k,3);
    chanlocs(end).type = 'FID';
end

EEG.chanlocs = chanlocs;
% EEG = eeg_checkset(EEG);
EEG=pop_chanedit(EEG, 'convert',{'cart2all'});
EEG = eeg_checkset(EEG,'chanlocs_homogeneous');
% EEG = eeg_checkset(EEG,'chanlocssize');
EEG.preprocess = [EEG.preprocess 'Xensor'];
EEG.preprocessInfo.XensorDate = datestr(now);
