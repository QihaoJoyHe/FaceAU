function fixation(w, xc, yc, len, width, color, time)
    Screen('FillRect',w,color,CenterRectOnPointd([0,0,len,width],xc,yc));
    Screen('FillRect',w,color,CenterRectOnPointd([0,0,width,len],xc,yc));
    Screen('Flip', w);
    WaitSecs(time);
end