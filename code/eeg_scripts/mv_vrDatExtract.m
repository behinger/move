function [sT3] = mv_vrDatExtract(p)
%% Wrapper Function. Reads out the p.full.psyphyVR

cfg = [];
cfg.plotInconsistentEvent = 0;
cfg.showWarningInconEvent = 1;
[sT, rawDat] = behav_processPsyPhy(p.full.psyphyVR,'cfg',cfg);
sT2 = behav_fullRespFile(sT);
sT3 = behav_sT_removeFields(sT2);
% 
try
    [sT3.badEEG sT3.badVR] = mv_readCommentXLS(p);
catch
     fprintf('No commentsheet detected!! \n')
     sT3.badEEG = nan(length(sT3.errors_T),1)';
     sT3.badVR  = nan(length(sT3.errors_T),1)';
end
%  sT3.badEEG = [];
%  sT3.badVR  = [];


