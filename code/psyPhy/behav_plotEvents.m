function behav_plotEvents(rawDat,varargin)
% plots all events, marks special events
%Input: rawDat, the vr-rawDat which contains rawDat.events
%       rawDat should also contain rawDat.time, the time is normalized to
%       the first entry
%event-codes that should be marked by vertical lines

    plot(rawDat.time-rawDat.time(1),rawDat.event)
    
    colorscale = ['rgbcmyk'];
    for k = 1:length(varargin)
    vline(rawDat.time(rawDat.event==varargin{k})-rawDat.time(1),colorscale(k),num2str(varargin{k}))
    end
    
