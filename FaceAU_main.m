% FaceAU
% Pilot study
% Goal: choose facial expressions with high accuracy
% By Qihao He, 2025 February

%% Experiment
% Clear the workspace and the screen
prompt = {'if has quitted the program in the middle, please enter 0'};
definput = {'1'}; % Default input value(s)
title = 'New Participant? [1=Y,0=N]';                           
NewParticipant = inputdlg(prompt, title, [1, 50], definput);
NewParticipant = str2num(NewParticipant{1});

if NewParticipant
    sca;
    clear;
    clc;
    NewParticipant = 1;
end
totalTime0 = GetSecs;
[vDist,winWidth,resolutionY] = getBehavInfo();

% path parameters
currPath = pwd;

% boolean variables
esc = 0; % if subjects want to quit
[practice, test, redo] = RunExperimentDecision();
boolean = [practice; test; redo];
PracticePass = 0;
redoMiss = 0; % if need redo
run = 1;

% counting variable
practice_times = 0;

% load data
load('StimuliList.mat','Stimuli');
load('PracticeStimuliList.mat','PracticeStimuli');

global trialnum variablenum StimuliTime Blank
% Parameters
StimuliTime = 1.5; % s
Blank = 0.5; % s
trials = 20;
blocks = 4;
trialnum = trials * blocks; % number of trials(videos)
repetition = 1;
variablenum = 21; % 1=stimuliNum, 2=subNum, 3=subName, 4=gender, 5=age, 6=handness, 7=KeyResponseMap, 8=StimuliName, 9=emotype, 10=gender, 11=A_AU5_AU6, 12=A_AU9_AU12, 13=A_AU10_AU25, 14=P_AU5_AU6, 15=P_AU9_AU12, 16=P_AU10_AU25, 17=RT, 18=keycode, 19=emoResponse, 20=accuraacy, 21=endTime
parameternum = 15; % 1=vDist, 2=winWidth, 3=resolutionY, 4=flipIntv, 5=refreshRate, 6=StimuliTime, 7=Blank, 8=trialnum, 9=facesize, 10=VideoY, 11=VideoX, 12=paracticeDuration, 13=testDuration, 14=redoDuration, 15=totalDuration

% Text font and text color
TextFont = 'Arial'; %Current: 宋体；other option: 'Simhei'
TextSize = 50;

% Stimuli viewing parameters
cmpd = tand(1/2) * vDist * 2; % cm per degree
ppd = cmpd * resolutionY / winWidth; % pixel per degree
% stimuli size
facesize = 9.5; % degree; vertical

% Fixation cross parameters
fixDim = 1;
fixWidth = fixDim / 10;

global fixCrossDimPix lineWidthPix
% arm
fixCrossDimPix = round(fixDim * ppd);
% width
lineWidthPix = round(fixWidth * ppd);

%Image parameters
InitialImageY = 800; % pixel
InitialImageX = 600;
faceY = 665; % pixel
HWratio = InitialImageX/InitialImageY;
IFratio = InitialImageY/faceY; % image/face
videoppd = facesize * ppd * IFratio;
VideoY = round(videoppd);
VideoX = round(videoppd * HWratio);

% response keys
KbName('UnifyKeyNames');
global Leftkey Rightkey Upkey Esckey Triggerkey
Leftkey = KbName('LeftArrow'); 
Rightkey = KbName('RightArrow'); 
Upkey=KbName('UpArrow');
Esckey=KbName('escape');
Triggerkey = KbName('space'); 
RestrictKeysForKbCheck([Leftkey Rightkey Upkey Esckey Triggerkey]);

% Get demography data
if NewParticipant
    subinfo = getSubInfo();
    Seriesnum = str2num(subinfo{1});
end

% create results saving folder
global ResultSavingPath
ResultSavingPath = [currPath,'/ResultsSummary/',num2str(Seriesnum),'_FaceAUResults'];
mkdir(ResultSavingPath);

% load all instructions 左右按键调换
if rem(Seriesnum,2) == 1 % 余数
    load('Instructions1.mat');
