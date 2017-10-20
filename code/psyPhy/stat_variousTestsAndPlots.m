%% Descriptive statistics
close all;
clear all;




% %% Compute ratio of nonturner trials in only 90 ° degree trials (Bene's suggestion), this ratio is even higher
% nonTurnerTrials = find(abs(concPP.errors_T(abs(concPP.turningAnglePerfect) == 90)) > abs(concPP.errors_NT(abs(concPP.turningAnglePerfect) == 90)));
% numberOfValidTrials = numel(concPP.errors_T(abs(concPP.turningAnglePerfect) == 90)) - numel(find(isnan(concPP.errors_T(abs(concPP.turningAnglePerfect) == 90)) == 1));
% nonTurnerTrialsPercent = numel(nonTurnerTrials) / numberOfValidTrials;





%% Compute deviations of turned angle in the proprioceptive condition!!
devTurnedAngles = [];
for cond= 1:4
    figure;
    for vpNr=1:5
        subplot(2, 3, vpNr);
        bar(concPP.degreesTurned(concPP.vp == vpNr & concPP.condCoded == cond) - concPP.turningAnglePerfect(concPP.vp == vpNr & concPP.condCoded == cond))
%         devTurnedAngles = 4        
        meanDevTurnedAngles(vpNr, cond) = nanmean( abs(concPP.degreesTurned(concPP.vp == vpNr & concPP.condCoded == cond) - concPP.turningAnglePerfect(concPP.vp == vpNr & concPP.condCoded == cond)));
        stdDevTurnedAngles(vpNr, cond) = nanstd( concPP.degreesTurned(concPP.vp == vpNr & concPP.condCoded == cond) - concPP.turningAnglePerfect(concPP.vp == vpNr & concPP.condCoded == cond));
    end
    title(['Deviations actual turned angle, Condition ', int2str(cond)])
end
meanDevTurnedAngleProprio = nanmean( abs(concPP.degreesTurned(concPP.condCoded == 2) - concPP.turningAnglePerfect(concPP.condCoded == 2)));
meanDevTurnedAngleVestib = nanmean( abs(concPP.degreesTurned(concPP.condCoded == 3) - concPP.turningAnglePerfect(concPP.condCoded == 3)));
meanDevTurnedAngleActive = nanmean( abs(concPP.degreesTurned(concPP.condCoded == 4) - concPP.turningAnglePerfect(concPP.condCoded == 4)));
stdDevTurnedAngleProprio = nanstd( abs(concPP.degreesTurned(concPP.condCoded == 2) - concPP.turningAnglePerfect(concPP.condCoded == 2)));
stdDevTurnedAngleVestib = nanstd( abs(concPP.degreesTurned(concPP.condCoded == 3) - concPP.turningAnglePerfect(concPP.condCoded == 3)));
stdDevTurnedAngleActive = nanstd( abs(concPP.degreesTurned(concPP.condCoded == 4) - concPP.turningAnglePerfect(concPP.condCoded == 4)));


%% Compute length of first piece
% firstArmLengths = sqrt(concPP.StartPosX.^2 + concPP.StartPosZ.^2); %including passive
firstArmLengths = sqrt(concPP.StartPosX(concPP.condCoded ~=1 ).^2 + concPP.StartPosZ(concPP.condCoded ~=1).^2); %without passive
minFirstArmLengths = min(firstArmLengths(~isnan(firstArmLengths)))
maxFirstArmLengths = max(firstArmLengths(~isnan(firstArmLengths)))
meanFirstArmLengths = nanmean(firstArmLengths)
stdFirstArmLengths = nanstd(firstArmLengths)

%% Calculate differences of varying endpoints
%% Conclusion: If we add a distance of 1 meter to the endpoint (e.g. for
%% the arrow position) subject's perform worse
errors2 = concPP.errors_T_VarPos2;  %added the 1 or 2 steps
errors3 = concPP.errors_T_VarPos3;  %added the 1.2 meters of the arrow distance
errors4 = concPP.errors_T_VarPos4;  %added the 1 or 2 steps AND the 1.2 meters of the arrow distance
differenceTo2 = errors - errors2;
differenceTo3 = errors - errors3;
differenceTo4 = errors - errors4;

for vpNr=1:5
    figure;
    bar(concPP.degreesTurned(concPP.vp == vpNr & concPP.condCoded == 2) - concPP.turningAnglePerfect(concPP.vp == vpNr & concPP.condCoded == 2))
    subplot(2, 2, 1); bar(errors(concPP.vp == vpNr));
    subplot(2, 2, 2); bar(errors2(concPP.vp == vpNr));
    subplot(2, 2, 3); bar(errors3(concPP.vp == vpNr));
    subplot(2, 2, 4); bar(errors4(concPP.vp == vpNr));
    title(['VP ', int2str(vpNr)])
end

% undershoot1 = numel(find(errors<0))
% overshoot1 = numel(find(errors>0))
% undershoot2 = numel(find(errors2<0))
% overshoot2 = numel(find(errors2>0))
% undershoot3 = numel(find(errors3<0))
% overshoot3 = numel(find(errors3>0))
% undershoot4 = numel(find(errors4<0))
% overshoot4 = numel(find(errors4>0))


%% Quick and dirty hist plot
figure
for cond = 1:4
    subplot(2, 2, cond) 
    hist((errors(concPP.condCoded  == cond)), -180:180)  % positive errors for overshoot (= inside the triangle) and neg. errors for undershoot (= outside the triangle)
%     hist(abs(errors(concPP.condCoded == cond)), -100:100)
   set(get(gca,'child'),'FaceColor','k','EdgeColor','r');
    if cond == 1
        title('Passive')
    elseif cond == 2
        title('Proprioceptive')
    elseif cond == 3
        title('Vestibular')
    elseif cond == 4
        title('Active')
    end
    axis([-180 180 0 30])    
%     axis([-10 100 0 60])  % axis for absolute errors
end



%% Plot MEAN errors for each subject in a subplot color coded by condition
figure;
meansErr = [];
color = 'gbrk';
for vpNumbers = 1:5
    subplot(2, 3, vpNumbers);
    hold on
    for cond = 1:4     
        meansErr(vpNumbers, cond) = nanmean(abs(errors(concPP.vp == vpNumbers & concPP.condCoded == cond)));  
        plot(cond, meansErr(vpNumbers, cond),'x','Color', color(cond), 'MarkerSize', 10);
        title(['Means VP ', int2str(vpNumbers)])
    end
    hold off
    axis([0, 5, 0, 50])  % absolute
%     axis([-100, 100, -55, 55]) % not absolute
end
legend('Passive','Proprio', 'Vestib', 'Active');


%% Plot MEAN SD for each subject in a subplot color coded by condition
figure;
meansErr = [];
color = 'gbrk';
for vpNumbers = 1:5
    subplot(2, 3, vpNumbers);
    hold on
    for cond = 1:4     
        sdErr(vpNumbers, cond) = nanstd((errors(concPP.vp == vpNumbers & concPP.condCoded == cond)));  
        plot(cond, sdErr(vpNumbers, cond),'x','Color', color(cond), 'MarkerSize', 10);
        title(['STD VP ', int2str(vpNumbers)])
    end
    hold off
    axis([0, 5, 0, 50])  % absolute
%     axis([-100, 100, -55, 55]) % not absolute
end
legend('Passive','Proprio', 'Vestib', 'Active');


%% Plot MEAN errors for each subject in a subplot divided into different turning
%% angles and color coded by condition
figure;
meansTD = [];
color = 'gbrk';
for vpNumbers = 1:5
    subplot(2, 3, vpNumbers);
    hold on
    for cond = 1:4
        for td = [-90 -60 -30 30 60 90; 1 2 3 4 5 6]
                meansTD(td(2), vpNumbers, cond) = nanmean(abs(errors(concPP.turningAnglePerfect == td(1) & concPP.vp == vpNumbers & concPP.condCoded == cond)));
        end    
        plot([-90 -60 -30 30 60 90],meansTD(:, vpNumbers, cond),'x','Color', color(cond), 'MarkerSize', 10);
        title(['Means VP ', int2str(vpNumbers)])
    end   
    hold off
    axis([-100, 100, 0, 50])  % absolute
%     axis([-100, 100, -55, 55]) % not absolute
end
legend('Passive','Proprio', 'Vestib', 'Active');


%% Plot MEDIAN errors for each subject in a subplot divided into different turning
%% angles and color coded by condition
figure;
medianTD = [];
color = 'gbrk';
for vpNumbers = 1:5
    subplot(2, 3, vpNumbers);
    hold on
    for cond = 1:4
        for td = [-90 -60 -30 30 60 90; 1 2 3 4 5 6]
                medianTD(td(2), vpNumbers, cond) = nanmedian(abs(errors(concPP.turningAnglePerfect == td(1) & concPP.vp == vpNumbers & concPP.condCoded == cond)));
        end    
        plot([-90 -60 -30 30 60 90],medianTD(:, vpNumbers, cond),'x','Color', color(cond), 'MarkerSize', 10);
        title(['Median VP ', int2str(vpNumbers)])
    end   
    hold off
    axis([-100, 100, 0, 50])
end
legend('Passive','Proprio', 'Vestib', 'Active');


%% Plot STD errors for each subject in a subplot divided into different turning
%% angles and color coded by condition
figure;
stdTD = [];
color = 'gbrk';
for vpNumbers = 1:5
    subplot(2, 3, vpNumbers);
    hold on
    for cond = 1:4
        for td = [-90 -60 -30 30 60 90; 1 2 3 4 5 6]
                stdTD(td(2), vpNumbers, cond) = nanstd((errors(concPP.turningAnglePerfect == td(1) & concPP.vp == vpNumbers & concPP.condCoded == cond)));
        end    
        plot([-90 -60 -30 30 60 90],stdTD(:, vpNumbers, cond),'x','Color', color(cond), 'MarkerSize', 10);
        title(['STD VP ', int2str(vpNumbers)])
    end   
    hold off
    axis([-100, 100, 0, 50])
end
legend('Passive','Proprio', 'Vestib', 'Active');


%% Plot errors over time for learning effect
figure;
for vpNumbers = 1:5  
    for cond = 1:4    
        subplot(5, 4, cond + ((vpNumbers - 1) * 4))
        bar((errors(concPP.vp == vpNumbers & concPP.condCoded == cond)));
        title(['VP ', int2str(vpNumbers), ' - Cond: ', int2str(cond)]);
        axis([0, 130, -100, 100])
    end  
end

td = [-90 -60 -30 30 60 90; 1 2 3 4 5 6];         
undershoot=numel(find(errors(concPP.classifDegreesTurned == td(1,i) & concPP.vp == vpNumbers & concPP.condCoded == cond)<0));
overshoot=numel(find(errors(concPP.classifDegreesTurned == td(1,i) & concPP.vp == vpNumbers & concPP.condCoded == cond)>0));


%% Plot mean errors for each condition for the different subjects and
%% angles
figure;
meansTD = [];
color = 'gbrkm';

for cond=1:4
    subplot(2, 2, cond);
    hold on
    for vpNumbers = 1:5
        for td = [-90 -60 -30 30 60 90; 1 2 3 4 5 6]
            meansTD(td(2), vpNumbers, cond) = nanmean(abs(errors(concPP.turningAnglePerfect == td(1) & concPP.vp == vpNumbers & concPP.condCoded == cond)));
        end
        plot([-90 -60 -30 30 60 90],meansTD(:, vpNumbers, cond),'-x','Color', color(vpNumbers), 'MarkerSize', 10);
        title(['Means Condition ', int2str(cond)])
    end
    hold off
    axis([-100, 100, 0, 50]) 
end
legend('VP1','VP2', 'VP3', 'VP4','VP5');


%% Plot mean errors for each condition for the different subjects and
%% angles
figure;
meansTD = [];
color = 'gbrkm';

for cond=1:4
    subplot(2, 2, cond);
    hold on
    for vpNumbers = 1:5
        for td = [-90 -60 -30 30 60 90; 1 2 3 4 5 6]
            meansTD(td(2), vpNumbers, cond) = nanmean(abs(errors(concPP.turningAnglePerfect == td(1) & concPP.vp == vpNumbers & concPP.condCoded == cond)));
        end
        plot([-90 -60 -30 30 60 90],meansTD(:, vpNumbers, cond),'-x','Color', color(vpNumbers), 'MarkerSize', 10);
        title(['Means Condition ', int2str(cond)])
    end
    hold off
    axis([-100, 100, 0, 50]) 
end
legend('VP1','VP2', 'VP3', 'VP4','VP5');



%% Plot mean relative errors for different angles and the different subjects
figure;
errors = concPP.winsErrorT;
meansTD = [];
stdTD = [];
color = 'gbrkm';
hold on
for vpNumbers = 1:5
    for td = [-90 -60 -30 30 60 90; 1 2 3 4 5 6]
        meansTD(vpNumbers) = nanmean(errors);
        stdTD(vpNumbers) = nanstd(errors(concPP.vp == vpNumbers));
%         meansTD(td(2), vpNumbers) = nanmean((errors(concPP.turningAnglePerfect == td(1) & concPP.vp == vpNumbers)));
%         stdTD(td(2), vpNumbers) = nanstd((errors(concPP.turningAnglePerfect == td(1) & concPP.vp == vpNumbers)));
    end
    x= [-90 -60 -30 30 60 90]+2.5.*vpNumbers;
    plot(x,meansTD(:, vpNumbers)','x','Color', color(vpNumbers), 'MarkerSize', 10);
    title(['Means Condition ', int2str(cond)])
end
hold off
% axis([-100, 110, -10, 60])
% set(gca,'XTick',[-90:30:90]) 
legend('VP1','VP2', 'VP3', 'VP4','VP5');


%% relative mean errors not seperated for anything
meansTD = [];
color = 'gbrk';
figure;
for cond=1:4  
    absmeansTD(cond) = nanmean(abs(errors(concPP.condCoded == cond)));
    hold on;
    plot(cond,absmeansTD(cond),'x','Color', color(cond), 'MarkerSize', 10, 'LineWidth', 2);
    
end

title('Absolute Means over conditions');
axis([0.5, 4.55, 11.5, 15]);
set(gca,'XTick',[0:1:5])
set(gca,'yTick',[12:1:15])
legend('Passive','Proprioceptive', 'Vestibular', 'Active');

%% relative mean errors with errorbars
errors = concPP.winsErrorT;

 x= [1 2 3 4];
 clear meansTD;
 clear stdTD;
figure;

  
for cond=1:4   
   meansTD(cond) = nanmean(errors(concPP.condCoded == cond));
   stdTD(cond) = nanstd(errors(concPP.condCoded == cond));
   hold on;    
   errorbar(x(cond),meansTD(cond),stdTD(cond),'x','Color', color(cond), 'MarkerSize', 15, 'LineWidth', 1.5);
%     title(['Means Condition ', int2str(cond)])
 
end

title('Means over Conditions (with errorbars)');
axis([0.5, 4.55, -30, 30]);
set(gca,'XTick',[0:1:5])
set(gca,'yTick',[-30:5:30])
legend('Passive','Proprioceptive', 'Vestibular', 'Active');




%% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %%
%% Bootstrapping Test
%% (ToDo: Check if violation of independence assumption is very bad
%% (Maybe using "Cluster data (cluster each session -> only 40 sessions) or moving time series"
numberOfBSSamples = 8000;
sampleSize = 600;  % or 600 or 120? or even 2400?
randomValues = randi(numel(errors), numberOfBSSamples, sampleSize);  % draw random values from ALL errors (irrespective of condition)
BS_Samples_Abs = abs(concPP.winsErrorT(randomValues));  % draw the Bootstrap samples
BS_Samples = (concPP.winsErrorT(randomValues));  % draw the Bootstrap samples


meanAbsBS = nanmean(BS_Samples_Abs, 2);
varAbsBS = nanvar(BS_Samples_Abs, 1, 2);
varBS = nanvar(BS_Samples, 1, 2);

critValMeanAbs = prctile(meanAbsBS,[5 95]);
critValVarAbs = prctile(varAbsBS,[5 95]);
critValVar = prctile(varBS,[5 95]);

for cond = 1:4
    meansAbsConditions(cond) = nanmean(abs(concPP.winsErrorT(concPP.condCoded == cond)));
    varAbsConditions(cond) = nanvar(abs(concPP.winsErrorT(concPP.condCoded == cond)));    
    varConditions(cond) = nanvar(concPP.winsErrorT(concPP.condCoded == cond));    
end

figure;
hold on
hist(meanAbsBS, 50)
line([critValMeanAbs(1), critValMeanAbs(1)],  [0,100], 'Color', 'r')
line([critValMeanAbs(2), critValMeanAbs(2)],  [0,100], 'Color', 'r')
insignificantValues = meansAbsConditions(meansAbsConditions > critValMeanAbs(1) & meansAbsConditions < critValMeanAbs(2));
significantValues = meansAbsConditions(meansAbsConditions < critValMeanAbs(1) | meansAbsConditions > critValMeanAbs(2));
plot (insignificantValues, 70 * ones(1,numel(insignificantValues)), 'x', 'Color', 'g')
plot (significantValues, 60 * ones(1,numel(significantValues)), '*', 'Color', 'r')
title('Bootstrap samples distribution of the abs. mean')
xlabel('                        active   -   vestibular     -     passive           -           proprioceptive')
hold off

figure;
hold on
hist(varAbsBS)
line([critValVarAbs(1), critValVarAbs(1)],  [0,100], 'Color', 'r')
line([critValVarAbs(2), critValVarAbs(2)],  [0,100], 'Color', 'r')
insignificantValues = varAbsConditions(varAbsConditions > critValVarAbs(1) & varAbsConditions < critValVarAbs(2));
significantValues = varAbsConditions(varAbsConditions < critValVarAbs(1) | varAbsConditions > critValVarAbs(2));
plot (insignificantValues, 70 * ones(1,numel(insignificantValues)), 'x', 'Color', 'g')
plot (significantValues, 60 * ones(1,numel(significantValues)), '*', 'Color', 'k')
title('Bootstrap samples distribution of the abs. variance')
xlabel('                        active   -   vestibular     -     passive           -           proprioceptive')
hold off

figure;
hist(varBS)
title('Bootstrap samples distribution of the variance')






%% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %%
%% Significance Testing, not sure if this is valid, guess not
figure
hold on

for cond = 1:4
    capable = @(x)nanmean(abs(x));  % Process capability
    bootci(2000, capable, errors(concPP.condCoded == cond))            % BCa confidence interval    
%         ci(:, vpNumbers, cond) = bootci(2000, capable, errors(select & concPP.condCoded == cond));            % BCa confidence interval
%         means(vpNumbers, cond) = nanmean(abs(errors(select & concPP.condCoded == cond)));
%         errorbar(cond+(vpNumbers/10), nanmean(abs(errors(select &
%         concPP.condCoded==cond))), ci(1, vpNumbers, cond), ci(2, vpNumbers, cond), 'Color', color(vpNumbers));
%     mean(bootstrp(2000, capable, concPP.errors_T(concPP.condCoded==i)))            % BCa confidence interval
end

for vpNumbers =1:5
    select = concPP.vp ==vpNumbers;
%     % Test of normal distribution
%     for cond = 1:4
%        [h,p]  = lillietest(concPP.errors_T(select & concPP.condCoded==cond))
%     end
    %% Bootstrapped Confidence Interval
    % You have to generate bootstrap samples and compute the statistic of interest for each bootstrap sample. 
    % The 2.5th and 97.5th percentiles of the bootstrap samples form a good approximation of the 95% confidence interval.
    ci = [];
    color = 'rgbkc';

    % ci = zeros(4,3);
    bootstrappedCI = []
    for cond = 1:4
        capable = @(x)nanmean(abs(x));  % Process capability
        bootstrappedCI(:, cond) = bootci(2000, capable, errors(concPP.condCoded == cond));            % BCa confidence interval
%         ci(:, vpNumbers, cond) = bootci(2000, capable, errors(select & concPP.condCoded == cond));            % BCa confidence interval
%         means(vpNumbers, cond) = nanmean(abs(errors(select & concPP.condCoded == cond)));
%         errorbar(cond+(vpNumbers/10), nanmean(abs(errors(select &
%         concPP.condCoded==cond))), ci(1, vpNumbers, cond), ci(2, vpNumbers, cond), 'Color', color(vpNumbers));
    %     mean(bootstrp(2000, capable, concPP.errors_T(concPP.condCoded==i)))            % BCa confidence interval
    end  
%     plot(1,nanmean(abs(errors(select & concPP.condCoded==1))),'x','Color', color(vpNumbers), 'MarkerSize', 10)
%     plot(2,nanmean(abs(errors(select & concPP.condCoded==2))),'x','Color', color(vpNumbers), 'MarkerSize', 10)
%     plot(3,nanmean(abs(errors(select & concPP.condCoded==3))),'x','Color', color(vpNumbers), 'MarkerSize', 10)
%     plot(4,nanmean(abs(errors(select & concPP.condCoded==4))),'x','Color', color(vpNumbers), 'MarkerSize', 10)
%     axis([0 5 0 60])    
end
title('Means with BS Confidence Bars. Different colors are different subjects. ')
xlabel('Conditions')
ylabel('Mean Errors')
hold off


%% Check ANOVA for single subjects
for vpNumbers = 1:5
    for cond = 1:4
        errorsVP(:,vpNumbers, cond) = errors(concPP.vp == vpNumbers & concPP.condCoded == cond)';
    end

    [p,table,stats] = anova1(errorsVP(:,vpNumbers,:))
end

%% Check ANOVA for data pooled over subjects
for cond = 1:4
        errorsCond(:, cond) = errors(concPP.condCoded == cond)';
end
[p,table,stats] = anova1(errorsCond)


%% Paired t-tests
% [h_PassProp, p_PassProp] = ttest(errorsCond(:, 1), errorsCond(:, 2))
% [h_PassVest, p_PassVest] = ttest(errorsCond(:, 1), errorsCond(:, 3))
% [h_PassAct, p_PassAct] = ttest(errorsCond(:, 1), errorsCond(:, 4))
% [h_PropVest, p_PropVest] = ttest(errorsCond(:, 2), errorsCond(:, 3))
% [h_PropAct, p_PropAct] = ttest(errorsCond(:, 2), errorsCond(:, 4))
% [h_VestAct, p_VestAct] = ttest(errorsCond(:, 3), errorsCond(:, 4))

% %% Two-sample t-tests
% [h_PassProp, p_PassProp] = ttest2(errorsCond(:, 1), errorsCond(:, 2))
% [h_PassVest, p_PassVest] = ttest2(errorsCond(:, 1), errorsCond(:, 3))
% [h_PassAct, p_PassAct] = ttest2(errorsCond(:, 1), errorsCond(:, 4))
% [h_PropVest, p_PropVest] = ttest2(errorsCond(:, 2), errorsCond(:, 3))
% [h_PropAct, p_PropAct] = ttest2(errorsCond(:, 2), errorsCond(:, 4))
% [h_VestAct, p_VestAct] = ttest2(errorsCond(:, 3), errorsCond(:, 4))


