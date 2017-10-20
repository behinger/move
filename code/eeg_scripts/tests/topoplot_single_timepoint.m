figure,
range1 = 100010:100500;
EEG.times = linspace(0,EEG.pnts/1024,EEG.pnts)
range1 = find(abs(EEG.times-155)<0.005)
topoplot(mean(EEG.data(:,range1),2)-mean(EEG.data(:,158321:158921),2),EEG.chanlocs,'electrodes','ptslabels')
% topoplot(mean(EEG.data(:,range1),2),EEG.chanlocs,'electrodes','ptslabels')