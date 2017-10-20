function [sT] = behav_calculateErrorAngles(rawDat, sT)
%% The following code is moved into the behav_prepareRawDat.mat file
% %% Calculate appropriate angles according to the positions
% sT.calculatedFirstArm = atan2(sT.StartPosZ, sT.StartPosX) * 180/pi;  
% sT.calculatedSecondArm = atan2(sT.EndPosZ, sT.EndPosX) * 180/pi;
% % sT.calculatedSecondArm = sT.calculatedSecondArm - sT.calculatedFirstArm;
% % sT.calculatedFirstArm = sT.calculatedFirstArm - sT.calculatedFirstArm;
% sT.degreesTurned = normAngle(sT.calculatedSecondArm - (sT.calculatedFirstArm + 180));  % This is the better calculation compared to taking the secondArm
% 
% 
% if strcmp(sT.condition,'proprioceptive')
%     sT.degreesTurned = rawDat.proprioceptiveDummy(sT.fadeIndIdx);  
% end
for endPosVar = 1:4
    if endPosVar == 1 %% Let everything normal for the first run
        endPosX = sT.EndPosX;
        endPosZ = sT.EndPosZ;
    else
        endPosX = sT.EndPosXVar(:, endPosVar);
        endPosZ = sT.EndPosZVar(:, endPosVar);
    end
    
    bLen = sqrt((((endPosX - sT.StartPosX)).^2) + (((endPosZ - sT.StartPosZ).^2))); % hypothenuse, distance between points
    aLen = sqrt(endPosX.^2 + endPosZ.^2); % distance to (0|0)
    cLen = sqrt(sT.StartPosX.^2 + sT.StartPosZ.^2); % distance to (0|0)
    gamma = radtodeg(asin(cLen .* sin(degtorad(180 - abs(sT.degreesTurned))) ./ bLen)); % gamma=unterscheid zwischen optimalem turner response und grade durchgezogener hypothenuse
    % The following alternative is a sanity check, for old files it does not
    % work for the proprioceptive (as the positions jumped to the real position
    % back and not the VR position) but for the new files it should
    gammaAlternat = radtodeg(acos(((aLen .^ 2 + bLen .^ 2 - cLen .^ 2) ./ (2 * (aLen .* bLen)))));
    sT.gamma = gamma;
% --- Anna hier stehen geblieben---
    sT.arrowAngleOptimalT = (180 - gamma) .* sign(sT.degreesTurned);  %180 - gamma to get an angle that is equal to sT.chosenArrowAngleNorm, negative sign to get right MATLAB coords (turn right is negative, turn left positive)
    sT.arrowAngleOptimalNonT = sT.arrowAngleOptimalT + sT.degreesTurned;  % Add the turned angle (if it is negative, it automatically gets subtracted) to compensate for the nonturner effect\

    sT.arrowAngleOptimalTAbs = normAngle(sT.calculatedSecondArm + sT.arrowAngleOptimalT);
    sT.arrowAngleOptimalNonTAbs = normAngle(sT.calculatedSecondArm + sT.arrowAngleOptimalNonT);

    % VERY IMPORTANT!!! If you use sT.calculatedSecondArm + sT.chosenArrowAngle, 
    % you also have to use sT.chosenArrowAngle - sT.arrowAngleInitial
    % If is used later in: calculatedSecondArm - sT.chosenArrowAngleNorm 
    % it has to be sT.arrowAngleInitial -sT.chosenArrowAngle
    sT.chosenArrowAngleNorm =  sT.chosenArrowAngle - sT.arrowAngleInitial; 
    sT.chosenArrowAngleAbs =  normAngle(sT.calculatedSecondArm + sT.chosenArrowAngleNorm);  % Rotate it so that it fits in absolute coordinates to the second Arm


    % % These lines are only to check if the normalized arrow yield the same
    % % error, and it does if you compare sT.errors_TNotNormed with sT.errors_T
    % % and sT.errors_NTNotNormed with sT.errors_NT
    % sT.arrowAngleOptimalTNotNormed = normAngle(180 + sT.arrowAngleInitial  + (changeSign * gamma .* sign(sT.degreesTurned)));  %180+ as the arrow otherwise would point in the wrong direction
    % sT.arrowAngleOptimalNonTNotNormed = sT.arrowAngleOptimalTNotNormed + sT.degreesTurned;  % Add the turning angle (if it is negative, it automatically gets subtracted) to compensate for the nonturner effect\


    %% Calc errorsD
%     sT.errors_T = normAngle(sT.chosenArrowAngleNorm - sT.arrowAngleOptimalT) .* sign(sT.degreesTurned);  % We multiply with the sign of the degreesTurned to get positive errors for overshoot and neg. errors for undershoot
%     sT.errors_NT = normAngle(sT.chosenArrowAngleNorm - sT.arrowAngleOptimalNonT) .* sign(sT.degreesTurned);
    
    if endPosVar == 1  %% Let everything normal for the first run
        sT.errors_T = normAngle(sT.chosenArrowAngleNorm - sT.arrowAngleOptimalT) .* sign(sT.degreesTurned);  % We multiply with the sign of the degreesTurned to get positive errors for overshoot and neg. errors for undershoot
        sT.errors_NT = normAngle(sT.chosenArrowAngleNorm - sT.arrowAngleOptimalNonT) .* sign(sT.degreesTurned);
    elseif endPosVar == 2
        sT.errors_T_VarPos2 = normAngle(sT.chosenArrowAngleNorm - sT.arrowAngleOptimalT) .* sign(sT.degreesTurned);  % We multiply with the sign of the degreesTurned to get positive errors for overshoot and neg. errors for undershoot
        sT.errors_NT_VarPos2 = normAngle(sT.chosenArrowAngleNorm - sT.arrowAngleOptimalNonT) .* sign(sT.degreesTurned);
    elseif endPosVar == 3
        sT.errors_T_VarPos3 = normAngle(sT.chosenArrowAngleNorm - sT.arrowAngleOptimalT) .* sign(sT.degreesTurned);  % We multiply with the sign of the degreesTurned to get positive errors for overshoot and neg. errors for undershoot
        sT.errors_NT_VarPos3 = normAngle(sT.chosenArrowAngleNorm - sT.arrowAngleOptimalNonT) .* sign(sT.degreesTurned);
    elseif endPosVar == 4
        sT.errors_T_VarPos4 = normAngle(sT.chosenArrowAngleNorm - sT.arrowAngleOptimalT) .* sign(sT.degreesTurned);  % We multiply with the sign of the degreesTurned to get positive errors for overshoot and neg. errors for undershoot
        sT.errors_NT_VarPos4 = normAngle(sT.chosenArrowAngleNorm - sT.arrowAngleOptimalNonT) .* sign(sT.degreesTurned);
    end
    
    % % These lines are only to check if the normalized arrow yield the same
    % % error, and they do
    % sT.errors_TNotNormed = normAngle(sT.chosenArrowAngle - sT.arrowAngleOptimalTNotNormed);
    % sT.errors_NTNotNormed = normAngle(sT.chosenArrowAngle - sT.arrowAngleOptimalNonTNotNormed);
end

perfectTurningAngles = [-90, -60, -30, 30, 60, 90];
[~,ind] = arrayfun(@(x)min(abs(x- perfectTurningAngles)),sT.degreesTurned);%,'UniformOutput',0);

sT.turningAnglePerfect = perfectTurningAngles(ind);

