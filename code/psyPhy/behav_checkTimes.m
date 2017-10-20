
%% Get the complete sT and RawDat
addpath('/net/store/projects/move/move_svn/code/psyPhy')
flags = mv_check_folderstruct_fast;
for i = 1:length(flags.vp)
    tic
    fprintf('Working on job %i of %i \n',i,length(flags.vp))
%     p = mv_generate_paths(flags.path{i}); % get the filepaths
    p = flags.p{i};
    [sT, rawDat] = behav_processPsyPhy(p.full.psyphyVR);
    numTrialsForRepmat = length(sT.errors_T);
    sT.vp = repmat(flags.vp(i), numTrialsForRepmat, 1)'; % add the VP number to sT
    rawDat.vp = repmat(flags.vp(i), length(rawDat.roll), 1); % add the VP number to sT
    if strcmp(sT.condition, 'passive')
        sT.condCoded = ones(numTrialsForRepmat, 1)';  % fill in ones
        rawDat.condCoded = ones(length(rawDat.roll), 1);  % fill in ones
    elseif strcmp(sT.condition, 'proprioceptive')
        sT.condCoded = repmat(2, numTrialsForRepmat, 1)';
        rawDat.condCoded = repmat(2, length(rawDat.roll), 1);
    elseif strcmp(sT.condition, 'vestibular')
        sT.condCoded = repmat(3, numTrialsForRepmat, 1)';
        rawDat.condCoded = repmat(3, length(rawDat.roll), 1);
    elseif strcmp(sT.condition, 'active')
        sT.condCoded = repmat(4, numTrialsForRepmat, 1)';
        rawDat.condCoded = repmat(4, length(rawDat.roll), 1);
    end
    
    if i == 1
        concPP = sT;
        concRawDat = rawDat;
    else
        concRawDat = mergestruct(concRawDat, rawDat); % concatenates
        concPP = mergestruct(concPP, sT); % concatenates
    end
    
    
    timeNeeded = toc;
    fprintf('... done in: %fs \n',timeNeeded)
end

%%

a = {'trig20','trig100','turnStartIndIdx'   ,'trig29',          'turnEndIndIdx', 'startFirstPathIdx','startSecondPathIdx'}
b = {'trig29','trig109','turnEndIndIdx'     ,'turnStartIndIdx', 'trig100'      , 'endFirstPathIdx','endSecondPathIdx'}
timeRes = [];
for cond = 1:4
   for k = 1:length(a)
    timeRes(cond,k) = trimmean(concRawDat.time(concPP.(b{k})(concPP.condCoded == cond)) - concRawDat.time(concPP.(a{k})( concPP.condCoded == cond)),10);
   end
end

%     firstPathDur(cond) = trimmean(concRawDat.time(concPP.(b)(concPP.condCoded == cond)) - concRawDat.time(concPP.(a)( concPP.condCoded == cond)),10);

%     secondPathDur(cond) = trimmean(concRawDat.time(concPP.(b)(concPP.condCoded == cond)) - concRawDat.time(concPP.(a)( concPP.condCoded == cond)),10);

    %%
    for k = 1:4
        
%         t(k) =mean(concRawDat.time(concRawDat.event ==9&concRawDat.condCoded == k) - concRawDat.time(concRawDat.event ==2&concRawDat.condCoded == k));
        t(k) =mean(concRawDat.time(concRawDat.event ==9&concRawDat.condCoded == k) - concRawDat.time(concRawDat.event ==8&concRawDat.condCoded == k));
        
    end

mean(concRawDat.time(concRawDat.event ==9) - concRawDat.time(concRawDat.event ==2));
mean(concRawDat.time(concRawDat.event ==9) - concRawDat.time(concRawDat.event ==8));
%%
   for k = 1:4
       for subj = 1:5 
%         t(k,subj) =mean(concRawDat.time(concRawDat.vp = subj & concRawDat.event ==9&concRawDat.condCoded == k) - concRawDat.time(concRawDat.vp = subj & concRawDat.event ==2&concRawDat.condCoded == k));
        resp(k,subj) =mean(concRawDat.time(concRawDat.vp == subj & concRawDat.event ==9&concRawDat.condCoded == k) - concRawDat.time(concRawDat.vp == subj & concRawDat.event ==8&concRawDat.condCoded == k));
       end
    end

%%
tmpAngles = [30 60 90];
for k = 1:3
    
    anglesDur(k) = trimmean(concRawDat.time(concPP.turnEndIndIdx(abs(concPP.turningAnglePerfect)== tmpAngles(k))) - concRawDat.time(concPP.turnStartIndIdx(abs(concPP.turningAnglePerfect)== tmpAngles(k))),10);

end