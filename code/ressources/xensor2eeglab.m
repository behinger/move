electrode = read_xensor(filename)

for ch=6:135
   EEG.chanlocs(ch-5).labels = electrode.labels{ch};
   EEG.chanlocs(ch-5).X = electrode.elecpos(ch,1);
   EEG.chanlocs(ch-5).Y = electrode.elecpos(ch,2);
   EEG.chanlocs(ch-5).Z = electrode.elecpos(ch,3);
end
EEG = eeg_checkset(EEG);eeglab redraw
EEG = pop_chanedit( EEG, 'eval', 'EEG.chanlocs = pop_chancenter(EEG.chanlocs,[],[])');