elseif rem(Seriesnum,2) == 0
    load('Instructions2.mat');
end

% generate random order
rng(double(Seriesnum)); % Initialize the random number generator to make the results repeatable, make rng different for different subjects
s = rng; % save the random number generator setting in struct format
% key-response mapping
KeyResponseMap = balancekeyresponsemap(Seriesnum); % balancekeyresponse
% shuffle test stimuli
seq_test = randperm(1200, trialnum);


% Creat result names
columnNames = {'stimuliNum', 'subNum', 'subName', 'gender_1m_2f', 'age', 'handness_1l_2r', 'KeyResponseMap', 'StimuliName', 'emotype', 'gender','A_AU5_AU6', 'A_AU9_AU12', 'A_AU10_AU25', 'P_AU5_AU6', 'P_AU9_AU12', 'P_AU10_AU25', 'RT', 'keycode', 'emoResponse', 'accuracy', 'endTime'};
% Creat result matrix
results = cell(trialnum, variablenum);
% Creat instrument parameters matrix
parameters = cell(1, parameternum);

% record instrument parameters
parameters{1,1} = vDist;
parameters{1,2} = winWidth;
parameters{1,3} = resolutionY;
parameters{1,6} = StimuliTime;
parameters{1,7} = Blank;
parameters{1,8} = trialnum;
parameters{1,9} = facesize;
parameters{1,10} = VideoY;
parameters{1,11} = VideoX;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

try
    AssertOpenGL;
    InitializeMatlabOpenGL; % OpenGL for image rendering
    Screen('Preference', 'SkipSyncTests', 1);
    HideCursor;

    ListenChar(2);

    % Get the screen numbers
    screens = Screen('Screens');
    screenNumber = max(screens);

    global white black
    % Define black and white
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber);

    % Open window
