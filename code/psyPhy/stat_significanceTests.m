function [behavResults] = stat_significanceTests(concPP, save_behavResults)

%% 1. Constants
nrVPs = 5;
nrConds = 4;
angles = [-90, -60, -30, 30, 60, 90];
nrAngles = numel(angles);
differentErrors = 2;


errorsVect = concPP.winsErrorT;
condVect = concPP.condCoded;
vpVect = concPP.vp;
% errorsVect = trimmed.winsErrorT;
% condVect = trimmed.condCoded;
% vpVect = trimmed.vp;


%% Compute means and SD over conditions:
for cond = 1:4
    behavResults.meansAbsErrOverCond(cond) = nanmean(abs(concPP.winsErrorT(concPP.condCoded == cond)));
    behavResults.meansRelErrOverCond(cond) = nanmean((concPP.winsErrorT(concPP.condCoded == cond)));
    behavResults.SD_absErrOverCond(cond) = nanstd(abs(concPP.winsErrorT(concPP.condCoded == cond)));
    behavResults.SD_relErrOverCond(cond) = nanstd((concPP.winsErrorT(concPP.condCoded == cond)));
end

%% Compute means and SD for VPS:
for vp = 1:nrVPs
    behavResults.meansAbsErr_VP(vp) = nanmean(abs(concPP.winsErrorT(concPP.vp == vp)))';
    behavResults.meansRelError_VP(vp) = nanmean((concPP.winsErrorT(concPP.vp == vp)))';
    behavResults.SD_AbsErr_VP(vp) = nanstd(abs(concPP.winsErrorT(concPP.vp == vp)))';
    behavResults.SD_RelErr_VP(vp) = nanstd((concPP.winsErrorT(concPP.vp == vp)))';
end

%% Compute means and SD for turningAngles:
for angle = angles
    behavResults.meansAbsErr_tAngles(find(angles == angle)) = nanmean(abs(concPP.winsErrorT(concPP.turningAnglePerfect == angle)));
    behavResults.meansRelError_tAngles(find(angles == angle)) = nanmean((concPP.winsErrorT(concPP.turningAnglePerfect == angle)));
    behavResults.SD_AbsErr_tAngles(find(angles == angle)) = nanstd(abs(concPP.winsErrorT(concPP.turningAnglePerfect == angle)));
    behavResults.SD_RelErr_tAngles(find(angles == angle)) = nanstd((concPP.winsErrorT(concPP.turningAnglePerfect == angle)));
end


%% Compute means and SD for VPS and cond:
for cond = 1:nrConds
    for vp = 1:nrVPs
        behavResults.meansAbsErr_CondVP(vp, cond) = nanmean(abs(concPP.winsErrorT(concPP.condCoded == cond & concPP.vp == vp)));
        behavResults.meansRelError_CondVP(vp, cond) = nanmean((concPP.winsErrorT(concPP.condCoded == cond & concPP.vp == vp)));
        behavResults.SD_AbsErr_CondVP(vp, cond) = nanstd(abs(concPP.winsErrorT(concPP.condCoded == cond & concPP.vp == vp)));
        behavResults.SD_RelErr_CondVP(vp, cond) = nanstd((concPP.winsErrorT(concPP.condCoded == cond & concPP.vp == vp)));
    end
end


%% Compute ratio of nonturner trials out of non-winsorized data
nonTurnerTrials = find(abs(concPP.errors_T) > abs(concPP.errors_NT));
numberOfValidTrials = numel(concPP.errors_T) - numel(find(isnan(concPP.errors_T) == 1));
behavResults.nonTurnerTrialsPercent = numel(nonTurnerTrials) / numberOfValidTrials * 100;


