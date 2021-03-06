function EEG = mv_fit_dipole(EEG,p,chosenAmica,force)
if nargin < 3 || isempty(chosenAmica)
    if any(strcmpi(fieldnames(EEG.preprocessInfo),'chosenICA'))
   chosenAmica = EEG.preprocessInfo.chosenICA; 
    else
        error('Error, could not detect which ICA was loaded, aborting')
    end
end
if ~exist('force','var')
    force = 0;
end
p = mv_generate_paths(p);
if ~check_EEG(EEG.preprocess,'Dipfit')
        if (~exist(p.full.dipole{chosenAmica},'file')  || force==1) && force ~=2
            fprintf('Calculating Dipoles \n')
            dipfitdefs;
            [~,transform] = coregister(EEG.chanlocs,template_models(2).chanfile,'mesh',template_models(2).hdmfile,'warp','auto','manual','off');
            EEG = pop_dipfit_settings( EEG, 'hdmfile','/net/store/projects/move/eeglab/plugins/dipfit2.2/standard_BEM/standard_vol.mat','coordformat','MNI','mrifile','/net/store/projects/move/eeglab/plugins/dipfit2.2/standard_BEM/standard_mri.mat','chanfile','/net/store/projects/move/eeglab/plugins/dipfit2.2/standard_BEM/elec/standard_1005.elc','coord_transform',transform ,'chansel',[1:EEG.nbchan] );
            EEG.preprocess = [EEG.preprocess 'DipfitWarp'];
            EEG.preprocessInfo.DipfitWarpDate =datestr(now);
            %     tic
            %     EEG = pop_dipfit_gridsearch(EEG, [1:EEG.nbchan] ,linspace(-85,85,20),linspace(-85,85,20),linspace(0,85,10) ,0.4);
            %     toc
            EEG = pop_multifit(EEG,[],'dipoles',1,'threshold',100);
            dipfit = EEG.dipfit;
            save(p.full.dipole{chosenAmica},'dipfit')
            EEG.preprocess = [EEG.preprocess 'Dipfit'];
            EEG.preprocessInfo.DipfitDate =datestr(now);
        else
            fprintf('Loading Dipoles \n')
            load(p.full.dipole{chosenAmica});
            EEG.dipfit = dipfit;
            EEG = eeg_checkset(EEG);
            EEG.preprocess = [EEG.preprocess 'Dipfit'];
            EEG.preprocessInfo.DipfitDate =datestr(now);

        end
   
    
end