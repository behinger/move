EEG2 = EEG;


%%
% for i = 1:EEG.trials
%     fprintf('Timewarping Trial %i \n',i)
% endPointLat =  eeg_lat2point( [ EEG.times(end)], [ 1 ],   EEG.srate, [EEG.xmin EEG.xmax]*1000, 1E-3);
% startPointLat =  eeg_lat2point( [ EEG.times(1)], [ 1 ],   EEG.srate, [EEG.xmin EEG.xmax]*1000, 1E-3);
% urLatency = [startPointLat startPointLat+5*EEG.srate startPointLat+15*EEG.srate endPointLat]; % reference is 1 to 15s with baseline 1 to 5s
% urLatency = round(urLatency);
%
%
%      evLatency = [startPointLat, ...
%          eeg_lat2point([EEG.epoch(i).eventlatency{1:2}],[1 1],   EEG.srate, [EEG.xmin EEG.xmax]*1000, 1E-3) ...
%          endPointLat] ;
%      evLatency = round(evLatency);
%     warpMat = timewarp(evLatency,urLatency);
%     EEG2.data_new(:,:,i) = warpMat * EEG.data(:,:,i)';
%
%
% end
EEG2 = eeg_checkset(EEG2)
eegplot(EEG2.data,'srate',EEG.srate,'winlength',5,'events',EEG2.event,'wincolor',[0.2 0.2 1],'command','rej=TMPREJ');

%%
for i = 1:EEG.trials
    eventms(i,:) = [EEG.epoch(i).eventlatency{1:2}]
    %eventms(i,:) = eeg_lat2point([EEG.epoch(i).eventlatency{1:2}],[1 1],   EEG.srate, [EEG.xmin EEG.xmax]*1000, 1E-3);
end
%%
figure
[ersp,itc,powbase,times,freqs,erspboot,itcboot,tfdata] = ...
    newtimef(EEG.icaact(13,:,:), EEG.pnts, [EEG.xmin*1000 EEG.xmax*1000], EEG.srate, [3 0.5],...
    'timewarp',eventms);  %'timewarpms',[0 12*1000] <-- this warps everthing to 0 to 12s instead of 0 to mean of events
%%

figure
for i = 1:40
    subplot(4,10,i),
    imagesc(times,freqs,abs(tfdata(:,:,i))),set(gca,'YDir','normal')
end