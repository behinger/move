function [] = mv_study_prepSet(varargin)
flags = mv_check_folderstruct;
if nargin == 1
    select = varargin{1};
else
  select = 1:44; %select all
end
for k = select%(1:10)
    p = mv_generate_paths(flags.path{k});
    
    [EEG] = mv_load_set2(p,1);
    try
    EEG = mv_load_ICA(EEG,p,5);
    catch
        fprintf('%i',k);
    break
    end
    EEG = mv_fit_dipole(EEG,p);
%     
    EEG = mv_epoch(EEG,p);
    EEG = mv_clean_trial(EEG,p,1);
    EEG.preprocess = [EEG.preprocess 'Study03-04-13'];
    pop_saveset(EEG,'filename',EEG.preprocess,'filepath',p.path.set2,'savemode','twofiles')
    
end