%% Learning effect, correlations
errorsVect = concPP.winsErrorT;
condVect = concPP.condCoded;
vpVect = concPP.vp;
for typeError = 1:differentErrors  % Calculate permutation test for different errors (absolute and relative)
    if typeError == 1
        errors = abs(errorsVect); 
        sprintf(['VP', int2str(vp), ' Absolute Errors']);
    else
        errors = errorsVect;
        sprintf(['VP', int2str(vp), ' Under/Overshoot']);
    end
    for vp=1:5  %pooled over individual subjects
        [r,p] = corrcoef(errors(vpVect == vp),(1:numel(errors(vpVect == vp))),'rows','complete');
        if typeError == 1
            behavResults.correlAbsErr_p_Values(vp, 1) = vp;
            behavResults. correlAbsErr_p_Values(vp, 2) = r(2,1);
            behavResults.correlAbsErr_p_Values(vp, 3) = p(2,1);
        else
            behavResults.correlOverUnd_p_Values(vp, 1) = vp;
            behavResults.correlOverUnd_p_Values(vp, 2) = r(2,1);
            behavResults.correlOverUnd_p_Values(vp, 3) = p(2,1);
        end
    end
end


%% For the post-hoc test after significant angle in 4x6 ANOVA do seperate t-tests 
%% betweeen angles that yield no significant behavResults
% Maybe if we split up the persons in conditions again (so instead of one
% line for each person 4 lines) we get significant differences
meanSplitAngles = [];
counter = 1;
errors = concPP.winsErrorT;
for angle = [-90, -60, -30, 30, 60, 90] 
    for vp = 1:nrVPs
        meanSplitAngles(vp, counter) = nanmean(errors((concPP.vp == vp) & (concPP.turningAnglePerfect == angle)));     
    end
    counter = counter + 1;
end
nrCombis = nchoosek(6,2);
combinAngles = [1, 2; 1, 3; 1, 4; 1, 5; 1, 6; 2, 3; 2, 4; 2, 5; 2, 6; 3, 4; 3, 5; 3, 6; 4, 5; 4, 6; 5, 6];
behavResults.t_Tests_TurningAngles = nan(nrCombis, 4);
behavResults.t_Tests_TurningAngles(:, 1:2) = combinAngles;
for comb = 1:nrCombis
%     sprintf(['Conditions ', int2str([combinAngles(comb, 1),combinAngles(comb, 2)])]);
    [h, p] = ttest(meanSplitAngles(:, combinAngles(comb, 1)), meanSplitAngles(:, combinAngles(comb, 2)));  % paired-sample ttest
    behavResults.t_Tests_TurningAngles(comb, 3) = h;
    behavResults.t_Tests_TurningAngles(comb, 4) = p;
end

% If we split up the persons in conditions again (so instead of one
% line for each person 4 lines) we do not get any significant differences
% either
meanSplitAnglesCond = [];
counter = 1;
errors = concPP.winsErrorT;
for angle = [-90, -60, -30, 30, 60, 90] 
    for vp = 1:nrVPs
        for cond = 1:nrConds
            meanSplitAnglesCond(((vp-1)*nrConds)+cond, counter) = nanmean(errors((concPP.vp == vp) & (concPP.turningAnglePerfect == angle) & (concPP.condCoded == cond)));     
        end
    end
    counter = counter + 1;
end
nrCombis = nchoosek(6,2);
combinAngles = [1, 2; 1, 3; 1, 4; 1, 5; 1, 6; 2, 3; 2, 4; 2, 5; 2, 6; 3, 4; 3, 5; 3, 6; 4, 5; 4, 6; 5, 6];
behavResults.t_Tests_TurningAnglesCond = nan(nrCombis, 4);
behavResults.t_Tests_TurningAnglesCond(:, 1:2) = combinAngles;
for comb = 1:nrCombis
%     sprintf(['Conditions ', int2str([combinAngles(comb, 1),combinAngles(comb, 2)])])
    [h, p] = ttest(meanSplitAnglesCond(:, combinAngles(comb, 1)), meanSplitAnglesCond(:, combinAngles(comb, 2)));  % paired-sample ttest
    behavResults.t_Tests_TurningAnglesCond(comb, 3) = h;
    behavResults.t_Tests_TurningAnglesCond(comb, 4) = p;
