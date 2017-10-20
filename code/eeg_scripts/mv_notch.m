function [EEG] = mv_notch(EEG,p)
    EEG = pop_eegfiltnew(EEG,48,52,[],1,[],0);
    EEG.preprocess = [EEG.preprocess 'Notch'];
    EEG.preprocessInfo.notch = [48 52];
    EEG.preprocessInfo.notDate =  datestr(now);



end