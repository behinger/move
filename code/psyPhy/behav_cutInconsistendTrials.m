function [rawDat_cut badTrials] = behav_cutInconsistendTrials(rawDat,varargin)
%% CutInconsistendTrials(rawDat[,plot][,warningOn])
% This functions has a good look at the eventstructure of rawDat.event
% it checks
% a) if there are any trigger that are not standard (should not happen)
% b) if the sequence of triggers is a realistic one, e.g. right order
%
% it can plot the event and mark (with line) the as inconsistend tagged
% trials, usage:
%
% [rawDat_cut] = behav_cutInconsistendTrials(rawDat)
% [rawDat_cut] = behav_cutInconsistendTrials(rawDat,1) % with the plot
% option on
% [rawDat_cut] = behav_cutInconsistendTrials(rawDat,1,0) % with warnings off

if nargin < 1
    plot = 0;
else
    plot=varargin{1};
end
if nargin < 2
    warning('on','badTrial:eventInconsistend');
else
    if varargin{2};
        warning('on','badTrial:eventInconsistend')
    else
        warning('off','badTrial:eventInconsistend')
    end
end
event_order = [149,1,2,20:28,3,4,5,6,100:109,7,8,9];
% multiple 1's possible
% unnesecary events: 250,251,252

event = rawDat.event;

%event(event==0) = []; % for debugging purposes
nrTrials = sum(event==149); %how many trials in event structure?
trialBeginIdx = find(event==149,nrTrials,'first');
trialEndIdx = [find(event==149,nrTrials,'first')-1;length(event)]; %  end of trial is beginning of next trial + 1, except last trial, there it is the last entry
trialEndIdx(1) = [];

if length(trialEndIdx) ~= length(trialBeginIdx)
    warning('badTrial:eventInconsistend','Something is terribly wrong with the amount of trialEnd/Begin Indexes')
end
% XXX lengtH8event maybe better used through end of experiemnt, trigger 251
% or 252

