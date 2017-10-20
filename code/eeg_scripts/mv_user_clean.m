

%% Clean EEG continuos
[EEG p] = mv_load_random_set('badCont');

%%
[EEG] = mv_clean_continuous(EEG,p);

%% Reject Channels
%     Most Important: Exclude empty (flat) channels (e.g. 129 and
%     130,VEOG and HEOG, sometimes M1 and if the noisy channels e.g. Fz(channel 6) do weird spiky behavior-->kick it out!) 
% VEOG HEOG
% FZ,TriggerCh,HEOG,VEOG AFF1 FFC1H, F1


% %% If you made your list of channels to remove:
EEG = mv_reject_channel(EEG,p);


%% Example:
%VP01S03proprioFiltfir
EEG = mv_load_set(p);


%% Important

% After every use: Put in a console the following commands
% cd /net/store/projects/move/
% chmod -R 777 *

%% To re-clean a set
flags = mv_check_folderstruct;
% [EEG p] = mv_load_set(flags.path{flags.vp==5&flags.session==2&flags.condition==2});
[EEG p] = mv_load_set(flags.path{7});

EEG=mv_reject_channel(EEG,p,1);

mv_clean_continuous(EEG,p);


%%
[EEG p] = mv_load_random_set('badTrial');
mv_clean_trial(EEG,p);