%     [w, Rect] = PsychImaging('OpenWindow', screenNumber, black, [50 50 950 950]); % test
    [w, Rect] = PsychImaging('OpenWindow', screenNumber, black);

    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [xc, yc] = RectCenter(Rect);
    [ResX, ResY] = Screen('WindowSize',w);
    [width, height]=Screen('DisplaySize', w); % 物理大小mm
    global flipIntv
    flipIntv = Screen('GetFlipInterval',w);% 刷屏时间
    slack = flipIntv / 2; % for precise timing

    % record flipIntv
    parameters{1,4} = flipIntv;
    parameters{1,5} = 1 / flipIntv;

    % Make textures in advance, to decrease time delay
    exp_start = Screen('MakeTexture',w,Instruction.Start);
    exp_practice = Screen('MakeTexture',w,Instruction.Practice);
    exp_test = Screen('MakeTexture',w,Instruction.Test);
    exp_redo = Screen('MakeTexture',w,Instruction.Redo);
    exp_miss = Screen('MakeTexture',w,Instruction.Miss);
    exp_end = Screen('MakeTexture',w,Instruction.End);
    exp_fixation = Screen('MakeTexture',w,Instruction.Adjust);
    exp_rest = Screen('MakeTexture',w,Instruction.Rest);
    exp_fail = Screen('MakeTexture',w,Instruction.Fail);
    exp_pass = Screen('MakeTexture',w,Instruction.Pass);
    exp_correctHH = Screen('MakeTexture',w,Instruction.CorrectHH);
    exp_correctAA = Screen('MakeTexture',w,Instruction.CorrectAA);
    exp_wrongAH = Screen('MakeTexture',w,Instruction.WrongAH);
    exp_wrongHA = Screen('MakeTexture',w,Instruction.WrongHA);
    exp_wrongUH = Screen('MakeTexture',w,Instruction.WrongUH);
    exp_wrongUA = Screen('MakeTexture',w,Instruction.WrongUA);
    exp_pracmiss = Screen('MakeTexture',w,Instruction.PracMiss);

    % pack feedbacks
    Feedbacks = {exp_correctHH, exp_correctAA, exp_wrongAH, exp_wrongHA, exp_wrongUH, exp_wrongUA, exp_pracmiss};

    % Center the rectangle on the centre of the screen using fractional pixel
    global centeredRect
    VideoRect = [0 0 VideoX VideoY];
    centeredRect = CenterRectOnPointd(VideoRect, xc, yc);

    % Preload videos in the 1st block into a structure
    videos = struct();
    for ind = 1:trials
        file = fullfile(currPath,'/Stimuli',Stimuli(seq_test(ind)).video);
        videos(ind).file = file; 
        videos(ind).handle = Screen('OpenMovie',w, file);
    end


    % Adjust the seat according to the fixation
    FixationAdjustment(w, Rect, exp_fixation, fixCrossDimPix,lineWidthPix, white);

    % display instructions and wait for press
    ShowInstructionsPress(w, exp_start, 2); 

    while run == 1
        % practice phase
        if practice == 1
            tprac0 = GetSecs;
            while ~PracticePass
                practice_times = practice_times + 1;
                [practiceResults, esc, PracticePass] = Practice(PracticeStimuli, w, xc, yc, exp_practice, Feedbacks, exp_fail, exp_pass, Seriesnum, subinfo, KeyResponseMap, ResultSavingPath);
                practiceColumnNames = {'subNum', 'subName', 'gender_1m_2f', 'age', 'handness_1l_2r', 'KeyResponseMap', 'StimuliName', 'emotype', 'gender', 'RT', 'keycode', 'emoResponse', 'accuracy', 'endTime'};

                % save results
                practiceResultsWithNames = [practiceColumnNames; practiceResults];
                save([ResultSavingPath,'/practiceResults_',num2str(Seriesnum),'_',subinfo{2},'_Gender1m2f_',num2str(subinfo{3}),'_Age_',num2str(subinfo{4}),'_',datestr(datetime('now'),30),'.mat'],'practiceResultsWithNames');
                % save txt
                filePrac = fullfile(ResultSavingPath,['/practiceResults_',num2str(Seriesnum),'_',subinfo{2},'_Gender1m2f_',num2str(subinfo{3}),'_Age_',num2str(subinfo{4}),'_',datestr(datetime('now'),30),'.txt']);
                writetable(cell2table(practiceResultsWithNames),filePrac);

                if esc == 1
                    run = 0; 
                    break
                end
            end

            pracTime = GetSecs - tprac0;
            parameters{1,12} = pracTime;

            if esc == 1
                run = 0;
                break
            end
        end


        % test phase
        if test == 1
            ttest0 = GetSecs;
            % instruction 
            ShowInstructionsPress(w, exp_test, 2);

