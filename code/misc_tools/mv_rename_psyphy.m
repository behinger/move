%ask for directory
destDir = uigetdir('/net/store/projects/move/eeg');
%get content of dir
destCont = dir(destDir); %content

newName = inputdlg('What should the new subject be called?')
newName = newName{1};
for k = 1:length(destCont)
    
    [startInd,endInd,tokInd,matStr,tokenStr,exprNam] = regexpi(destCont(k).name,'Participant_([0-9][.]?[0-9])');
    if ~isempty(tokenStr)
        tmpName = destCont(k).name;
        tmpName(tokInd{1}(1):tokInd{1}(2)) = [];
        
        tmpName = [tmpName(1:tokInd{1}(1)-1) newName tmpName(tokInd{1}(1):end)];
        movefile(fullfile(destDir,destCont(k).name),fullfile(destDir,tmpName))
    end
    
end
[startInd,endInd,tokInd,matStr,tokenStr,exprNam] = regexpi(destDir,'Participant_([0-9][.]?[0-9])');
if ~isempty(tokenStr)
    tmpDir = destDir;
    tmpDir(tokInd{1}(1):tokInd{1}(2)) = [];
    tmpDir = [tmpDir(1:tokInd{1}(1)-1) newName tmpDir(tokInd{1}(1):end)];
    
    movefile(destDir,tmpDir)
else
    error('could not rename the directory')
end