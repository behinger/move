function [behavResults] = stat_checkVarianceEquality(concPP, behavResults)

relErrPerCond = [];
vpNrs = (unique(concPP.vp));



for vp = 1:numel(vpNrs)
%   err = concPP.winsErrorT;
    err = concPP.errors_T;
    for cond = 1:numel(unique(concPP.condCoded))
        %% Print table
        
        
        relErrPerCond = [relErrPerCond; [err(concPP.vp == vpNrs(vp) & ...
            concPP.condCoded == cond); concPP.condCoded(concPP.vp == vpNrs(vp) & concPP.condCoded == cond)]'];
%         [h,p]  = lillietest(err(concPP.vp == vp & concPP.condCoded == cond)); % also see writeMeansToTXT
    end
    % 'on' displays the statistics, 'off' does not display them
    p = vartestn(relErrPerCond(:,1), relErrPerCond(:,2), 'off', 'robust')  % robust performs the levene test instead of bartletts
    behavResults.(['vp', num2str(vpNrs(vp)), 'Levene']) = p;
    relErrPerCond = [];
end


