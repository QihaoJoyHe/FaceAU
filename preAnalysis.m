function analysis = preAnalysis(results)

% results
% 1=stimuliNum, 2=subNum, 3=subName, 4=gender, 5=age, 6=handness, 7=KeyResponseMap, 8=StimuliName, 9=emotype, 10=gender, 11=A_AU5_AU6, 12=A_AU9_AU12, 13=A_AU10_AU25, 14=P_AU5_AU6, 15=P_AU9_AU12, 16=P_AU10_AU25, 17=RT, 18=keycode, 19=emoResponse, 20=accuraacy, 21=endTime

analysis = cell(2,12);
results = results(2:length(results(:,1)),:);

% Filter out 'Miss' or empty
results = results(~(strcmp(results(:,17), 'miss') | cellfun(@isempty, results(:, 17))), :);
len = length(results(:,1));

%% accuracy analysis
% overall accuracy
analysis{1,1} = 'Overall_acc';
analysis{2,1} = sum(cell2mat(results(:,20)))/len; 

% specific emotion results: angry
analysis{1,2} = 'Angry_acc';
results_angry = results(contains(results(:,9),'Angry') == 1,:); 
analysis{2,2} = sum(cell2mat(results_angry(:,20)))/length(results_angry(:,1));

% specific emotion results: angry
analysis{1,3} = 'Happy_acc';
results_happy = results(contains(results(:,9),'Happy') == 1,:); 
analysis{2,3} = sum(cell2mat(results_happy(:,20)))/length(results_happy(:,1));

%% RT analysis
% overall correct
analysis{1,4} = 'RTcorrect';
analysis{2,4} = mean(cell2mat(results(cell2mat(results(:,20)) == 1,17))); % correct RTs

% overall wrong
wrongResponses = results(cell2mat(results(:,20)) == 0, :);
% Mean RT for incorrect responses
analysis{1,5} = 'RTwrong';
wrongRTs = cell2mat(wrongResponses(:, 17));
analysis{2,5} = mean(wrongRTs);

% RTs for 'Happy' correct
happyCorrectResponses = results(cell2mat(results(:,20)) == 1 & strcmp(results(:,9), 'Happy'), 17);
analysis{1,6} = 'RThappyCorrect';
analysis{2,6} = mean(cell2mat(happyCorrectResponses));

% RTs for 'Angry' correct
angryCorrectResponses = results(cell2mat(results(:,20)) == 1 & strcmp(results(:,9), 'Angry'), 17);
analysis{1,7} = 'RTangryCorrect';
analysis{2,7} = mean(cell2mat(angryCorrectResponses));

% RTs for 'Happy' wrong
happyWrongResponses = wrongResponses(strcmp(wrongResponses(:,9), 'Happy'), 17);
analysis{1,8} = 'RThappyWrong';
analysis{2,8} = mean(cell2mat(happyWrongResponses));

% RTs for 'Angry' wrong
angryWrongResponses = wrongResponses(strcmp(wrongResponses(:,9), 'Angry'), 17);
analysis{1,9} = 'RTangryWrong';
analysis{2,9} = mean(cell2mat(angryWrongResponses));

%% Other
OtherResponses = results(strcmp(results(:,19), 'Other'), :);
analysis{1,10} = 'OtherNum';
analysis{2,10} = size(OtherResponses, 1);
analysis{1,11} = 'RTOther';
analysis{2,11} = mean(cell2mat(OtherResponses(:, 17)));

%% attention check
% top 10% (120) esiest trials (sum of the 3 amplitude > 1.2848)
easyTials = results((cell2mat(results(:,11))+cell2mat(results(:,12))+cell2mat(results(:,13))) > 1.2848, :);
analysis{1,12} = 'EasyAccCheck';
analysis{2,12} = sum(cell2mat(easyTials(:,20)))/size(easyTials, 1);

return
end