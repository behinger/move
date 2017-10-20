rmpath('/opt/matlab/toolbox/spm5')

addpath(genpath('/net/store/projects/move/move_svn/code/eeg_scripts'))
addpath('/net/store/projects/move/eeglab/')
addpath('/net/store/projects/move/move_svn/code/ressources/amica/')


%% define path
newScriptname = ['/net/store/projects/move/eeg/grid/currently_running_on_grid_' datestr(now,'mmddyy_HHMMSS') '.m'];
[status message] = copyfile('/net/store/projects/move/eeg/grid/runtime_grid_script.m',newScriptname);


fprintf('Copied Runtime_Grid_script \n')

% delete the file after copying
delete('/net/store/projects/move/eeg/grid/runtime_grid_script.m');
fprintf('Deleted runtime_grid_script \n')
fprintf('running %s \n',newScriptname)
fprintf('Loading EEGlab \n')

%start eeglab
eeglab
fprintf('EEGlab Loaded \n')

%run the script
run(newScriptname);
fprintf('Script Finished \n')

%delete it after finishing
delete(newScriptname)
fprintf('Deleted Scriptfile \n')
fprintf('finished %s',datestr(now))