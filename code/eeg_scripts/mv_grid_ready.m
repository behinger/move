function mv_grid_ready(varargin)
%% this functions waits 60s and checks whether the runtime_grid_script.m is
%% available or not. 
% It has a simple preocess bar. It will throw an error if the gridfile
% still exists after 60s
if nargin == 1
    waitTime = varargin{1};
else
    waitTime = 60;
end
fprintf(['Waiting up to ' num2str(60) 's until gridfile is free again:'])
timeTrue = true;
tic
while timeTrue
    if ~exist('/net/store/projects/move/eeg/grid/runtime_grid_script.m','file')
        timeTrue = false;
    end
    if mod(toc,10)<1
        fprintf(':')
    else
        fprintf('.');
    end
    WaitSecs(1);
    if toc>waitTime
        error('Gridfile has not been deleted by the last job! Investigate!')
    end
end
end