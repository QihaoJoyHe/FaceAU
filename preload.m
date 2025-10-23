% Setup Psychtoolbox
Screen('Preference', 'SkipSyncTests', 1);  % Skip sync tests for this example
[window, windowRect] = Screen('OpenWindow', 0, [0 0 0]);  % Open a black screen window
Screen('Flip', window);  % Flip to clear the screen

% List of Video Files
videoDir = 'videos';  % Directory containing the video files
videoFiles = {'video1.avi', 'video2.avi', 'video3.avi'};  % List of video filenames

% Preload Video Frames into a Structure
allVideos = struct();

for vidIdx = 1:length(videoFiles)
    videoFilename = fullfile(videoDir, videoFiles{vidIdx});
    moviePtr = Screen('OpenMovie', window, videoFilename);
    
    frameIndex = 1;
    while true
        tex = Screen('GetMovieImage', window, moviePtr);
        if tex <= 0
            break;
        end
        
        allVideos(vidIdx).frames(frameIndex).tex = tex;
        frameIndex = frameIndex + 1;
    end
    
    Screen('PlayMovie', moviePtr, 0);  % Stop playback
    Screen('CloseMovie', moviePtr);  % Close the movie
end

% Play the Preloaded Videos
for vidIdx = 1:length(videoFiles)
    for frameIdx = 1:length(allVideos(vidIdx).frames)
        Screen('DrawTexture', window, allVideos(vidIdx).frames(frameIdx).tex);
        Screen('Flip', window);
        
        % Optionally, add a short pause to simulate frame rate
        pause(1/30);  % Assuming 30 fps
    end
end

% Clean Up
for vidIdx = 1:length(videoFiles)
    for frameIdx = 1:length(allVideos(vidIdx).frames)
        Screen('Close', allVideos(vidIdx).frames(frameIdx).tex);
    end
end

Screen('CloseAll');  % Close all Psychtoolbox windows