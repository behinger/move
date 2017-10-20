function [] = stat_writeMeansToTXTforSPSS(concPP, behavResults)



    %% 2. Constants
    nrVPs = 5;
    nrConds = 4;
    angle = [-90, -60, -30, 30, 60, 90];
    nrAngles = numel(angle);
    differentErrors = 2;


    for typeError = 1:differentErrors  
        if typeError == 1
            errors = abs(concPP.winsErrorT);  
        elseif typeError == 2
            errors = concPP.winsErrorT;
        end 

        %% 1x6 (or 3x2) ANOVA for angles(xdirections)
        % For 5 subject and 6 angles we need a 5x6 matrix
        % -90, -60, -30, 30, 60, 90
       means1x6 = nan(nrVPs, nrAngles);
       for vp = 1:nrVPs
            for angl = 1:nrAngles
                means1x6(vp, angl) = nanmean(errors((concPP.vp == vp) & (concPP.turningAnglePerfect == angle(angl))));
            end
       end
       if typeError == 1
           dlmwrite('/net/store/projects/move/move_svn/code/SPSS_psyPhy/meansAbs1x6.txt', means1x6, 'delimiter', ',')
       elseif typeError == 2
           dlmwrite('/net/store/projects/move/move_svn/code/SPSS_psyPhy/meansPosNeg1x6.txt', means1x6, 'delimiter', ',')
       end  


        %% 3. 2x2 Design ANOVA
        % For 5 subject and 4 conditions we need a 5x4 matrix
        % First column: Passive
        % Second column: Proprioceptive
        % Third column: Vestibular
        % Fourth column: Active
        % In the rows are the corresponding values from subject 1 t    
       mean2x2 = nan(nrVPs, nrConds);
       for vp = 1:nrVPs
            for cond = 1:nrConds
                means2x2(vp, cond) = nanmean(errors((concPP.vp == vp) & (concPP.condCoded == cond)));
            end
       end

        % % Test normality (you can test that in SPSS too)
        % for column = 1:4
        %     [h,p]  = lillietest(means2x2(:,column));
        % end

        if typeError == 1
            dlmwrite('/net/store/projects/move/move_svn/code/SPSS_psyPhy/meansAbs2x2.txt', means2x2, 'delimiter', ',')
        elseif typeError == 2
            dlmwrite('/net/store/projects/move/move_svn/code/SPSS_psyPhy/meansPosNeg2x2.txt', means2x2, 'delimiter', ',')
        end 
        
        
       %% 3. 2x3 (left/right) Design ANOVA
        % For 5 subject and 6 factor levels we need a 5x6 matrix
        % First column: -90
        % Second column:-60
        % Third column: -30
        % Fourth column: 30
        % Fourth column: 60
        % Fourth column: 90     
       mean2x3 = nan(nrVPs, 6);
       tunringAngles = [-90, -60, -30, 30, 60, 90];
       for vp = 1:nrVPs
            for ang = 1:6
                means2x3(vp, ang) = nanmean(errors((concPP.vp == vp) & (concPP.turningAnglePerfect == tunringAngles(ang))));
            end
       end
      if typeError == 1
            dlmwrite('/net/store/projects/move/move_svn/code/SPSS_psyPhy/meansAbs2x3.txt', means2x3, 'delimiter', ',')
        elseif typeError == 2
            dlmwrite('/net/store/projects/move/move_svn/code/SPSS_psyPhy/meansPosNeg2x3.txt', means2x3, 'delimiter', ',')
      end 
        
        % % Test normality (you can test that in SPSS too)
        % for column = 1:4
        %     [h,p]  = lillietest(means2x2(:,column));
        % end

        if typeError == 1
            dlmwrite('/net/store/projects/move/move_svn/code/SPSS_psyPhy/meansAbs2x2.txt', means2x2, 'delimiter', ',')
        elseif typeError == 2
            dlmwrite('/net/store/projects/move/move_svn/code/SPSS_psyPhy/meansPosNeg2x2.txt', means2x2, 'delimiter', ',')
        end 



        %% 4. Write to SPSS the 6x4 different conditions (24 columns) + VP as a categorial variable of absolute and log
        % In SPSS within subjects variables always need a seperate column, between subject
        % variable are categorical variables
        rowVPs = [];
        numTrialsPerSubject = 20;
        outputMatrix = nan(numTrialsPerSubject * nrVPs, nrConds * nrAngles + 1);
        counter = 2;
        counterVP = 1;
        for vp = 1:nrVPs
            rowVPs = [rowVPs; vp .* ones(numTrialsPerSubject, 1)];
            for cond = 1:nrConds
                for ang = [-90, -60, -30, 30, 60, 90] 
                    tmp = errors(concPP.condCoded == cond & concPP.turningAnglePerfect == ang & concPP.vp == vp);
                    outputMatrix(((counterVP - 1) * numTrialsPerSubject) + 1 : numel(tmp) + ((counterVP - 1) * numTrialsPerSubject), counter) = tmp;
                    counter = counter + 1;
                end
            end
            counter = 2;
            counterVP = counterVP + 1;
        end
        outputMatrix(101,:) = [];    % Delete the last entry, not sure why it fills it up to 101 at all?
        outputMatrix(:,1) = rowVPs;  % Fill the first column with VP numbers

        means4x6 = [];
        for vp = 1:nrVPs 
            means4x6(vp,:) = nanmean(outputMatrix(outputMatrix(:,1) == vp,:), 1)
        end
        means4x6(:, 1) = []  % Remove the first column with VP Numbers


        % Test normality (you can test that in SPSS too)
        for column = 1:24
            [h,p]  = lillietest(means4x6(:,column))
        end

        if typeError == 1
            dlmwrite('/net/store/projects/move/move_svn/code/SPSS_psyPhy/meansAbs4x6.txt', means4x6, 'delimiter', ',')
        elseif typeError == 2
            dlmwrite('/net/store/projects/move/move_svn/code/SPSS_psyPhy/meansPosNeg4x6.txt', means4x6, 'delimiter', ',')
        end 
    end


    %% 4. Write to SPSS the (120*4)x1x1(coded by the condition) relative errors for each subject
    counterNonNormal = 0;
    relErrPerCond = [];
    % Mapping from the condition to the factors vestibular and kinesthetic
    condFactors = [1, 0, 0; 2, 1, 0; 3, 0, 1; 4, 1, 1];
    
    for vp = 1:nrVPs
        err = concPP.winsErrorT;
