function EEG = mv_reject_channel_cov(EEG,p,varargin)

if nargin == 3
    bad_channels = varargin{1};
else
    error('what the hell?')
end
p = mv_generate_paths(p);


if exist(p.full.badChannelCorr ,'file')==2
    error('file already found')
end


if exist(p.full.badChannelCorr ,'file')==2 %&& exist('askAppendOverwrite','var')&& strcmp(askAppendOverwrite,'c')
    copyfile(p.full.badChannelCorr ,[p.full.badChannelCorr  '.bkp' datestr(now,'mm-dd-yyyy_HH-MM-SS')]);
    fprintf('Backup created \n')
end
save(p.full.badChannelCorr ,'bad_channels');

EEG = pop_select( EEG,'nochannel',bad_channels);
%     EEG.preprocess = [EEG.preprocess 'Noisychannel'];
EEG.preprocessInfo.badChannelCorr  = bad_channels;
EEG.preprocessInfo.badChannelCorrDate = datestr(now);


end
