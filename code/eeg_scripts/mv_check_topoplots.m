[~,indx] = min(abs(EEG.times-558.4*1000)) % 1 part
[~,indx] = min(abs(EEG.times-2200.74*1000))

%%
figure,
topoplot(mean(EEG.data(:,indx),2),EEG.chanlocs,'electrodes','on')
caxis([-40 40])
%%
figure,
topoplot(mean(EEG.data(70:end,indx-5:indx+5),2),EEG.chanlocs(70:end))%'electrodes','on')
title('second half')
caxis([-40 40])
figure
topoplot(mean(EEG.data(1:50,indx-5:indx+5),2),EEG.chanlocs(1:50),'electrodes','on')
caxis([-40 40])
title('first half')
%%
figure
begI = [1,29,60,90];
endI = [28,59,89,117];

begI = [1,32,67,99];
endI = [32,64,98,130];
for k = 1:4
    subplot(2,2,k)
    topoplot(mean(EEG.data(begI(k):endI(k),indx-5:indx+5),2),EEG.chanlocs(begI(k):endI(k)),'electrodes','on')
    caxis([-40 40])
    title(num2str(k))
    
end

%%
for k = [3:4; 4:-1:3]
    subplot(2,2,k(1))
    topoplot(mean(EEG.data(begI(k(1)):endI(k(1)),indx-5:indx+5),2),EEG.chanlocs(begI(k(2)):endI(k(2))),'electrodes','on')
    caxis([-40 40])
    title(num2str(k(1)))
    
end