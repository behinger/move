clear powSpec
p = generate_paths('MOVEalexBaselineAfter.cnt','/net/store/projects/move/eeg/alexPilotBaseline');
for comp = [1:EEG.nbchan]

[tfOUt,~,base1,times2,freqs2,~,~,~,tfdata2] =newtimef(EEG.icaact(comp,:,:),...
    EEG.pnts, [EEG.xmin*1000 EEG.xmax*1000], EEG.srate, 0, 'ntimesout', 200 ,'plotitc','off' ,   'baseline',[EEG.xmin*1000 EEG.xmax*1000],'freqs',[1 50],'nfreqs',99);
%logData2 = 10*log10(mean(tfdata2,3));
Pori = mean(tfdata2,3);
mbase = mean(Pori,2);

%bsl = mean(logData2(:,(times2 > -5500& times2<-500) | (times2 < 500 & times2 > 5500)),2)';

powSpec(comp,:) = 10*log10(mbase);
end


save(p.full.powBaseline,'powSpec')



%%
% Pori = mean(tfdata2,3);
% mbase = mean(Pori(:,:),2);
% 
% 
% %%
% logData2 = mean(10*log10(),2);
% bsl = mean(logData2(:,(times2 >= -4000& times2<=-500)),2)';
% 
% bsl = mean(mean(tfdata2(:,(times2 > -4000& times2<-500),:),3),2)