end



%% Statcond
%% ... can perform standard parametric or nonparametric permutation-based 
%% ANOVA (1-way or 2-way) or t-test methods
% Problem of the statcond script: Does not take Nans!!!!
% TwobyTwoStruct = {abs(concPP.winsErrorT(concPP.condCoded == 1)) abs(concPP.winsErrorT(concPP.condCoded == 2)); ...
%               abs(concPP.winsErrorT(concPP.condCoded == 3)) abs(concPP.winsErrorT(concPP.condCoded == 4))}; 
%         % pseudo (2,3)-condition data array, each entry containing 
%         %                                    ten (3,4) data matrices
% [F df pvals] = statcond(TwobyTwoStruct);  % perform a paired 2-way ANOVA 
% Output:
% pvals{1} % a (3,4) matrix of p-values; effects across columns
% pvals{2} % a (3,4) matrix of p-values; effects across rows 
% pvals{3} % a (3,4) matrix of p-values; interaction effects



%% PERMUTATION TESTS

%% If we shuffle the values randomly and assign
%% them to conditions, then we will destroy any association between the condition and error (the null hypothesis). 
%% Therefore, the distribution of the test statistic obtained from repeated random shuffling, 
%% can be used to approximate the null distribution of the test statistic.

% Compare the difference for individual subjects
alpha = 0.0083;

pairs = [1, 2 ; 1, 3; 1, 4; 2, 3; 2, 4; 3, 4];
errors = concPP.winsErrorT;
behavResults.signigic_NoOfSubj_PermutPVal_WINS = zeros(6, 4); % Zeros as it is used for summing up
behavResults.signigicPermutPVal_SubjNumb_WINS = NaN(6, 5); 
for vp = 1 : nrVPs
    behavResults.(['perm_p_Val_vp', num2str(vp)]) = nan(6, 3);
    for pair = 1:6 % Compare all conditions       
        behavResults.(['perm_p_Val_vp', num2str(vp)])(pair,1:2) = pairs(pair,:);  % Fill the array with the first conditions that are 
        behavResults.signigic_NoOfSubj_PermutPVal_WINS(pair,1:2)  = pairs(pair,:);
        cond1 = pairs(pair, 1);
        cond2 = pairs(pair, 2);
        poolData = [errors(condVect == cond1 & vpVect == vp) errors(condVect == cond2 & vpVect == vp)]';
        numberOfPermutations = 4000;
        diffMeans = nan(1, numberOfPermutations);
        for i = 1:numberOfPermutations
            permIndices = randperm(numel(poolData));
            permutatedData = poolData(permIndices);
            diffMeans(i) = nanmean(permutatedData(1:numel(poolData)/2)) - nanmean(permutatedData(numel(poolData)/2+1 : numel(poolData)));
        end
        realDiffMean = nanmean(errors(condVect == cond1 & vpVect == vp)) - nanmean(errors(condVect == cond2 & vpVect == vp));
        %% According to Bootstrap_Method, page 50, we can improve the
        %% estimate of the p value by adding one sample result more extreme
        %% than the observed statistic
        p_Permuation = (numel(find(abs(diffMeans) >= abs(realDiffMean)))+1) / (numberOfPermutations+1);  
    %         p_Permuation = numel(diffMeans(abs(diffMeans) >= abs(realDiffMean))) / numberOfPermutations;
        behavResults.(['perm_p_Val_vp', num2str(vp)])(pair, 3) = p_Permuation;
        behavResults.signigic_NoOfSubj_PermutPVal_WINS(pair, 3) = behavResults.signigic_NoOfSubj_PermutPVal_WINS(pair, 3) + (p_Permuation<alpha); % add 1 if p is significant      
        
        if nanmean(errors(condVect == cond1 & vpVect == vp)) > nanmean(errors(condVect == cond2 & vpVect == vp))
            behavResults.signigic_NoOfSubj_PermutPVal_WINS(pair, 4) = behavResults.signigic_NoOfSubj_PermutPVal_WINS(pair, 4) + (p_Permuation<alpha); % add 1 if p is significant and mean of cond1 is bigger than cond2
        end
        if (p_Permuation<alpha) && (nanmean(errors(condVect == cond1 & vpVect == vp)) > nanmean(errors(condVect == cond2 & vpVect == vp)))
             behavResults.signigicPermutPVal_SubjNumb_WINS(pair, vp) = 1;
        elseif (p_Permuation<alpha) && (nanmean(errors(condVect == cond1 & vpVect == vp)) < nanmean(errors(condVect == cond2 & vpVect == vp)))
             behavResults.signigicPermutPVal_SubjNumb_WINS(pair, vp) = -1;   
        end
    end
