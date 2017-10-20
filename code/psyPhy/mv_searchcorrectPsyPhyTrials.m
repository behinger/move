cfg = [];
cfg.plotInconsistentEvent = 0;

%%

fileToPath='/net/store/projects/move/eeg/VP03/S05Proprio/psyphy/Participant_3.5_Time_1359715019.txt'

rawDat = readRawVRData_norm(fileToPath);
[sT, rawDat] = behav_processPsyPhy(fileToPath,'cfg',cfg);
sT.trialNumbers

%%

figure;
plot(rawDat.event);