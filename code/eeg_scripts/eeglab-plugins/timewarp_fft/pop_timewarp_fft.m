function [com,ersp,itc,powbase,times,freqs,erspboot,itcboot,tfdata]= pop_timewarp_fft(EEG)

uilist = { ...
    { 'Style', 'text', 'string', 'Component number', 'fontweight', 'bold'  } ...
    { 'Style', 'edit', 'string', '1' 'tag' 'chan'}...
    { 'Style', 'checkbox', 'string' 'Channels instead of Components' 'tag' 'chanCompBool' },{},  ...
    ...
    { 'Style', 'text', 'string', 'Frequency limits [min max] (Hz) or sequence', 'fontweight', 'bold' } ...
    { 'Style', 'edit', 'string', '' 'tag' 'freqs'  },{},{}, ...
    ...
    { 'Style', 'text', 'string', 'Baseline limits [min max] (msec) (0->pre-stim.)', 'fontweight', 'bold' } ...
    { 'Style', 'edit', 'string', '0' 'tag' 'baseline' } ...
    { 'Style', 'popupmenu',  'string', 'Use divisive baseline (DIV)|Use standard deviation (STD)|Use single trial DIV baseline|Use single trial STD baseline' 'tag' 'basenorm' } ...
    { 'Style', 'checkbox', 'string' 'No baseline' 'tag' 'nobase' } ...
    ...
    { 'Style', 'text', 'string', 'Bootstrap significance level (Ex: 0.01 -> 1%)', 'fontweight', 'bold' } ...
    { 'Style', 'edit', 'string', '', 'tag' 'alpha'} ...
    { 'Style', 'checkbox', 'string' 'FDR correct (set)' 'tag' 'fdr' } ...
    { 'Style', 'checkbox', 'string' 'Parallel computing (set)' 'tag' 'parallel' }  ...
    ...
    { 'Style', 'text', 'string', 'Timewarp Events (e.g. 1:2)', 'fontweight', 'bold' } ...
    { 'Style', 'edit', 'string', '3 4 ' 'tag' 'twEvents' }, {},{}...
    ...
    {'Style', 'text', 'string', 'Warp too MS, [event1 event2...] (e.g. 0 12*1000,empty = median)', 'fontweight', 'bold' } ...
    { 'Style', 'edit', 'string', '' 'tag' 'timewarpms' }, {},{}...
    ...
    { 'Style', 'text', 'string', 'Plot Single Trials?', 'fontweight', 'bold' } ...
    { 'Style', 'checkbox', 'string' 'Fig+Subplot' 'tag' 'plotSingleTrial' } ...
    };
%plotSingleTrial
g = [1 0.3 0.6 0.4] ;
geometry = {g g g g g g [1 1]};

[ tmp1 tmp2 strhalt result ] = inputgui( geometry, uilist, ...
    'pophelp(''pop_timewarp_fft'');', 'Plot channel time frequency -- pop_timewarp_fft()');
% get eventms
if length( tmp1 ) == 0 return; end;
if isempty(result.twEvents)     result.twEvents = '2 3'; end


%change strings to nr
chan	     = eval( [ '[' result.chan    ']' ] );
%	tlimits	 = eval( [ '[' result.tlimits ']' ] );
%cycles	 = eval( [ '[' result.cycle   ']' ] );
freqs    = eval( [ '[' result.freqs   ']' ] );
twEvents = eval( [ '[' result.twEvents    ']' ] );



for i = 1:EEG.trials;
    eventIndex = [];
    for j = 1:length(twEvents)
        eventIndex = [eventIndex find(strcmp([EEG.epoch(i).eventtype], num2str(twEvents(j))))];
    end
    if length(eventIndex) ~= length(twEvents)
        error('Not all timewarping events are in every epoch (e.g. %i), make longer epochs',i)
    end
    eventms(i,:)=[EEG.epoch(i).eventlatency{eventIndex}];
end;

options = [];
options = [ options ',  ''timewarp'', eventms ,''plotitc'',''off'' ' ];

if result.nobase,   result.baseline = 'NaN'; end;

if ~isempty( result.baseline ),  options = [ options ', ''baseline'',[' result.baseline ']' ]; end;
if ~isempty( result.alpha ),     options = [ options ', ''alpha'',' result.alpha ];   end;
if result.fdr,                   options = [ options ', ''mcorrect'', ''fdr''' ];     end;
if result.basenorm == 2,         options = [ options ', ''basenorm'', ''on''' ];      end;
if result.basenorm == 4,         options = [ options ', ''basenorm'', ''on''' ];      end;
if result.basenorm >= 3,         options = [ options ', ''trialbase'', ''full''' ];      end;
if ~isempty(result.timewarpms),  options = [ options ', ''timewarpms'',[' result.timewarpms ']' ]; end %

if result.parallel
    parStr = '_par';
else
    parStr = '';
end
    

figure;
if result.chanCompBool
    dataStr = 'data'
else
    dataStr = 'icaact'
end
%evaluate the options from the gui
    %com = sprintf(['[ersp,itc,powbase,times,freqs,erspboot,itcboot,tfdata] =newtimef_par(EEG.data(%i,:,:),' ...
    com = sprintf(['[ersp,itc,powbase,times,freqs,erspboot,itcboot,tfdata] =newtimef' parStr '(EEG.' dataStr '(%i,:,:),' ...
        'EEG.pnts, [EEG.xmin*1000 EEG.xmax*1000], EEG.srate, [3 1], ''ntimesout'', 200 %s );'],chan, options );
    eval(com);
    title([ dataStr ':' num2str(chan)]);



if result.plotSingleTrial
    figure
    for i = 1:EEG.trials
        subplot(floor(EEG.trials/10),10,i),
        imagesc(times,freqs,abs(tfdata(:,:,i))),set(gca,'YDir','normal')
    end
end
