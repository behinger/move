% STUDY.measureProjection.ersp.projection.plotVoxelColoredByDomain
% figure
haMeasures = [];
for k = 1:2%6
% subplot(2,3,k)
    
    STUDY.measureProjection.ersp.projection.domain(k).plotMeasure
    haMeasures(k) = gcf;
end
merge_figures(haMeasures)
close(haMeasures)
