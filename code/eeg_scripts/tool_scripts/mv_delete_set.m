function [p] = mv_delete_set(setname)

%Deletes a folder with ICA with the given folderName
% Example:
%  mv_amica_newFolder('epoched-15_15')
% Will delete the folder and all contets
% /eeg/VP02/S01Active/amica/epoched-15_15
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
     eval(['!rm -R ' p.path.set2 '_old'])
    for l = 1:length(p.full.sets)
        if strfind(p.full.sets{l},setname)
        fprintf('Deleting: %s \n',p.full.sets{l})
        delete(p.full.sets{l})
        delete([p.full.sets{l}(1:end-3) 'fdt'])
        delete([p.full.sets{l}(1:end-3) 'icaersp'])
        delete([p.full.sets{l}(1:end-3) 'icafdt'])
        delete([p.full.sets{l}(1:end-3) 'icatopo'])
        end
    end
    
    
end


% VP04S03proprioFiltfirResampleXensorNoisychannelRerefavIcaEpochStudy.set