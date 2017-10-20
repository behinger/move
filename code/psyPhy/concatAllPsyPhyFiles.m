% function [concPP, concErrors] = concatAllPsyPhyFiles()
%% Concatenates all PsyPhy Files
flags = mv_check_folderstruct;
% mv_study_prepSet;

% find(flags.vp==2 & flags.condition ==3)
% find(flags.vp==2 & flags.condition ==4)
% find(flags.vp==3 & flags.condition ==2)
% find(flags.vp==3 & flags.condition ==3)
% 
p = mv_generate_paths(flags.path{14}); % get the filepaths
[sT] = mv_vrDatExtract(p);

for i = 1:length(flags.path)
    fprintf('Working on job %i of %i \n',i,length(flags.path))
    p = mv_generate_paths(flags.path{i}); % get the filepaths
    [sT] = mv_vrDatExtract(p);
    numTrialsForRepmat = length(sT.errors_T);
    sT.vp = repmat(flags.vp(i), numTrialsForRepmat, 1)'; % add the VP number to sT
    if strcmp(sT.condition, 'passive')
        sT.condCoded = ones(numTrialsForRepmat, 1)';  % fill in ones
    elseif strcmp(sT.condition, 'proprioceptive')
        sT.condCoded = repmat(2, numTrialsForRepmat, 1)';
    elseif strcmp(sT.condition, 'vestibular')
        sT.condCoded = repmat(3, numTrialsForRepmat, 1)';
    elseif strcmp(sT.condition, 'active')
        sT.condCoded = repmat(4, numTrialsForRepmat, 1)';
    end
        
    if i == 1
        concPP = sT; 
    else
        concPP = mergestruct(concPP, sT); % concatenates   
    end
end

