% folder = 'D:\behinger\Studium\move\svn_move\behaviouralData\Subj_04\Participant_4.3';
% file = {[folder filesep 'Participant_4.3_Time_1358350844.txt']};
% file = [folder filesep 'Participant_4.3_Time_1358346300.txt'];

% folder = 'D:\behinger\Studium\move\svn_move\behaviouralData\Subj_05\Participant_5.2';
% file = {[folder filesep 'Participant_5.2_Time_1358431208.txt'],[folder filesep 'Participant_5.2_Time_1358433595.txt'],[folder filesep 'Participant_5.2_Time_1358434293.txt']};

% folder = 'D:\behinger\Studium\move\svn_move\behaviouralData\Subj_05\Participant_5.1';
% file = {[folder filesep 'Participant_5.1_Time_1358242926.txt']}
% 
% folder = 'D:\behinger\Studium\move\svn_move\behaviouralData\Subj_04\Participant_4.1';
% file = [folder filesep 'Participant_4.1_Time_1357647714.txt'];

[fileSelect folder] = uigetfile('D:\behinger\Studium\move\svn_move\behaviouralData\*.txt','MultiSelect','on');
file = [];
for k = 1:length(fileSelect)
    file{k} = fullfile(folder,fileSelect{k});
end

cfg = [];
cfg.plotInconsistentEvent = 1;
[sT rawDat] = behav_processPsyPhy(file,'cfg',cfg);
sT2 = behav_fullRespFile(sT);
sT3 = behav_sT_removeFields(sT2);


%%
plot(sT3.degreesTurned,sT3.turningAnglePlanned,'x')
hold on,plot(-90:90,-90:90,'r')
%%
abweichung = sT3.degreesTurned - sT3.perfectTurningAngles;

hist(abweichung);
hold on,
vline(nanmean(abs(abweichung)),'g','absMeanError')
vline(nanmean(abweichung),'r','relMeanError')

title('Deviation from planned Angles')
xlabel('Error in Degree')