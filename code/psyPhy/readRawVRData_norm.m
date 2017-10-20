function [rawDatOut data] = readRawVRData_norm(filepath,varargin)
%%function [rawDat data] = readRawVRData(filepath',[nrDelimiter])
% takes the filepath and reads out the vr and returns a struct of all
% essential extracted data. Does some preprocessing, e.g. fixes outputs
% from VR, see code
%
% If multiple files need to be concatenated, use a cell array of filepaths
% e.g. rawDat = readRawVRData({'file1.txt','file2.txt')
%
% Optional input: [,nrDelimiter] if old data wants to be read in, you can
% use this to overwrite the delmiter spacing (how many outputs there are in
% the file. Standard is 28
if nargin<2
    delimiter = 28;
else
    delimiter = varargin{1};
end
if ischar(filepath)
    filepath = {filepath};
end


% structLength = [];
% for l = [26:34]
%     try
%     txt = fopen(filepath{1}); % passive 12  tr
%     data = textscan(txt, [repmat('%f ', 1, l), '%s'], 'Delimiter', '\t');
%     structLength(l) = length(data{1});
%     catch
%         structLength(l) = nan;        
%     end
%     fclose(txt);
% end
% 
% [~,delimiter] = (max(structLength));

for k = 1:length(filepath)
    
    
    structLength = [];
    for l = [26:34]
        try
            txt = fopen(filepath{k}); % passive 12  tr
            data = textscan(txt, [repmat('%f ', 1, l), '%s'], 'Delimiter', '\t');
            structLength(l) = length(data{1});
        catch
            structLength(l) = nan;        
        end
    fclose(txt);
    end

    [~,delimiter] = (max(structLength));

    txt = fopen(filepath{k});    data = textscan(txt, [repmat('%f ', 1, delimiter), '%s'], 'Delimiter', '\t');fclose(txt);
    
    rawDat.condition            = data{end};  % condition as string, either "passive", "active", "proprioceptive" or "vestibular"
    
    correctionRoll = 90;  % used for mainView's euler rotation, transforms the orientation data so that it matches the positions
    correctionArrow = 180;  % needed to counterbalance the 3d object's initial rotation 
    if strcmp(rawDat.condition(1), 'passive')
        correction = 180;  % used for guiding object rotation, so that it matches the polar plot in Matlab
    else
        correction = 90;
    end
    
    %% Import the data and transform it to MATLAB coordinates
    % (Angles have to be inverted via a negative sign and 90 degrees has to
    % be added to it, so that it matches the polar plot in MATLAB that
    % corresponds to the PosX/PosZ Plot
    % This also explains why we used the switched atan2 in Vizard, as
    % Vizard seems to work in principal this other way
    rawDat.time                 = data{1};  % time in seconds as floating point number (according to the the system clock)
    rawDat.event                = data{2};  % event, see wiki for details
    rawDat.trialNumber          = data{3} + 1;  % trialNumber, starting with 1
%     rawDat.turningAnglePlanned  = data{4};  % This is the condition, here 30 degrees means 30� to the right
    rawDat.turningAnglePlanned  = - data{4};  % This is the condition, here 30 degrees means 30� to the left
    % the - seems to be correct, behinger 14.02 10:13
    rawDat.chosenAngle          = - data{5} + correctionArrow;  % This is the angle chosen by the arrow / by the subject
    rawDat.posX                 = data{6};	 % posX in meters
    rawDat.posY                 = data{7};  % posY in meters
    rawDat.posZ                 = data{8};  % posZ in meters
    rawDat.roll                 = - data{9} + correctionRoll;  % heading orientation (right-left, rotation around the y-axis)
    rawDat.rollUnnorm           = - data{9} + correctionRoll;  % heading orientation (right-left, rotation around the y-axis)
    rawDat.pitch                = data{10};  % 0 in the passive condition (rotation around the x-axis (head-tilt to the side))
    rawDat.yaw                  = data{11};	 % 0 in the passive condition (rotation around the z-axis (head up-down movement))
    
    rawDat.firstArm             = - data{13} + correction + 180; % only relevant for the active conditions % 180 deg offset to turningAngle
    rawDat.firstArmForRot       = - data{13} + correction + 180; % this is needed for the rotation matrix for normalizing the positions
    rawDat.secondArm            = - data{15} + correction; % only relevant for the active conditions % second Arm global angle against z-axis
    rawDat.prelimSecondArm      = - data{14} + correction; % only for debugging, this was before the tracker was offset
    
    rawDat.centerX              = data{16};  % This is the stored center, which was used to center the platform to (0,0) not interesting for analysis
    rawDat.centerY              = data{17};
    
    rawDat.proprioceptiveDummy  = - data{12};  % only invert it here, as we only want to use it to get the turnedAngle
    
    if delimiter > 25  % these parameters weren't there in old textfiles
        rawDat.guidingOrient    = - data{26} + correction;
        rawDat.guidingOrientUnnorm  = - data{26} + correction;
        rawDat.guidingXPos      = data{27};
        rawDat.guidingZPos      = data{28};
    end
    %% It can happen that the programm exited / crashed while writing samples. Therefore we have to cut the respective samples.
    %Find minimum
    minField = [];
    for l =fieldnames(rawDat)'
        minField(end+1) = length(rawDat.(l{:}));
    end
    if length(unique(minField))~=1
    minField = min(minField);
    fprintf('Sample Inconsistency, deleting last sample in some rawDat fields \n')
    for l =fieldnames(rawDat)'
        rawDat.(l{:}) = rawDat.(l{:})(1:minField);
    end
    end
    
    
    %% Set the firstArm to 0 for the passive condition
    if strcmp(rawDat.condition(1), 'passive')
        rawDat.firstArm = rawDat.firstArm - rawDat.firstArm;
        rawDat.firstArmForRot = rawDat.firstArmForRot - rawDat.firstArmForRot;
    end
    
    %% Normalize the data so that the first arm is turned to 0�
    rawDat.chosenAngle          = rawDat.chosenAngle - rawDat.firstArm;  % This is the angle chosen by the arrow / by the subject
    rawDat.roll                 = rawDat.roll - rawDat.firstArm;  % heading orientation (right-left, rotation around the y-axis)
    rawDat.secondArm            = rawDat.secondArm - rawDat.firstArm; % only relevant for the active conditions % second Arm global angle against z-axis
    rawDat.prelimSecondArm      = rawDat.prelimSecondArm - rawDat.firstArm; % only for debugging, this was before the tracker was offset
    %     rawDat.proprioceptiveDummy  = rawDat.proprioceptiveDummy - rawDat.firstArm;  % only invert it here, as we only want to use it to get the turnedAngle
    if delimiter > 25  % these parameters weren't there in old textfiles
        rawDat.guidingOrient    = rawDat.guidingOrient - rawDat.firstArm;
    end
    rawDat.firstArm             = rawDat.firstArm - rawDat.firstArm; % only relevant for the active conditions % 180 deg offset to turningAngle
    
    
    
    %     if strcmp(rawDat.condition(1), 'passive')
    %     else
    %         rawDat.chosenAngle = rawDat.chosenAngle + 90; % this has to be done due to a diffrence in VR-code see ticket #99
    %     end
    
    if k > 1
%         rawDatTmp = mergestruct(rawDatOut,rawDat);
%         if length(setdiff(unique(rawDatTmp.trialNumber),(rawDatTmp.trialNumber))) > 1
        if rawDat.trialNumber(find(rawDat.trialNumber>0,1,'first'))< max(rawDatOut.trialNumber) && ...
                rawDat.trialNumber(find(rawDat.trialNumber>0,1,'first'))<31 && ...
                length(intersect(unique(rawDatOut.trialNumber), unique(rawDat.trialNumber)))>10
                
%             dbstop tic; tic; dbclear tic;
            if any(rawDat.trialNumber+30 >60)
                warning('Hey! We tried to add 30 but made no sense?')
            else
                rawDat.trialNumber = rawDat.trialNumber + 30;
                rawDat.event(rawDat.event>150 & rawDat.event<211) = rawDat.event(rawDat.event>150 & rawDat.event<211) + 30;
            end
        end
        % if k is not 1, we have multiple files as input, therefore we
        % want to concatenate
        rawDatOut = mergestruct(rawDatOut,rawDat);
    else
        rawDatOut = rawDat;
    end
end
% fclose(txt);