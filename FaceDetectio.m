clc,clear

%Faces Part
pathFaces=[cd,'\Images\Faces'];
Facefiles=dir(pathFaces);
Facefiles=Facefiles(3:end);
FaceResponse=zeros(1,9);
%non Faces Part
pathNonFaces=[cd,'\Images\NonFaces'];
NonFacefiles=dir(pathNonFaces);

NonFacefiles=NonFacefiles(3:end);

n=length(Facefiles);
circleColor=[170, 215, 255];
FacesVisualSignal=[];
NonFacesVisualSignal=[];
SignalFace=[100,80,50,20,0];
SignalNonFace=SignalFace*(-1);

nTrial=2*5*length(Facefiles);
textureFaces=[];
textureNonFaces=[];

reactionTime=nan(1,nTrial);
accuracy=nan(1,nTrial); %accuracy Guid: 1 is true 0 is not answerd and -1 is not correct
response=nan(1,nTrial);

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
    pic=rgb2gray(imread(Facefiles(i).name));
    for mm=1:5
        FacesVisualSignal=[FacesVisualSignal,SignalFace(mm)];
        textureFaces=[textureFaces,Screen('MakeTexture',wPtr,imnoise(pic,"salt & pepper",noise(mm)))];
    end
end
%nonFaces Part
for i=1:length(NonFacefiles)
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

%Stimuli Presentation
commandwindow
RestrictKeysForKbCheck([KbName('right'),KbName('left')]);
for l=1:nTrial

    %Fixation Cross
    Screen('FillRect',wPtr,[0 0 0],crossA);
    Screen('FillRect',wPtr,[0 0 0],crossB);
    Screen('Flip',wPtr);
    WaitSecs(0.3);

    %Stimuli presentation
    Screen('DrawTexture',wPtr,FaceAndNonFaceTexture(order(l)),[],centerCoord);
    Screen('Flip',wPtr);
    WaitSecs(0.3);

    reactionTime(l) = nan;
    accuracy(l) = 0;
    Screen('DrawTexture',wPtr,FaceAndNonFaceTexture(order(l)),[],centerCoord);
    Screen('FillOval',wPtr,circleColor,leftCirCo);
    Screen('FillOval',wPtr,circleColor,rightCirCo);
    Screen('TextFont',wPtr,'Times');
    Screen('TextSize',wPtr,48);
    DrawFormattedText(wPtr, 'F', rightTextCo(1), rightTextCo(2), [0 0 0]);
    DrawFormattedText(wPtr, 'N', leftTextCo(1), leftTextCo(2), [0 0 0]);
    keyPressed = false;
    Screen('Flip',wPtr);
    % Response collection                                                  
    initalTime = tic;





    
    
    while toc(initalTime) < 0.5
        [pressed, ~, keycode] = KbCheck();
        if pressed && ~keyPressed
            keyName = KbName(find(keycode));

            % Recording the reaction time
            reactionTime(l) = toc(initalTime);
            keyPressed = true; % Prevent multiple detections

            % Determine the response
            if strcmp(keyName, 'right')
                resp = 'Face';
                if FaceAndNonFaceSignal(l)==-100
                    FaceResponse(1)=FaceResponse(1)+1;
                elseif FaceAndNonFaceSignal(l)==-80
                    FaceResponse(2)=FaceResponse(2)+1;
                elseif FaceAndNonFaceSignal(l)==-50
                    FaceResponse(3)=FaceResponse(3)+1;
                elseif FaceAndNonFaceSignal(l)==-20
                    FaceResponse(4)=FaceResponse(4)+1;
                elseif FaceAndNonFaceSignal(l)==-0
                    FaceResponse(5)=FaceResponse(5)+1;
                elseif FaceAndNonFaceSignal(l)==20
                    FaceResponse(6)=FaceResponse(6)+1;
                elseif FaceAndNonFaceSignal(l)==50
                    FaceResponse(7)=FaceResponse(7)+1;
                elseif FaceAndNonFaceSignal(l)==80
                    FaceResponse(8)=FaceResponse(8)+1;
                elseif FaceAndNonFaceSignal(l)==100
                    FaceResponse(9)=FaceResponse(9)+1;
                end
                % NumberOfFaceAnswers=NumberOfFaceAnswers+1;
            elseif strcmp(keyName, 'left')
                resp = 'NonFace';
            else
                resp = '';
            end

            % Check accuracy
            if strcmp(resp, 'Face') && FaceNonFace(order(l)) == 1
                accuracy(l) = 1; % Correct for face
            elseif strcmp(resp, 'NonFace') && FaceNonFace(order(l)) == 0
                accuracy(l) = 1; % Correct for NonFace
            else
                accuracy(l) = -1; % Incorrect
            end
        end
    end

    if ~keyPressed
        % if he didnt answer
        accuracy(l) = 0;
    end
    WaitSecs(0.3);
end

sca;
NotAnswerNumberOfTrials=[];
WrongAnswerNumberOfTrials=[];
CorrectAnswerNumberOfTrials=[];
%create a MATRIX for the ones that you didnt answerd etc

NotAnswerNumberOfTrials = find(accuracy == 0);
WrongAnswerNumberOfTrials = find(accuracy == -1);
CorrectAnswerNumberOfTrials = find(accuracy == 1);

% a for calcluation of sums of each signal
respMat=zeros(1,9);
for pp=1:length(response)
    if FaceAndNonFaceSignal(pp)==-100
        respMat(1)=respMat(1)+1;
    elseif FaceAndNonFaceSignal(pp)==-80
        respMat(2)=respMat(2)+1;
    elseif FaceAndNonFaceSignal(pp)==-50
        respMat(3)=respMat(3)+1;
    elseif FaceAndNonFaceSignal(pp)==-20
        respMat(4)=respMat(4)+1;
    elseif FaceAndNonFaceSignal(pp)==0
        respMat(5)=respMat(5)+1;
    elseif FaceAndNonFaceSignal(pp)==20
        respMat(6)=respMat(6)+1;
    elseif FaceAndNonFaceSignal(pp)==50
        respMat(7)=respMat(7)+1;
    elseif FaceAndNonFaceSignal(pp)==80
        respMat(8)=respMat(8)+1;
    elseif FaceAndNonFaceSignal(pp)==100
        respMat(9)=respMat(9)+1;
    end
end

save('SavedVars.mat', 'accuracy','FaceNonFace', 'order','CorrectAnswerNumberOfTrials','NotAnswerNumberOfTrials','reactionTime','FaceAndNonFaceSignal');

plot([-100,-80,-50,-20,0,20,50,80,100],FaceResponse)
% legend()