clear, clc;
ColorsN = {'Red','Green','Blue','Yellow'}; 
ColorsRGBYCode = [255,0,0; 0,255,0; 0,0,255; 255,255,0]; 
ColorsS = size(ColorsN,2);
repeat = 3;
nTrial = repeat * ColorsS.^2;

% 1.colorcode 2.colorcodeShow 3.Congruency 4.ReactionTime 5.KeyAnswer 6.Accuracy
data = [repelem(1:ColorsS, ColorsS)', repmat(1:ColorsS, [1, ColorsS])', zeros(ColorsS.^2, 4)];
data = repmat(data, [repeat, 1]);
data = data(randperm(nTrial), :);

% Set congruency column
data(data(:,1) == data(:,2), 3) = 1; 

TextMessages = {'Correct', 'Incorrect'};

commandwindow
Screen('Preference', 'SkipSyncTests', 1);
[wPtr, rect] = Screen('OpenWindow', max(Screen('Screens')), [127 127 127]);

W = rect(3); H = rect(4);
font = struct('size', round(W/27), 'name', 'Times');
Screen('TextFont', wPtr, font.name);
Screen('TextSize', wPtr, font.size);
side=0.4*W;
a=H/100;
b=H/10;
crossA=[W/2-a/2,H/2-b/2,W/2+a/2,H/2+b/2];
crossB=[W/2-b/2,H/2-a/2,W/2+b/2,H/2+a/2];
centerCoord=[W/2-side/2,H/2-side/2,W/2+side/2,H/2+side/2];

RestrictKeysForKbCheck([KbName('r'), KbName('g'), KbName('b'), KbName('y')]);

for i = 1:nTrial
    DrawFormattedText(wPtr, ColorsN{data(i,1)}, 'center', 'center', ColorsRGBYCode(data(i,2), :));
    Screen('Flip', wPtr);

    % Start timing and wait for response
    t = GetSecs();
    [~, keycode] = KbWait();
    KbReleaseWait(); % Ensure key release before proceeding
    data(i,4) = GetSecs() - t;

    keyName = KbName(find(keycode, 1)); % Get first pressed key
    if strcmp(keyName, 'r')
        data(i,5) = 1;
    elseif strcmp(keyName, 'g')
        data(i,5) = 2;
    elseif strcmp(keyName, 'b')
        data(i,5) = 3;
    elseif strcmp(keyName, 'y')
        data(i,5) = 4;
    end

    % Check accuracy
    if data(i,2) == data(i,5)
        data(i,6) = 1;
        DrawFormattedText(wPtr, TextMessages{1}, 'center', 'center', [255,255,255]);
    else
        DrawFormattedText(wPtr, TextMessages{2}, 'center', 'center', [255,255,255]);
    end
    Screen('Flip', wPtr);
    WaitSecs(0.5); 
    %fixationCross
    Screen('FillRect',wPtr,[0 0 0],crossA);
    Screen('FillRect',wPtr,[0 0 0],crossB);
    Screen('Flip',wPtr);
    WaitSecs(0.3);

    
    % Screen('Flip', wPtr);
    
end

sca;

% Compute mean reaction times
MeanCong = mean(data(data(:,3) == 1, 4)); % Mean RT for congruent trials
MeanInCong = mean(data(data(:,3) == 0, 4)); % Mean RT for incongruent trials

% Save results
T = table(data(:,1), data(:,2), data(:,3), data(:,4), data(:,5), data(:,6), ...
    'VariableNames', {'ColorWord', 'DisplayedColor', 'Congruency', 'ReactionTime', 'UserResponse', 'Accuracy'});
writetable(T, 'stroop_results.csv');


%% Calculate Statistics
% Separate trials into congruent and incongruent
congruentTrials = data(data(:,3)==1, :);
incongruentTrials = data(data(:,3)==0, :);

% Reaction Time stats
meanRT_cong   = mean(congruentTrials(:,4));
meanRT_incong = mean(incongruentTrials(:,4));
stdRT_cong    = std(congruentTrials(:,4));
stdRT_incong  = std(incongruentTrials(:,4));
nCong   = size(congruentTrials,1);
nIncong = size(incongruentTrials,1);
seRT_cong   = stdRT_cong / sqrt(nCong);
seRT_incong = stdRT_incong / sqrt(nIncong);

% Accuracy stats (percentage)
acc_cong   = mean(congruentTrials(:,6)) * 100;
acc_incong = mean(incongruentTrials(:,6)) * 100;

%% Plotting in one window using subplot
figure;

% Subplot 1: Bar Plot of Mean Reaction Times with Error Bars
subplot(2,2,1);
bar(1, meanRT_cong, 0.4, 'FaceColor', [0.2 0.6 0.5]); hold on;
bar(2, meanRT_incong, 0.4, 'FaceColor', [0.8 0.4 0.4]);
errorbar(1, meanRT_cong, seRT_cong, 'k', 'LineStyle', 'none', 'LineWidth', 1.5);
errorbar(2, meanRT_incong, seRT_incong, 'k', 'LineStyle', 'none', 'LineWidth', 1.5);
set(gca, 'XTick', [1 2], 'XTickLabel', {'Congruent','Incongruent'});
ylabel('Reaction Time (s)');
title('Mean Reaction Time by Condition');
hold off;

% Subplot 2: Histogram of Reaction Times
subplot(2,2,2);
histogram(data(:,4), 'BinWidth', 0.1, 'FaceColor', [0.4 0.4 0.8]);
xlabel('Reaction Time (s)');
ylabel('Frequency');
title('Reaction Time Distribution');

% Subplot 3: Trial-by-Trial Reaction Times
subplot(2,2,3);
plot(data(:,4), '-o', 'MarkerFaceColor', 'k');
xlabel('Trial Number');
ylabel('Reaction Time (s)');
title('Reaction Time per Trial');
grid on;

% Subplot 4: Bar Plot of Accuracy by Condition
subplot(2,2,4);
bar(1, acc_cong, 0.4, 'FaceColor', [0.3 0.7 0.3]); hold on;
bar(2, acc_incong, 0.4, 'FaceColor', [0.9 0.3 0.3]);
set(gca, 'XTick', [1 2], 'XTickLabel', {'Congruent','Incongruent'});
ylabel('Accuracy (%)');
title('Accuracy by Condition');
hold off;

