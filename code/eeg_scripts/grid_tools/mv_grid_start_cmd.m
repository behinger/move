function [] = mv_grid_start_cmd(cmd_grid,varargin)
%% This function gets as input a command
% This command is executed on the grid. There are many paths added to the
% matlab grid execution paths (e.g. eeglab, the move eegscript folder) but
% also the current working directory is changed to be
% eeg_scripts/grid_tools
% mv_grid_start_cmd(cmd,[..job_name],[..job-number],[..requirements])
% requirements e.g. num_proc=8,exclusive=true (default)
if nargin > 4
    help mv_grid_start_cmd
    error('Too many input arguments')
end
if nargin > 1
    job_name = varargin{1};
else
    job_name = 'move_gridjob';
end
if nargin > 2 
    if ~isnumeric(varargin{2})
        error('the third parameter has to be a (job)-number!')
    end
    t = num2str(varargin{2});
else
    t = num2str(1);
end;
if nargin ==4
    if ~ischar(varargin{3})
        error('Requirements have to bee a string')
    end
    requirements = varargin{3};
else
%     requirements = ' -q ikw@*&(*sinope*) ';
%      requirements = 'mem_free=33G'; %for ramsauer
%     requirements = 'num_proc=8,exclusive=true,mem_free=14G';
  requirements = 'num_proc=8,exclusive=true';
%   requirements = 'num_proc=8';
%    requirements = 'exclusive=true'; %-q ikw@*&!(*picture*) 
    
end
if exist('/net/store/projects/move/eeg/grid/runtime_grid_script.m','file')
    error('The runtime_grid_script already exists! PLease delete it before starting new grid jobs')
end
    
fid = fopen('/net/store/projects/move/eeg/grid/runtime_grid_script.m','w');
fprintf(fid,cmd_grid);
fclose(fid);
% save('/net/store/projects/move/eeg/amica_grid/runtime_grid.mat','p','chosenSet','amicaChosenPath');

cmd = [];
cmd = [cmd 'cd /net/store/projects/move/move_svn/code/eeg_scripts/grid_tools; umask 0002;'];

% cmd = [cmd 'qsub -cwd -t 1 -l num_proc=8 -N move_gridjob -q ikw grid_shell_start_matlab.sh'];
cmd = [cmd 'qsub -cwd -t ' t ' -o /net/store/projects/move/eeg/grid/oLogs/ -e /net/store/projects/move/eeg/grid/eLogs/ -l ' requirements ' -N ' job_name '  -q ikw grid_shell_start_matlab.sh'];
fprintf('\n%s \n',cmd) %debug, for real result ucomment
[status,result] = system(cmd);
fprintf('st: %i \t res: %s',status,result)