comps = [1:20];

twEvents = [4 5];
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

%%
figure
tic
for i = [comps; 1:length(comps)]
subplot(floor(max(comps)/5),5,i(2)),

[ersp,itc,powbase,times,freqs,erspboot,itcboot,tfData,PA] =newtimef_par(EEG.icaact(i(1),:,:),EEG.pnts, [EEG.xmin*1000 EEG.xmax*1000], EEG.srate, 0, 'ntimesout', 200 ,  'timewarp', eventms ,'plotitc','off' , 'baseline',[0], 'trialbase', 'full' );
title(sprintf('comp %i',i(1)));
toc
end
%ALLEEG(2).icaact(9,:,:)}


%%
figure,imagesc(ersp)
figure,imagesc( 10*log10(mean(PA(:,:,:),3)))
%%

    std_erspplot(STUDY,ALLEEG,'clusters',1,'comps',15)
