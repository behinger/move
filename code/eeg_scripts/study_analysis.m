p = generate_paths('MOVEalexPilot6.cnt','/net/store/projects/move/eeg/alexPilot');


 if length(p.full.sets) > 1
        for i = 1:length(p.full.sets)
            fprintf('%i : %s | %s \n',i,p.full.setsDate{i}, p.full.sets{i})
        end
        sets_index=input('Please choose an set: ');
 else
        sets_index = 1;
 end
%% Generate Study(here only one file)
    
    

    
    %% Precompute channel measures
    
STUDY = std_makedesign(STUDY, ALLEEG, 1, 'variable1','','variable2','','name','ersp bsl [-5.5 -1.5]','subjselect',{'AL'});
STUDY = std_makedesign(STUDY, ALLEEG, 2, 'variable1','','variable2','','name','ersp bsl [-4 -2]','subjselect',{'AL'});
STUDY = std_makedesign(STUDY, ALLEEG, 3, 'variable1','cond','variable2','','name','ersp [-4 -2] Pos vs Neg','values1',{[30:30:90]  [-90:30:-30] },'subjselect',{'AL'});
STUDY = std_makedesign(STUDY, ALLEEG, 4, 'variable1','cond','variable2','','name','ersp [-4 -2] small vs big','values1',{[-90 90]  [-60 60]  [-30 30] },'subjselect',{'AL'});
STUDY = std_makedesign(STUDY, ALLEEG, 5, 'variable1','cond','variable2','','name','ersp [-4 -2] all individual','values1',{-90 -60 -30 30 60 90},'subjselect',{'AL'});
% with singleTrialBSl
STUDY = std_makedesign(STUDY, ALLEEG, 6, 'variable1','','variable2','','name','ersp [-4 -2] singleTrialBsl ','subjselect',{'AL'});
STUDY = std_makedesign(STUDY, ALLEEG, 7, 'variable1','cond','variable2','','name','ersp [-4 -2] singleTrialBsl Pos vs Neg','values1',{[30:30:90]  [-90:30:-30] },'subjselect',{'AL'});

STUDY = std_makedesign(STUDY, ALLEEG, 8, 'variable1','','variable2','','name','ersp [block] singleTrialBsl  ','subjselect',{'AL'});
%STUDY = std_makedesign(STUDY, ALLEEG, 5, 'variable1','cond','variable2','','name','ersp [-4 -2] all individual','values1',{-90 -60 -30 30 60 90},'subjselect',{'AL'});


%%

% load(p.full.powBase)
% optional_powbase = powBase
    %optional_powbase = '';
    
    for k = [6 7]
        STUDY = std_selectdesign(STUDY, ALLEEG, k);

        [STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, ...
            'components','recompute','on',...
            ... %'erp','on','erpparams',{'rmbase' [-5500 -1500] }, ...
            ... %'scalp','on', ...
            ... %'spec','on','specparams',{'specmode' 'fft'}, ...
            'ersp','on','erspparams',{'cycles' [0] 'freqs' [1 50]  'baseline' [-4000,-2000] 'timewarpms',[0 4250],'trialbase','full' });
    end
    
    %% selectdesig
    load(p.full.powBaseline)
    %%
    powSpecSelect = powSpec(STUDY.cluster.comps,:);
    
    for k = [8]
        STUDY = std_selectdesign(STUDY, ALLEEG, k);

        [STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, ...
            'components','recompute','on',...
            'ersp','on','erspparams',{'cycles' [0] 'freqs' [1 50] 'timewarpms',[0 4250],'powbase',powSpecSelect});
    end
    
    
    %% precluster

[STUDY ALLEEG] = std_preclust(STUDY, ALLEEG, [], ... 
	{'spec' 'npca' 10 'norm' 1 'weight' 1 'freqrange' [3 25]} , ... 
	{'erp' 'npca' 10 'norm' 1 'weight' 1 'timewindow' [-4000 8000]} , ... 
	{'dipoles' 'norm' 1 'weight' 10}, ...
    {'ersp' 'npca' 10 'freqrange' [3 25] 'cycles' [3 0.5] 'timewindow' [-4000 8000] 'norm' 1 'weight' 1});


%%
%sizeX = 650;
% sizeY = 350;
 compVec = [1:20];
% rowNr = round(1600/sizeX)+1;
% x =[repmat(sizeX*(0:rowNr-1),[],round(length(compVec)/rowNr))]';
% x = x(:);
% %y = [repmat(ones(1,rowNr),[],round(length(compVec)/rowNr))];
% y = 800-(repmat([0:round(length(compVec)/rowNr)-1],[],rowNr).*sizeY);
% y = y(:);
figure
for k = compVec
        subplot(4,5,k),
[STUDY erspdata ersptimes erspfreqs] = std_erspplot(STUDY,ALLEEG,'clusters',1, 'comps', k,'plotmode','none');
imagesc(ersptimes,erspfreqs,erspdata{1})
caxis([-7 7])
set(gca,'YDir','normal')
vline([-5500 -1500 4250 4400],{'r','r','b:','b'},{'T1','','','T2'})
title(num2str(STUDY.cluster.comps(k)))

    %std_erspplot(STUDY,ALLEEG,'clusters',1,'comps',k)
    %set(gcf,'Position',[x(k),y(k),sizeX,sizeY])
    %title(num2str(k))
end
