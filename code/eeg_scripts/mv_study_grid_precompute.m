function [STUDY,ALLEEG] = mv_study_grid_precompute(STUDY,ALLEEG,varargin)
%% mv_study_grid_precompute(STUDY,ALLEEG,[only needed for running locally],[only needed for running locally])
% starts the precomputing on the grid
if nargin >2 
    if varargin{1} > 4
        error('you have no Idea what you are doing, ahve you?')
    end
    kLim = 9;
    steps = 1:10:length(STUDY.design(1).cell);
    steps = steps(varargin{1});
    fprintf('Steps: %i, kLim: %i \n',steps,kLim)
else
    steps = 1:4:length(STUDY.design(1).cell);
    kLim = 1;
end
for t = steps
    %     [~, ~, ~ ,~, e, ~, ~] = regexp(STUDY.design(1).cell(t).case,'VP([\d])S([\d])C([\d])');
    %     subj = str2num(e{1}{1});
    %     ses = str2num(e{1}{2});
    %     cond = str2num(e{1}{3});
    %     if flags.setERSPprecomp(flags.vp== subj&flags.session==ses&flags.condition==cond)
    %         fprintf('Already Calculated %s, skipping ... \n',STUDY.design(1).cell(t).case);
    %     else
    cmd = [      '[STUDY ALLEEG] = mv_study_generate; '];
    for k = 0:kLim;
        if t+k>length(STUDY.design(1).cell);
            break
        end
        cmd = [cmd '[STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, ''components'','...
            '''cell'', [' num2str([t+k]) '], '...
            '''design'',1,'...
            '''recompute'',''on'',' ...
            ...%'''erp'',''on'',''erpparams'',{''rmbase'' [-5500 -1500] ''},' ... %no Timewarp for ERP!
            '''scalp'',''on'',' ...
            '''spec'',''on'',''specparams'',{''specmode'' ''fft'' ''freqrange'' [1 120] ''timerange'' [0 3500]},' ... % no timewarp for SPEC\
            ...%'''spec'',''on'',''specparams'',{''specmode'' ''fft'' ''freqrange'' [1 120] ''timerange'' [0 3500] ''alpha'' 0.05},' ... % no timewarp for SPEC
            '''savetrials'',''off'',' ...
            '''ersp'',''on'',''erspparams'',{''cycles'' [3 0.5] ''freqs'' [1 50]  ''baseline'' [-6000,-3500] ''timewarpms'',[-6000 -3500 0 4250],''trialbase'',''full'',''savetrials'',''on''});'];
    end
    if nargin < 3
    mv_grid_ready(60);
    mv_grid_start_cmd(cmd,'mv_ersps',t);
    else
        fprintf('Running Locally \n')
        eval(cmd)
    end
    %     end
    
end
end