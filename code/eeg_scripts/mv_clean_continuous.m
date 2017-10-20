function [EEG] = mv_clean_continuous(EEG,p,varargin)
%% Cleaning function
%Example Call
%  [EEG] = mv_clean_continuous(EEG,p)
% Checks whether file is already cleaned, asks user what to do if so
%
% [EEG] = mv_clean_continuous(EEG,p,1)
% Does not ask user and simply rejects the data
global rej
rej = [];
% If there is an additional Input, that is not a char, then go silently and
% simply use the available cleaning times. This is for grid use
if nargin == 3 && ~ischar(varargin{1})
    silent = varargin{1};
    cleaning_check = 0;
    
    %If an Char called 'Bene' is given, then we want to go into cleaning
    %check to register whether the data is cleaned good. "Qualitycheck"
elseif nargin == 3 && ischar(varargin{1}) && strcmpi(varargin{1},'bene')
    silent = 0;
    cleaning_check =1;
    fprintf('Welcome Bene to the cleaningCheck')
else
    %Else simply run the script
    silent = 0;
    cleaning_check = 0;
end
if ~check_EEG(EEG.preprocess,'Clean')
    %IF not on grid, ask for cleanerName
    if  silent == 0 && ~cleaning_check;
        cleanerName = input('Your name: ','s');
    end
    % Check if the file already exists
    if exist(p.full.badCont,'file')==2
        %Load it
        load(p.full.badCont)
        fprintf('Rejections loaded \n')
        % Check whether an empty (temporary) file has been made
        if exist('tmp','var') 
            warning('Loaded Rejections were Empty! MAYBE SOMEONE ELSE IS CURRENTLY CLEANING THE FILE')
        else %if not temporary, check Samplingrate
