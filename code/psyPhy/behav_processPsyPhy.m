function [sT rawDat] = behav_processPsyPhy(file,varargin)
%% Behav_ProcessPsyPhy
% This function inputs a raw-VR file-paths (or cellarray of file-paths),
% concatenates them and calculates the error and conditions from it.
% Possible Inputs:
% File: Cell Array of Filepaths
% ['cfg',cfg.struct] with one of the following fields:
% 'plotInconsistentEvent'       Plots the rawDat.event and marks rejected trials. Default: 0
% 'showWarningInconEvent'       Shows the warning that an inconsistend
%                               event was found. Default: 1
% 'plotSingleTrialError'        Shows a plot for nonTurner / Turner error
%                               Default: 0
% 'showMedianError'             Outputs the median error of nonT/T.
%                               Default: 1
% 'showPercentageTurner'        Outputs percentage nonT/T. Default: 1
% 'sanityChecks'                Calculates Sanitychecks. May be deprevated
% 'plotAllAngles'               Plots all trials + angles in a single plot.
%                               Default: 0


if nargin ==  1
    varargin = {'bla'};
end
tmpFieldnames = {'plotInconsistentEvent','showWarningInconEvent','plotSingleTrialError','showMedianError','showPercentageTurner','sanityChecks','plotAllAngles'};
%% Output Config
%Preprocess Config
cfg = cell2struct({0 1 0 1 1 0 0}',tmpFieldnames);

idxCfg = strfind(varargin{1:2:end},'cfg');
if ~isempty(idxCfg)
    cfgNew = varargin{idxCfg+1};
    fn = fieldnames(cfgNew);
    for k = fn'
        if ~any(cell2mat(strfind(tmpFieldnames,k{:})))
            warning('Cfg Option %s is not a valid option',k{:});
            continue
        end
       cfg.(k{:}) = cfgNew.(k{:}); 
    end
end

rawDat = readRawVRData_norm(file);
%%
[rawDat,sT] = behav_prepareRawDat(rawDat,cfg);

%% Calculate the optimal answer angles
[sT] = behav_calculateErrorAngles(rawDat,sT);

%% Get walking and guiding object position correctly rotated and plot it
if cfg.plotAllAngles
    figure
    visualize_angle(rawDat,sT,1:sT.numTrials)
end

%% Plot
if cfg.plotSingleTrialError
    figure;
    bar(sT.trialNumbers, sT.errors_T);
    xlabel('Time (Trials in order)');
    ylabel('Error in degrees');
    title('Errors Turners over trials');
    axis([0 max(sT.trialNumbers)+1 -200 200])
    figure;
    bar(sT.trialNumbers,sT.errors_NT);
    xlabel('Time (Trials in order)');
    ylabel('Error in degrees');
    title('Errors Non-Turners over trials');
    axis([0 max(sT.trialNumbers)+1 -200 200])
end
%%
if cfg.showMedianError
    fprintf('Cond: %15s  Turner  Error Median: \t %f \n',sT.condition, median(abs(sT.errors_T)))
    fprintf('Cond: %15s  NonTurner Error Median:\t %f \n',sT.condition,median(abs(sT.errors_NT)))
end
if cfg.showPercentageTurner
    percentageTurner = sum((abs(sT.errors_T)<abs(sT.errors_NT)))./sT.numTrials;
    fprintf('Cond: %15s  Error perc Turner:\t %f \n',sT.condition,percentageTurner);
end
% fprintf('Cond: %15s  TrialDuration: \t %f \n',sT.condition,median(sT.trialDuration))

%%
if cfg.sanityChecks
    behav_sanityChecks;
end