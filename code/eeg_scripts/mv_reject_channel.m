function EEG = mv_reject_channel(EEG,p,varargin)
if nargin == 3
   silent = varargin{1};
else
    silent= 0;
end
p = mv_generate_paths(p);
if ~check_EEG(EEG.preprocess,'Noisychannel')
    
    if exist(p.full.badChannel,'file')==2
        load(p.full.badChannel)
        fprintf('Rejected Channels loaded \n')
        for i = 1:length(rej_channel)
            fprintf('%7s ,', EEG.chanlocs(rej_channel(i)).labels);
        end
        fprintf('\n')
        fprintf('%7i ,', rej_channel(:))
        fprintf('\n')
        if silent
            askAppendOverwrite = 'u';
        else
        askAppendOverwrite = input('Overwrite old rejection channels? (o)verwrite/(a)ppend/(u)se old/(c)ancel: ','s');
        end
        if strcmpi(askAppendOverwrite,'o')
            rej_channel = input('Which channels to reject e.g. [3,5,12] or {''Fz'',''AFF2''}? ');
        elseif strcmpi(askAppendOverwrite,'a')
            rej_channel_orig = rej_channel;
            rej_channel = input('Which channels to reject e.g. [3,5,12] or {''Fz'',''AFF2''}? ');
        elseif  strcmpi(askAppendOverwrite,'c')
            error('User Canceled');
        elseif ~strcmpi(askAppendOverwrite,'u')
            error('Unrecognized');
        end
        
    else
        rej_channel=input('Which channels to reject e.g. [3,5,12] or {''Fz'',''AFF2''},? ');
    end
    
    
    
    
    % if cell input, convert it to matrix number
    if iscell(rej_channel)
        fprintf('%7s ,', rej_channel{:})
        fprintf('\n')
        
        rej_channel_nr = [];
        for i = 1:length(rej_channel)
            fprintf('%7i ,', find(strcmpi({EEG.chanlocs.labels},rej_channel(i))))
            rej_channel_nr = [rej_channel_nr find(strcmpi({EEG.chanlocs.labels},rej_channel(i)))];
            
        end
        rej_channel_cell = rej_channel;
        rej_channel = rej_channel_nr;
        fprintf('\n')
    else %then we have the numbers and need to convert them temporarily for printing to the corresponding labels
        rej_channel = sort(rej_channel);
        for i = 1:length(rej_channel)
            fprintf('%7s ,', EEG.chanlocs(rej_channel(i)).labels);
            rej_channel_cell{i} = EEG.chanlocs(rej_channel(i)).labels;
        end
        fprintf('\n')
        fprintf('%7i ,', rej_channel(:))
        fprintf('\n')
    end
    rej_channel = sort(rej_channel);
    if exist('askAppendOverwrite','var') && strcmpi(askAppendOverwrite,'a')
        rej_channel = sort([rej_channel_orig,rej_channel]);
        askAppendOverwrite = [];
    end
    if ~exist([p.full.badChannel 'rej_channel.beforeNotch.bkp'],'file')
        copyfile(p.full.badChannel,[p.full.badChannel 'rej_channel.beforeNotch.bkp']);
        fprintf('First Notch Detected, creating backup \n')
    end
    if ~isdir(p.path.reject),          mkdir(p.path.reject);     end
    if exist(p.full.badChannel,'file')==2 && exist('askAppendOverwrite','var')&& ~strcmp(askAppendOverwrite,'c')
        copyfile(p.full.badChannel,[p.full.badChannel '.bkp' datestr(now,'mm-dd-yyyy_HH-MM-SS')]);
        fprintf('Backup created \n')
    end
    save(p.full.badChannel,'rej_channel');
    fprintf('Rejections Saved \n')
    EEG = pop_select( EEG,'nochannel',rej_channel);
    EEG.preprocess = [EEG.preprocess 'Noisychannel'];
    EEG.preprocessInfo.badChannels = rej_channel;
    EEG.preprocessInfo.badChannelsLbl = rej_channel_cell;
    EEG.preprocessInfo.badChannelsDate = datestr(now);
    
    
end

