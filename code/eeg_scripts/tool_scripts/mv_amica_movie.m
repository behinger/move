% ICA runtime aquisition
if ~exist('flags','var')
    flags = mv_check_folderstruct;
end
[EEG p] = mv_load_set2(flags.path{4},1,'info');
% addpath('~/Documents/MATLAB/common_eeg_scripts/')
% p = bs_generate_paths('/net/store/nbp/EEG/blind_spot/data/VPA3');
% EEG = be_load_set(p,1,'info');
    aIdx = 4;
    tmp = dir(p.amica.path{aIdx});  
    
if strcmp(tmp(12).name,'history')
    histDir = dir([p.amica.path{aIdx} filesep 'history']);
    
    for k = 1:length(histDir)-3
    f = figure;
    mod = loadmodout12([p.amica.path{aIdx} filesep 'history' filesep num2str(k*10)]);
    fprintf('Plotting history %i \n',k*10)
    winv = inv(mod.W*mod.S);
    for l = 1:20
        subplot(4,5,l)
        fprintf('%i,',l);
        topoplot(winv(:,l),EEG.chanlocs);
    end
    set(gcf,'Position',[1 25 1600 1070]);
    fprintf('\n')
    icaMovie(k,:) = getframe(f);
    close(f);
    end
    
end
    fprintf('fini \n')
    
    
%%
f = figure('Position',[1 25 1600 1070]);
movie(f,icaMovie,1,1)