
switch gridParam
    case 1
        amicaSubFolder = 'BePassiveFov60FiltRefavgClean';
    case 2
        amicaSubFolder = 'BePassiveFov60FiltRefavgCleanFilt1Hz';
    case 3
        amicaSubFolder = 'BePassiveFov60FiltRefavg';
    case 4
        amicaSubFolder = 'BePassiveFov60FiltRefavgEpochClean';
    case 5
        amicaSubFolder = 'BePassiveFov60Filt1hzNoisychannelRefavgClean';
end


eegFileName =[amicaSubFolder '.set'];
addpath('~/Documents/MATLAB/eeglab')
eeglab
addpath('/net/store/projects/move/move_svn/code/ressources/amica/')

EEG = pop_loadset(eegFileName,'/net/store/projects/move/eeg/benePassive24092012/sets');
cd /net/store/projects/move/eeg/benePassive24092012/sets

runamica12(EEG,'outdir',['/net/store/projects/move/eeg/amica/' amicaSubFolder],'num_models',1,'share_comps',1,'do_reject',1,'numrej',8,'rejsig',2,'max_threads',7)
%EEG = pop_runica(EEG,'icatype','runica');
%pop_saveset(EEG,'filename',[amicaSubFolder 'ICA'])

%qsub -cwd -t 1:3 -l num_proc=8 -N amica_move -q ikw matlab -nodisplay
%-nojvm -r "gridParam=$SGE_TASK_ID;amica_grid.m;"
