function []= mv_grid_filter(subj)
%% This script runs the importing and filtering on the grid
% Simply plugin a subject number, the program will then ask you on which
% sets to run the filtering

flags = mv_check_folderstruct(subj);

for k = find(~flags.setFilt  & flags.raw & flags.vp == subj)
    p = mv_generate_paths(flags.path{k});
    fprintf('%i: \t %s\t %s \n',k,p.folder,p.filename)
end


impTemp = input('For which rawdata should we load and process the raw data (e.g. [1 3 5 7])? ');

for k = impTemp
    cmd = [...
        'p = mv_generate_paths(''' flags.path{k} ''');'...
        'EEG = mv_import_cnt(p);'...
        'EEG = mv_filter_cont(EEG,p);'...
        'pop_saveset(EEG,''filename'',EEG.preprocess,''filepath'',p.path.set);'];
    mv_grid_ready;
    mv_grid_start_cmd(cmd,['mv_VP' num2str(flags.vp(k)) 'Co' num2str(flags.condition(k)) 'S' num2str(flags.session(k)) 'Filt']);
    
    
end

