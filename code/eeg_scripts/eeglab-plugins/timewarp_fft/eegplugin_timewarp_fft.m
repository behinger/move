function eegplugin_eegplotKeyboard( fig, try_strings, catch_strings);
 %plotmenu = findobj(fig, 'tag', 'plot');
%plotmenu = findobj(fig, 'tag', 'plot');
%uimenu( plotmenu, 'label', 'ERP plugin', 'callback', [try_strings.no_check 'figure; plot(EEG.times, mean(EEG.data,3));'])
% create menu
%toolsmenu = findobj(fig, 'tag', 'plot');
%submenu = uimenu( toolsmenu, 'label', 'Channel Data (Scroll+Keyboard)');
plotmenu = findobj(fig, 'tag', 'plot');


cmd = ['[LASTCOM] = pop_timewarp_fft(EEG);'];  % this end seems to be of a bug, just delete it if there is an error of "too many ends" or similar    
uimenu( plotmenu, 'label', 'timewarp TimeFrequency','callback', [try_strings.check_ica cmd catch_strings.add_to_hist])




return;
