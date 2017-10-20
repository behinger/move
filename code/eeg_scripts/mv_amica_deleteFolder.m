function [p] = mv_amica_deleteFolder(folderName)
%Deletes a folder with ICA with the given folderName
% Example:
%  mv_amica_newFolder('epoched-15_15')
% Will delete the folder and all contets
% /eeg/VP02/S01Active/amica/epoched-15_15
if nargin ~= 1
    help mv_amica_deleteFolder
    error('Wrong Input number')
end
if ~ischar(folderName)
    error('FolderName has to be a string')
end
flags = mv_check_folderstruct;

for k = 1:length(flags.path)
    p = mv_generate_paths(flags.path{k});
    try
    rmdir([p.path.amica filesep folderName],'s');
    catch
    end
%         rmdir(p.path.set2,'s')
    
end