%%
for cT =1:nrTrials;%currentEvent
    trialInvalid(cT) = true;
    % get events in trial:
    currEv = event(trialBeginIdx(cT):trialEndIdx(cT)); % events in current trial
    currEv(currEv==0) = []; % delete all non-events
    currEv(currEv==-1) = []; % delete the -1 strange event
    currEv(find(currEv==250):end) = []; % delete everything that is from merged Files, e.g. if there is a new trialstart we could have [...8 9 250 1] then this would trigger the eventinconsistency of event 1
    
    % first of all, check that all triggers are included, then check the
    % trigger order
    if ~isempty(setdiff(currEv,[-1 0 250 29 150,211:214,251,252,event_order 150+rawDat.trialNumber(trialBeginIdx(cT))]))
        warning('badTrial:eventInconsistend','Different events in segment  %i',cT)
        continue;
        
    end
    if ~isempty(setdiff([event_order 150+rawDat.trialNumber(trialBeginIdx(cT))],currEv))
        warning('badTrial:eventInconsistend','Not all events in segment  %i',cT)
        continue;
        
    end
    
    %check trial number
    if currEv(1) ~= 149
        warning('badTrial:eventInconsistend','you should never have a trial event IDX start which is not 149')
        continue
    else
        currEv(1) = [];
    end
    if currEv(1) ~= 150+rawDat.trialNumber(trialBeginIdx(cT));
        warning('badTrial:eventInconsistend','In segment %i, there seems to be the segment event wrong',cT)
        continue
    else
        currEv(1) = [];
    end
    if ~ismember(currEv(1),[211:214]);
        %         warning('The Condition Event is missing',cT)
    end
    %         continue
    currEv(1) = [];
    
    while currEv(1) == 1
        currEv(1) = [];
    end
    if ~isempty(find(currEv==1,1)) % somebody pressed C after the trial started
        warning('badTrial:eventInconsistend','Too many /wrong event: 1 found in Segment %i',cT)
        continue;
    end
    % Check if every trigger is there only once
    if length(unique(currEv)) ~= length(currEv)
        warning('badTrial:eventInconsistend','Some events are detected more than once:');
        fprintf('%i,',currEv);
        fprintf('\n');
        continue;
    end
    
    if currEv(1) == 2
        currEv(1) = [];    else       warning('badTrial:eventInconsistend','event 2 is not coming after event 1')   ,     continue,
    end
    if ~isempty(find(currEv==2,1))
        warning('badTrial:eventInconsistend','Too many /wrong event: 2 found in Segment %i',cT)
        continue;
    end
    while currEv(1) ~= 4 && currEv(1)~= 29 %we can do that, because we checked beforehand that 4 is a real event
        if ismember(currEv(1),[20:28,3])
            currEv(1) = [];
        else
            warning('badTrial:eventInconsistend','Too many /wrong event: 3,20:29 found in Segment %i',cT)
            break;
        end
    end
    
    while currEv(1)~= 5 %we can do that, because we checked beforehand that 4 is a real event
        if ismember(currEv(1),[3,29,4])
            currEv(1) = [];
        else
            warning('badTrial:eventInconsistend','Too many /wrong event: 29,4 found in Segment %i',cT)
            break;
        end
    end
    
    if any(currEv(1) ~= [5]) % this is the turn, + beginning of straight movement
        warning('badTrial:eventInconsistend','Too many /wrong event:  5 found in Segment %i',cT)
        
        continue;
    else
        currEv(1) = [];
    end
    
    
    while currEv(1) ~= 9 %we can do that, because we checked beforehand that 8 is a real event
        if ismember(currEv(1),[6,100:109,7,8,29])
            currEv(1) = [];
        else
            warning('badTrial:eventInconsistend','Too many /wrong event: 7,100:109 found in Segment %i',cT)
            break;
        end
    end
    
    if any(currEv(1) ~= [9]) % this is the turn, + beginning of straight movement
        warning('badTrial:eventInconsistend','Too many /wrong event: 9 found in Segment %i',cT)
        continue;
    else
        currEv(1) = [];
    end
    if ~isempty(currEv)
        fprintf('additional events in segment %i are: %i \n',[repmat(cT,size(currEv)),currEv]')
        continue;
    end
    trialInvalid(cT) = false;
    
end

allTrialEvents = event(ismember(event,[151:210]))-150;
if length(unique(allTrialEvents(~trialInvalid))) ~= length(allTrialEvents(~trialInvalid))
    try
        doubleEvents = diff(allTrialEvents);
        if any(doubleEvents>1)
            error
        end
         trialInvalid(~logical(doubleEvents)) = 1;
    catch
       dbstop if tic
       , tic, 
       dbclear if tic;
    end
end



%%

% plot = true
if plot
    figure
    behav_plotEvents(rawDat,149), hold on,
    if any(trialInvalid)
        line([rawDat.time(trialBeginIdx(trialInvalid))-rawDat.time(1),   rawDat.time(trialEndIdx(trialInvalid))-rawDat.time(1)]', ... % x times
            [-10 -10],'LineWidth',10) % y coordinates
    end
end
rawDat_cut = cutResultStruct(rawDat,[1; trialBeginIdx(trialInvalid)],[trialBeginIdx(1); trialEndIdx(trialInvalid)]); % also cuts of the first part until first trial
badTrials = find(trialInvalid);


end
function [rawDat] = cutResultStruct(rawDat,idxBeg,idxEnd)
% this function cuts everything between the pairs idxBeg and idxEnd in the
% struct rawDat
fn = fieldnames(rawDat);
for tr = length(idxBeg):-1:1 % cut each trial, start with the last to not mess up the idx
    for m = 1:length(fn)
        rawDat.(fn{m})(idxBeg(tr):idxEnd(tr)) = [];
    end
end



end