function [EEG,p] = mv_load_set2(p,varargin)
if ischar(p)
    p = mv_generate_paths(p);
end
if nargin >= 2
    if ~isnumeric(varargin{1})
        error('Setselection has to be a Number')
    end
    setIdx = varargin{1};
else
    for i = 1:length(p.full.sets2)
        fprintf('%i : %s | %s \n',i,p.full.sets2Date{i}, p.full.sets2{i});
    end
    setIdx=input('Please choose a Set to load: ');
end
if nargin ==3
    loadmode = varargin{2};
else
        loadmode ='all';
end

EEG = pop_loadset('filename',p.full.sets2{setIdx},'loadmode',loadmode);



end