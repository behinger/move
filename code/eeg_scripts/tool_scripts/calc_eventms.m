function [eventms] = calc_eventms(EEG,twEvents)

if nargin < 2
    twEvents = [22 27 4 5];
end
for i = 1:EEG.trials;
    eventIndex = [];
    for j = 1:length(twEvents)
        eventIndex = [eventIndex find(strcmp([deblank(EEG.epoch(i).eventtype)],num2str(twEvents(j))),1,'first' )];
    end
    if length(eventIndex) ~= length(twEvents)
        fprintf('current eventIndex:')
        fprintf('%i,',eventIndex)
        
        error('Not all timewarping events are in every epoch (e.g. %i), make longer epochs,',i)
    end
    eventms(i,:)=[EEG.epoch(i).eventlatency{eventIndex}];
    
end;
EEG.preprocessInfo.twEvents = twEvents;
EEG.preprocessInfo.eventms = eventms;

