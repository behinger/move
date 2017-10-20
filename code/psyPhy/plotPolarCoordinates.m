%%
ang =5;
%%
figure,
h = polar(degtorad(sT.secondArm(ang)),[repmat(1,1,numel(ang))]','xr');
% h = polar(degtorad(180-sT.turningAnglePlanned(ang)),[repmat(1,1,numel(ang))]','xr')

 set(h,'LineWidth',10)

hold on
h = polar(degtorad(sT.firstArm(ang)),[repmat(1,1,numel(ang))]','xb');
set(h,'LineWidth',10)

% To calculate the chosenAngle relative to the angle of the second arm (so
% relative to their end rotation) you have to subtract the chosenArrowAngleNorm,
% as MATLAB plots additions as left rotations and subtractions as right
% rotations, completely contrary to Vizard
h = polar(degtorad(sT.secondArm(ang)-sT.chosenArrowAngleNorm(ang)),[repmat(1,1,numel(ang))]','xg');
set(h,'LineWidth',10)
h = polar(degtorad(sT.secondArm(ang)-sT.arrowAngleOptimalT(ang)),[repmat(1,1,numel(ang))]','oc');
set(h,'LineWidth',4)

h = polar(degtorad(sT.secondArm(ang)-sT.arrowAngleOptimalNT(ang)),[repmat(1,1,numel(ang))]','oy');
set(h,'LineWidth',4)

% h = polar(degtorad(sT.arrowAngle(ang)),[repmat(1,1,numel(ang))]','xg')
 %h = polar(degTorad(sT.initialArrowAngle(ang)),[repmat(1,1,numel(ang))]','xy')
 %set(h,'LineWidth',10)
legend('red second','blue first','green chosenAngle','cyan optimal Turner', 'yellow optimal NT')

title(num2str(ang))
%correctAng = [-90 30 -90 60 90 90 60 -90 30];

%correctAng(ang)
%%

figure
plot(sT.StartPosX(ang),sT.StartPosZ(ang),'bx','LineWidth',10),hold on
plot(rawDat.posX(sT.firstIdxRaw(ang):sT.lastIdxRaw(ang)),rawDat.posZ(sT.firstIdxRaw(ang):sT.lastIdxRaw(ang)))

title(num2str(ang))
axis([-4 4 -4 4])
%%

    firstArm = sT.firstArm;
    firstArm(sT.firstArm<-180) = 360+sT.firstArm(sT.firstArm<-180);
    tA = abs(firstArm - (sT.secondArm));
    tA(tA>180) = tA(tA>180)-180;
    %%
    figure
    plot(rawDat.posX,rawDat.posZ,'x')
    
    %%
    figure
    plot(rawDat.posX(sT.firstIdxRaw(ang):sT.lastIdxRaw(ang)),rawDat.posZ(sT.firstIdxRaw(ang):sT.lastIdxRaw(ang)),'x')
    %%
    figure,
    plot(rawDat.event),hold on
    plot((rawDat.event==2).*10,'r')
    
    %%
    figure,
    
    behav_plotEvents(rawDat,20,9)
    title('Events')
    
    