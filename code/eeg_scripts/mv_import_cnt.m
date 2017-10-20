function [EEG] = mv_import_cnt(p)
%% Adds the ANTeepimport 1.09 to path and loads the File with pop_loadeep
% also updates the path before doing it.
% names the EEG.setname to the filename
% EEG = mv_import_cnt(p) % with p = mv_generate_paths(..)
if nargin < 1 || nargin >1
    help mv_import_cnt
    error('Not enough or too many input arguments %i, should be 1',nargin)
end
% p = mv_generate_paths(p);
addpath('/net/store/projects/move/move_svn/code/ressources/anteepimport1.09')
if strcmp(p.full.raw(end-2:end),'cnt')
EEG = pop_loadeep(p.full.raw,'triggerfile','on');
else
    EEG=  pop_loadset(p.full.raw);
end

EEG.preprocess = [p.filename(1:end-4)];
EEG.preprocessInfo.importCNTDate = datestr(now);
EEG = eeg_checkset(EEG);