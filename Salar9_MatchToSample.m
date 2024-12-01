%آدرس پوشه عکس
path=[cd,'\Images'];
files=dir(path);
files=files(1:end-2);
n=length(files);
texture=nan(1,n);

%اجرا کردن سایکتولباکس
Screen('Preference', 'SkipSyncTests', 1);
[wPtr, rect] = Screen('OpenWindow', max(Screen('Screens')), [127 127 127],[0 0 1000 500]);
W =rect(3);
H=rect(4);
side=0.4*W;
a=H/100;
b=H/10;
coord=[W/4-side/2,H/2-side/2,W/4+side/2,H/2+side/2;3*W/4-side/2,H/2-side/2,3*W/4+side/2,H/2+side/2];
for i=1:n
    pic=imread(files(i).name);
    texture(i)=Screen('MakeTexture',wPtr,pic);
end
order1=randperm(n);
order2=randperm(n);
for i= 1:n
    WaitSecs(0.5)
    Screen('DrawTexture',wPtr,texture(order1(i)),[],[W/2-side/2,H/2-side/2,W/2+side/2,H/2+side/2]);
    Screen('Flip',wPtr);
    KbWait();
    WaitSecs(0.5);

    %Fixation Cross
    Screen('FillRect',wPtr,[0 0 0],[W/2-a/2,H/2-b/2,W/2+a/2,H/2+b/2]);
    Screen('FillRect',wPtr,[0 0 0],[W/2-b/2,H/2-a/2,W/2+b/2,H/2+a/2]);
    Screen('Flip',wPtr);
    %KbWait();
    WaitSecs(0.5);

    coord=coord(randperm(2,2),:);

    Screen('DrawTexture',wPtr,texture(order1(i)),[],coord(1,:));
    Screen('DrawTexture',wPtr,texture(order2(i)),[],coord(2,:));
     Screen('Flip',wPtr);
     WaitSecs(0.5);
end


KbWait();
WaitSecs(0.3);

sca; 