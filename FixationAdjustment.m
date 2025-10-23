function esc = FixationAdjustment(window, windowRect, Instruction, fixCrossDimPix,lineWidthPix, Color)

% Parameters:
% Instruction = MakeTextures(FixationAdjust);

global Esckey Triggerkey

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Enable alpha blending for anti-aliasing
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% Define the destination rectangles for our spiral textures. For this demo
% these will be the same size as out actualy texture, but this doesn't have
% to be the case. See: ScaleSpiralTextureDemo and CheckerboardTextureDemo.
baseRect = [0 0 screenXpixels screenYpixels];

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];

% exp_fixation = Screen('MakeTexture',window,Instruction);
% Adjust the seat according to the fixation
Screen('DrawTexture', window, Instruction,[],baseRect);
Screen('DrawLines', window, allCoords,lineWidthPix, Color, [xCenter yCenter], 2);
Screen('Flip',window);
while 1
    [keyisdown, ~, keycode] = KbCheck;
    if keyisdown && keycode(Esckey)
        esc = 1;
        break
    elseif keyisdown && keycode(Triggerkey)
        break
    end
end
KbReleaseWait;
end