%             if EEG.srate ~= sampRate
%                 error('Cleaning Sampling Rate (%i) is different from EEG sampling Rate (%i)\n',sampRate,EEG.srate)
%                 %recalculate rejection times to latency, then back to
%                 %points with the new sampRate
% %                 eeg_point2lat
%             end

            if isempty(rej)
                warning('Rejection are empty please overwrite')
            else
                
                if size(rej,2)-5 ~= EEG.nbchan
                    %                error('The number of Channels in the EEG and in the old Cleaning times do not match: rej: %i, cleaning: %i \n Did you remove channels in between first cleaning session and second? \n',size(rej,2)-5,EEG.nbchan);
                    rej = [rej(:,1:5) zeros(EEG.nbchan,size(rej,1))'];
                    fprintf('Last time the Data had been cleaned with different number of channels, fixing it!\n ')
                end
            end
        end
        % Check whether current sampling rate is the same as previous
        
        % If silent, the cleaningInput should be "use old"
        if silent
            cleaningInput='u';
            % if Cleaning Check, we want to see the cleaning Times and use
            % Append
        elseif cleaning_check
            cleaningInput='a';
        else
            %Else we ask what the user wants
            cleaningInput = input('Old cleaning times found: (o)verwrite, (u)se old cleaning, (a)ppend, (c)ancel y/n: ','s');
        end
        %If we overwrite, we simply ask the user to clean again
        if strcmp(cleaningInput,'o')
            eegplot_keyboard(EEG.data,'srate',EEG.srate,'winlength',8, ...
                'events',EEG.event,'wincolor',[1 0.5 0.5],'command','global rej,rej=TMPREJ',...
                'eloc_file',EEG.chanlocs);
            uiwait;
            %If we append, we use the old rejectiontimes for 'winrej'
        elseif strcmp(cleaningInput,'a')
            % Cleaning 1: Rejection times from 128 channels, then removing
            % channels and now in cleaning 2 you try to reload the old
            % cleaning times, but in between you rejected channels and now
            % have 120 channels. Then you have 128 cleaningtimes for 120
            % channels and the program does not know what to do.
            if isempty(rej)
               fprintf('The old Rejections were empty, (a)ppend does the same thing as (o)verwrite \n');
            else
              if size(rej,2)-5 ~= EEG.nbchan,
                       error('This should not happen anymore, contact Bene rej: %i, cleaning: %i \n \n',size(rej,2)-5,EEG.nbchan);
                  
              end
            end
            eegplot_keyboard(EEG.data,'srate',EEG.srate,'winlength',8, ...
                'events',EEG.event,'wincolor',[1 0.5 0.5],'command','global rej,rej=TMPREJ',...
                'eloc_file',EEG.chanlocs,'winrej',sort(rej(:,1:2))./(sampRate/EEG.srate));
            uiwait;
            
            if strcmp(input('Do you really want to append (y)es/(a)bort :','s'),'a')
                error('User Aborted')
            end
            
            
            % If we cancel, thwrow an error
        elseif strcmp(cleaningInput,'c') %
            error('User canceled the cleaning-action')
            % The only possible Input now can be 'u', for continuing the
            % cleaning
        elseif ~strcmp(cleaningInput,'u')
            error('User gave impossible input')
        end
        
        %If the file does not exist simply clean (same as 'o')
    else
        tmp=[];
        cleaningInput = 'firstRun';
        save(p.full.badCont,'tmp')
        eegplot_keyboard(EEG.data,'srate',EEG.srate,'winlength', 8,...
            'events',EEG.event,'wincolor',[1 0.5 0.5],'command','global rej,rej=TMPREJ'...
            ,'eloc_file',EEG.chanlocs);
        uiwait;
        % use this for temporary filter
        %eegplot(EEG_temp.data,'srate',EEG_temp.srate,'winlength',4,'events',EEG_temp.event,'wincolor',[1 0.5 0.5],'command','rej=TMPREJ');
    end
    if cleaning_check
        %If the CleaningChecker said the cleaningtimes are OK, then save 1
        if exist('cleanerName','var')
            fprintf('Last Person Cleaning: %s \n',cleanerName)
        end
        cleaningTimesOK = strcmpi(input('Clean Enough(y/n)? ','s'),'y');
        if ~cleaningTimesOK 
            cleaningTimesComment = input('Comment on why not OK: ','s');
        else
            cleaningTimesComment = [];
        end
        
        load(p.full.badCont)
        fprintf('All Changes from this Session Removed \n')
        copyfile(p.full.badCont,[p.full.badCont '.bkp' datestr(now,'mm-dd-yyyy_HH-MM-SS')]);
        fprintf('Backup created \n')
        if ~exist('cleanerName','var')
            cleanerName = 'unknown';
        end
        save(p.full.badCont,'rej','sampRate','cleanerName','cleaningTimesOK','cleaningTimesComment');
        fprintf('Quit \n')
        return
    else
        
    % save the times of the rejection
    if ~isdir(p.path.reject),          mkdir(p.path.reject);     end %should be deprevated, but also does not hurt
    if exist(p.full.badCont,'file')==2 && ~silent && ~strcmp(cleaningInput,'u') % if we find the file, and we are not on the grid and we do not continue without cleaning anything, backup!
        copyfile(p.full.badCont,[p.full.badCont '.bkp' datestr(now,'mm-dd-yyyy_HH-MM-SS')]);
        fprintf('Backup created \n')
    end
    % We get the current samplingRate
    
    %If not on grid and not just cleaning the Dataset, save it!
    if ~silent && ~strcmp(cleaningInput,'u')
        if isempty(rej)
            error('rejection was empty! Did not save and aborted')
        end
        sampRate = EEG.srate;
        save(p.full.badCont,'rej','sampRate','cleanerName');
        fprintf('Rejections saved \n')
    end
    
    % Convert and reject the marked rejections
    tmprej = eegplot2event(rej, -1);
%     tmpLat = eeg_point2lat(tmprej(:,3),[],512,[EEG.xmin EEG.xmax]);
%     EEG.times = linspace(EEG.xmin,EEG.xmax,EEG.pnts);
if ~strcmp(cleaningInput,'a')
    tmprej(:,3:4) = round(tmprej(:,3:4)/(sampRate/EEG.srate));
end
%     [~,IDX] = arrayfun(@(x)(min(abs((x-EEG.times)))),tmpLat,'UniformOutput',1)
    
    [EEG LASTCOM] = eeg_eegrej(EEG,tmprej(:,[3 4]));
    
    %Save it in the preprocess unit.
    EEG.preprocessInfo.tmprej = tmprej;
    EEG.preprocessInfo.cleanContDate = datestr(now);
    EEG.preprocess = [EEG.preprocess 'Clean'];
    end
end
