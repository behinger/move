
flags = mv_check_folderstruct;
select = find(flags.badCont==1,1,'first');
whichSet = flags.path{select(1)};
[EEG p] = mv_load_set(whichSet);
% [EEG p] = mv_load_set(flags.path{flags.vp==5&flags.session==1&flags.condition==4});

if flags.badChannel(select(1))
[EEG] = mv_reject_channel(EEG,p,1);
end
[EEG] = mv_clean_continuous(EEG,p,'Bene');

%%

fprintf('%i %i %i %i \n',flags.vp(flags.amica == 1& flags.badCont ~=2)',flags.session(flags.amica == 1 & flags.badCont ~=2)',flags.condition(flags.amica == 1& flags.badCont ~=2)')

%%
% [EEG,p] = mv_load_set(flags.path{find(flags.amica==1,1,'first')});
% [EEG,p] = mv_load_set(flags.path{find(flags.amica==1,1,'first')});
[EEG,p] = mv_load_set(flags.path{35});
EEG = mv_clean_continuous(EEG,p,1);
EEG = mv_load_ICA(EEG,p);
% IZ, P6, CZ, VEOG, HEOG