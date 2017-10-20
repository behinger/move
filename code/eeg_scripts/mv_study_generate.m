function [STUDY ALLEEG] = mv_study_generate(varargin)
%% Generates the study containing all datasets flagged in the
% flags.setStudy
% Varargin for backwards compatibility
STUDY = [];
ALLEEG = [];
EEG = [];
flags = mv_check_folderstruct;
cond = {'a-passive','b-proprio','c-vestib','d-active'};

indRun = 1;
select = 1:44;

for k = select%(1:10)
    
    p = mv_generate_paths(flags.path{k});
    
    %     command_cell{indRun} =  { 'index', indRun, 'load', p.full.sets{flags.setStudy(k)}, 'subject',['VP' num2str(flags.vp(k)) 'S' num2str(flags.session(k)) 'C' num2str(flags.condition(k))]};%, 'condition'};%, cond{flags.condition(k)} };
    command_cell{indRun} =  { 'index', indRun, ...
        'load', p.full.sets2{flags.setStudy(k)}, ...
        'subject',['VP' num2str(flags.vp(k)) 'S' num2str(flags.session(k))], ...
        'condition' num2str(cond{flags.condition(k)})};  %,'session', flags.session(k) };
    indRun = indRun+1;
end

[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'commands', [ command_cell {{ 'inbrain' 'on' 'dipselect' 0.15 }}]);
STUDY.name = 'MOVE Study all Cond';
STUDY.task = 'Passive(1) Proprioceptive(2) Vestibular(3) Active(4)';
designPath = [p.path.study filesep 'study_02-04-13' filesep 'design' num2str(1)];
if ~exist(designPath,'dir')
    mkdir(designPath);
end
STUDY = std_makedesign(STUDY, ALLEEG, 1, 'variable1','condition','name','cycles [3 0.5] fulltrial inbrain rV<0.15','filepath',designPath);
