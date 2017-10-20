function EEG = mv_filter_cont(EEG,p,varargin)
p = mv_generate_paths(p);
if ~check_EEG(EEG.preprocess,'Filt')
    
    
    if nargin <3
        lowCutOff = 1;
        highCutOff = 120;
        type = 'fir1';
        type = 'fir_eegfiltnew';
    elseif nargin == 5
        lowCutOff = varargin{1};
        highCutOff = varargin{2};
        type = varargin{3};
    else
        error('wrong input number')
    end
    
%     EEG = pop_eegfilt( EEG, lowCutOff, 0, [], 0,0,0,type); %highpass
    EEG = pop_eegfiltnew(EEG,0,highCutOff);
    EEG = pop_eegfiltnew(EEG,lowCutOff,0);
%     EEG = pop_eegfilt( EEG, 0, highCutOff, [], 0,0,0,type); % lowpass
    EEG = eeg_checkset( EEG );
    EEG.preprocessInfo.filter.type = type;
    EEG.preprocessInfo.filter.eegfiltnew = 1;
    EEG.preprocessInfo.filter.lowCutoff = lowCutOff;
    EEG.preprocessInfo.filter.highCutoff = highCutOff;
    EEG.preprocessInfo.filter.date = datestr(now);
    EEG.preprocess = [EEG.preprocess 'fir1'];
end