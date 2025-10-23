function [practice, test, redo] = RunExperimentDecision()
% Decide run which part in the experiment
prompt = {'Pratice Phase','Test Phase','Redo Missing Phase'};
title = 'Decide which part to run [1=Yes,0=No]'; % The title of the dialog box
definput = {'1','1','1'}; % Default input value(s)
runinfo = inputdlg(prompt, title, [1, 50], definput);
practice = str2num(runinfo{1});
test = str2num(runinfo{2});
redo = str2num(runinfo{3});
end