end
% hist(diffMeans)




% 
% %% PERMUTATION TESTS
% 
% %% If we shuffle the values randomly and assign
% %% them to conditions, then we will destroy any association between the condition and error (the null hypothesis). 
% %% Therefore, the distribution of the test statistic obtained from repeated random shuffling, 
% %% can be used to approximate the null distribution of the test statistic.
% 
% % Compare the difference between means of permutated conditions (compares
% % only two conditions at a time)
% differentErrors = 2;
% behavResults.perm_p_Values = nan(6, 3, differentErrors);
% pairs = [1, 2 ; 1, 3; 1, 4; 2, 3; 2, 4; 3, 4];
% for typeError = 1:differentErrors  % Calculate permutation test for different errors (absolute and relative)
%     if typeError == 1
%         % The nice thing is, the significant values do not change if you take the unwisorized
%         % abs(concPP.errors_T) or concPP.errors_T for typeError == 2
%         errors = abs(concPP.winsErrorT);  
%     else
%         errors = concPP.winsErrorT;
%     end      
%     behavResults.perm_p_Values(:,1, typeError) = pairs(:,1);  % Fill the array with the first conditions that are 
%     behavResults.perm_p_Values(:,2, typeError) = pairs(:,2);  % compared as first two columns
%     for pair = 1:6 % Compare all conditions
%         cond1 = pairs(pair, 1);
%         cond2 = pairs(pair, 2);
%         poolData = [errors(condVect == cond1) errors(condVect == cond2)]';
%         numberOfPermutations = 5000;
%         diffMeans = nan(1, numberOfPermutations);
%         for i = 1:numberOfPermutations
%             permIndices = randperm(numel(poolData));
%             permutatedData = poolData(permIndices);
%             diffMeans(i) = nanmean(permutatedData(1:numel(poolData)/2)) - nanmean(permutatedData(numel(poolData)/2+1 : numel(poolData)));
%         end
%     %     hist(diffMeans)
%         realDiffMean = nanmean(errors(condVect == cond1)) - nanmean(errors(condVect == cond2));
%         %% According to Bootstrap_Method, page 50, we can improve the
%         %% estimate of the p value by adding one sample result more extreme
%         %% than the observed statistic
%         p_Permuation = (numel(find(abs(diffMeans) >= abs(realDiffMean)))+1) / (numberOfPermutations+1);  
% %         p_Permuation = numel(diffMeans(abs(diffMeans) >= abs(realDiffMean))) / numberOfPermutations;
%         behavResults.perm_p_Values(pair, 3, typeError) = p_Permuation;
%     end
% end
% behavResults.perm_p_Values  % print the behavResults
% % hist(diffMeans)




