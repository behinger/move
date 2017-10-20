close all
clear all

% If you want to recreate this file go to stat_exec.m
load('/net/store/projects/move/move_svn/code/MAT_datafiles/behavResults_06-05-2013.mat')
[concPP] = stat_removeOutliers();


%% Those are the winsorized means for the 2x2 ANOVA with 5 VPs
% I create a plot that is very similar to that of SPSS
meansRelError_CondVP = behavResults.meansRelError_CondVP;
passive = mean(meansRelError_CondVP(:,1));
kinesth = mean(meansRelError_CondVP(:,2));
vestib = mean(meansRelError_CondVP(:,3));
active = mean(meansRelError_CondVP(:,4));
numVPs = 5;

figure
hold on
plot([0, 1], [passive, kinesth], '-o')
errorbar([0, 1], [passive, kinesth], [std(meansRelError_CondVP(:,1)) / sqrt(numVPs), std(meansRelError_CondVP(:,2)) / sqrt(numVPs)], '-o')
plot([0.02, 1.02], [vestib, active], '-o', 'Color', 'r')
errorbar([0.02, 1.02], [vestib, active], [std(meansRelError_CondVP(:,3)) / sqrt(numVPs), std(meansRelError_CondVP(:,4)) / sqrt(numVPs)], '-o', 'Color', 'r')
legend('vestibular information off', 'vestibular information on', 'Location', 'NorthWest')
axis([-0.5 1.5 -14 6])
xlabel('  kinesthetic information off                              kinesthetic information on')
hold off

% figure
% hold on
% plot([0, 1], [passive, kinesth], '-o')
% plot([0, 1], [vestib, active], '-o', 'Color', 'r')
% legend('vestibular information off', 'vestibular information on', 'Location', 'NorthWest')
% axis([-0.5 1.5 -10 0])
% xlabel('  kinesthetic information off                              kinesthetic information on')
% hold off


% The significant interaction has a p = 0.008, F(1, 4) = 24.420 
% No significant main effect
% SDs are 9.7, 12.1, 7.0, 7.7



%%
% %% Next I plot the pairwise differences
% % We looked at the systematic and stochastic error by comparing the mean
% % When correcting for multiple comparisons we find for the variance an
% % effect always only in 2 out of 5 subjects

