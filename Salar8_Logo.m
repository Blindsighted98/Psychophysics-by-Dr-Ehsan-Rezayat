r=input('enter radius\n');
s=input('enter speed\n');
gameTime=20;
commandwindow
Screen('Preference', 'SkipSyncTests', 1);
[wPtr, rect] = Screen('OpenWindow', max(Screen('Screens')), [127 127 127],[0 0 1200 600]);
Width=rect(3);
Height=rect(4);
coordinates=[Width/2-r Height/2-r Width/2+r Height/2+r];
color=randi([0,255],[1,3])
Screen('FillOval',wPtr,color,coordinates);
Screen('Flip',wPtr);
KbWait();
WaitSecs(0.3);
tt=GetSecs;
%to make the movement randomize
thetta=randi([0,90],1)
while GetSecs<=tt+gameTime
    if KbCheck();
        break;
    end
    coordinates=coordinates +s.*[cosd(thetta),sind(thetta),cosd(thetta),sind(thetta)];
    Screen('FillOval',wPtr,color,coordinates);
    Screen('Flip',wPtr);
    %left and right
    if  coordinates(1)<=rect(1)||coordinates(3)>=rect(3)
        thetta=180-thetta;
        color=randi([0,255],[1,3]);
    end
    %up and down
    if coordinates(2)<=rect(2)||coordinates(4)>=rect(4)
        thetta=-thetta;
        color=randi([0,255],[1,3]);
    end
end
sca;