function [paths] = mv_generate_paths(folder)
%% Generates folder Structure
% [p] = mv_generate_paths(Folder-Path)
% or to update
% [p] = mv_generate_paths(p)


%find file in folder
if nargin < 1
    error('You need to put in at least one argument');
end

if isstruct(folder) %in this case we want to update p!
    % the input file is in this case p!
    file = folder.filename;
    folder = folder.folder;
    
    fprintf('Updating the Folderstructure \n')
elseif ischar(folder)
    file = [];
    rawPathDir =dir([folder filesep 'raw']);
    for k = 1:length(rawPathDir)
        if rawPathDir(k).isdir
            continue
        end
        tmpXf = rawPathDir(k).name;
        if any(strfind(tmpXf,'.cnt')) || any(strfind(tmpXf,'.set'))
            if ~isempty(file)
                fprintf('%%%%%%%%%%%%%%%%%% \n')
                fprintf('multiple EEG files found! 1) %s \t 2) %s \n',file,tmpXf)
                fprintf('%%%%%%%%%%%%%%%%%% \n')
            end
            file= [tmpXf];
        end
        
        
    end
    if isempty(file)
        fprintf('No EEG file found');
    end
else
    error('Unknown input')
end


paths.folder = folder;
paths.filename = file;

%%
if ~isempty(file)
    paths.full.raw = [folder filesep 'raw' filesep file];
end
paths.path.raw = [folder filesep 'raw'];

paths.path.set = [folder filesep 'sets'];
paths.path.set2 = [folder filesep 'set2'];
paths.path.study = ['/net/store/projects/move/eeg/study'];
% paths.filename = file;

%% Find all ICA's and Dipole

paths.path.amica = [folder filesep 'amica'];
tmp = dir([folder filesep 'amica']);
if ~isempty(tmp)
    tmp(1:2) = [];
end
if isempty(tmp)
    paths.amica.path{1} = [folder filesep 'amica' filesep 'amicaRun'];
    paths.path.dipole{1} = [folder filesep 'amica' filesep 'amicaRun'];

    paths.full.dipole{1} = [folder filesep 'amica' filesep 'amicaRun' filesep 'dipole.mat'];
    paths.amica.date{1} = [date];
else
        paths.path.dipole{1} = [folder filesep 'amica' filesep 'amicaRun'];

    paths.full.dipole{1} = [folder filesep 'amica' filesep tmp(1).name filesep 'dipole.mat'];
    paths.amica.path{1} = [folder filesep 'amica' filesep tmp(1).name];
    paths.amica.date{1} = [tmp(1).date];
    for i = 2:length(tmp)
        paths.path.dipole{end+1} = [folder filesep 'amica' filesep tmp(i).name];

        paths.full.dipole{end+1} = [folder filesep 'amica' filesep tmp(i).name filesep 'dipole.mat'];
        paths.amica.path{end+1} = [folder filesep 'amica' filesep tmp(i).name];
        paths.amica.date{end+1} = [tmp(i).date];
    end
end



%% Find all sets
tmp = dir([folder filesep 'sets']);
if ~isempty(tmp)
tmp(1:2) = [];
end
if isempty(tmp)
    paths.full.sets{1} = [];
    paths.full.setsDate{1} = [];
else
        paths.full.sets{1} = [];
    paths.full.setsDate{1} = [];

for k = 1:length(tmp) 
    if strfind(tmp(k).name,'.set')
        paths.full.sets{end+1} = [folder filesep 'sets' filesep tmp(k).name];
        paths.full.setsDate{end+1} = [tmp(k).date];
    end
end
paths.full.sets(1) = [];
paths.full.setsDate(1) = [];
end
%% Find all sets2
tmp = dir([folder filesep 'set2']);
if ~isempty(tmp)
tmp(1:2) = [];
end
if isempty(tmp)
    paths.full.sets2{1} = [];
    paths.full.sets2Date{1} = [];
else
        paths.full.sets2{1} = [];
        paths.full.sets2Date{1} = [];

for k = 1:length(tmp) 
    if strfind(tmp(k).name,'.set')
        paths.full.sets2{end+1} = [folder filesep 'set2' filesep tmp(k).name];
        paths.full.sets2Date{end+1} = [tmp(k).date];
    end
end
paths.full.sets2(1) = [];
paths.full.sets2Date(1) = [];
end
%%
%% Find all studies
tmp = dir(paths.path.study);
if ~isempty(tmp)
tmp(1:2) = [];
end
if isempty(tmp)
    
    paths.study.preComp = [];