%             for i = 1:15 % test
            for i = 1:trialnum
                KbReleaseWait;

                % Show fixation, 0.8-1.2s
                FixationTime = 0.8 + rand * 0.4; % 0.8-1.2s
                fixation(w, xc, yc, fixCrossDimPix, lineWidthPix, white, FixationTime);
            
                % Show stimulus
                video = videos(i).handle;
                Screen('PlayMovie', video, 1);
            
                % For RT
                videoEnded = false;
                t0 = GetSecs;
            
                % initial time of vertical retraces
                vbl = Screen('Flip', w);

                % display video & blank
                while GetSecs - t0 <= StimuliTime + Blank % time restriction
                    if ~videoEnded
                        % get next frame
                        tex = Screen('GetMovieImage', w, video);
            
                        % check the end
                        if tex <= 0
                            videoEnded = true;
                            Screen('PlayMovie', video, 0); % stop the video
                        else
                            % display frame
                            Screen('DrawTexture', w, tex, [], centeredRect);
                            vbl = Screen('Flip', w, vbl + 0.5 * flipIntv);
            
                            % close tex
                            Screen('Close', tex);
                        end
                    else
                        % display blank
                        Screen('FillRect', w, 0);
                        vbl = Screen('Flip', w, vbl + 0.5 * flipIntv);
                    end
            
                    % check the key
                    [keyIsDown, secs, keyCode] = KbCheck;
                    if keyIsDown && keyCode(Leftkey)
                        t = secs - t0;
                        % record RT
                        results{i,17} = t;
                        % record keycode
                        results{i,18} = 'left';
                        % record emoResponse
                        if rem(Seriesnum, 2) == 1 % 余数
                            results{i,19} = 'Angry';
                        elseif rem(Seriesnum, 2) == 0
                            results{i,19} = 'Happy';
                        end
                    elseif keyIsDown && keyCode(Upkey)
                        t = secs - t0;
                        % record RT
                        results{i,17} = t;
                        % record keycode
                        results{i,18} = 'up';
                        % record emoResponse
                        results{i,19} = 'Other';
                    elseif keyIsDown && keyCode(Rightkey)
                        t = secs - t0;
                        % record RT
                        results{i,17} = t;
                        % record keycode
                        results{i,18} = 'right';
                        % record emoResponse
                        if rem(Seriesnum, 2) == 1 % 余数
                            results{i,19} = 'Happy';
                        elseif rem(Seriesnum, 2) == 0
                            results{i,19} = 'Angry';
                        end
                    elseif keyIsDown && keyCode(Esckey)
                        esc = 1;
                        break;
                    end

                    if keyIsDown && (keyCode(Leftkey) || keyCode(Upkey) || keyCode(Rightkey))
                        Screen('PlayMovie', video, 0);
                        break;
                    end
                end
 
                tstop = GetSecs - t0;
                % close the video
                Screen('CloseMovie', video);
            
                results{i,1} = Stimuli(seq_test(i)).num; % stimuliNum
                results{i,8} = Stimuli(seq_test(i)).video; % StimuliName
                results{i,9} = Stimuli(seq_test(i)).emoType; % emotype
                results{i,10} = Stimuli(seq_test(i)).gender; 
                results{i,11} = Stimuli(seq_test(i)).A_AU5_AU6; 
                results{i,12} = Stimuli(seq_test(i)).A_AU9_AU12; 
                results{i,13} = Stimuli(seq_test(i)).A_AU10_AU25;
                results{i,14} = Stimuli(seq_test(i)).P_AU5_AU6;
                results{i,15} = Stimuli(seq_test(i)).P_AU9_AU12;
                results{i,16} = Stimuli(seq_test(i)).P_AU10_AU25;
                results{i,21} = tstop;
            
                % gather demography data
                for sub = 1:length(subinfo)
                    results{i,sub + 1} = subinfo{sub};
                end
                results{i,7} = KeyResponseMap{1,1};
            
                % give feedback for missing
                if keyIsDown == 0
                    ShowInstructionsPress(w, exp_miss, 2);
                    redoMiss = 1;
                    % record miss
                    results{i,17} = 'miss'; % RT
                    results{i,18} = 'miss'; % keycode
                    results{i,19} = 'miss'; % emoResponse
                end
            
                % accuracy
                if strcmp(results{i,9}, results{i,19}) % identical
                    results{i,20} = 1; % correct
                else
                    results{i,20} = 0;
                end
            
                % rest, 60 blocks * 20 trails
                if mod(i, trials) == 0 && i < blocks * trials
                    ShowRest(w, exp_rest, i);
            
                    % preload videos in the next block
                    for ind = (i + 1):(i + trials)
                        file = fullfile(currPath, '/Stimuli', Stimuli(seq_test(ind)).video);
                        videos(ind).file = file;
                        videos(ind).handle = Screen('OpenMovie', w, file);
                    end
                end
            
                % save txt
                name_data_test = fullfile(ResultSavingPath,['/initialResults_',num2str(Seriesnum),'.txt']);
                writetable(cell2table(results),name_data_test);

                % save mat
                save(strcat(ResultSavingPath,'/initialResults_', num2str(Seriesnum), '.mat'), 'results');

                % break
                if esc == 1
                    break;
                end
            end
        
            testTime = GetSecs - ttest0;
            parameters{1,13} = testTime;

            % sort
            firstColumn = cell2mat(results(:,1));
            [~, sortedIdx] = sort(firstColumn);
            sortedResults = results(sortedIdx, :);
            
            % Combine column names and results
            initialResultsWithNames = [columnNames; sortedResults];
            % save results mat
            save([ResultSavingPath,'/initialSortedResults_',num2str(Seriesnum),'_',subinfo{2},'_Gender1m2f_',num2str(subinfo{3}),'_Age_',num2str(subinfo{4}),'_',datestr(datetime('now'),30),'.mat'],'initialResultsWithNames');
            % save txt
            fileInitial = fullfile(ResultSavingPath,['/initialSortedResults_',num2str(Seriesnum),'_',subinfo{2},'_Gender1m2f_',num2str(subinfo{3}),'_Age_',num2str(subinfo{4}),'_',datestr(datetime('now'),30),'.txt']);
            writetable(cell2table(initialResultsWithNames),fileInitial);
            
            if esc == 1
                run = 0; 
                break
            end
        end

        % redo missing trials
        if redo == 1 && redoMiss == 1
            tredo0 = GetSecs;
            completeResults = results;
            % redo instruction
            ShowInstructionsPress(w, exp_redo, 2);
            % redo loop
            while redoMiss == 1
                [completeResults, redoMiss, esc] = RedoMiss(completeResults, Stimuli, w, xc, yc, seq_test, exp_miss, Seriesnum, ResultSavingPath);
            end

            redoTime = GetSecs - tredo0;
            parameters{1,14} = redoTime;

            % sort
            completeSortedResults = completeResults(sortedIdx, :);

            % save redo results
            redoResultsWithNames = [columnNames; completeSortedResults];
            save([ResultSavingPath,'/completeResults_',num2str(Seriesnum),'_',subinfo{2},'_Gender1m2f_',num2str(subinfo{3}),'_Age_',num2str(subinfo{4}),'_',datestr(datetime('now'),30),'.mat'],'redoResultsWithNames');
            % save txt
            fileRedo = fullfile(ResultSavingPath,['/completeResults_',num2str(Seriesnum),'_',subinfo{2},'_Gender1m2f_',num2str(subinfo{3}),'_Age_',num2str(subinfo{4}),'_',datestr(datetime('now'),30),'.txt']);
            writetable(cell2table(redoResultsWithNames),fileRedo);

            if esc == 1
                run = 0; 
                break
            end
        end

        run = 0;
        break
    end

    % end
    if esc==0
        ShowInstructionsPress(w, exp_end, 2);
    end
   
    parameters{1,15} = GetSecs - totalTime0;
    % save instrument parameters & experiment duration
    parameterNames = {'vDist', 'winWidth', 'resolutionY', 'flipIntv', 'refreshRate', 'StimuliTime', 'Blank', 'trialnum', 'facesize', 'VideoY', 'VideoX', 'paracticeDuration', 'testDuration', 'redoDuration', 'totalDuration'};
    parameters = [parameterNames; parameters];
    save([ResultSavingPath,'/Parameters_',num2str(Seriesnum),'_',subinfo{2},'_Gender1m2f_',num2str(subinfo{3}),'_Age_',num2str(subinfo{4}),'_',datestr(datetime('now'),30),'.mat'],'parameters');

    % pre-analysis data
    if exist('initialResultsWithNames')
        PreAnalysis_Results.test = preAnalysis(initialResultsWithNames);
    end
    
    if exist('redoResultsWithNames')
        PreAnalysis_Results.redo = preAnalysis(redoResultsWithNames);
    end

    if exist('PreAnalysis_Results')
        save([ResultSavingPath,'/PreAnalysisResults_',num2str(Seriesnum),'_',subinfo{2},'_Gender1m2f_',num2str(subinfo{3}),'_Age_',num2str(subinfo{4}),'_',datestr(datetime('now'),30),'.mat'],'PreAnalysis_Results'); % save pre-analysis results
    end

    ShowCursor;
    sca;
    ListenChar(0);

catch

    ShowCursor;
    sca;
    ListenChar(0);
    psychrethrow(psychlasterror);

end
