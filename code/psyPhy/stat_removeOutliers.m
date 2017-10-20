function [concPP] = stat_removeOutliers()

%% Load concatenated behavioral data
load('/net/store/projects/move/move_svn/code/MAT_datafiles/concPP_08-03_moreTrials_cutInconsistNew.mat');

%% Constants
nrVPs = 5;
nrConds = 4;
angle = [-90, -60, -30, 30, 60, 90];
nrAngles = numel(angle);


%% Take into account commentsheets
threshComment = 1; % either 1 or 0 if you want to throw away events that were marked with 1 too
concPP.errors_T(concPP.badVR > threshComment) = nan;
concPP.errors_NT(concPP.badVR > threshComment) = nan;



%% Calculate outlierfree data
percent90 = 90;  % take 90 or take 95 ???
percent95 = 95;  % take 90 or take 95 ???
for vpNumbers = 1:nrVPs   
    for cond = 1:nrConds
        workRange = find(concPP.vp == vpNumbers & concPP.condCoded == cond);
        concPP.winsErrorT90(workRange) = winsorising(concPP.errors_T(workRange), percent90);
        concPP.winsErrorT95(workRange) = winsorising(concPP.errors_T(workRange), percent95);   % This makes sense
    end   
    workRange = find(concPP.vp == vpNumbers);
    concPP.winsErrorSubjT90(workRange) = winsorising(concPP.errors_T(workRange), percent90);
    concPP.winsErrorSubjT95(workRange) = winsorising(concPP.errors_T(workRange), percent95);  % This makes sense
end
% concPP.winsErrorAll90 = winsorising(concPP.errors_T, percent90);  %Removing the outliers this way makes the 
% performance weigh better and therefore makes not much sense
% concPP.winsErrorAll95 = winsorising(concPP.errors_T, percent95);

%Count how many outliers are removed
outliersRemoved90 = numel(find((concPP.winsErrorT90 - concPP.errors_T)>1));  % yields 87 outliers
outliersRemoved95 = numel(find((concPP.winsErrorT95 - concPP.errors_T)>1));  % yields 37 outliers 

% Decide which percentage you want to winsorize
% concPP.winsErrorT = concPP.winsErrorT95;  % Cuts away too little
% concPP.winsErrorT = concPP.winsErrorSubjT90;  % Cuts away too much
% concPP.winsErrorT = concPP.winsErrorSubjT95;  % This winsorization goes
% only over subjects (not divided by conditions)

concPP.winsErrorT = concPP.winsErrorT90;  % Looks good, actually similar to concPP.winsErrorSubjT95;
% We take this kind of winsorization that changes every block of 120 trials
% so that no condition (if e.g. proprioceptive was the worst in one
% subject) is systematically improved while the others are not which would
% be unfair and reduce our power

plotWinsData = false;

if plotWinsData == true
    figure
    subplot(2,2,1)
    bar(concPP.errors_T)
    axis([-0 2500 -180 150])
    title('Original data including outliers')
    subplot(2,2,2)
    bar(concPP.winsErrorT90)
    axis([-0 2500 -80 80])
    title('Winsorize 120 trials (split in cond. and subj) with 90%')
    subplot(2,2,3)
    bar(concPP.winsErrorSubjT90)
    xlabel('TOO RESTRICTIVE; IMPROVES PERFORMANCE ARTIFICIALLY!')
    axis([-0 2500 -80 80])
    title('Winsorize 480 trials (split in subjects) with 90%')
    subplot(2,2,4)
    bar(concPP.winsErrorSubjT95)
    title('Winsorize 480 trials (split in subjects) with 95%')
    axis([-0 2500 -80 80])
end


%% Outlierfree data for variance calculation
%% All data more extreme than the 2 * IQR should be removed
concPP.outlierFreeErrors = concPP.errors_T;
numOfOutlierRem = 0;
for vpNumbers = 1:nrVPs   
    for cond = 1:nrConds
        workRange = find(concPP.vp == vpNumbers & concPP.condCoded == cond);
        iqrange = iqr(concPP.errors_T(workRange));
        currMedian = nanmedian(concPP.errors_T(workRange));
        lowCutOff = currMedian - iqrange * 2;
        highCutOff = currMedian + iqrange * 2;
        currErrors = concPP.outlierFreeErrors(workRange);        
        numOfOutlierRem = numOfOutlierRem + numel(find(currErrors < lowCutOff)) ...
            + numel(find(currErrors > highCutOff));  % Count outliers, 124 outliers are removed      
        currErrors(currErrors < lowCutOff) = lowCutOff;
        currErrors(currErrors > highCutOff) = highCutOff;
        concPP.outlierFreeErrors(workRange) = currErrors;
    end   
end

plotOutlierFreeErrors = true
if plotOutlierFreeErrors == true
    figure
    subplot(2,1,1)
    bar(concPP.errors_T)
    axis([-0 2500 -180 150])
    title('Original data including outliers')
    subplot(2,1,2)
    bar(concPP.outlierFreeErrors)
    title('Outlierfree data')
    axis([-0 2500 -180 150])
end


%% Trim the array so that for each VP and condition the number of entries
%% is equal (I did use that for the signed test but in principal this makes
%% not much sense)
trimmed.winsErrorT = [];
errors = concPP.winsErrorT;
appendIndex = 1;
for vp = 1: nrVPs
    tmpErrors1 = errors(concPP.condCoded == 1 & concPP.vp == vp);
    tmpErrors1(isnan(tmpErrors1)) = []; 
    tmpErrors2 = errors(concPP.condCoded == 2 & concPP.vp == vp);
    tmpErrors2(isnan(tmpErrors2)) = []; 
    tmpErrors3 = errors(concPP.condCoded == 3 & concPP.vp == vp);
    tmpErrors3(isnan(tmpErrors3)) = []; 
    tmpErrors4 = errors(concPP.condCoded == 4 & concPP.vp == vp);
    tmpErrors4(isnan(tmpErrors4)) = []; 
    cutBorder = min([numel(tmpErrors1), numel(tmpErrors2), numel(tmpErrors3), numel(tmpErrors4)]);
    tmpErrors1 = tmpErrors1(1:cutBorder);
    tmpErrors2 = tmpErrors2(1:cutBorder);
    tmpErrors3 = tmpErrors3(1:cutBorder);
    tmpErrors4 = tmpErrors4(1:cutBorder);
    trimmed.winsErrorT(appendIndex:appendIndex-1+(numel(tmpErrors1)*4)) = [tmpErrors1, tmpErrors2, tmpErrors3, tmpErrors4];
    trimmed.condCoded(appendIndex:appendIndex-1+(numel(tmpErrors1)*4)) = [1 * ones(1, cutBorder), 2 * ones(1, cutBorder), 3 * ones(1, cutBorder), 4 * ones(1, cutBorder)];
    trimmed.vp(appendIndex:appendIndex-1+(numel(tmpErrors1)*4)) = vp * ones(1,numel(tmpErrors1)*4);
    appendIndex = numel(trimmed.winsErrorT);
end

sprintf(['Outliers are removed, concPP.winsErrorT is generated.'])