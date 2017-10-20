function [] = mv_mpa_init(STUDY,ALLEEG)


measureName = 'ersp';
STUDY.measureProjection.(measureName).object = pr.dipoleAndMeasureOfStudyErsp(STUDY, ALLEEG);

 

STUDY.measureProjection.(measureName).headGrid = pr.headGrid(STUDY.measureProjection.option.headGridSpacing);
STUDY.measureProjection.(measureName).projection = pr.meanProjection(STUDY.measureProjection.(measureName).object, STUDY.measureProjection.(measureName).object.getPairwiseMutualInformationSimilarity, STUDY.measureProjection.(measureName).headGrid, 'numberOfPermutations', STUDY.measureProjection.option.numberOfPermutations, 'stdOfDipoleGaussian', STUDY.measureProjection.option.standardDeviationOfEstimatedDipoleLocation,'numberOfStdsToTruncateGaussian', STUDY.measureProjection.option.numberOfStandardDeviationsToTruncatedGaussaian, 'normalizeInBrainDipoleDenisty', fastif(STUDY.measureProjection.option.normalizeInBrainDipoleDenisty,'on', 'off'));

% STUDY = place_components_for_projection_of_measure(STUDY, measureName);
STUDY.measureProjection.(measureName).lastCalculation.sets = STUDY.cluster(1).sets;
STUDY.measureProjection.(measureName).lastCalculation.comps = STUDY.cluster(1).comps;    
% put the STUDY variable back from workspace
assignin('base', 'STUDY', STUDY);
end