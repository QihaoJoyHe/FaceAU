function [practiceResults, esc, PracticePass] = Practice(Data, w, xc, yc, exp_practice, Feedbacks, exp_fail, exp_pass, Seriesnum, subinfo, KeyResponseMap, ResultSavingPath)
% practice phases
% Parameters:
% Data: PracticeStimuli Data

global Leftkey Rightkey Upkey Esckey white centeredRect StimuliTime fixCrossDimPix lineWidthPix Blank flipIntv

% path parameters
currPath = pwd;

practicenum = 4;
variablenum = 14;
correct = 0;
esc = 0;

% Creat result matrix
results = cell(practicenum, variablenum);
% 1=subNum, 2=subName, 3=gender, 4=age, 5=handness, 6=KeyResponseMap,
% 7=StimuliName, 8=emotype, 9=gender, 10=RT, 11=keycode, 12=emoResponse,
% 13=accuracy, 14=endTime

% shuffle practice trials
temp_seed = clock; % use current second value as random seed
temp_seed = temp_seed(1,6);
seq_practice = shuffle(practicenum, temp_seed, 1);

% intruction
ShowInstructionsPress(w, exp_practice, 2);

for i = 1 : practicenum
    KbReleaseWait;
    
    % Show fixation, 0.8-1.2s
    FixationTime = 0.8+rand*0.4; % 0.8-1.2s
    fixation(w, xc, yc, fixCrossDimPix, lineWidthPix, white, FixationTime);

    % Show stimulus
    file = fullfile(currPath,'/PracticeStimuli',Data(seq_practice(i)).video);
    video = Screen('OpenMovie',w, file);
    Screen('PlayMovie', video, 1);

    % For RT
    videoEnded = 0;
    t0 = GetSecs;

    % initial time of vertical retraces
    vbl = Screen('Flip', w);

    % display video
    while GetSecs - t0 <= StimuliTime + Blank % time restriction
        if ~videoEnded
            % get next frame
            tex = Screen('GetMovieImage', w, video);

            % check the end
            if tex <= 0
                videoEnded = 1;
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
            results{i,10}=t;
            % record keycode
            results{i,11}='left';
            % record emoResponse
            if rem(Seriesnum,2) == 1 % 余数
                results{i,12}='Angry';
            elseif rem(Seriesnum,2) == 0
                results{i,12}='Happy';
            end
        elseif keyIsDown && keyCode(Upkey)
            t = secs - t0;
            % record RT
            results{i,10}=t;
            % record keycode
            results{i,11}='up';
            % record emoResponse
            results{i,12}='Other';
        elseif keyIsDown && keyCode(Rightkey)
            t = secs - t0;
            % record RT
            results{i,10}=t;
            % record keycode
            results{i,11}='right';
            % record emoResponse
            if rem(Seriesnum,2) == 1 % 余数
                results{i,12}='Happy';
            elseif rem(Seriesnum,2) == 0
                results{i,12}='Angry';
            end
        elseif keyIsDown && keyCode(Esckey)
            esc=1;
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

    results{i,7} = Data(seq_practice(i)).video; % StimuliName
    results{i,8} = Data(seq_practice(i)).emoType; % emotype
    results{i,9} = Data(seq_practice(i)).gender;
    results{i,14} = tstop;

    % gather demography data
    for sub = 1:length(subinfo)
        results{i,sub} = subinfo{sub};
    end
    results{i,6} = KeyResponseMap{1,1};

    % give feedback for missing
    if keyIsDown==0
        ShowInstructionsPress(w, Feedbacks{7}, 2);
        % record miss
        results{i,10} = 'miss'; % RT
        results{i,11} = 'miss'; % keycode
        results{i,12} = 'miss'; % emoResponse
    end

    % accuracy & feedback
    if strcmp(results{i,8}, results{i,12}) % identical
        results{i,13} = 1; % correct
        correct = correct + 1;
        % feedback
        if strcmp(results{i,12}, 'Happy') && strcmp(results{i,8}, 'Happy')
            ShowInstructionsPress(w, Feedbacks{1}, 2);
        elseif strcmp(results{i,12}, 'Angry') && strcmp(results{i,8}, 'Angry')
            ShowInstructionsPress(w, Feedbacks{2}, 2);
        end
    else
        results{i,13} = 0;
        % feedback
        if strcmp(results{i,12}, 'Angry') && strcmp(results{i,8}, 'Happy')
            ShowInstructionsPress(w, Feedbacks{3}, 2);
        elseif strcmp(results{i,12}, 'Happy') && strcmp(results{i,8}, 'Angry')
            ShowInstructionsPress(w, Feedbacks{4}, 2);
        elseif strcmp(results{i,12}, 'Other') && strcmp(results{i,8}, 'Happy')
            ShowInstructionsPress(w, Feedbacks{5}, 2);
        elseif strcmp(results{i,12}, 'Other') && strcmp(results{i,8}, 'Angry')
            ShowInstructionsPress(w, Feedbacks{6}, 2);
        end
    end    
    
    % save txt
    name_data_prac = fullfile(ResultSavingPath,['/practiceResults_',num2str(Seriesnum),'.txt']);
    writetable(cell2table(results),name_data_prac);

    % save mat
    save(strcat(ResultSavingPath,'/practiceResults_', num2str(Seriesnum), '.mat'), 'results');

    % break
    if esc==1
        break;
    end

end

practiceResults = results;

if correct == practicenum
    PracticePass = 1;
    ShowInstructionsPress(w, exp_pass, 2);
else
    PracticePass = 0;
    ShowInstructionsPress(w, exp_fail, 2);
end

return

end
