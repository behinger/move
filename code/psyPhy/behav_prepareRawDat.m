function [rawDat,sT] = behav_prepareRawDat(rawDat,cfg)

[rawDat_cut badSegments] = behav_cutInconsistendTrials(rawDat,cfg.plotInconsistentEvent, cfg.showWarningInconEvent);
rawDat = rawDat_cut;

%%

%% Get important event indices
sT.startFirstPathIdx = find(rawDat.event == 2)';
% sT.startFirstPathIdx = find(rawDat.event == 2)';
sT.endFirstPathIdx = find(rawDat.event == 3)';
sT.turnStartIndIdx  = find(rawDat.event == 4)';
sT.turnEndIndIdx  = find(rawDat.event == 5)';  % This is only the moment where the guiding object stops, it does not mean that the subject has finished rotating
sT.startSecondPathIdx  = find(rawDat.event == 6)';
sT.endSecondPathIdx  = find(rawDat.event == 7)';
sT.fadeIndIdx  = find(rawDat.event == 8)';
sT.lastIdxRaw  = find(rawDat.event == 9)';
sT.trig20  = find(rawDat.event == 20)';
sT.trig28  = find(rawDat.event == 28)';
sT.trig100  = find(rawDat.event == 100)';
sT.trig109  = find(rawDat.event == 109)';


% This is not needed for MATLAB as we have the trialNumbers anyways, but shows how you can derive the trialNumbers from the EEG Triggers
% sT.trialNumbersTrigger = rawDat.event(rawDat.event > 150 & rawDat.event < 210)' - 150;

% chosenAngleFadeIn = normAngle(rawDat.chosenAngle(sT.fadeIndIdx(6)))  % Here you can check whether the three angles are correct
% rollFadeIn = normAngle(rawDat.roll(sT.fadeIndIdx(6)))
% guidingOrientFadeIn = normAngle(rawDat.guidingOrient(sT.endSecondPathIdx(6)))

if length(sT.startFirstPathIdx) ~= length(sT.lastIdxRaw)
    warning('There seems to be a problem regarding cut off trials.')
end


sT.condition            =  rawDat.condition{1};

sT.trialDuration        =  rawDat.time(sT.lastIdxRaw) - rawDat.time(sT.startFirstPathIdx);

sT.trialNumbers         =  rawDat.trialNumber(sT.lastIdxRaw);

sT.numTrials            =  numel(sT.trialNumbers);


%% normalize the rawData in X and Z direction
rawDat_conv = behav_normalizeXZ(rawDat,sT);
rawDat = rawDat_conv;



sT.turningAnglePlanned  =  rawDat.turningAnglePlanned(sT.lastIdxRaw); 

sT.secondArm            =  normAngle(rawDat.secondArm(sT.lastIdxRaw));          

sT.firstArm             =  normAngle(rawDat.firstArm(sT.lastIdxRaw));          

sT.arrowAngleInitial    =  normAngle(rawDat.chosenAngle(sT.fadeIndIdx)); 

sT.chosenArrowAngle     =  normAngle(rawDat.chosenAngle(sT.lastIdxRaw));

sT.StartPosX            = rawDat.posX(sT.startFirstPathIdx);
sT.StartPosZ            = rawDat.posZ(sT.startFirstPathIdx);

sT.EndPosX              = rawDat.posX(sT.fadeIndIdx);  
sT.EndPosZ              = rawDat.posZ(sT.fadeIndIdx);

%% Calculate appropriate angles according to the positions
sT.calculatedFirstArm = atan2(sT.StartPosZ, sT.StartPosX) * 180/pi;  
sT.calculatedSecondArm = atan2(sT.EndPosZ, sT.EndPosX) * 180/pi;
% sT.calculatedSecondArm = sT.calculatedSecondArm - sT.calculatedFirstArm;
% sT.calculatedFirstArm = sT.calculatedFirstArm - sT.calculatedFirstArm;
sT.degreesTurned = normAngle(sT.calculatedSecondArm - (sT.calculatedFirstArm + 180));  % This is the better calculation compared to taking the secondArm

if strcmp(sT.condition,'proprioceptive')
    sT.degreesTurned = rawDat.proprioceptiveDummy(sT.fadeIndIdx);  
end

%% The arrow had an offset of 1.2 meters to the subject, we are not exactly
%% sure if they used the offset
%% Calculate Position
beta = sT.degreesTurned;  %% or MINUS??!
for i = 1:numel(beta)
    rotationMatrix = [cosd(beta(i)) -sind(beta(i)); sind(beta(i)) cosd(beta(i))];
    sT.arrowOffsetRot(i,:) = rotationMatrix * [-1.2, 0]';
end
% Either the take the position where the arrow faded in or the position
% where the subject stopped to give the answer (sT.lastIdxRaw ) 
% fadePosFlag = false;
% arrowOffsetFlag = true;
% if fadePosFlag & ~arrowOffsetFlag  % If we want to take the position of the subject of the timepoint where the arrow faded in
%     endPosIndex = sT.fadeIndIdx;
%     sT.arrowOffsetRot = [0, 0];
% elseif ~fadePosFlag & ~arrowOffsetFlag   % If we want to to take the position of the subject of the timepoint of its response
%     endPosIndex = sT.lastIdxRaw;
%     sT.arrowOffsetRot = [0, 0];
% elseif fadePosFlag & arrowOffsetFlag
%     endPosIndex = sT.fadeIndIdx;
% elseif ~fadePosFlag & arrowOffsetFlag
%     endPosIndex = sT.lastIdxRaw;
% end
sT.EndPosX           = rawDat.posX(sT.fadeIndIdx);
sT.EndPosZ           = rawDat.posZ(sT.fadeIndIdx);
sT.EndPosXVar(:,1)   = rawDat.posX(sT.fadeIndIdx);  % This is just the standard condition again for the for-loop
sT.EndPosZVar(:,1)   = rawDat.posZ(sT.fadeIndIdx);
sT.EndPosXVar(:,2)   = rawDat.posX(sT.lastIdxRaw);
sT.EndPosZVar(:,2)   = rawDat.posZ(sT.lastIdxRaw);
sT.EndPosXVar(:,3)   = rawDat.posX(sT.fadeIndIdx) + sT.arrowOffsetRot(:,1); 
sT.EndPosZVar(:,3)   = rawDat.posZ(sT.fadeIndIdx) + sT.arrowOffsetRot(:,1); 
sT.EndPosXVar(:,4)   = rawDat.posX(sT.lastIdxRaw) + sT.arrowOffsetRot(:,1);   
sT.EndPosZVar(:,4)   = rawDat.posZ(sT.lastIdxRaw) + sT.arrowOffsetRot(:,2); 

