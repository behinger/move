close all
[concPP] = stat_removeOutliers();

nrVPs = 5;
nrConds = 4;
angles = [-90, -60, -30, 30, 60, 90];
nrAngles = numel(angles);
differentErrors = 2;


errorsVect = concPP.winsErrorT;
condVect = concPP.condCoded;
vpVect = concPP.vp;

%% From the bootstrap PDF
differentErrors = 2;
behavResults.perm_p_Values = nan(6, 3, differentErrors);
pairs = [1, 2 ; 1, 3; 1, 4; 2, 3; 2, 4; 3, 4];
for typeError = 1:differentErrors  % Calculate permutation test for different errors (absolute and relative)
    if typeError == 1
        % The nice thing is, the significant values do not change if you take the unwisorized
        % abs(concPP.errors_T) or concPP.errors_T for typeError == 2
        errors = abs(concPP.winsErrorT);  
    else
        errors = concPP.winsErrorT;
    end      
    behavResults.perm_p_Values(:,1, typeError) = pairs(:,1);  % Fill the array with the first conditions that are 
    behavResults.perm_p_Values(:,2, typeError) = pairs(:,2);  % compared as first two columns
    for pair = 1:6 % Compare all conditions
        cond1 = pairs(pair, 1);
        cond2 = pairs(pair, 2);
        poolData = [errors(condVect == cond1) errors(condVect == cond2)]';
        numberOfPermutations = 10000;
        diffMeans = nan(1, numberOfPermutations);
        for i = 1:numberOfPermutations
            permIndices = randperm(numel(poolData));
            permutatedData = poolData(permIndices);
            diffMeans(i) = nanmean(permutatedData(1:numel(poolData)/2)) - nanmean(permutatedData(numel(poolData)/2+1 : numel(poolData)));
        end
        figure
        hist(diffMeans)
        realDiffMean = nanmean(errors(condVect == cond1)) - nanmean(errors(condVect == cond2));
        %% According to Bootstrap_Method, page 50, we can improve the
        %% estimate of the p value by adding one sample result more extreme
        %% than the observed statistic
        p_Permuation = (numel(find(abs(diffMeans) >= abs(realDiffMean)))+1) / (numberOfPermutations+1);
        behavResults.perm_p_Values(pair, 3, typeError) = p_Permuation;
    end
end
behavResults.perm_p_Values  % print the behavResult