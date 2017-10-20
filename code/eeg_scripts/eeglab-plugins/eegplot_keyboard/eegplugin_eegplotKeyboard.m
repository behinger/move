function eegplugin_eegplotKeyboard( fig, try_strings, catch_strings);
 %plotmenu = findobj(fig, 'tag', 'plot');
%plotmenu = findobj(fig, 'tag', 'plot');
%uimenu( plotmenu, 'label', 'ERP plugin', 'callback', [try_strings.no_check 'figure; plot(EEG.times, mean(EEG.data,3));'])
% create menu
%toolsmenu = findobj(fig, 'tag', 'plot');
%submenu = uimenu( toolsmenu, 'label', 'Channel Data (Scroll+Keyboard)');
plotmenu = findobj(fig, 'tag', 'plot');
uimenu( plotmenu, 'label', 'Scroll Keyboard','callback', 'pop_eegplot_keyboard(EEG)')
return;
