
%% Send means to repeated measures anove for SPSS
%also see repeatedmeasures.pdf page 9 for further details

% For 5 subject and 4 conditions we need a 5x4 matrix
% First column: Passive
% Second column: Proprioceptive
% Third column: Vestibular
% Fourth column: Active
% In the rows are the corresponding values from subject 1 to 5
A = [40, 30, 30, 20; 40, 30, 30, 20; 40, 30, 30, 20; 40, 30, 30, 20; 40, 30, 30, 20];

filename = '/net/store/projects/move/move_svn/code/psyPhy/meansPsyPhy.txt';

dlmwrite(filename, A, 'delimiter', ',')