% %% Plot the differences in the mean with standard errors = s/sqrt(n)
% figure
% hold on 
% plot([0.08, 1],     [nanmean(concPP.winsErrorT(concPP.vp == 1 & concPP.condCoded == 2)), ...
%                   nanmean(concPP.winsErrorT(concPP.vp == 1 & concPP.condCoded == 4))], '-o', 'Color', 'g')
% errorbar([0.08, 1], [nanmean(concPP.winsErrorT(concPP.vp == 1 & concPP.condCoded == 2)), ...
%                   nanmean(concPP.winsErrorT(concPP.vp == 1 & concPP.condCoded == 4))], ...
%                   [nanstd(concPP.winsErrorT(concPP.vp == 1 & concPP.condCoded == 2)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 1 & concPP.condCoded == 2))), ...
%                    nanstd(concPP.winsErrorT(concPP.vp == 1 & concPP.condCoded == 4)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 1 & concPP.condCoded == 4)))], 'Color', 'g')
% 
% plot([0.02, 1.02],    [nanmean(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 2)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 4))], '-o', 'Color', 'c')
% errorbar([0.02, 1.02],[nanmean(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 2)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 4))], ...
%                  [nanstd(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 2)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 2))), ...
%                   nanstd(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 4)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 4)))], 'Color', 'c');
% 
% plot([0.04, 1.06],    [nanmean(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 2)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 4))], '-o', 'Color', 'r')
% errorbar([0.04, 1.06],[nanmean(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 2)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 4))], ...
%                  [nanstd(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 2)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 2))), ...
%                   nanstd(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 4)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 4)))], 'Color', 'r');
% 
%    plot([0.06, 1.04], [nanmean(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 2)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 4))], '-o')
% errorbar([0.06, 1.04],[nanmean(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 2)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 4))], ...
%                  [nanstd(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 2)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 2))), ...
%                   nanstd(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 4)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 4)))]);
% 
% legend('Subject 1', 'Subject 2', 'Subject 3', 'Subject 5', 'Location', 'NorthEast')
% axis([-0.2 1.3 -20 15])
% xlabel('  kinesthetic condition                                       active condition')
% hold off
% 
% 
% 
% 
% %% Other, similar differences we find between kin. and vestibular, but only for
% %% 3 VPs
% figure
% hold on 
% plot([0.08, 1],     [nanmean(concPP.winsErrorT(concPP.vp == 1 & concPP.condCoded == 2)), ...
%                   nanmean(concPP.winsErrorT(concPP.vp == 1 & concPP.condCoded == 3))], '-o', 'Color', 'g')
% errorbar([0.08, 1], [nanmean(concPP.winsErrorT(concPP.vp == 1 & concPP.condCoded == 2)), ...
%                   nanmean(concPP.winsErrorT(concPP.vp == 1 & concPP.condCoded == 3))], ...
%                   [nanstd(concPP.winsErrorT(concPP.vp == 1 & concPP.condCoded == 2)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 1 & concPP.condCoded == 2))), ...
%                    nanstd(concPP.winsErrorT(concPP.vp == 1 & concPP.condCoded == 3)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 1 & concPP.condCoded == 3)))], 'Color', 'g')
% 
% plot([0.02, 1.02],    [nanmean(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 2)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 3))], '-o', 'Color', 'c')
% errorbar([0.02, 1.02],[nanmean(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 2)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 3))], ...
%                  [nanstd(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 2)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 2))), ...
%                   nanstd(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 3)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 3)))], 'Color', 'c');
% 
% plot([0.04, 1.06],    [nanmean(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 2)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 3))], '-o')
% errorbar([0.04, 1.06],[nanmean(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 2)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 3))], ...
%                  [nanstd(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 2)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 2))), ...
%                   nanstd(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 3)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 3)))]);
% 
% legend('Subject 1', 'Subject 2', 'Subject 3', 'Location', 'NorthEast')
% axis([-0.2 1.3 -20 15])
% xlabel('  kinesthetic condition                                       vestibular condition')
% hold off
% 
% 
% 
% 
% %% Other, similar differences we find between passive and kinesthetic, but only for
% %% 3 VPs
% figure
% hold on 
% plot([0.02, 1.02],    [nanmean(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 1)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 2))], '-o', 'Color', 'c')
% errorbar([0.02, 1.02],[nanmean(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 1)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 2))], ...
%                  [nanstd(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 1)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 1))), ...
%                   nanstd(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 2)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 2 & concPP.condCoded == 2)))], 'Color', 'c');
% 
% plot([0.04, 1.06],    [nanmean(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 1)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 2))], '-o')
% errorbar([0.04, 1.06],[nanmean(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 1)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 2))], ...
%                  [nanstd(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 1)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 1))), ...
%                   nanstd(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 2)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 2)))]);
% 
% plot([0.08, 1],     [nanmean(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 1)), ...
%                   nanmean(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 2))], '-o', 'Color', 'g')
% errorbar([0.08, 1], [nanmean(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 1)), ...
%                   nanmean(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 2))], ...
%                   [nanstd(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 1)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 1))), ...
%                    nanstd(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 2)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 2)))], 'Color', 'g')
% 
% legend('Subject 1', 'Subject 2', 'Subject 5', 'Location', 'NorthWest')
% axis([-0.2 1.3 -20 15])
% xlabel('  kinesthetic condition                                       passive condition')
% hold off
% 
% 
% 
% 
% 
% 
% %% Other, similar differences we find between passive and vestibular, but only for
% %% 3 VPs
% figure
% hold on
% 
% plot([0.04, 1.06],    [nanmean(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 1)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 2))], '-o')
% errorbar([0.04, 1.06],[nanmean(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 1)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 2))], ...
%                  [nanstd(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 1)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 1))), ...
%                   nanstd(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 2)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 3 & concPP.condCoded == 2)))]);
% 
% plot([0.02, 1.02],    [nanmean(concPP.winsErrorT(concPP.vp == 4 & concPP.condCoded == 1)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 4 & concPP.condCoded == 2))], '-o', 'Color', 'c')
% errorbar([0.02, 1.02],[nanmean(concPP.winsErrorT(concPP.vp == 4 & concPP.condCoded == 1)), ...
%                  nanmean(concPP.winsErrorT(concPP.vp == 4 & concPP.condCoded == 2))], ...
%                  [nanstd(concPP.winsErrorT(concPP.vp == 4 & concPP.condCoded == 1)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 4 & concPP.condCoded == 1))), ...
%                   nanstd(concPP.winsErrorT(concPP.vp == 4 & concPP.condCoded == 2)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 4 & concPP.condCoded == 2)))], 'Color', 'c');
% 
% plot([0.08, 1],     [nanmean(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 1)), ...
%                   nanmean(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 2))], '-o', 'Color', 'g')
% errorbar([0.08, 1], [nanmean(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 1)), ...
%                   nanmean(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 2))], ...
%                   [nanstd(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 1)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 1))), ...
%                    nanstd(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 2)) / sqrt(numel(concPP.winsErrorT(concPP.vp == 5 & concPP.condCoded == 2)))], 'Color', 'g')
% 
% legend('Subject 3', 'Subject 4', 'Subject 5', 'Location', 'NorthWest')
% axis([-0.2 1.3 -30 15])
% xlabel('  passive condition                                       vestibular condition')
% hold off


