function EEG = mv_reref(EEG,p)
if ~check_EEG(EEG.preprocess,'Rerefav')
    
    
    EEG = pop_reref(EEG,[]);
    if any(strcmp({EEG(1).chanlocs.labels},'I2'))
        EEG = pop_select( EEG,'nochannel',{'I2'});
        EEG.preprocessInfo.chanRemAftRef = 'I2';
    elseif any(strcmp({EEG(1).chanlocs.labels},'I1'))
        EEG = pop_select( EEG,'nochannel',{'I1'});
        EEG.preprocessInfo.chanRemAftRef = 'I1';
    elseif any(strcmp({EEG(1).chanlocs.labels},'OI2h'))
        EEG = pop_select( EEG,'nochannel',{'OI2h'});
        EEG.preprocessInfo.chanRemAftRef = 'OI2h';
    elseif any(strcmp({EEG(1).chanlocs.labels},'OI1h'))
        EEG = pop_select( EEG,'nochannel',{'OI1h'});
        EEG.preprocessInfo.chanRemAftRef = 'OI1h';
    else
        for k = 1:20
            fprintf('%%%%%% WARNING NO I1/I2 CHANNEL REMOVED %%%%%%%%% \n')
        end
    end
    
    EEG.preprocess = [EEG.preprocess 'RerefavChanexcl'];
end