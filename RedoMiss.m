function [completeResults, redoMiss, esc] = RedoMiss(completeResults, Data, w, xc, yc, seq_test, exp_miss, Seriesnum, ResultSavingPath)

global Leftkey Rightkey Upkey Esckey white trialnum centeredRect StimuliTime fixCrossDimPix lineWidthPix Blank flipIntv

% path parameters
currPath = pwd;

redoMiss = 0; % if need redo
esc = 0;

missingnum = 0;
for nn = 1:trialnum
    if strcmp(completeResults{nn,17}, 'miss')
        missingnum = missingnum + 1;
        Missingidx(missingnum,1) = nn;
    end
end

for i = 1:missingnum
    KbReleaseWait;
    
    trial = Missingidx(i);

    % Show fixation, 0.8-1.2s
    FixationTime = 0.8 + rand * 0.4; % 0.8-1.2s
    fixation(w, xc, yc, fixCrossDimPix, lineWidthPix, white, FixationTime);

    % Show stimulus
    file = fullfile(currPath, '/Stimuli', Data(seq_test(trial)).video);
    video = Screen('OpenMovie', w, file);
    Screen('PlayMovie', video, 1);

    % For RT
    t0 = GetSecs;
    videoEnded = false;

    % initial time of vertical retraces
    vbl = Screen('Flip', w);
    
    % display video
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
            completeResults{trial,17} = t;
            % record keycode
            completeResults{trial,18} = 'left';
            % record emoResponse
            if rem(Seriesnum, 2) == 1 % 余数
                completeResults{trial,19} = 'Angry';
            elseif rem(Seriesnum, 2) == 0
                completeResults{trial,19} = 'Happy';
            end
        elseif keyIsDown && keyCode(Upkey)
            t = secs - t0;
            % record RT
            completeResults{trial,17} = t;
            % record keycode
            completeResults{trial,18} = 'up';
            % record emoResponse
            completeResults{trial,19} = 'Other';
        elseif keyIsDown && keyCode(Rightkey)
            t = secs - t0;
            % record RT
            completeResults{trial,17} = t;
            % record keycode
            completeResults{trial,18} = 'right';
            % record emoResponse
            if rem(Seriesnum, 2) == 1 % 余数
                completeResults{trial,19} = 'Happy';
            elseif rem(Seriesnum, 2) == 0
                completeResults{trial,19} = 'Angry';
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

    completeResults{trial,21} = tstop;

    % give feedback for missing
    if keyIsDown == 0
        ShowInstructionsPress(w, exp_miss, 2);
        redoMiss = 1;
        % record miss
        completeResults{trial,17} = 'miss'; % RT
        completeResults{trial,18} = 'miss'; % keycode
        completeResults{trial,19} = 'miss'; % emoResponse
    end

    % accuracy
    if strcmp(completeResults{trial,9}, completeResults{trial,19}) % identical
        completeResults{trial,20} = 1; % correct
    else
        completeResults{trial,20} = 0;
    end

    % save txt
    name_data_redo = fullfile(ResultSavingPath,['/redoResults_',num2str(Seriesnum),'.txt']);
    writetable(cell2table(completeResults),name_data_redo);

    % save mat
    save(strcat(ResultSavingPath,'/redoResults_', num2str(Seriesnum), '.mat'), 'completeResults');

    % break
    if esc == 1
        break;
    end
end

return

end
