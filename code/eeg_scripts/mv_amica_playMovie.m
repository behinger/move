% function [] = mv_amica_playMovie()
tmp = dir('/net/store/projects/move/temp/*.mat');
for k = 1:length(tmp)
    load(fullfile('/net/store/projects/move/temp', tmp(k).name))
    fra(k,:,:) = mod.W;
end