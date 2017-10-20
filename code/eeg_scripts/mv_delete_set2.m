function [p] = mv_delete_set2(setname)

%Deletes a folder with ICA with the given folderName

if nargin ~= 1
    help mv_delete_set
    error('Wrong Input number')
end
if ~ischar(setname)
    error('setname has to be a string')
end
flags = mv_check_folderstruct;

for k = 1:length(flags.path)
     p = mv_generate_paths(flags.path{k});
    for l = 1:length(p.full.sets2)
        if isempty(strfind(p.full.sets2{l},setname)) 
        fprintf('Deleting: %s \n',p.full.sets2{l})
%         delete(p.full.sets2{l})
%         delete([p.full.sets2{l}(1:end-3) 'fdt'])
%         delete([p.full.sets2{l}(1:end-3) 'icaersp'])
%         delete([p.full.sets2{l}(1:end-3) 'icafdt'])
%         delete([p.full.sets2{l}(1:end-3) 'icatopo'])
        end
    end
    
    
end


% VP04S03proprioFiltfirResampleXensorNoisychannelRerefavIcaEpochStudy.set