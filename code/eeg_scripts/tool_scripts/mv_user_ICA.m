%Start EEGlab fresh
%eeglab

% This checks which files are available and on which processing steps the
% sets are
%Cond : Passive = 1, Proprio = 2; Vestib = 3; Active = 4
flags = mv_check_folderstruct;

[EEG p] = mv_load_set(flags.path{find(flags.vp==3&flags.amica==1,1,'first')})
[EEG p] = mv_load_set(flags.path{21})


% --> 3
[EEG] = mv_load_ICA(EEG,p);
[EEG] = mv_fit_dipole(EEG,p);
EEG= mv_clean_continuous(EEG,p,1)
eeglab redraw
% Plot - Component Maps 2D - Check Dipole, select 40 comps (1:40)

%figure,imagesc(reshape(EEG.icaact(5,:),(EEG.pnts/107),[]))
%(17556*60)/512*1000

