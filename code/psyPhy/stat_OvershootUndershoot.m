%% Does not work at the moment! %%

clear overunder;
td = [-90 -60 -30 30 60 90; 1 2 3 4 5 6]; %different turning angles
overunder=[]; % initiate matrix


for vpNumbers = 1:5; % for every participant
    
    for cond = 1:4; % for every condition
        
        overshoot=0; % empty overshoot value
        undershoot=0; % empty undershoot value
        
        for angle=1:6; % for every angle
            
%             if cond<3
%                 undershoot=numel(find(errors(concPP.turningAnglePlanned == td(1,angle) & concPP.vp == vpNumbers & concPP.condCoded == cond)<0)); % count all undershoots
%                 overshoot=numel(find(errors(concPP.turningAnglePlanned == td(1,angle) & concPP.vp == vpNumbers & concPP.condCoded == cond)>0));  % count all overshoots
%                 meanU=nanmean(find(errors(concPP.turningAnglePlanned == td(1,angle) & concPP.vp == vpNumbers & concPP.condCoded == cond)<0)); % mean undershoot
%                 meanO=nanmean(find(errors(concPP.turningAnglePlanned == td(1,angle) & concPP.vp == vpNumbers & concPP.condCoded == cond)>0)); % mean overshoot
%             else
                
                undershoot=numel(find(errors(concPP.turningAnglePerfect == td(1,angle) & concPP.vp == vpNumbers & concPP.condCoded == cond)<0)); % count all undershoots
                overshoot=numel(find(errors(concPP.turningAnglePerfect == td(1,angle) & concPP.vp == vpNumbers & concPP.condCoded == cond)>0));  % count all overshoots
                meanU=nanmean(find(errors(concPP.turningAnglePerfect == td(1,angle) & concPP.vp == vpNumbers & concPP.condCoded == cond)<0)); % mean undershoot
                meanO=nanmean(find(errors(concPP.turningAnglePerfect == td(1,angle) & concPP.vp == vpNumbers & concPP.condCoded == cond)>0)); % mean overshoot
%             end
            
            if undershoot>overshoot % does subject prefer undershooting over
                strategy=1;         % overshooting, 1 if 'Yes'
            else
                if undershoot<overshoot
                    strategy=0;
                else
                    strategy=2;
                end
            end
            
            % store different values
            eval(['overunder.S', num2str(vpNumbers), '(', num2str((cond-1)*6+td(2,angle)), ',1)=',num2str(cond)]);
            eval(['overunder.S', num2str(vpNumbers), '(', num2str((cond-1)*6+td(2,angle)), ',2)=',num2str(td(1,angle))]);
            eval(['overunder.S', num2str(vpNumbers), '(', num2str((cond-1)*6+td(2,angle)), ',3)=',num2str(undershoot)]);
            eval(['overunder.S', num2str(vpNumbers), '(', num2str((cond-1)*6+td(2,angle)), ',4)=',num2str(meanU)]);
            eval(['overunder.S', num2str(vpNumbers), '(', num2str((cond-1)*6+td(2,angle)), ',5)=',num2str(overshoot)]);
            eval(['overunder.S', num2str(vpNumbers), '(', num2str((cond-1)*6+td(2,angle)), ',6)=',num2str(meanO)]);
            eval(['overunder.S', num2str(vpNumbers), '(', num2str((cond-1)*6+td(2,angle)), ',7)=',num2str(overshoot+undershoot)]);
            eval(['overunder.S', num2str(vpNumbers), '(', num2str((cond-1)*6+td(2,angle)), ',8)=',num2str(strategy)]);
            
        end;
        
    end;
    
    
    %     subplot(2, 3, vpNumbers);
    %     hold on;
    %vpNumber=1
    %     eval(['plot(overunder.S', num2str(vpNumbers), '(', num2str((cond-1)*6+td(2,angle)), ',3))']);
    %     plot(overunder((vpNumbers-1)*4+1:(vpNumbers-1)*4+4,4),'kx')
    %     axis([0, 5, 0, 95])
    %
end;
% legend('undershoot','overshoot')




