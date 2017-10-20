function [badEEG badVR] = mv_readCommentXLS(p)
%% Reads out the p.full.comment xls file

try
    num = csvread(p.full.comment,0,0);
catch
    num = csvread(p.full.comment,1,0);
end

badEEG = num(:,2)';
badVR = num(:,1)';