function [sanityCh] = behav_sanityChecks(sT,rawDat)
%% Sanity Checks
if cfg.sanityChecks

%% Check if the start and end position match to the firstArm and second Arm

%% Unnormalized First Arm has to match the calculated angle from start
%% position
sanityCh.diffFirstArm = sT.calculatedFirstArm - normAngle(rawDat.firstArm(sT.lastIdxRaw));
%% Unnormalized Second Arm has to match the calculated angle from end position
%% This only makes sense for the vestibular and the active condition, not
%% for the proprioceptive!
sanityCh.diffSecondArm = sT.calculatedSecondArm - normAngle(rawDat.secondArm(sT.lastIdxRaw));
% % CORRESPONDING TO:
% % rawDat.firstArm             = -data{13}+180; % only relevant for the active conditions % 180 deg offset to turningAngle
% % rawDat.secondArm            = -data{15}; % only relevant for the active conditions % second Arm global angle against z-axis   

% %% Unnormalized First Arm has to match the calculated angle from start position
% sT.calculatedFirstArm = atan2(sT.StartPosX, sT.StartPosZ) * 180/pi;  
% sanityCh.diffFirstArm = sT.calculatedFirstArm - normAngle(rawDat.firstArm(sT.lastIdxRaw));
% %% Unnormalized Second Arm has to match the calculated angle from end position
% %% This only makes sense for the vestibular and the active condition, not
% %% for the proprioceptive!
% sT.calculatedSecondArm = atan2(sT.EndPosX, sT.EndPosZ) * 180/pi;  
% sanityCh.diffSecondArm = sT.calculatedSecondArm - normAngle(rawDat.secondArm(sT.lastIdxRaw));
% % % CORRESPONDING TO:
% % % rawDat.firstArm             = data{13}-180; % only relevant for the active conditions % 180 deg offset to turningAngle
% % % rawDat.secondArm            = data{15}; % only relevant for the active conditions % second Arm global angle against z-axis


%% Degrees Turned Sanity Check
sanityCh.plannedAngles = sT.turningAnglePlanned;
sanityCh.guideRotations = normAngle(rawDat.guidingOrient(sT.turnEndIndIdx) - rawDat.guidingOrient(sT.turnStartIndIdx));
sanityCh.headRotationsTurn = normAngle(rawDat.roll(sT.startSecondPathIdx) - rawDat.roll(sT.turnStartIndIdx)); 
sanityCh.armDiffRotations = - normAngle(sT.secondArm - (sT.firstArm + 180));  % Calculates the difference from the real arm configuration
sanityCh.calcArmDiffRotations = - normAngle(sT.calculatedSecondArm - (sT.calculatedFirstArm + 180));  % Calculates the difference from the start and end positions in VR Positions!
sanityCh.proprioceptiveDummyRotations = rawDat.proprioceptiveDummy(sT.startSecondPathIdx);

%% Plot velocities, only as a check/for the documentation
% plotVelocities(rawDat);
end