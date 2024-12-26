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
values = [-100 -80 -50 -20 0 20 50 80 100];

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
    pic=rgb2gray(imread([pathFaces,'\',Facefiles(i).name]));
    for mm=1:5
        FacesVisualSignal=[FacesVisualSignal,SignalFace(mm)];
        textureFaces=[textureFaces,Screen('MakeTexture',wPtr,imnoise(pic,"salt & pepper",noise(mm)))];
    end
end
%nonFaces Part
for i=1:length(NonFacefiles)
    pic=rgb2gray(imread([pathNonFaces,'\',NonFacefiles(i).name]));
    for mm=1:5
        NonFacesVisualSignal=[NonFacesVisualSignal,SignalNonFace(mm)];
        textureNonFaces=[textureNonFaces,Screen('MakeTexture',wPtr,imnoise(pic,"salt & pepper",noise(mm)))];
    end
end

%Face is equal to 1, Non Face=0
FaceNonFace=[ones(size(textureFaces)),zeros(size(textureNonFaces))];
FaceAndNonFaceTexture=[textureFaces,textureNonFaces];
FaceAndNonFaceSignal =[FacesVisualSignal,NonFacesVisualSignal];
FaceAndNonFaceTexture=FaceAndNonFaceTexture(1,order);

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
    Screen('DrawTexture',wPtr,FaceAndNonFaceTexture(l),[],centerCoord);
    Screen('Flip',wPtr);
    WaitSecs(0.3);

    reactionTime(l) = nan;
    accuracy(l) = 0;
    Screen('DrawTexture',wPtr,FaceAndNonFaceTexture(l),[],centerCoord);
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
                index = find(FaceAndNonFaceSignal(l) == values);
                if ~isempty(index)
                    FaceResponse(index) = FaceResponse(index) + 1;
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

%sums of each signal
respMat = zeros(1, length(values));


for pp = 1:length(response)

    index = find(FaceAndNonFaceSignal(pp) == values);

    if ~isempty(index)
        respMat(index) = respMat(index) + 1;
    end
end

save('SavedVars.mat', 'accuracy','FaceNonFace', 'order','CorrectAnswerNumberOfTrials','NotAnswerNumberOfTrials','reactionTime','FaceAndNonFaceSignal');

signalCounts = zeros(1, length(values));
for i = 1:length(FaceAndNonFaceSignal)
    index = find(FaceAndNonFaceSignal(i) == values);
    if ~isempty(index)
        signalCounts(index) = signalCounts(index) + 1;
    end
end
faceResponseRatio = FaceResponse ./ signalCounts;

figure;
plot(values, faceResponseRatio)