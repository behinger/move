
%% Test the Bug that the Angle is wrong, plot the guide position and the walked way
%% IN ABSOLUTE COORDINATES (Not in normed, translated coordinates) TO CHECK
%% IF IT HAS SOMETHING TO DO WITH CARDINAL DIRECTIONS/QUADRANTS
for i=33:41
    %% If you plot the position you see that everything is alright   
%     subplot(2,3,i-32)
    figure
    trialDesired = i;
    trial = trialDesired - 3;  % 4-3 is array position 1, as we started with trialNr 4 in this textfile 
    plot(sT.StartPosX(trial),sT.StartPosZ(trial),'bx','LineWidth',10)
    hold on
    plot(rawDat.posX(sT.firstIdxRaw(trial):sT.lastIdxRaw(trial)), rawDat.posZ(sT.firstIdxRaw(trial):sT.lastIdxRaw(trial)))
    plot(rawDat.guidingXPos(sT.firstIdxRaw(trial):sT.lastIdxRaw(trial)), rawDat.guidingZPos(sT.firstIdxRaw(trial):sT.lastIdxRaw(trial)), 'Color', 'r')
    title (num2str(trialDesired))
    axis([-4 4 -4 4])
    %% If you plot the orientation you see deviations
%     h = polar(degtorad(rawDat.roll(sT.startSecondPathIdx(trial))), [repmat(1,1,numel(trial))]','xr');
    h = polar(degtorad(rawDat.rollUnnorm(sT.fadeIndIdx(trial))), [repmat(1,1,numel(trial))]','xg');
    set(h,'LineWidth',10)
%     h = polar(degtorad(rawDat.guidingOrient(sT.startSecondPathIdx(trial))), [repmat(1,1,numel(trial))]','oy');
    h = polar(degtorad(rawDat.guidingOrientUnnorm(sT.fadeIndIdx(trial))), [repmat(1,1,numel(trial))]','oc');
    set(h,'LineWidth',4)
    title (num2str(trialDesired))
    hold off
    fprintf('startSecondPath: %f \  fadeInArrowIdx: \t %f \n',rawDat.roll(sT.fadeIndIdx(trial)), rawDat.guidingOrient(sT.fadeIndIdx(trial)))
end


    