clc,clear;
personal_code=input('Enter your code\n','s');
ntrial=5;
neutral_n=floor(0.2*ntrial);
congruent_n=floor(0.4*ntrial);
incongruent_n=floor(0.4*ntrial);
congruent_time=[];
incongruent_time=[];
outputMat=[];

neutral_Mat=[0 0 1 0 0;0 0 3 0 0];
congruent_Mat=[ones(1,5);3.*ones(1,5)];
incongruent_Mat=[3 3 1 3 3;1 1 3 1 1];

%i coulve used a couple of for loops but it wasnt efficent computationally
outputMat(1:neutral_n, :) = neutral_Mat(randi(2, neutral_n, 1), :);
outputMat(neutral_n + 1 : neutral_n + congruent_n, :) = congruent_Mat(randi(2, congruent_n, 1), :);
outputMat(neutral_n + congruent_n + 1 : neutral_n + congruent_n + incongruent_n, :) = incongruent_Mat(randi(2, incongruent_n, 1), :);

% randomizing output rows
randomizedOutput = outputMat(randperm(size(outputMat, 1)), :);

commandwindow;
for i=1:size(randomizedOutput,1)
    clc;
    t1=GetSecs;
    randomizedOutput(i,:)
    x=input('please enter the middle number: \n');
    t2=GetSecs;
    delta=t2-t1;
    if randomizedOutput(i,3)==x
        if randomizedOutput(i,1)==randomizedOutput(i,3)
            congruent_time=[congruent_time,delta];
        elseif randomizedOutput(i,1)~=0
            incongruent_time=[incongruent_time,delta];
        end
    end
WaitSecs(0.3);
clc;
end
plot(congruent_time,'Color','b');
hold on;
plot(incongruent_time,'Color','r');
legend('congruent','incongruent')

filename = [personal_code, '.mat'];
save(filename);