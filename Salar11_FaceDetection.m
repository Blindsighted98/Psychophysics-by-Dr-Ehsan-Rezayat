clc,clear

%you probably need to create 2 foloder and use these syntaxex 2wise for the
%non faces part

%Faces Part
pathFaces=[cd,'\Images\Faces'];
Facefiles=dir(pathFaces);
Facefiles=Facefiles(3:end);
%non Faces Part
pathNonFaces=[cd,'\Images\NonFaces'];
NonFacefiles=dir(pathNonFaces);
NonFacefiles=NonFacefiles(3:end);

n=length(Facefiles);
%n=2*n


FacesVisualSignal=[];
NonFacesVisualSignal=[];
SignalFace=[100,80,50,20,0];
SignalNonFace=SignalFace*(-1);


nTrial=2*5*length(Facefiles);
textureFaces=[];
textureNonFaces=[];

%NonFaces Part

reactionTime=nan(1,nTrial);
accuracy=nan(1,nTrial);



circleColor=[170, 215, 255];

Screen('Preference', 'SkipSyncTests', 1);
[wPtr, rect] = Screen('OpenWindow', max(Screen('Screens')), [127 127 127],[0 0 1000 500]);

W =rect(3);
H=rect(4);
side=0.4*W;
a=H/100;
b=H/10;
r=W/20;
rightCirCo=[0.85*W-r,H/2-r,0.85*W+r H/2+r];
leftCirCo =[0.15*W-r,H/2-r,0.15*W+r H/2+r];
rightTextCo=[(rightCirCo(1)+rightCirCo(3))/2,(rightCirCo(2)+rightCirCo(4))/2];
leftTextCo =[(leftCirCo(1)+leftCirCo(3))/2,(leftCirCo(2)+leftCirCo(4))/2];

crossA=[W/2-a/2,H/2-b/2,W/2+a/2,H/2+b/2];
crossB=[W/2-b/2,H/2-a/2,W/2+b/2,H/2+a/2];
centerCoord=[W/2-side/2,H/2-side/2,W/2+side/2,H/2+side/2];
noise=[0 0.2 0.5 0.8 1];

order=Shuffle(1:nTrial);

%Faces Part
for i=1:length(Facefiles)
    %create a for loop right here
    pic=rgb2gray(imread(Facefiles(i).name));
    for mm=1:5
        FacesVisualSignal=[FacesVisualSignal,SignalFace(mm)];
        textureFaces=[textureFaces,Screen('MakeTexture',wPtr,imnoise(pic,"salt & pepper",noise(mm)))];
    end
end
%nonFaces Part

for i=1:length(NonFacefiles)
    %create a for loop right here
    pic=rgb2gray(imread(NonFacefiles(i).name));
    for mm=1:5
        NonFacesVisualSignal=[NonFacesVisualSignal,SignalNonFace(mm)];
        textureNonFaces=[textureNonFaces,Screen('MakeTexture',wPtr,imnoise(pic,"salt & pepper",noise(mm)))];
    end
end


%Face is equal to 1, Non Face=0
FaceNonFace=[ones(size(textureFaces)),zeros(size(textureNonFaces))];



FaceAndNonFaceTexture=[textureFaces,textureNonFaces];
FaceAndNonFaceSignal =[FacesVisualSignal,NonFacesVisualSignal];
%the 1st row is visual signal% the 2nd row is the Textures
%presenting the stimuli
commandwindow
%RestrictKeysForKbCheck([KbName('right'),KbName('left')]);
for l=1:nTrial

    %Fixation Cross 
    Screen('FillRect',wPtr,[0 0 0],crossA);
    Screen('FillRect',wPtr,[0 0 0],crossB);
    Screen('Flip',wPtr);
    WaitSecs(0.5);

    %استفاده از وایل به روش تدریس شده ی امروز استاد، وایل زمان، پروسه را ادامه
    %بده'

    %Stimuli presentation 
    Screen('DrawTexture',wPtr,FaceAndNonFaceTexture(order(l)),[],centerCoord);
    Screen('Flip',wPtr);
    WaitSecs(0.3);

    
    Screen('DrawTexture',wPtr,FaceAndNonFaceTexture(order(l)),[],centerCoord);
    Screen('FillOval',wPtr,circleColor,leftCirCo);
    Screen('FillOval',wPtr,circleColor,rightCirCo);
    Screen('TextFont',wPtr,'Times');
    Screen('TextSize',wPtr,48);
    DrawFormattedText(wPtr, 'F', rightTextCo(1), rightTextCo(2), [0 0 0]);
    DrawFormattedText(wPtr, 'N', leftTextCo(1), leftTextCo(2), [0 0 0]);
    Screen('Flip',wPtr);

    %Resposne collcetion
    [pressed,~,keycode]=KbCheck();
    initalTime=tic;
    while true
        %cheeeeeeeeeeeeeeeeeek heeeeeeeeeeeeeeeere
        if toc-initalTime>0.3
            break;
        end

        if pressed==1
            reactionTime(l)=toc-initalTimel;
        end

    end


    %checking the accuracy
    %turn the xx yy zz to a string then check the accuracy based on Face
    %...NonFace (FaceNonFace matrix)
    %if true
    %accuracy(l)=1
    %end
    % end



    %kbcheck
    %reactiontime(l)=toc-g;

    WaitSecs(0.3);
end

sca;
%save(reactionTime