else
    paths.study.preComp{1} = [];

    for k = 1:length(tmp)
        if tmp(k).isdir

           paths.study.preComp{end+1} = [paths.path.study filesep tmp(k).name];
        end
    end
   paths.study.preComp(1) = [];
end


%% Misc Paths
%paths.full.psyphyVR = ['/net/store/projects/move/move_svn/code/Move_vizard/' filesep 'Participant_1' filesep 'Participant_1_Time_1348501448.txt'];
paths.full.baselineVR = [folder filesep 'psyphyVR' filesep 'vr_baseline.txt'];

paths.full.badComp = [folder filesep 'reject' filesep 'marked_components.mat'];
paths.full.badCont = [folder filesep 'reject' filesep 'marked_continuous.mat'];
paths.full.badTrial = [folder filesep 'reject' filesep 'marked_trials.mat'];
paths.full.badChannel = [folder filesep 'reject' filesep 'marked_channels.mat'];
paths.full.badChannelCorr = [folder filesep 'reject' filesep 'marked_channels_corr.mat'];
% paths.full.xensor = [folder filesep 'xensor' filesep 'xensor.elc'];

%% find Xensor File
paths.path.xensor = [folder filesep 'xensor'];
%find xensor file

xensorDir =dir(paths.path.xensor);
for k = 1:length(xensorDir)
    if xensorDir(k).isdir
        continue
    end
    tmpXf = xensorDir(k).name;
    if strcmp(tmpXf(end-3:end),'.elc')
        paths.full.xensor = [folder filesep 'xensor' filesep tmpXf];
        break
    end
end
if sum(cellfun(@(x) strcmp(x, 'xensor'), fieldnames(paths.full)))<1;
    fprintf('No Xensor File found \n')
end


%% find Comment File
paths.path.comment = [folder filesep 'commentsheets'];
commentDir =dir(paths.path.comment);
for k = 1:length(commentDir)
    if commentDir(k).isdir
        continue
    end
    tmpXf = commentDir(k).name;
    if strcmp(tmpXf(end-3:end),'.csv')
        paths.full.comment = [paths.path.comment filesep tmpXf];
        break
    end
end
if sum(cellfun(@(x) strcmp(x, 'comment'), fieldnames(paths.full)))<1;
%     fprintf('No Comment File found \n')
end

%%
%% find PsyPhy File
paths.path.psyphyVR = [folder filesep 'psyphy'];

paths.full.psyphyVR{1} = [];
psyphyVRDir =dir(paths.path.psyphyVR);
for k = 1:length(psyphyVRDir)
    if psyphyVRDir(k).isdir
        continue
    end
    tmpXf = psyphyVRDir(k).name;
    if strcmp(tmpXf(end-3:end),'.txt')
        if any(regexpi(tmpXf,'center'))
        else
        paths.full.psyphyVR{end+1} = [folder filesep 'psyphy' filesep tmpXf];
        end
        
    end
end
paths.full.psyphyVR(1) = [];
if sum(cellfun(@(x) strcmp(x, 'psyphyVR'), fieldnames(paths.full)))<1 || isempty(paths.full.psyphyVR);
    fprintf('No PsyPhy File found \n')
end
%%
paths.path.powBaseline = [folder filesep 'powBaseline'];
paths.full.powBaseline = [folder filesep 'powBaseline' filesep 'powBaseline.mat'];

% paths.subjectID = str2num(paths.filename(4));
% paths.path.headModelwarp =['/net/store/projects/move/eeg/headmodels'];
% paths.full.headModelwarp =['/net/store/projects/move/eeg/headmodels/warpParamsVP0' num2str(paths.subjectID) '.mat'];


paths.path.reject  = [folder filesep 'reject'];
% if ~exist(paths.path.dipole,'dir')
%     mkdir(paths.path.dipole)
% end
% if ~exist(paths.path.reject,'dir')
%     mkdir(paths.path.reject)
% end
% if ~exist([folder filesep 'amica'],'dir')
%     mkdir([folder filesep 'amica'])
% end
if ~exist(paths.path.set2,'dir')
    mkdir(paths.path.set2)
end
% if ~exist(paths.path.study,'dir')
%     mkdir(paths.path.study)
% end
% if ~exist(paths.path.xensor,'dir')
%     mkdir(paths.path.xensor)
% end
% if ~exist(paths.path.powBaseline,'dir')
%     mkdir(paths.path.powBaseline)
% end
% if ~exist(paths.path.raw,'dir')
% %      error('RawFile not Found')
% end
