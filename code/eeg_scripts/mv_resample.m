function [EEG] = mv_resample(EEG,p,varargin)
    if nargin < 3
        newSamp = 512;
    elseif nargin == 3
        newSamp = varargin{1};
    else
        error('Nargin seems to be wrong %i',nargin)
    end
        
p = mv_generate_paths(p);
% if ~check_EEG(EEG.preprocess,'Resample')

    EEG = pop_resample( EEG, newSamp);
    EEG.preprocessInfo.resampleDate = datestr(now);
    EEG.preprocess = [EEG.preprocess 'Resample'];
% end