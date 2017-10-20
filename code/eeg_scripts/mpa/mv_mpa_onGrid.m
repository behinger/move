% get the STUDY and ALLEEG variables from workspace
% STUDY = evalin('base', 'STUDY;');
% ALLEEG = evalin('base', 'ALLEEG;');


% populate STUDY.measureProjection.option field with default option values.
if ~isfield(STUDY, 'measureProjection') || ~isfield(STUDY.measureProjection, 'option') || isempty(STUDY.measureProjection.option)
    
    % initialize the field
    if ~isfield(STUDY, 'measureProjection')
        STUDY.measureProjection = struct;
    end;
    assignin('base', 'STUDY', STUDY);
    
    show_gui_options(0, true);
    STUDY = evalin('base', 'STUDY;'); % get it back into this workspace.
end;


pop_savestudy(STUDY,EEG,'filename', 'mpaStudy.study', 'filepath','/net/store/projects/move/eeg/study');

%%

cmd = ['[STUDY,ALLEEG] = pop_loadstudy(''filename'', ''mpaStudy.study'', ''filepath'',''/net/store/projects/move/eeg/study'');'...
    'mv_mpa_init(STUDY,ALLEEG);'...
    'pop_savestudy(STUDY,EEG,''filename'', ''mpaStudy.study'', ''filepath'',''/net/store/projects/move/eeg/study'');' ];

mv_grid_start_cmd(cmd,'mv_mpa',1,'mf=30000m')