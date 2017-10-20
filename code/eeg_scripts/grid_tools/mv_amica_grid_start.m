function [] = mv_amica_grid_start(p,varargin)
%% Function wrapper to start amica on grid
% Calls internally mv_grid_start_cmd
% needs the p=struct in order to manually choose which set to run the amica
% on
% mv_amica_grid_start(p,chosenSet,chosenAmica)
error('Deprevated, please don''t use')
if nargin < 1
    error('You have to define the structure ''p'' with the function generate_paths')
end
if nargin > 1
    chosenSet = varargin{1};
else
    if length(p.full.sets)>1
        for i = 1:length(p.full.sets)
            fprintf('%i : %s  \n',i,p.full.sets{i})
        end
        chosenSet = input('Which set should the ICA run on? ');
    else
        chosenSet = 1;
    end
end

if nargin > 2
    amicaChosenPath = varargin{2};
else
    if length(p.amica.path)>1
        for i = 1:length(p.amica.path)
            
            fprintf('%i : %s  \n',i,p.amica.path{i})
        end
        amicaChosenPath = input('Where should the amica be saved? ');
    else
        amicaChosenPath = 1;
    end
end


cmd_grid = [ 'addpath(''/net/store/projects/move/move_svn/code/ressourcen/amica'');'...
    'EEG = pop_loadset(''' p.full.sets{ chosenSet} ''');'... %dchosenSet is definied my move_amica_grid_start
    'cd(''' p.path.set ''');'...
    'runamica12(EEG,''outdir'',''' p.amica.path{amicaChosenPath} ''',''num_models'',1,''share_comps'',1,'...
    ' ''do_reject'',1,''numrej'',8,''rejsig'',2,''max_threads'',6)'];
fprintf('%s \n',cmd_grid)
% mv_grid_start_cmd(cmd_grid)
