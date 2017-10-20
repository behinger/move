function [sT] = get_event_data(p)
error('Not yet implemented!')
normalizeData;
end


% %get_event_data
% txt = fopen(p.full.psyphyVR);
% data = textscan(txt, [repmat('%f ', 1, 11), '%s'], 'Delimiter', '\t');
% 
% time = data{1};  % time in seconds as floating point number (according to the the system clock) 
% event = data{2};  % event:
% 
% trialNumber = data{3};	 % trialNumber, starting with 0
% currentTurningAngle = data{4};  % This is the condition, e.g. -60�
% semiCorrectAnswerAngle = data{5};  % This angle could be calculated in MATLAB too. It is calculated in Vizard via 
% 
% chosenAngle = data{6};  % This is the angle chosen by the arrow / by the subject
% 
% condition = data{12};  % condition as string, either "passive", "active", "proprioceptive" or "vestibular"
% numberOfTrials = numel(unique(trialNumber)); %+1 as it starts with 0
% 
% for trial = 1:numberOfTrials
%     lastTrialEntry = find(trialNumber==(trial-1), 1, 'last' )-1;
%     firstTrialEntry = find(trialNumber==(trial-1), 1, 'first' );
%    % finalChosenAngles(trial) = chosenAngle(lastTrialEntry);  
%     currentTurningAngles(trial) = currentTurningAngle(lastTrialEntry); 
%    % semiCorrectAnswerAngles(trial) = semiCorrectAnswerAngle(lastTrialEntry); 
%    % trialDuration(trial) = time(lastTrialEntry) - time(firstTrialEntry);
% end