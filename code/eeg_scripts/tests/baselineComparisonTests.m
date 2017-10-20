eventms = get_eventms(EEG,[3 4]);

%% Timewarp %
comp = 13;
%figure
EEG = eeg_retrieve(ALLEEG,1);
[~,~,mbaseOrig,times,freqs,~,~,~,tfdata] =newtimef_par(EEG.icaact(comp,:,:),...
    EEG.pnts, [EEG.xmin*1000 EEG.xmax*1000], EEG.srate, 0,'plotitc','off' ,'baseline',[-4000 -2000],'trialbase', 'off' ,'freqs',[1 50],'timewarp',eventms);
% Baseline Before Each Trial
EEG = eeg_retrieve(ALLEEG,2);
[~,~,~,times2,freqs2,~,~,~,tfdata2] =newtimef_par(EEG.icaact(comp,:,:),...
    EEG.pnts, [EEG.xmin*1000 EEG.xmax*1000], EEG.srate, 0, 'ntimesout', 200 ,'plotitc','off' ,   'baseline',[-4000 -500],  'trialbase', 'off' ,'freqs',[1 50]);
% Baseline After
EEG = eeg_retrieve(ALLEEG,3);
[~,~,~,times3,freqs3,~,~,~,tfdata3] =newtimef_par(EEG.icaact(comp,:,:),...
    EEG.pnts, [EEG.xmin*1000 EEG.xmax*1000], EEG.srate, 0, 'ntimesout', 200 ,'plotitc','off' ,   'baseline',[-4000 -500], 'trialbase', 'off' ,'freqs',[1 50]);
%
% Baseline Before
EEG = eeg_retrieve(ALLEEG,4);
[~,~,~,times4,freqs4,~,~,~,tfdata4] =newtimef_par(EEG.icaact(comp,:,:),...
    EEG.pnts, [EEG.xmin*1000 EEG.xmax*1000], EEG.srate, 0, 'ntimesout', 200 ,'plotitc','off' ,   'baseline',[-4000 -500], 'trialbase', 'off' ,'freqs',[1 50]);

%% 
Pori = mean(tfdata,3);
bslKlaus = mean(Pori(:,times>-4000 & times < -1500),2);

turnPower = mean(Pori(:,times>500 & times < 3500),2);

timesBaseline = (times2 > -5500& times2<-500) | (times2 < 500 & times2 > 5500);
Pori2 = mean(tfdata2,3);
bsl = mean(Pori2(:,timesBaseline),2);


Pori3 = mean(tfdata3,3);
bslAfter = mean(Pori3(:,timesBaseline),2);

Pori4 = mean(tfdata4,3);
bslBefore = mean(Pori4(:,timesBaseline),2);



% logData =  10*log10(mean(abs(tfdata(:,:,:)),3));
% logData2 = 10*log10(mean(abs(tfdata2(:,:,:)),3));
% logData3 = 10*log10(mean(abs(tfdata3(:,:,:)),3));
% bsl = mean(logData2(:,(times2 > -5500& times2<-500) | (times2 < 500 & times2 > 5500)),2)';
% bslKlaus = mean(logData(:,times>-4000 & times < -1500),2)';
% bslAfter = mean(logData3(:,(times3 > -5500& times3<-500) | (times3 < 500 & times3 > 5500)),2)';

%%

figure,
subplot(1,5,1)
imagesc(times,freqs,10*log10(bsxfun(@rdivide,Pori,bsl)))
set(gca,'YDir','normal')
caxis([ -6.8 6.8])
vline(0,'r')
vline(4000,'r')
title(['Comp' comp ' BeforeEachTrial-Baseline'])


subplot(1,5,2)

imagesc(times,freqs,10*log10(bsxfun(@rdivide,Pori,bslKlaus)))
title('Tunnel-Baseline')
set(gca,'YDir','normal')
vline(0,'r')
vline(4000,'r')
caxis([ -6.8 6.8])

subplot(1,5,3)
imagesc(times,freqs,10*log10(bsxfun(@rdivide,Pori,bslAfter)))
title('AfterExpBlock-Baseline')
set(gca,'YDir','normal')
caxis([ -6.8 6.8])
vline(0,'r')
vline(4000,'r')

subplot(1,5,4)
imagesc(times,freqs,10*log10(bsxfun(@rdivide,Pori,bslBefore)))
title('BeforeExpBlock-Baseline')
set(gca,'YDir','normal')
caxis([ -6.8 6.8])
vline(0,'r')
vline(4000,'r')

subplot(1,5,5)
imagesc(times,freqs,10*log10(bsxfun(@rdivide,Pori,(bslAfter+bslBefore)/2)))
title('BothBefore+After-Baseline')
set(gca,'YDir','normal')
caxis([ -6.8 6.8])
vline(0,'r')
vline(4000,'r')

%%
figure

plot(freqs,10*log10(bsl))
hold all
plot(freqs,10*log10(bslKlaus),'Linewidth',2)
plot(freqs,10*log10(bslAfter))
plot(freqs,10*log10(bslBefore))
plot(freqs,10*log10((bslBefore+bslAfter)/2))
plot(freqs,10*log10(turnPower),':k','Linewidth',2)
title('Comp 17 Baselines')
xlabel('Freq in hz')
ylabel('10*log10(\muV^{2}/Hz)')
legend('BeforeEachTrial','Tunnel1','BlockAfter','BlockBefore','BothBlock','TrialMean')
%%

for k = 1:30
    subplot(6,5,k),
[STUDY erspdata ersptimes erspfreqs] = std_erspplot(STUDY,ALLEEG,'clusters',1, 'comps', k,'plotmode','none');
imagesc(ersptimes,erspfreqs,erspdata{1})
caxis([-7 7])
set(gca,'YDir','normal')
vline(0,'r')
vline(4250,'r')
title(num2str(STUDY.cluster.comps(k)))

end
colorbar



%%
comp = 17;
figure
[~,~,~,times4,freqs4,~,~,~,tfdata4] =newtimef_par(EEG.icaact(comp,:,:),...
    EEG.pnts, [EEG.xmin*1000 EEG.xmax*1000], EEG.srate, 0,'plotitc','off','powbase',10*log10(bsl),'freqs',[1 50]); %,'timewarp',eventms
