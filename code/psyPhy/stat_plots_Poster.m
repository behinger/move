%% Absolute errors with errorbars
errors = abs(concPP.winsErrorT);
color = 'cbrkcy';

meansTD = [];
stdTD = [];


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











figure;
hold on
for cond=1:4   
    for td = [-90 -60 -30 30 60 90; 1 2 3 4 5 6]
        meansTD(td(2), cond) = nanmean(errors(concPP.turningAnglePerfect == td(1) & concPP.condCoded == cond));
        stdTD(td(2), cond) = nanstd(errors(concPP.turningAnglePerfect == td(1) & concPP.condCoded == cond));
    end
    x= [-90 -60 -30 30 60 90] + 2.5 .* cond;
    errorbar(x,meansTD(:, cond),stdTD(:, cond),'-x','Color', color(cond), 'LineWidth', 2, 'MarkerSize', 10);
    title('Mean of absolute pointing errors (split up in turning angles and conditions)');
    axis([-100, 110, -10, 45]);
    set(gca,'XTick',[-90:30:90]);  
    xlabel('Turning angles in °');
    ylabel('Mean of pointing errors in °');
end
legend('Passive','Proprioceptive', 'Vestibular', 'Active');
%% Text:
% Means of absolute pointing errors are plotted between the six different
% turning angles (x-Axis) and four conditions (different colors). Errorbars
% represent the standard devation.
hold off



%% Relative errors seperated by conditions and subjects

errors = concPP.winsErrorT;
color = 'mbrgk';


x= [1 2 3 4];
meansTD = [];
stdTD = [];
figure;
hold on
for cond=1:4   
   for vp = 1:5
      meansTD(cond) = nanmean(errors(concPP.condCoded == cond & concPP.vp == vp));
      stdTD(cond) = nanstd(errors(concPP.condCoded == cond & concPP.vp == vp));
      errorbar((x(cond)+ 0.05 .* vp), meansTD(cond), stdTD(cond),'x','Color', color(vp), 'MarkerSize', 15, 'LineWidth', 2);

%        errorbar((x(cond)+ 0.05 .* vp), meansTD(cond), stdTD(cond),'x','Color', color(vp), 'MarkerSize', 15, 'LineWidth', 2);
   end
end
legend('VP 1','VP 2', 'VP 3', 'VP 4', 'VP 5');
hold off
title('Means of positive/negative errors over conditions (divided by subjects)');
xlabel('Condition (1 = Passive | 2 = Proprioceptive | 3 = Vestibular | 4 = Active)')
ylabel('Mean of positive/negative errors in °')
hline(0)
set(gca,'XTick',[0:1:5])
axis([0.2, 5, -60, 40]);
 


%% Relative mean errors seperated by conditions (was not in the poster)
meansTD = []
figure;
olor = 'gbrk';
errors = concPP.winsErrorT;
for cond=1:4  
    meansTD(cond) = nanmean(errors(concPP.condCoded == cond));
    stdTD(cond) = nanstd(errors(concPP.condCoded == cond));
    hold on;
    errorbar(cond, meansTD(cond), stdTD(cond), 'x','Color', color(cond), 'MarkerSize', 10, 'LineWidth', 2);
    
end

title('Relative means over conditions');
xlabel('Condition (Passive - Proprioceptive - Vestibular - Active)')
ylabel('Mean of relative (positive and negative) errors in °')
set(gca,'XTick',[0:1:5])
