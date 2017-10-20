%% Correlations

color = 'gbrkm';

figure;
for i=1:5
    plot(errors(concPP.vp==i),'x','Color',color(i))
    hold on;
end

figure;
for i=1:5
    plot(abs(errors(concPP.vp==i)),'x','Color',color(i))
    hold on;
end

for i=1:5
    figure
    bar((errors(concPP.vp==i)))
end


%% Correlation overshoot/undershoot over time

%pooled over subjects
[r,p]=corrcoef(errors,(1:2400),'rows','complete')
% r=.0601
% p=0.0052 -> significant effect of time, subjects tend to go from under to
% overshooting or make smaller undershooting errors

% for single subjects
for i=1:5  %pooled over subjects
    [r,p]=corrcoef(errors(concPP.vp==i),(1:480),'rows','complete')
end

%% Correlation absolute errors over time

%pooled over subjects
[r,p]=corrcoef(abs(errors),(1:2400),'rows','complete')
% r=-0.0572
% p=0.0079 -> significant effect over time, subjects get better over time

% for single subjects
for i=1:5 
    [r,p]=corrcoef(abs(errors(concPP.vp==i)),(1:480),'rows','complete')
end

%%

rp(i,:)

