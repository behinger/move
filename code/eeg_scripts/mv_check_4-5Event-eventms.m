for k = 1:44
    p = mv_generate_paths(flags.path{k});
    if flags.setStudy(k) == 3
        fprintf('%i \n',k);
        EEG = mv_load_set2(p,3,'info');
        
        calc_eventms(EEG);
    end
end