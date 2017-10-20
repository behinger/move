%% Get current status
flags= mv_check_folderstruct
%     1     6    11    25    32    37    38
% Unkown: 11? 25?
%done new Reject and Grid Start: 37,38,32,
% bad dipole: 6,1
%% Load a set
% [EEG,p] = mv_load_set(flags.path{1},);
%%
[EEG,p] = mv_load_set2(flags.path{9},1,'info');

EEG = mv_load_ICA(EEG,p,4);
%     EEG = mv_fit_dipole(EEG,p);
% FFC1H, CCP2H
%% Check the ICA
% EEG = mv_check_ica(EEG,p);

    %% Plot Component Maps with Dipoles
    figure
    whichComps = [1:30];  %Plot component 1 to 30
    pop_topoplot(EEG,0, whichComps ,'EEProbe continuous data',[5 6] ,1,'electrodes','off');
    %%
    pop_topoplot(EEG,0, whichComps ,'EEProbe continuous data',[5 6] ,'electrodes','off');
    
    %% Plot components, clickable for more information
    
    pop_selectcomps_behinger(EEG,whichComps)
    
    %% Scroll the ICA component activation
    eegplot(EEG.icaact,'srate',EEG.srate,'dispchans',50)
    
    
    
    
    
    %%
    whichComps = [1:30];  %Plot component 1 to 30
    figure
    for k = 1:44
    [EEG,p] = mv_load_set(flags.path{1},5,'info');
    
    pop_topoplot(EEG,0, whichComps ,p.filename(1:end-4),[5 6] ,1,'electrodes','off');
    export_fig(['/net/store/projects/move/move_svn/dropSVN/graphs/ICA/run2set' num2str(k) '_' p.filename(1:end-4)],'-png','-r300','-cmyk','-nocrop')
    %     close(gcf)
    
    
    end