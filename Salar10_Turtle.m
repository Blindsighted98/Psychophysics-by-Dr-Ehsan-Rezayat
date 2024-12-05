r=input('enter the radius\n');
s=2;
rColor=[255,0,0];
gColor=[0,255,0];
bColor=[0,0,255];
commandwindow
Screen('Preference', 'SkipSyncTests', 1);
[wPtr, rect] = Screen('OpenWindow', max(Screen('Screens')), [127 127 127],[0 0 1200 600]);
Width=rect(3);
Height=rect(4);
coordinates=[Width/2-r Height/2-r Width/2+r Height/2+r];
color=randi([0,255],[1,3]);
Screen('FillOval',wPtr,color,coordinates);
Screen('Flip',wPtr);
KbWait();
WaitSecs(0.5);
x1=Width/2;
y1=Height/2;
while 1
    [x0,y0,btn]=GetMouse();
    if any(btn)
        sca;
        break;

    end
    xd=x0-x1;
    yd=y0-y1;
    d=sqrt(xd.^2+yd.^2);
    if d>2
        x1=x1 + s*xd/d;
        y1=y1 + s*yd/d;
    end
    Screen('FillOval',wPtr,color,[x1-r,y1-r,x1+r,y1+r]);
    Screen('Flip',wPtr);
    [pressed, ~, keyCode] = KbCheck();
    if pressed
        whichKey = KbName(find(keyCode));
        if strcmp(whichKey,'r')
            color=rColor;
        elseif strcmp(whichKey,'b')
            color=bColor;
        elseif strcmp(whichKey,'g')
            color=gColor;
        end
    end
end
KbWait();
sca;