%% Exact permutation test for the 5x4 matrix (means of subjects), has to be
%% checked again
%% TODO (If we want to use it): Check if        
%% p_Permuation = numel(diffMeans(abs(diffMeans) >= abs(realDiffMean))) / factorial(nrVPs * 2);  % absolute value in 2-sided testings    
%% really is correct
% differentErrors = 2;
% behavResults.permExact_p_Values = nan(6, 3, differentErrors);
% pairs = [1, 2 ; 1, 3; 1, 4; 2, 3; 2, 4; 3, 4];
% for typeError = 1:2  % Calculate permutation test for different errors (absolute and relative)
%     if typeError == 1
%         errors = behavResults.meansAbsErr_CondVP;  
%     else
%         errors = behavResults.meansRelError_CondVP;
%     end    
%     behavResults.permExact_p_Values(:,1, typeError) = pairs(:,1);  % Fill the array with the first conditions that are
%     behavResults.permExact_p_Values(:,2, typeError) = pairs(:,2);  % compared as first two columns
%     for pair = 1:6 % Compare all conditions
%         cond1 = pairs(pair, 1);
%         cond2 = pairs(pair, 2);
%         poolData = [errors(:,cond1) errors(:,cond2)]';
%         exactPermutatedData = perms(poolData);  % PERMS not RANDPERM!!
%         diffMeans = nanmean(exactPermutatedData(:, (1:nrVPs)), 2) - nanmean(exactPermutatedData(:, (nrVPs+1:nrVPs * 2)), 2);
%         realDiffMean = nanmean(errors(:, cond1)) - nanmean(errors(:, cond2));
%         p_Permuation = numel(diffMeans(abs(diffMeans) >= abs(realDiffMean))) / factorial(nrVPs * 2);  % absolute value in 2-sided testings    
%         behavResults.permExact_p_Values(pair, 3, typeError) = p_Permuation;
%     end
% end




%% Signed (Vorzeichen) Test, has to be revisited
% %% Yields probably invalid behavResults
% behavResults.sign_p_Values = nan(6, 3, differentErrors);
% % pairs = [1, 2 ; 1, 3; 1, 4; 2, 3; 2, 4; 3, 4];
% % errorsVect = trimmed.winsErrorT;
% % condVect = trimmed.condCoded;
% % vpVect = trimmed.vp;
% for typeError = 1:differentErrors  % Calculate permutation test for different errors (absolute and relative)
%     if typeError == 1
%         % The nice thing is, the significant values do not change if you take the unwisorized
%         % abs(concPP.errors_T) or concPP.errors_T for typeError == 2
%         errors = abs(errorsVect);  
%     else
%         errors = errorsVect;
%     end
%     pairs = [1, 2; 1, 3; 1, 4; 2, 3; 2, 4; 3, 4];
%     behavResults.sign_p_Values(:,1, typeError) = pairs(:,1);  % Fill the array with the first conditions that are 
%     behavResults.sign_p_Values(:,2, typeError) = pairs(:,2);  % compared as first two columns
%     
%     for pair = 1:6 % Compare all conditions
%         cond1 = pairs(pair, 1);
%         cond2 = pairs(pair, 2);      
%         tmpErrors1 = errors(condVect == cond1);
%         tmpErrors1(isnan(tmpErrors1)) = []; 
%         tmpErrors2 = errors(condVect == cond2);
%         tmpErrors2(isnan(tmpErrors2)) = []; 
%         cutBorder = min(numel(tmpErrors1), numel(tmpErrors2));
%         tmpErrors1 = tmpErrors1(1:cutBorder);
%         tmpErrors2 = tmpErrors2(1:cutBorder);
%         behavResults.sign_p_Values(pair, 3, typeError) = signtest(tmpErrors1, tmpErrors2);
%     end
% end

if save_behavResults
    path = '/net/store/projects/move/move_svn/code/MAT_datafiles/behavResults_13-03-2013.mat';
    save(path, 'behavResults')
    sprintf(['A new file behavResults_XX.mat is saved to:\n', path])
else 
    sprintf(['No new behavResults_XX.mat is saved.'])
end


