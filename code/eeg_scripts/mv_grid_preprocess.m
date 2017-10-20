function [cmd_final]= mv_grid_preprocess(varargin)
%% Function which does the preprocessing steps on the grid
% mv_grid_preprocess(command,subj)
%
% possible commands:
%       'Filt'          --> Imports the File and Filters it
%       'ResampXensor'  --> Resamples to 512Hz and loads Xensor
%       'ChannelReref'  --> Removes Channels and Rerefs
%       'Preprocess'    --> Does the three steps above

%       'ICA'           --> Runs AMICA
%       'dipole'        --> Excludes bad Trials and Fits Dipoles
% subj: Can be skipped, then runs on all 5 Subjects
%
% Example: mv_grid_preprocess('Filt')
%    --> Runs the Importing & Filtering on the grid for all subjects
% Example: mv_grid_preprocess('ICA',10)
%    --> Runs the ICA for set 10, regardless of any checks
if nargin <1 || nargin > 2
    help mv_grid_preprocess
    error('Wrong Inputsize')
end
if nargin>=1
    ppType = varargin{1}; % PreProcessing Type
end
local = 0;

%% If multiple ICA's ask
flags = mv_check_folderstruct;
p = mv_generate_paths(flags.path{1});
if (strcmp(ppType,'ICA') || strcmp(ppType,'Dipole') || strcmp(ppType,'ICAepoched') || strcmp(ppType,'runica') )&& length(p.amica.path)>1
    for i = 1:length(p.amica.path)
        fprintf('%i : %s  \n',i,p.amica.path{i})
    end
    amicaChosenPath = input('Which AMICA you want? ');
else
    amicaChosenPath = 1;
end



switch ppType
    case 'Filt'
        flagSelect = ~flags.setFilt; %chose those that are not yet filtered
        ppCmd = [ 'EEG = mv_filter_cont(EEG,p);'];
    case 'ResampXensor'
        flagSelect = flags.setFilt>0 & flags.xensor & ~(flags.setResamp==2);
        ppCmd = [...
            'EEG = mv_resample(EEG,p); '...
            ...%             'EEG = mv_reref2Amps(EEG);'...
            'EEG = mv_load_xensor(EEG,p); '];
    case 'ChannelReref'
        flagSelect = flags.setResamp>0 & flags.badChannel  & flags.badCont>1 & flags.setChannel==0;
        ppCmd = ['EEG = mv_reject_channel(EEG,p,1);'...
            'EEG = mv_reref(EEG,p);'];
    case {'Preprocess' , 'PreprocessNoFilt'  }
      
    case {'ICA','runica','ICAepoched'}
        flagSelect = flags.setChannel>0& flags.badCont==2 & ~cellfun(@(x)any(ismember(x,amicaChosenPath)),flags.amica);
        ppCmd = [];
        
    case 'Dipole'
        flagSelect = cellfun(@(x)any(ismember(x,amicaChosenPath)),flags.amica) & ~cellfun(@(x)any(ismember(x,amicaChosenPath)),flags.dipole);
        ppCmd = [''...
            'EEG = mv_load_ICA(EEG,p,' num2str(amicaChosenPath) ');'...
            'EEG = mv_fit_dipole(EEG,p,' num2str(amicaChosenPath) ',1);'];
    case 'CleanCont'
        ppCmd = ['EEG = mv_clean_continuous(EEG,p,1);'];
    otherwise
        error('Unknown Preprocessingstep')
        
end


subj = 1:5;
if nargin == 2 %
    impTemp = varargin{2};
else
    possibleSets =  find(flagSelect & flags.raw & ismember(flags.vp,subj));
    for k = possibleSets;
        p = mv_generate_paths(flags.path{k});
        fprintf('%i: \t %s\t %s \n',k,p.folder,p.filename)
    end
    
    
    impTemp = input('For which rawdata should we load and process the raw data (e.g. [1 3 5 7])? ');
    impTemp = intersect(impTemp,possibleSets);
end

if strcmp(ppType,'ICA2')
   firstLoop = impTemp(1:2:length(impTemp));
%      firstLoop = 1;
   secondLoop = 0:1;
%      secondLoop = 0:43;
elseif strcmp(ppType,'Preprocess')
    firstLoop =impTemp(1);
%     firstLoop = impTemp(1:5:length(impTemp));
    secondLoop = 0:length(impTemp)-1;
%     secondLoop = 0:4;
else
    firstLoop = impTemp;
    secondLoop = 0;
