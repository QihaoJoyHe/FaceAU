function esc = ShowRest(w, Instructions, num)

% show rest press & next block
%
% Parameters:
% Instruction = MakeTextures(Rest)
% num = current trailnum
% blocks = total blocksnum

global white Esckey Triggerkey

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', w);

% Define the destination rectangles for our spiral textures. For this demo
% these will be the same size as out actualy texture, but this doesn't have
% to be the case. See: ScaleSpiralTextureDemo and CheckerboardTextureDemo.
baseRect = [0 0 screenXpixels screenYpixels];

TextFont = 'SimHei'; 
TextSize = 50;

nextBlock = (num / 20) + 1;

esc = 0;

while 1

    Screen('DrawTexture', w, Instructions,[],baseRect);
    DrawFormattedText(w, ['Next block: ', num2str(nextBlock)], 'center', 'center', white); % next block
    Screen('Flip',w);

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

KbReleaseWait;

end