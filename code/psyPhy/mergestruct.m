function  out= mergestruct(varargin)
%MERGESTRUCT Merge structures with same fieldnames.

if nargin < 2
    out = varargin{1};
    return
end

% Initialize c with empty fields
% for k = 1:nargin
%     for l = 1:length(fn)
%         eval(['c.' fn{l} '= [];']);
%     end
% end

%concatenate the fields
for k = 2:nargin
    tmp = fieldnames(varargin{1});
    for m = 1:length(tmp)
        tmpSize = size(varargin{1}.(tmp{m}));
        if tmpSize(1) > tmpSize(2)
            varargin{1}.(tmp{m}) = [varargin{1}.(tmp{m}); varargin{k}.(tmp{m})];
        else
            varargin{1}.(tmp{m}) = [varargin{1}.(tmp{m}) varargin{k}.(tmp{m})];
        end
    end
    
    
%     for l = 1:length(fn)
%         eval(['c.' fn{l} '= [c.' fn{l} '; varargin{k} .' fn{l} '];']);
%     end
end
out = varargin{1};
