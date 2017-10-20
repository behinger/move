function [] = plotVelocities(rawDat)

pV.startFirstPath      = find(rawDat.event == 2)';
pV.endFirstPath        = find(rawDat.event == 3)';
pV.turnStartIdx        = find(rawDat.event == 4)';
pV.turnEndIdx          = find(rawDat.event == 5)';  % This is only the moment where the guiding object stops, it does not mean that the subject has finished rotating
pV.startSecondPathIdx  = find(rawDat.event == 6)';
pV.endSecondPathIdx    = find(rawDat.event == 7)';

pV.condition           = rawDat.condition{1};
pV.trialNumbers        = rawDat.trialNumber(pV.endSecondPathIdx);
pV.numTrials           = numel(pV.trialNumbers);

pV.guideOrientation  =  rawDat.guidingOrient; 
pV.guideXPos         =  rawDat.guidingXPos;
pV.guideZPos         =  rawDat.guidingZPos;

pV.guideXPos((find(rawDat.event > 20))+1)         =  pV.guideXPos((find(rawDat.event > 20)));  % Set the other events that are triggered by the subject's position
pV.guideZPos((find(rawDat.event > 20))+1)         =  pV.guideZPos((find(rawDat.event > 20)));  % to a reasonable value

% pV.guideOrientDiff = NaN(1,pV.numTrials);
for trial=1:pV.numTrials
    pV.guideOrientDiff = diff(pV.guideOrientation(pV.turnStartIdx(trial):pV.turnEndIdx(trial)));

    pV.firstStraightDiffX = diff(pV.guideXPos(pV.startFirstPath(trial):pV.endFirstPath(trial)));
    pV.firstStraightDiffZ = diff(pV.guideZPos(pV.startFirstPath(trial):pV.endFirstPath(trial)));
    pV.secondStraightDiffX = diff(pV.guideXPos(pV.startSecondPathIdx(trial):pV.endSecondPathIdx(trial)));
    pV.secondStraightDiffZ = diff(pV.guideZPos(pV.startSecondPathIdx(trial):pV.endSecondPathIdx(trial)));
    
    pV.movementFirst = sqrt(pV.firstStraightDiffX .* pV.firstStraightDiffX + pV.firstStraightDiffZ .* pV.firstStraightDiffZ);
    pV.movementSecond = sqrt(pV.secondStraightDiffX .* pV.secondStraightDiffX + pV.secondStraightDiffZ .* pV.secondStraightDiffZ);
    figure;
    subplot(3,1,1)
    plot(pV.guideOrientDiff)
    title('Velocity turn, Trial:  %d')
    subplot(3,1,2)
    plot(pV.movementFirst)
    title('Velocity first straight part')
    subplot(3,1,3)
    plot(pV.movementSecond)
    title('Velocity second straight part')
    fprintf('Trial: %d \n', trial)
    fprintf('Velocity first straight part: %d \n', mean( pV.movementFirst(round(numel(pV.movementFirst)/2)-20:round(numel(pV.movementFirst)/2)+20)))
    fprintf('Velocity second straight part: %d \n', mean( pV.movementSecond(round(numel(pV.movementSecond)/2)-20:round(numel(pV.movementSecond)/2)+20)))
    fprintf('Velocity turn guidingobject: %d \n', mean( pV.guideOrientDiff(round(numel(pV.guideOrientDiff)/2)-20:round(numel(pV.guideOrientDiff)/2)+20)))
end