end
for k = firstLoop
    cmd_final = [];
    for l = secondLoop
        
    switch ppType
        case {'Filt'}
            loadCmd = ['EEG = mv_import_cnt(p);'];
        case 'ResampXensor'
            loadCmd = ['EEG = mv_load_set(p,' num2str(flags.setFilt(k)) ');'];
        case 'ChannelReref'
            loadCmd = ['EEG = mv_load_set(p,' num2str(flags.setResamp(k)) ');'];
        case 'ICA'
         
        case 'runica'
            loadCmd = [ ...
                 'EEG = mv_load_set2(p,1);'... 
                 'EEG = mv_clean_continuous(EEG,p,1);'...
                 '[weights,sphere] = runica(EEG.data,''extended'',1);' ...
                 'save([p.amica{4} filesep ''runicaWS.mat''], ''weights'',''sphere'');'];
         case 'ICAepoched'
            loadCmd = [ 'addpath(''/net/store/projects/move/move_svn/code/ressourcen/amica'');'...
                 'EEG = mv_load_set(p,' num2str(flags.setChannel(k)) ');'... %dchosenSet is definied my move_amica_grid_start
...%                 'EEG = mv_load_set2(p,1);'... %dchosenSet is definied my move_amica_grid_start
                'EEG = mv_clean_continuous(EEG,p,1);'...
                'cd( p.path.set2 );'...
                'EEG = mv_epoch(EEG,p);' ...
                'runamica12(EEG,''outdir'', p.amica.path{' num2str(amicaChosenPath) '},''num_models'',1,''share_comps'',1,''max_threads'',7,' ...
...%                 ' ''do_reject'',1,''numrej'',9,''rejsig'',3);'];
            ' ''do_reject'',1,''numrej'',5,''rejsig'',3,''do_history'',1);'];
        case {'Dipole', 'CleanCont'}
            loadCmd = ['EEG = mv_load_set2(p,1);'];
            
    end
    switch ppType
        case {'Dipole','ICAepoched','runica'}
            cmd = [...
                'p = mv_generate_paths(''' flags.path{k+l} ''');'...
                loadCmd ppCmd];
        case 'ICA'
            cmd = [...
                'p = mv_generate_paths(''' flags.path{k+l} ''');'...
                'addpath(''/net/store/projects/move/move_svn/code/ressourcen/amica'');'...
                'EEG = mv_load_set2(p,2);'... %dchosenSet is definied my move_amica_grid_start
                'cd( p.path.set2 );'...
                'runamica12(EEG,''outdir'', p.amica.path{' num2str(amicaChosenPath) '},''num_models'',1,''share_comps'',1,''max_threads'',5,' ...
                ' ''do_reject'',1,''numrej'',3,''rejsig'',2,''do_history'',1);' ppCmd];
        case {'Preprocess'}
                cmd = [...
                ...%'addpath(''/net/store/projects/move/eeglab_old/'');eeglab;'...
                'p = mv_generate_paths(''' flags.path{k+l} ''');'...
                'EEG = mv_import_cnt(p);'...
                'EEG = mv_resample(EEG,p,256); '...
                'EEG = mv_switchChannels(EEG,p);'...
                'EEG = mv_filter_cont(EEG,p);' ...
                'EEG = mv_notch(EEG,p);'...
                ...%'pop_saveset(EEG,''filename'',EEG.preprocess,''filepath'',p.path.set2);'...
                'EEG = mv_reref2Amps(EEG,p);' ...
                'EEG = mv_load_xensor(EEG,p);'...
                'EEG = mv_reject_channel(EEG,p,1);'...
                'EEG = mv_reref(EEG,p);'...
                'EEG = mv_add_events(EEG,p);'...
                'pop_saveset(EEG,''filename'',EEG.preprocess,''filepath'',p.path.set2);'...
                'EEG = mv_clean_continuous(EEG,p,1);'...
                'pop_saveset(EEG,''filename'',EEG.preprocess,''filepath'',p.path.set2);'];
        case {'PreprocessNoFilt'}
                cmd = [...
                'addpath(''/net/store/projects/move/eeglab_old/'');eeglab;'...
                'p = mv_generate_paths(''' flags.path{k+l} ''');'...
                'EEG = mv_load_set2(p,4);'... %dchosenSet is definied my move_amica_grid_start
                ...%'EEG = mv_resample(EEG,p); '...
                'EEG = mv_reref2Amps(EEG,p);' ...
                'EEG = mv_load_xensor(EEG,p);'...
                'EEG = mv_reject_channel(EEG,p,1);'...
                'EEG = mv_reref(EEG,p);'...
                'EEG2 = mv_resample(EEG,p,256);'...
                'pop_saveset(EEG2,''filename'',EEG2.preprocess,''filepath'',p.path.set2);'...
                'clear(''EEG2'');'...
                'EEG = mv_resample(EEG,p,512);'...
                'EEG = mv_clean_continuous(EEG,p,1);'...
                'EEG = mv_resample(EEG,p,256);'...
                'pop_saveset(EEG,''filename'',EEG.preprocess,''filepath'',p.path.set2);'];
        otherwise
            error('This should not be neccessary anymore')
            cmd = [...
                'p = mv_generate_paths(''' flags.path{k} ''');'...
                loadCmd ppCmd ...
                'pop_saveset(EEG,''filename'',EEG.preprocess,''filepath'',p.path.set);'];
    end
    if local
        cmd_final = cmd;
        return
    end
    cmd_final = [cmd_final cmd];
    end
    
    mv_grid_ready(60);
    mv_grid_start_cmd(cmd_final,['mv_' num2str(k) '_' ppType]);
    
    
end

