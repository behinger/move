%% Clean the ICA-Activation Trials!
% if ~exist('flags','var')
%     flags = mv_check_folderstruct;
% end
%% Load a Random Set
% [EEG,p] =mv_load_set(flags.path{7},3)
[EEG,p] = mv_load_random_set('badTrial');

% Load the ICA
EEG = mv_load_ICA(EEG,p,4);
% Add the Eventnumber to the Epoch
% EEG = mv_add_trialToTrig4(EEG,p);

EEG = mv_epoch(EEG,p);
EEG = eeg_checkset(EEG);
% EEG = mv_add_events(EEG,p)
%% Run the Cleaning script
mv_clean_trial(EEG,p)