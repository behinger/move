function [p] = mv_amica_newFolder(folderName)
%Generates a folder for a new ICA with the given folderName
% Example:
%  mv_amica_newFolder('epoched-15_15')
% Will generate a new folder for all session-cond-folders e.g.:
% /eeg/VP02/S01Active/amica/epoched-15_15
if nargin ~= 1
    help mv_amica_newFolder
    error('Wrong Input number')
end
if ~ischar(folderName)
    error('FolderName has to be a string')
end
flags = mv_check_folderstruct;

for k = 1:length(flags.path)
    p = mv_generate_paths(flags.path{k});
    mkdir([p.path.amica filesep folderName]);
    
end