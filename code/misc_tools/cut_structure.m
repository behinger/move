function [data] = cut_structure(data,idxBeg,except)
%% this function cuts every element in idxBeg in the
% struct data
% usage: cut_structure(dataStruct,[1 3 5 7],{'fieldToExclude'})
% 1 3 5 7 are now deleted from the struct
if nargin < 3
except = [];
end
fn = fieldnames(data);
for tr = length(idxBeg):-1:1 % cut each trial, start with the last to not mess up the idx
    
    for m = 1:length(fn)
        if any(strcmp(fn{m},except)) %scip the except
            continue
        else
            
        data.(fn{m})(idxBeg(tr)) = [];
        end
    end
end


