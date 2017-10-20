function [EEG] = mv_clean_trial(EEG,p,varargin)
global rej
rej = [];
if nargin == 3 && ~ischar(varargin{1})
    silent = varargin{1};

else
silent = 0;
end
if ~check_EEG(EEG.preprocess,'VRevents','silent','on') && ~check_EEG(EEG.preprocess,'Trig4','silent','on')
   error('Events should be loaded before doing the rejection');
end
   
if ~check_EEG(EEG.preprocess,'Ica','silent','on')
   error('ICA needs to be loaded before looking at ICA components');
end
if ~check_EEG(EEG.preprocess,'Trialclean')
        %IF not on grid, ask for cleanerName
    if  silent == 0
        cleanerName = input('Your name: ','s');
    end

    if exist(p.full.badTrial,'file')==2
        load(p.full.badTrial)
        fprintf('Trial Rejections loaded \n')
        fprintf('%i ',find(trialrej))
        fprintf('\n')
        if silent
            cleaningInput = 'u';
        else
        cleaningInput = input('Old cleaning times found: (a)ppend, (o)verwrite, (u)se old cleaning, (c)ancel y/n: ','s');
        end
        if strcmp(cleaningInput,'o')
            eegplot(EEG.icaact,'srate',EEG.srate,'winlength',1,'events',EEG.event,'wincolor',[1 0.5 0.5],'command','global rej;rej=TMPREJ', 'submean','on','dispchans',40);
            uiwait;
            [trialrej elecrej] = eegplot2trial( rej, EEG.pnts,  EEG.trials);
        elseif strcmp(cleaningInput,'a')
            eegplot(EEG.icaact,'srate',EEG.srate,'winlength',1,'events',EEG.event,'wincolor',[1 0.5 0.5],'winrej',trial2eegplot(trialrej,zeros(size(EEG.icaact,1),EEG.trials),EEG.pnts,[0.8 1 0.8]),'command','global rej;rej=TMPREJ', 'submean','on','dispchans',40);
            uiwait;
            [trialrej elecrej] = eegplot2trial( rej, EEG.pnts,  EEG.trials);
        elseif strcmp(cleaningInput,'c') %
            error('User canceled the cleaning-action')
        elseif ~strcmp(cleaningInput,'u')
            error('User gave impossible input')
        end
    else
        cleaningInput = 'new';
        eegplot(EEG.icaact,'srate',EEG.srate,'winlength',1,'events',EEG.event,'wincolor',[1 0.5 0.5],'command','global rej;rej=TMPREJ', 'submean','on','dispchans',40);
        uiwait;
        [trialrej elecrej] = eegplot2trial( rej, EEG.pnts,  EEG.trials);
        
    end
    %convert trialrej to actual trial reference
    
    vrTrialReject =[];
    for k = 1:length(trialrej)
        if trialrej(k)
            tmpTrialNr = EEG.epoch(k).eventtrialNumber{1};
            if isempty(tmpTrialNr)
                tmpTrialNr = 999;
            end
            vrTrialReject = [vrTrialReject tmpTrialNr];
        end
    end
    % save the times of the rejection
    if ~isdir(p.path.reject),          mkdir(p.path.reject);     end
    if ~strcmp(cleaningInput,'u')
        if exist(p.full.badTrial,'file')==2
            copyfile(p.full.badTrial,[p.full.badTrial '.bkp' datestr(now,'mm-dd-yyyy_HH-MM-SS')]);
            fprintf('Backup created \n')
        end
        PreprocessInfo = EEG.preprocessInfo;
        save(p.full.badTrial,'trialrej','cleanerName','vrTrialReject','PreprocessInfo');
        fprintf('Rejections saved \n')
    end
    
    %reject the marked rejections
    
    EEG = pop_rejepoch(EEG, trialrej, 0);
    
    EEG = eeg_checkset(EEG);
    EEG.preprocessInfo.trialrej = trialrej;
    EEG.preprocessInfo.trialrejDate = datestr(now);


    EEG.preprocess = [EEG.preprocess 'Trialclean'];
end
