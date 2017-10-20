function [] = visualize_angle(rawDat,sT,allTrials)
stepSize = 20;  % Performant plotting
% stepSize = 1;   % Plot every point
for trial = 1:allTrials

    posXRot = rawDat.posX(sT.startFirstPathIdx(trial):stepSize:sT.fadeIndIdx(trial));
    posZRot = rawDat.posZ(sT.startFirstPathIdx(trial):stepSize:sT.fadeIndIdx(trial));
    guideXRot = rawDat.guidingXPos(sT.startFirstPathIdx(trial):stepSize:sT.fadeIndIdx(trial));
    guideZRot = rawDat.guidingZPos(sT.startFirstPathIdx(trial):stepSize:sT.fadeIndIdx(trial));
    
%     figure;
    plot(posXRot(:), posZRot(:));    
    hold on
    r = 3; % radius of arrows for the quiver plot
    plot(guideXRot(:), guideZRot(:), 'Color', 'g');
%     h = polar(degtorad(sT.chosenArrowAngleAbs(trial)), [repmat(1,1,numel(trial))]','ok');
    quiver(posXRot(end), posZRot(end), r * cosd(sT.chosenArrowAngleAbs(trial)), r * sind(sT.chosenArrowAngleAbs(trial)), 'Color', 'k', 'LineWidth', 1)
%     set(h,'LineWidth',2)
%     h = polar(degtorad(sT.arrowAngleOptimalTAbs(trial)), [repmat(1,1,numel(trial))]','xm');
%     set(h,'LineWidth',5)
    quiver(posXRot(end), posZRot(end), r * cosd(sT.arrowAngleOptimalTAbs(trial)), r * sind(sT.arrowAngleOptimalTAbs(trial)), 'Color', 'm')
%     h = polar(degtorad(sT.arrowAngleOptimalNonTAbs(trial)), [repmat(1,1,numel(trial))]','xy');
    quiver(posXRot(end), posZRot(end), r * cosd(sT.arrowAngleOptimalNonTAbs(trial)), r * sind(sT.arrowAngleOptimalNonTAbs(trial)), 'Color', 'y')
%     set(h,'LineWidth',5)
    h = polar(degtorad(rawDat.roll(sT.fadeIndIdx(trial))), [repmat(1,1,numel(trial))]','xr');
    set(h,'LineWidth',5)
    h = polar(degtorad(rawDat.guidingOrient(sT.fadeIndIdx(trial))), [repmat(1,1,numel(trial))]','xc');
    set(h,'LineWidth',2)
    legend('blue-Subject Track','green-Guide Track', 'black-Answer Angle', 'pink-Turner Opt.', 'yellow-NonT. Opt.') 
    title (num2str(trial))
    
    axis([-4 4 -4 4])
end
