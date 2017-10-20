function [rawDat_converted] = behav_normalizeXZ(rawDat,sT)
rawDat_converted = rawDat;
rawDat_converted.firstArmOrig = rawDat.firstArmForRot;



for tr = 1:sT.numTrials
    
        beta = -rawDat.firstArmForRot(sT.lastIdxRaw(tr));
        rotationMatrix = [cosd(beta) -sind(beta); sind(beta) cosd(beta)];
        
        XYval = [rawDat.posX(sT.startFirstPathIdx(tr):sT.lastIdxRaw(tr)),rawDat.posZ(sT.startFirstPathIdx(tr):sT.lastIdxRaw(tr))];
        XYvalGuide = [rawDat.guidingXPos(sT.startFirstPathIdx(tr):sT.lastIdxRaw(tr)),rawDat.guidingZPos(sT.startFirstPathIdx(tr):sT.lastIdxRaw(tr))];
        endPosNew =rotationMatrix*XYval';
        endPosGuideNew =rotationMatrix*XYvalGuide';
        
        rawDat_converted.posX(sT.startFirstPathIdx(tr):sT.lastIdxRaw(tr)) = endPosNew(1,:);
        rawDat_converted.posZ(sT.startFirstPathIdx(tr):sT.lastIdxRaw(tr)) = endPosNew(2,:);    
        
        rawDat_converted.guidingXPos(sT.startFirstPathIdx(tr):sT.lastIdxRaw(tr)) = endPosGuideNew(1,:);
        rawDat_converted.guidingZPos(sT.startFirstPathIdx(tr):sT.lastIdxRaw(tr)) = endPosGuideNew(2,:);        
        
%         for k = {'chosenAngle','firstArm','secondArm'}%fieldnames(rawDat)
%             rawDat_converted.(k{:})(sT.startFirstPathIdx(tr):sT.lastIdxRaw(tr)) =  rawDat.(k{:})(sT.startFirstPathIdx(tr):sT.lastIdxRaw(tr)) - beta;
%         end

end





end