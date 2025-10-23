function esc = ShowInstructionsPress(window, Instructions, anykey)

global Esckey Triggerkey

% show instructions and waiting for response
%
% Parameters:
% Instruction = MakeTextures(FixationAdjust)
% anykey: 1 = KbStrokeWait, 2 = specific key waiting

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Text font and text color
TextFont = 'Arial'; %Current: 宋体；other option: 'Simhei'
TextSize = 50;

% Define the destination rectangles for our spiral textures. For this demo
% these will be the same size as out actualy texture, but this doesn't have
% to be the case. See: ScaleSpiralTextureDemo and CheckerboardTextureDemo.
baseRect = [0 0 screenXpixels screenYpixels];

esc = 0;

while 1
    % display Instructions for which block will be next
    % sad-neutral block
    Screen('DrawTexture', window, Instructions,[],baseRect);
    Screen('Flip',window);
    %     x= Screen('GetImage', window); % [100 100 center(1)*2-100 center(2)*2-100]
    %     writeVideo(vidObj,x);

    if anykey == 1
        if KbStrokeWait % waiting for key pressing
            break
        end
    end
    if anykey == 2
        if KbCheck % waiting for key pressing
            [keyisdown, ~, keycode] = KbCheck;
            if keyisdown && keycode(Esckey)
                esc = 1;
                break
            elseif keyisdown && keycode(Triggerkey)
                break
            end
        end
    end
end
KbReleaseWait;
end