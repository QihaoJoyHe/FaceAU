function [vDist,winWidth,resolutionY] = getBehavInfo()
% Behavioural Information Collection
% Obtain some information of experiment
% vDist:  viewing distane (cm)
% winWidth: screen width (cm)
% resolutionX: the resolution of X (width), could find it in the system

prompt = {'What is the visual distance value (cm)? ','What is the height of window (cm)? ','What is the resolution in height of window? '};
title = 'Behavioural information'; % The title of the dialog box
definput = {'79','33','1080'}; % Default input value(s)
behavinfo = inputdlg(prompt, title, [1, 50], definput);
vDist = str2num(behavinfo{1});
winWidth = str2num(behavinfo{2});
resolutionY = str2num(behavinfo{3});
end
