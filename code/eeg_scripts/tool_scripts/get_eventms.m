function eventms = get_eventms(EEG,twEvents)

for i = 1:EEG.trials;
    eventIndex = [];
    for j = 1:length(twEvents)
        eventIndex = [eventIndex find(strcmp([EEG.epoch(i).eventtype], num2str(twEvents(j))))];
    end
    if length(eventIndex) ~= length(twEvents)
        error('Not all timewarping events are in every epoch (e.g. %i), make longer epochs',i)
    end
    eventms(i,:)=[EEG.epoch(i).eventlatency{eventIndex}];
end;
