function [EEG] = mv_check_ica(EEG,p)
if ~check_EEG(EEG.preprocess,'Clean')
     fprintf('Loading Cleaining Times \n')
    EEG = mv_clean_continuous(EEG,p,1);
end
if ~check_EEG(EEG.preprocess,'ICA')
    fprintf('Loading ICA \n')
    EEG = mv_load_ICA(EEG,p,1);
end
if ~check_EEG(EEG.preprocess,'Dipole')
    fprintf('Loading Dipole \n')
    EEG = mv_fit_dipole(EEG,p);
end

end
