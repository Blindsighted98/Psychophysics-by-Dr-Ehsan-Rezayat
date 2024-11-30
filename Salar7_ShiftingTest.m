clc,clear;
personal_code=input('Enter your code\n','s');
ntrial=10;
neutral_n=floor(0.2*ntrial);
congruent_n=floor(0.4*ntrial);
incongruent_n=floor(0.4*ntrial);
correct_congruent_time=[];
incorrect_congruent_time=[];

correct_incongruent_time=[];
incorrect_incongruent_time=[];

correct_neutral_time=[];
incorrect_neutral_time=[];

neutral_Mat=[0 0 1 0 0;0 0 3 0 0];
congruent_Mat=[ones(1,5);3.*ones(1,5)];
incongruent_Mat=[3 3 1 3 3;1 1 3 1 1];
resp_Mat=[];
disp_Mat=[];
overallTime=[];

up1=KbName('1!');
num1=KbName('1');
up3=KbName('3#');
num3=KbName('3');
logiCorrectness_Mat=[];
outputMat=[repmat(neutral_Mat,[neutral_n/2,1]);repmat(congruent_Mat,[congruent_n/2,1]);repmat(incongruent_Mat,[incongruent_n/2,1])];

% randomizing output rows
randomizedOutput = outputMat(randperm(size(outputMat, 1)), :);
%disp part
RestrictKeysForKbCheck([KbName('1!'),KbName('1')]);
commandwindow;
fprintf('In every trial you see %d digits.\nEnter the middle one.\nTry to be as fast as you can.\nPress 1 to start\n',ntrial)
KbWait();
WaitSecs(0.3);
RestrictKeysForKbCheck([KbName('1!'),KbName('3#'),KbName('1'),KbName('3')]);
commandwindow;
for i=1:size(randomizedOutput,1)
    clc;
    %%you should use kbwaite
    %fprintf('          %d %d %d %d %d \nplease enter the middle number: \n',randomizedOutput(i,:))
    randomizedOutput(i,:)
    tic;
    %what key did you pushed
    [~,keyCode]=KbWait();
    keyName = KbName(find(keyCode));

    delta=toc;
    overallTime=[overallTime,delta];
    if strcmp(keyName,'3#')==1||strcmp(keyName,'3')==1
        resp=3;
    else
        resp=1;
    end
    resp_Mat=[resp_Mat;resp];
    logiCorrectness_Mat=[logiCorrectness_Mat,resp==randomizedOutput(i,3)];
    if resp==randomizedOutput(i,3)
        if randomizedOutput(i,1)==randomizedOutput(i,3)   
            correct_congruent_time=[correct_congruent_time,delta];
        elseif randomizedOutput(i,1)~=0
            correct_incongruent_time=[correct_incongruent_time,delta]; 
        else
            correct_neutral_time=[correct_neutral_time,delta];
        end
    else
        if randomizedOutput(i,1)==randomizedOutput(i,3)
            incorrect_congruent_time=[incorrect_congruent_time,delta];
        elseif  randomizedOutput(i,1)~=0
            incorrect_incongruent_time=[incorrect_incongruent_time,delta];
        else
            incorrect_neutral_time=[incorrect_neutral_time,delta];
        end
    end
    WaitSecs(0.3);
    clc;
end
plot(correct_congruent_time,'Color','b');
hold on;
plot(correct_incongruent_time,'Color','r');
legend('congruent','incongruent')
filename = [personal_code, '.mat'];

MCNT=mean(correct_neutral_time);
MWNT=mean(incorrect_neutral_time);
MCIT=mean(correct_incongruent_time);
MWIT=mean(incorrect_incongruent_time);
MCCT=mean(correct_congruent_time);
MWCT=mean(incorrect_congruent_time);
save(filename,'randomizedOutput','logiCorrectness_Mat',"resp_Mat","overallTime",'personal_code','correct_incongruent_time','correct_congruent_time',"MCNT","MWNT","MCIT","MWIT",'MCCT','MWCT');