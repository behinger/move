function [badTrials,trialInvalid,event] = mv_eeg_eventConsistency(EEG)
tmp = {EEG.event.type};
tmp2 = cellfun(@(x)str2num(deblank(x)),tmp,'UniformOutput',0);
event = cell2mat(tmp2);

% trialBeginIdx = find(event>150 & event <211);
% trStartIdx(end+1) = length(event);
% endTurnIdx = find(event==5);
event_order = [149,1,20:29,4,5,100:109,8,9];

% nrTrials = sum(event==149); %how many trials in event structure?
% 
% if nrTrials < 2
    
    nrTrials = sum(ismember(event,[151:210])); %how many trials in event structure?
    trialBeginIdx = find(ismember(event,[151:210]),nrTrials,'first');
    trialEndIdx = [find(ismember(event,[151:210]),nrTrials,'first')-1,length(event)]; %  end of trial is beginning of next trial + 1, except last trial, there it is the last entry
    trialEndIdx(1) = [];
    skip_149 = 1;

% else
% trialBeginIdx = find(event==149,nrTrials,'first');
% trialEndIdx = [find(event==149,nrTrials,'first')-1,length(event)]; %  end of trial is beginning of next trial + 1, except last trial, there it is the last entry
% trialEndIdx(1) = [];
% skip_149 = 0;
% end
%%

for cT = 1:nrTrials
    trialInvalid(cT) = true;
    % get events in trial:
    currEv = event(trialBeginIdx(cT):trialEndIdx(cT)); % events in current trial
    currEv(find(currEv==5)+1:end) = []; % delete everything that is from merged Files, e.g. if there is a new trialstart we could have [...8 9 250 1] then this would trigger the eventinconsistency of event 1

    % first of all, check that all triggers are included, then check the
    % trigger order
    if ~isempty(setdiff(currEv,[-1 0 250 150,211:214,251,252,event_order event(trialBeginIdx(cT)+1)]))
%         warning('badTrial:eventInconsistend','Different events in segment  %i',cT)
%         continue;
        
    end
%     if ~isempty(setdiff([event_order event(trialBeginIdx(cT))],currEv))
%         warning('badTrial:eventInconsistend','Not all events in segment  %i',cT)
%                 dbstop tic, tic, dbclear tic;

%         continue;

%     end
%     
%     if currE
%     
    %check trial number
    if currEv(1) ~= 149 && ~skip_149
        warning('badTrial:eventInconsistend','you should never have a trial event IDX start which is not 149')
             fprintf('%i,',currEv);
        fprintf('\n');
        continue
    else
        currEv(1) = [];
    end
%     if currEv(1) ~= 150+rawDat.trialNumber(trialBeginIdx(cT));
%         warning('badTrial:eventInconsistend','In segment %i, there seems to be the segment event wrong',cT)
%         continue
%     else
    currEv(1) = []; % Trial number
%     end
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
%                         dbstop tic, tic, dbclear tic;
     fprintf('%i,',currEv);
        fprintf('\n');
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
        currEv(1) = [];    
    
    elseif currEv(1) == 20 
    else
        warning('badTrial:eventInconsistend','event 2 is not coming after event 1')   ,   
%                         dbstop tic, tic, dbclear tic;
      fprintf('%i,',currEv)
        fprintf('\n')
                        continue,
    end
    if ~isempty(find(currEv==2,1))
        warning('badTrial:eventInconsistend','Too many /wrong event: 2 found in Segment %i',cT)
        continue;
    end
    while currEv(1) ~= 5 %we can do that, because we checked beforehand that 4 is a real event
        if ismember(currEv(1),[20:29,3,4])
            currEv(1) = [];
        else
            warning('badTrial:eventInconsistend','Too many /wrong event: 3,20:29,4 found in Segment %i',cT)
            break;
        end
    end
%     if any(~ismember(currEv(1:2),[4,29]))
%          
%         warning('badTrial:eventInconsistend','Trigger 29/4 did not come after each other %i :',cT)
%         fprintf('%i,',currEv)
%         fprintf('\n')
%         
%         continue;
%     else
%         currEv(1:2) = [];
%     end
        
    if any(currEv(1) ~= [5]) % this is the turn, + beginning of straight movement
        
        warning('badTrial:eventInconsistend','The next Event should have been 5 Segment %i :',cT)
        fprintf('%i,',currEv)
        fprintf('\n')
        
        continue;
    else
        currEv(1) = [];
    end
    
%     
%     while currEv(1) ~= 9 %we can do that, because we checked beforehand that 8 is a real event
%         if ismember(currEv(1),[6,100:109,7,8])
%             currEv(1) = [];
%         else
%             warning('badTrial:eventInconsistend','Too many /wrong event: 7,100:109 found in Segment %i',cT)
%              fprintf('%i,',currEv)
%              fprintf('\n')
%              break;
%         end
%     end
%     
%     if any(currEv(1) ~= [9]) % this is the turn, + beginning of straight movement
%         warning('badTrial:eventInconsistend','Too many /wrong event: 9 found in Segment %i',cT)
%               fprintf('%i,',currEv)
%         fprintf('\n')
% %         continue;
%     else
%         currEv(1) = [];
%     end
%     if ~isempty(currEv)
%         fprintf('additional events in segment %i are: %i \n',[repmat(cT,size(currEv)),currEv]')
% 
% %         continue;
%     end
    trialInvalid(cT) = false;
    
end
badTrials =  event(event>150 & event <211)- 150;


%%

% if plot
%     figure
%     behav_plotEvents(rawDat,149), hold on,
%     if any(trialInvalid)
%         line([rawDat.time(trialBeginIdx(trialInvalid))-rawDat.time(1),   rawDat.time(trialEndIdx(trialInvalid))-rawDat.time(1)]', ... % x times
%             [-10 -10],'LineWidth',10) % y coordinates
%     end
% end
% rawDat_cut = cutResultStruct(rawDat,[1; trialBeginIdx(trialInvalid)],[trialBeginIdx(1); trialEndIdx(trialInvalid)]); % also cuts of the first part until first trial
% badTrials = find(trialInvalid);


% end
% function [rawDat] = cutResultStruct(rawDat,idxBeg,idxEnd)
% % this function cuts everything between the pairs idxBeg and idxEnd in the
% % struct rawDat
% fn = fieldnames(rawDat);
% for tr = length(idxBeg):-1:1 % cut each trial, start with the last to not mess up the idx
%     for m = 1:length(fn)
%         rawDat.(fn{m})(idxBeg(tr):idxEnd(tr)) = [];
%     end
% end
% 
% 
% 
% end