function [behavResults] = stat_checkVarianceEqualityPairwise(concPP, behavResults)
% Calculates the pairwise comparisons and stores them to behavResults
% Once with winsorized data and once with unwinsorized data
% The first two columns are the conditions that are compaired pairwise
% For the signific_NoOfSubjs_LevenePairwise and
% signific_NoOfSubjs_LevenePairwise_WIN matrices, the third column means
% the number of subjects where this pairwise comparison was significant.
% The fourth column tells in how many subjects (of those that were
% significant) the variance of the errors in the condition of the first column
% was higher than the variance of the errors in the condition thats written in 
% the second column
%% TODO: Check how strict we should be with outliers, use WINSORIZING or
%% not?

condPairs = [1, 2; 1, 3; 1, 4; 2, 3; 2, 4; 3, 4];
alpha = 0.0083;  % not even 0.0100 yields more significant results
% %% Do it with winsorized errors
% for vp = 1:numel(unique(concPP.vp))
%     for cp = 1:length(condPairs)
%         err = concPP.winsErrorT;
%         
%         cnd1 = condPairs(cp, 1);
%         cnd2 = condPairs(cp, 2);
%         if vp == 1
%             counts(cp, 1:2) = [cnd1, cnd2];
%             counts(cp, 3) = 0;
%             counts(cp, 4) = 0;
%         end
%         errsCnd1 = err(concPP.vp == vp & concPP.condCoded == cnd1);
%         errsCnd2 = err(concPP.vp == vp & concPP.condCoded == cnd2);        
%         % 'on' displays the statistics, 'off' does not display them
%         p = vartestn([errsCnd1, errsCnd2]', [ones(1,numel(errsCnd1)), 2*ones(1,numel(errsCnd2))]', 'off', 'robust');  % robust performs the levene test instead of bartletts
%         behavResults.(['vp', num2str(vp), 'LevenePairwise_WINS'])(cp, :) = [cnd1, cnd2, p];
%         counts(cp, 3) = counts(cp, 3) + (p<alpha);  % Count how many significant effects in how many conditions we have
%         %% In the last column write in how many significant cases the
%         %% variance of the first variable is higher
%         if nanvar(errsCnd1) > nanvar(errsCnd2)
%             counts(cp, 4) = counts(cp, 4) + (p<alpha);
%         end
%     end
% end
% 
% behavResults.(['signific_NoOfSubjs_LevenePairwise_WINS']) = counts;
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Do it with outlierfree (Keep 4xIQ) errors
% for vp = 1:numel(unique(concPP.vp))
%     for cp = 1:length(condPairs)
%         err = concPP.outlierFreeErrors;
%         
%         cnd1 = condPairs(cp, 1);
%         cnd2 = condPairs(cp, 2);
%         if vp == 1
%             counts(cp, 1:2) = [cnd1, cnd2];
%             counts(cp, 3) = 0;
%             counts(cp, 4) = 0;
%         end
%         errsCnd1 = err(concPP.vp == vp & concPP.condCoded == cnd1);
%         errsCnd2 = err(concPP.vp == vp & concPP.condCoded == cnd2);        
%         % 'on' displays the statistics, 'off' does not display them
%         p = vartestn([errsCnd1, errsCnd2]', [ones(1,numel(errsCnd1)), 2*ones(1,numel(errsCnd2))]', 'off', 'robust');  % robust performs the levene test instead of bartletts
%         behavResults.(['vp', num2str(vp), 'LevenePairwise_Outlierfree'])(cp, :) = [cnd1, cnd2, p];
%         counts(cp, 3) = counts(cp, 3) + (p<alpha);  % Count how many significant effects in how many conditions we have
%         %% In the last column write in how many significant cases the
%         %% variance of the first variable is higher
%         if nanvar(errsCnd1) > nanvar(errsCnd2)
%             counts(cp, 4) = counts(cp, 4) + (p<alpha);
%         end
%     end
% end
% 
% behavResults.(['signific_NoOfSubjs_LevenePairwise_Outlierfree']) = counts;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Do it with unwinsorized errors
for vp = 1:numel(unique(concPP.vp))
    for cp = 1:length(condPairs)
        err = concPP.errors_T;
        
        cnd1 = condPairs(cp, 1);
        cnd2 = condPairs(cp, 2);
        if vp == 1
            counts(cp, 1:2) = [cnd1, cnd2];
            counts(cp, 3) = 0;
            counts(cp, 4) = 0;
        end
        errsCnd1 = err(concPP.vp == vp & concPP.condCoded == cnd1);
        errsCnd2 = err(concPP.vp == vp & concPP.condCoded == cnd2);        
        % 'on' displays the statistics, 'off' does not display them
        p = vartestn([errsCnd1, errsCnd2]', [ones(1,numel(errsCnd1)), 2*ones(1,numel(errsCnd2))]', 'off', 'robust');  % robust performs the levene test instead of bartletts
        behavResults.(['vp', num2str(vp), 'LevenePairwise'])(cp, :) = [cnd1, cnd2, p];
        counts(cp, 3) = counts(cp, 3) + (p<alpha);  % Count how many significant effects in how many conditions we have
        %% In the last column write in how many significant cases the
        %% variance of the first variable is higher
        if nanvar(errsCnd1) > nanvar(errsCnd2)
            counts(cp, 4) = counts(cp, 4) + (p<alpha);
        end
    end
end

behavResults.(['signific_NoOfSubjs_LevenePairwise']) = counts;