%%%%%%%%%%%%%%%%%%%%%%
%% Plot with all conditions and single subjects
figure
hold on 
clr = 'rgbkcm';
for vp = 1:5
    vpOffset = 0.02*vp;
    meansCds = [nanmean(concPP.winsErrorT(concPP.vp == vp & concPP.condCoded == 1)), ...
        nanmean(concPP.winsErrorT(concPP.vp == vp & concPP.condCoded == 2)), ...
        nanmean(concPP.winsErrorT(concPP.vp == vp & concPP.condCoded == 3)), ...
        nanmean(concPP.winsErrorT(concPP.vp == vp & concPP.condCoded == 4)) ];
    stdCds = [nanstd(concPP.winsErrorT(concPP.vp == vp & concPP.condCoded == 1)) / sqrt(numel(concPP.winsErrorT(concPP.vp == vp & concPP.condCoded == 1))), ...
        nanstd(concPP.winsErrorT(concPP.vp == vp & concPP.condCoded == 2)) / sqrt(numel(concPP.winsErrorT(concPP.vp == vp & concPP.condCoded == 2))), ...
        nanstd(concPP.winsErrorT(concPP.vp == vp & concPP.condCoded == 3)) / sqrt(numel(concPP.winsErrorT(concPP.vp == vp & concPP.condCoded == 3))), ...
        nanstd(concPP.winsErrorT(concPP.vp == vp & concPP.condCoded == 4)) / sqrt(numel(concPP.winsErrorT(concPP.vp == vp & concPP.condCoded == 4))) ];
    
    plot([1 + vpOffset, 2 + vpOffset, 3 + vpOffset, 4 + vpOffset],   meansCds ,  '-o', 'Color', clr(vp))
    errorbar([1 + vpOffset, 2 + vpOffset, 3 + vpOffset, 4 + vpOffset],   meansCds , stdCds, '-o', 'Color', clr(vp))
    xlabel('passive                      kinesthetic                      vestibular                         active')
    title('All subjects, all conditions')
end

%% ===========================================
% Turning angles
figure;
meansTD = [];
color = 'gbrk';  
hold on
for cond = 1:4
    for td = [-90 -60 -30 30 60 90; 1 2 3 4 5 6]
            meansTD(td(2), cond) = nanmean(abs(errors(concPP.turningAnglePerfect == td(1) & concPP.condCoded == cond)));
    end    
    plot([-90 -60 -30 0 30 60],meansTD(:, cond),'-o','Color', color(cond), 'MarkerSize', 10);
    title('Mean absolute error over all trials');
