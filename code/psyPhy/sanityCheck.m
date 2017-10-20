%% How many combinations of angle and conditions actually have 20 trials?

clear u;
td = [-90 -60 -30 30 60 90; 1 2 3 4 5 6];
i=0;

for vpNumbers = 1:5; % for every participant
    for cond = 1:4; % for every condition
        for angle=1:6; % for every angle
            i=i+1;
%             if cond<3
%                 numOfTrials(i)=numel(find(concPP.turningAnglePlanned==td(1,angle) & concPP.vp==vpNumbers & concPP.condCoded==cond)); % count all trials that belong to VP,cond&angle
%             else
                numOfTrials(i)=numel(find(concPP.turningAnglePerfect==td(1,angle) & concPP.vp==vpNumbers & concPP.condCoded==cond));
%             end
        end;
    end;
end;

u(1,:)=unique(numOfTrials); % how many different numbers of trials do we have?

for k=1:length(u);
    p=u(1,k);
    u(2,k)=numel(find(numOfTrials==p)); % how often do these amounts of trials occur?
    
end

u
figure;
plot(u(1,:),u(2,:))
axis([11, 23, 0, 60])

%% How many trials are left?
% either

numel(find(~isnan(concPP.errors_T)))

% or
for i=1:length(u)
    x(i)=u(1,i)*u(2,i);
end
sum(x)

% 2270 trials are left without taking commentsheet into account (sum(x)==numel)
% 2160 trials are left when taking comment sheets into account

%% Do turningAnglePlanned and turningAnglePerfect have the same value?
for i=1:2400;
    samesame(i)= concPP.turningAnglePlanned(i)==(concPP.turningAnglePerfect(i));
end

s=numel(find(samesame==1));


%% Trial durations

td = [-90 -60 -30 30 60 90; 1 2 3 4 5 6];
i=0;
color = 'gbrk'
for cond=1:4;
    
    for angle=1:6
        i=i+1;
        duration(cond,angle)=nanmean(concPP.trialDuration(concPP.turningAnglePerfect==td(1,angle)&concPP.condCoded==cond));
    end
    %     plot(duration(cond,:),'x','Color', color(cond));
    %     hold on
    %     axis([0, 7, 0, 50])
end

