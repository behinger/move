% Analysis of MOVE behavioral data

% Runs the stat_removeOutliers() function that returns the concPP including winsorized outlier-free data.
% stat_significaneTests() calls a function that calculates several tests and generates means and SDs and percents of 
% non-turner trials. It stores it to a structure called behavResults.
% stat_writeMeansToTXTforSPSS() outputs four textfiles with means (e.g.
% over vps) arranged in a matrix for further

close all;
% do not make a clear all or else the paths are removed


[concPP] = stat_removeOutliers();


save_behavResults = true;  % save the results to MAT_datafiles ?
[behavResults] = stat_significanceTests(concPP, save_behavResults);

behavResults = stat_storeVariance(concPP, behavResults);

behavResults = stat_checkVarianceEquality(concPP, behavResults);
behavResults = stat_checkVarianceEqualityPairwise(concPP, behavResults);

% STDs of conditions, trialwise!!
for cnd = 1:4
   behavResults.stdTrialwiseAbsError(cnd) = nanstd(abs(concPP.errors_T(concPP.condCoded == cnd)));
   behavResults.stdTrialwiseRelError(cnd) = nanstd(concPP.errors_T(concPP.condCoded == cnd));  % not really relevant
end

nanmean(behavResults.meansRelError_CondVP, 1)

nanmean(behavResults.meansAbsErr_CondVP, 1)
nanstd(behavResults.meansAbsErr_CondVP, 1)
[p, table stats] = anova1(behavResults.meansAbsErr_CondVP)

if save_behavResults
    path = '/net/store/projects/move/move_svn/code/MAT_datafiles/behavResults_06-05-2013.mat';
    save(path, 'behavResults')
    sprintf(['A new file behavResults_XX.mat is saved to:\n', path])
else 
    sprintf(['No new behavResults_XX.mat is saved.'])
end

stat_writeMeansToTXTforSPSS(concPP, behavResults);  % Write the behavioral data to a txt
% file in order to import it for SPSS, TODO: Remove array generation (and
% concPP as input) but take the arrays from behavResults, that are not 
% used at the moment
