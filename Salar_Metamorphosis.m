clc,clear
subjectsCode=input('Please Enter Subjects Code\n','s');
Delay=[2 4 6];nDelay=size(Delay,2);
CollorsGrReBl=[0 255 0;255 0 0;0 0 0];
Sa=[68,71,74,78,81,84];nSa=size(Sa,2);Sb=76;
repeat=17;
nTrial=nSa*repeat*nDelay;
TextMessages = {'WAIT!', 'press SPACE to start','Correct','Incorrect'};
%oneBlockWithoutRepeat
data0Init=[repmat((1:nSa)',[nDelay,1]),repelem(Delay,nSa)'];
%data0:    1st Column is Sa Noise Code, 2nd is Delay, 3rd is RT, 4th is KeyPressed(s==>1,k==>2) 
%5th is Accuracy
data0=[repmat(data0Init,[repeat,1]),zeros(nTrial,3)];
data0=data0(Shuffle(1:nTrial),:);
duration=0.4;sampleRate=48000;
%Pink Noise or White Noise%Pink Noise May make an error in old versions of Matlab
% VoltageNormalNoise=pinknoise(1,duration*sampleRate);
VoltageNormalNoise=randn(1,duration*sampleRate)/3;
%use the following for MATLAB under 2015 versions
% NoiseA=nan(nSa,duration*sampleRate);
% for i=1:nSa
%     NoiseA(i,:)=VoltageNormalNoise./(10^((max(Sa)-Sa(i))/20));
% end
%every ROW in NoiseA and NoiseB is a noise for each noise code
%May make an error in old versions of Matlab
NoiseA=repmat(VoltageNormalNoise,[nSa       ,1])./(10.^((max(Sa)-Sa)/20)');
NoiseB=repmat(VoltageNormalNoise,[size(Sb,2),1])./(10.^((max(Sa)-Sb)/20)');
%Creating Auditory Go Cue
GoFrequency = 6000;GoDuration = 0.2;
beep = MakeBeep(GoFrequency, GoDuration, sampleRate);
commandwindow
Screen('Preference', 'SkipSyncTests', 1);
[wPtr, rect] = Screen('OpenWindow', max(Screen('Screens')), [127 127 127]); %,[0 0 1000 500]);
W=rect(3);H=rect(4);
font=struct('size',round(W/27),'name','Times');
Screen('TextFont',wPtr,font.name);
Screen('TextSize',wPtr,font.size);
Side=50;
CoordinatesLR=[W/4-Side H/2-Side   W/4+Side H/2+Side
             3*W/4-Side H/2-Side 3*W/4+Side H/2+Side];
for i=1:nTrial
    %press Space to start the trial
    DrawFormattedText(wPtr, TextMessages{2}, 'center', 'center', CollorsGrReBl(3,:));
    Screen('Flip',wPtr);
    RestrictKeysForKbCheck([KbName('space')]);
    KbWait();
    %resetting the KBcheck, and clearing the screen
    RestrictKeysForKbCheck([]);
    %Primal Delay
    Screen('Flip',wPtr);
    WaitSecs(0.25);
    %GREEN At the Left
    Screen('FillRect',wPtr,CollorsGrReBl(1,:),CoordinatesLR(1,:));
    Screen('Flip',wPtr);
    %playing Sa
    sound(NoiseA(data0(i,1),:),sampleRate);
    %waiting for Sa to finish
    WaitSecs(duration);
    %WAIT at the center
    Screen('FillRect',wPtr,CollorsGrReBl(1,:),CoordinatesLR(1,:));
    DrawFormattedText(wPtr, TextMessages{1}, 'center', 'center', CollorsGrReBl(3,:));
    Screen('Flip',wPtr);
    %variable delay, using third Column of data0 for delays
    WaitSecs(data0(i,2));
    %Red at the Right %GREEN At the Left
    Screen('FillRect',wPtr,CollorsGrReBl(1,:),CoordinatesLR(1,:));
    Screen('FillRect',wPtr,CollorsGrReBl(2,:),CoordinatesLR(2,:));
    Screen('Flip',wPtr);
    %playing Sb
    sound(NoiseB(1,:),sampleRate)
    %waiting for Sb to finish
    WaitSecs(duration);
    %Subsequent Delay
    WaitSecs(0.250)
    %Playing go Cue Auditory for 0.2 and waiting to Finnish
    sound(beep,sampleRate);
    WaitSecs(GoDuration)
    %Response Collection
    RestrictKeysForKbCheck([KbName('s'), KbName('k')]);
    %RT
    t = GetSecs();
    [~, keycode] = KbWait();
    data0(i,3) = GetSecs() - t;
    %Key Pressed
    keyName = KbName(find(keycode));
    if strcmp(keyName, 's')
        data0(i,4) = 1;
    else
        data0(i,4) = 2;
    end
    RestrictKeysForKbCheck([]);
    %checking accuracy%Correct Answers
    % KeyPressed==> "S" && Sa was louder   || KeyPressed==> "K" && Sb was louder 
    if (data0(i,4)==1&& Sa(data0(i,1))>Sb) || (data0(i,4)==2&& Sa(data0(i,1))<Sb) 
        data0(i,5)=1;
        DrawFormattedText(wPtr, TextMessages{3}, 'center', 'center', CollorsGrReBl(3,:));
        Screen('Flip',wPtr);
    %Wrong Answers%if he didnt choose the following then he is wrong and data0(i,5)%remains zero
    else
        DrawFormattedText(wPtr, TextMessages{4}, 'center', 'center', CollorsGrReBl(3,:));
        Screen('Flip',wPtr);
    end
    %feedback During this 1.0  seconds
    WaitSecs(1.0)    
end
save(subjectsCode,'data0')
RestrictKeysForKbCheck([]);
sca;
x=Sa-Sb;
y=zeros(nDelay,nSa);
%Each column of y Belongs to Sa-Sb=-8,-5,-2,2,5,8
%each row   is the number of S pressed in the 2,4,6 Delays respecTively
for i=1:nDelay
    for j=1:nSa
               %howManyTimes pressed S    & Delays            & Sa==1,2,3,4,5,6
    y(i,j)=100*(sum((data0(:,4)==1)&(data0(:,2)==Delay(i))&(data0(:,1)==j)))/repeat;
    end
end
plot(x, y(1,:), 'b-o', 'LineWidth', 2, 'MarkerSize', 5);hold on;
plot(x, y(2,:), 'r-s', 'LineWidth', 1, 'MarkerSize', 10);hold on;
plot(x, y(3,:), 'g-d', 'LineWidth', 0.5, 'MarkerSize', 15);hold on;
legend({'Delay = 2', 'Delay = 4', 'Delay = 6'}, 'Location', 'best');
title("Delay's Effect on S Response", 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Sa-Sb', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Percentage of "S" Pressed', 'FontSize', 14, 'FontWeight', 'bold');