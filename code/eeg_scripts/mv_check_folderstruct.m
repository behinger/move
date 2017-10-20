function [flags] = mv_check_folderstruct(varargin)
% Returns a big matrix with file-checks
% For detailed description see:
% https://ikw.uni-osnabrueck.de/trac/move/wiki/EEGAnalysis

if nargin  == 1
    subjList = varargin{1};
else
    subjList = 1:5;
end

mv_path = '/net/store/projects/move/eeg';

taskList = {'pas','pro','ves','act'};

autoFields = {'raw','xensor','badComp','badCont','badTrial','badChannel','comment'};
fields = {'psyphyVR','folder','vp','session','condition','numSets','numSets2','setFilt','setResamp','setChannel','amica','dipole','dipoleQual','dipoleQualAll','cleaningComment','setStudy','setERSPprecomp'};
%make empty fields
for k = [autoFields fields]
    flags.(k{:}) = [];
end

flags.path = {};
for subj = subjList
    subjFiles = dir([mv_path filesep 'VP0' num2str(subj)]);
    subjFolder = subjFiles([subjFiles.isdir]);
    subjFolder(1:2) = []; %these are . and ..
    for task = taskList
        % concatenates subjFolder.name to a cell, applies strfind of the
        % current searched task
        taskIDXtmp=cellfun(@(x)regexpi(x,task{:}),{subjFolder.name},'UniformOutput',0);
        taskIDX=find(cellfun(@(x)~isempty(x),taskIDXtmp));  % because UniformOutput
        if ~isempty(taskIDX)
            %             fprintf('VP%i %s %i\n',subj,task{:},length(taskIDX))
            flags.folder(end+1:end+length(taskIDX)) = taskIDX;
        else
            flags.folder(end+1) = 0;
        end
        for k = taskIDX
            
            %% Flag VP Condition Filter and Autofields
            flags.vp(end+1) = subj;
            flags.condition(end+1) = find(cellfun(@(x)any(strfind(x,task{:})),taskList));
            flags.session(end+1) = str2num(subjFolder(k).name(3));
            eval(['p = mv_generate_paths(''' mv_path filesep  'VP0' num2str(subj) filesep subjFolder(k).name ''');']);
            flags.cleaningComment{end+1} = '';
            for l = autoFields
                try
                    if exist(p.full.(l{:}),'file')
                        
                        if strcmp(l{:},'badCont')
                            % try to load the file
                            
                            clear cleaningTimesOK
                            clear tmp
                            load(p.full.(l{:}))
                            %if empty, write a 5
                            
                            if isempty(rej)  || exist('tmp','var')
                                flags.(l{:})(end+1) = 5;
                                % if the cleaningTimesOK variable exists
                            elseif exist('cleaningTimesOK','var')
                                if cleaningTimesOK == 1
                                    %'cleaned and checked OK'
                                    flags.(l{:})(end+1) =2;
                                    
                                else
                                    %'cleaned and checked not OK'
                                    flags.cleaningComment{end} = cleaningTimesComment;
                                    flags.(l{:})(end+1) =6;
                                end
                                %else it is only a '1' meaning 'cleaned but
                                %not checked'
                            else
                                flags.(l{:})(end+1) = 1;
                            end
                            
                        else
                            flags.(l{:})(end+1) = 1;
                        end
                    else
                        %                         fprintf('%s not found\n',l{:})
                        error('go to exception') %this is not how errors should be used - but I don't care :P
                    end
                catch exception
                    flags.(l{:})(end+1) = 0;
                end
            end
            %% Field VRpsyphy
            if isempty(p.full.psyphyVR);
                flags.psyphyVR(end+1) = 0;
            else
                flags.psyphyVR(end+1) = length(p.full.psyphyVR);
            end
            if ~isempty(p.full.sets)
                %% Set Filtered
                
                tmpFilt = cellfun(@(x)strfind(x,'Filt'),p.full.sets,'UniformOutput',0);
                if isempty(tmpFilt{end})
                    flags.setFilt(end+1) = 0;
                else
                    flags.setFilt(end+1)  = find(cellfun(@(x)~isempty(x),tmpFilt),1,'first');
                end
                %% Set Resamples
                tmpResamp = cellfun(@(x)strfind(x,'Resamp'),p.full.sets,'UniformOutput',0);
                if isempty(tmpResamp{end})
                    flags.setResamp(end+1) = 0;
                else
                    flags.setResamp(end+1) = find(cellfun(@(x)~isempty(x),tmpResamp),1,'first');
                end
                %% Set Noisy Channels
                tempReref = cellfun(@(x)strfind(x,'Reref'),p.full.sets,'UniformOutput',0);
                if isempty(tempReref{end})
                    flags.setChannel(end+1) = 0;
                else
                    flags.setChannel(end+1) = find(cellfun(@(x)~isempty(x),tempReref),1,'first');
                end
                
                %% ICA calculated
                flags.amica{end+1} = [];
                for m = [4 5 6 7]%1:length(p.amica.path)
                    
                    if exist([p.amica.path{m} filesep 'out.txt'],'file')>0
                        try
                            mod = loadmodout12(p.amica.path{m});
                            mod.W;
                            flags.amica{end} = [flags.amica{end} m];
                        catch
                            %                    flags.amica(end+1) = 0;
                            fprintf('%s \n',p.amica.path{m})
                            fprintf('ICA available, but could not load \n')
                            %                    if strcmp('y',input('Remove (y/n): ','s'))
                            %                        fprintf('Removing dir \n')
                            %                        rmdir(p.amica.path{1},'s')
                            %                    end
                            
                        end
                        
                    end
                end
                %% Dipole
                flags.dipole{end+1} = [];
                flags.dipoleQual{end+1} = [];
                flags.dipoleQualAll{end+1} = [];
                for m = [4 5 6 7]%m = 1:length(p.amica.path)
                    if exist(p.full.dipole{m},'file')
                        clear dipfit
                        load(p.full.dipole{m})
                        tmpRV = [dipfit.model.rv];
                        
                        flags.dipoleQual{end} = [flags.dipoleQual{end} sum(tmpRV<0.15)/numel(tmpRV)];
                        flags.dipoleQualAll{end} = [flags.dipoleQualAll{end} tmpRV];
                        flags.dipole{end} = [flags.dipole{end} m];
                    else
                        flags.dipoleQual{end} = [flags.dipoleQual{end} nan];
                        flags.dipoleQualAll{end} = [flags.dipoleQualAll{end} nan];
                        flags.dipole{end} = [flags.dipole{end} nan];             
                    end
                end
                %% Study Set
                tempStudy = cellfun(@(x)strfind(x,'Study'),p.full.sets2,'UniformOutput',0);
                if isempty([tempStudy{:}])
                    flags.setStudy(end+1) = 0;
                else
                    flags.setStudy(end+1) = find(cellfun(@(x)~isempty(x),tempStudy),1,'last');
         
                end
                %% Precomp
                for m = 1:length(p.study.preComp)
                    try
                        tmp2 = dir(p.study.preComp{m});
                        tmp2(1:2) = [];
                        for n = 1:length(tmp2)
                            if ~isempty(regexpi(tmp2(n).name,['VP' num2str(flags.vp(end)) 'S' num2str(flags.session(end)) '.*' num2str(taskList{flags.condition(end)})]))
                                break
                            end
                        end
                        if n == length(dir)
                            flags.setERSPprecomp{end+1} = 0;
                        else
                            if m == 1
                                flags.setERSPprecomp{end+1} = {1};
                            else
                                flags.setERSPprecomp{end} = [flags.setERSPprecomp{end} {1}];
                            end
                            
                        end
                    catch
                        flags.setERSPprecomp{end+1} = 0;
                        
                    end
                end
                
                
                %%
                
                flags.numSets(end+1) =sum(cellfun(@(x)~isempty(x),p.full.sets));
                flags.numSets2(end+1) = sum(cellfun(@(x)~isempty(x),p.full.sets2));
                
            else
                flags.setStudy(end+1) = 0;
                flags.dipole(end+1) = 0;
                flags.setChannel(end+1) = 0;
                flags.amica(end+1) = 0;
                flags.setResamp(end+1) = 0;
                flags.setFilt(end+1) = 0;
                flags.numSets(end+1) = 0;
                flags.numSets2(end+1) = 0;
            end
            
            flags.path{end+1} = [mv_path filesep  'VP0' num2str(subj) filesep subjFolder(k).name];
        end
        
    end
    
end

flags = rmfield(flags,'folder');
flags = sort_struct(flags,'session');
end


function [struct] = sort_struct(struct,sortField)

fn = fieldnames(struct);
[~, IDX] = sort(struct.session);
for k = fn'
    struct.(k{:}) = struct.(k{:})(IDX);
end
[~, IDX] = sort(struct.vp);
for k = fn'
    struct.(k{:}) = struct.(k{:})(IDX);
end

end