%         err = concPP.errors_T;
        for cond = 1:nrConds        
            relErrPerCond = [relErrPerCond; [(err(concPP.vp == vp & concPP.condCoded == cond))', repmat(condFactors(find(condFactors(:,1) == cond), 2:3), 120, 1)]];
            [h,p]  = lillietest(err(concPP.vp == vp & concPP.condCoded == cond)); 
            counterNonNormal = counterNonNormal + h;
        end
        relErrPerCond(isnan(relErrPerCond),:) = [];  % Remove nans completely
        dlmwrite(['/net/store/projects/move/move_svn/code/SPSS_psyPhy/winsRelErr_vp', num2str(vp), '.txt' ], relErrPerCond, 'delimiter', ',')
        relErrPerCond = []; % empty it to fill it with the next subjects data
    end
    [num2str(counterNonNormal), ' conditions out of 5x4 = 20 nonnormal.']


    %% Old: Send means to SPSS for repeated measures ANOVA including all trials
    %% which is not allowed
    % also see repeatedmeasures.pdf page 9 for further details

    % % Create 2 dimensional array
    % numTrialsPerSubject = 120;
    % errorsRMSorted = nan(nrVPs * numTrialsPerSubject, nrConds+1);
    % rowVPs = [];
    % for vp = 1:nrVPs
    %     rowVPs = [rowVPs; vp .* ones(numTrialsPerSubject, 1)];
    %     for cond = 1:nrConds
    %         errorsRMSorted((vp-1) * numTrialsPerSubject + 1 : vp*numTrialsPerSubject, cond + 1) = errors((concPP.vp == vp) & (concPP.condCoded == cond))';
    %     end
    % end
    % errorsRMSorted(:, 1) = rowVPs;  % Fill the first column with VP numbers
    % 
    % dlmwrite('/net/store/projects/move/move_svn/code/SPSS_psyPhy/rmLogANOVA.txt', errorsRMSorted, 'delimiter', ',')
    % 