end   
hold off
axis([-100, 70, 0, 30])  % absolute
set(gca,'XTick',[-90, -60, -30, 0, 30, 60]); 
set(gca,'XTickLabel',{'-90', '-60', '-30', '30', '60', '90'})
legend('Passive','Proprio', 'Vestib', 'Active');





%%%%%%%%%
%% Quiver Plots
indices = find(concPP.vp == 5 & concPP.condCoded == 4);
angles = unique(concPP.turningAnglePerfect);
angles = angles(~isnan(angles));
clr = 'rgbkcmy';
clr = [[0.24, 0.66, 0.90]; [0.2, 0.56, 1.0];  [0.5, 0.9, 1.0]; ...  % bluish colors
       [0.61, 0.88, 0.42]; [0.3, 0.9, 0.5]; [0.2, 0.73, 0.51]];      % greenish colors
r = 3; % radius of paths to walk
lenArrOptim = [4.5, 5.5, 6, 6, 5.5, 4.5]; % len of the pointBackArrow
lenArr = [2, 2, 2, 2, 2, 2]; % len of the pointBackArrow


cnd = [4];
vps = [1, 2, 3, 4, 5];
vps = [1];

for cd = cnd
    for vp = 1:numel(vps)
        figure;
        hold on
        line([-3, 0], [0, 0], 'Color', 'k', 'LineWidth',4)
        for turnAng = 1:numel(angles)
            line([0, r * cosd(angles(turnAng))], [0, r * sind(angles(turnAng))], 'Color','k', 'LineWidth',4)
            indices = find(concPP.vp == vps(vp) & concPP.condCoded == cd & concPP.turningAnglePerfect == angles(turnAng));
            if vp == 4
                indices = indices(1 : 1 : end);  % obsolete> take only every 5th vector, now take every vector
            else
                indices = indices(1 : 1 : end);  
            end
            bLen = sqrt(r.^2 + r.^2 - 2*r*r*cos(degtorad(180 - abs(angles(turnAng))))); % hypothenuse, distance between points
            aLen = r; 
            cLen = r;
            gamma = radtodeg(asin(cLen * sin(degtorad(180 - abs(angles(turnAng)))) / bLen));
            arrowAngleOptimal = (180 + gamma) * sign(angles(turnAng));
           
            % Part for plotting the mean angle
            answerAngles = arrowAngleOptimal +  concPP.winsErrorT(indices) .* sign(angles(turnAng)); 
            endPosX = r * cosd(angles(turnAng));
            endPosY = r * sind(angles(turnAng));
            quiver(endPosX, endPosY, lenArr(turnAng) * cosd(nanmean(answerAngles)), lenArr(turnAng) * sind(nanmean(answerAngles)), 'Color', 'r')
            % Part for plotting the other arrows
            for idx = indices          
                answerAngle = arrowAngleOptimal +  concPP.winsErrorT(idx) * sign(angles(turnAng));        
                endPosX = r * cosd(angles(turnAng));
                endPosY = r * sind(angles(turnAng));
                quiver(endPosX, endPosY, lenArrOptim(turnAng) * cosd(arrowAngleOptimal), lenArrOptim(turnAng) * sind(arrowAngleOptimal), 'Color', [0.9, 0.82, 0.75])
                quiver(endPosX, endPosY, lenArr(turnAng) * cosd(answerAngle), lenArr(turnAng) * sind(answerAngle), 'Color', clr(turnAng,:))
            %   legend('blue-Subject Track','green-Guide Track', 'black-Answer Angle', 'pink-Turner Opt.', 'yellow-NonT. Opt.') 
                axis([-3.5 3.5 -3.5 3.5])
            end
        end
        title(['VP', num2str(vps(vp)), ' in cond ', num2str(cd)]);
        hold off
    end
end