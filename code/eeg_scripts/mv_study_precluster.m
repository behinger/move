
[STUDY,ALLEEG] = mv_study_generate;
%load studyTeatime
%%
[STUDY ALLEEG] = std_preclust(STUDY, ALLEEG, 1,...
    {'scalp' 'npca' 10 'norm' 1 'weight' 1 'abso' 1},...
    {'dipoles' 'norm' 1 'weight' 10},...
    {'ersp' 'npca' 30 'freqrange' [] 'timewindow' [-6000 -3000 0 4250]  'norm' 1 'weight' 3},...
    {'finaldim' 'npca' 20});
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
[STUDY,~,~,sumD] = pop_clust(STUDY, ALLEEG, 'algorithm','kmeans','clus_num',  25 , 'outliers',  3 );
% studyCalc = 0
% end