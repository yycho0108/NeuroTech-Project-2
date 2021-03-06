% This code will allow us to filter all of the data and determine the good data from the bad data.  

%Load the data
addpath('C:\Users\kelly_000\OneDrive\Documents\Olin 2017\NeuroTech\NeuroTech-Project-2\data');
data_folder = dir('data');
data_folder.name;
parse(data_folder(7).name);
%[data_norm, stimulus_type, match_type, event_times] = [0,0,0,0]
[data_norm, stimulus_type, match_type, event_times] = parse(data_folder(4).name);
for i=5:7
    [data_norm_temp, stimulus_type_temp, match_type_temp, event_times_temp] = parse(data_folder(i).name);
    data_norm = vertcat(data_norm, data_norm_temp);
    stimulus_type = vertcat(stimulus_type,stimulus_type_temp);
    match_type = vertcat(match_type,match_type_temp);
    event_times = vertcat(event_times,event_times_temp);
    %[data_norm, stimulus_type, match_type, event_times; data_norm_temp, stimulus_type_temp, match_type_temp, event_times_temp]
end

%% Filtering out the Eye Blinks
%if the absolute value of any of the channels at any time point is above
    %100mV, remove the trial.
    
j = 1; %Initialize the indexing for data_norm_noblinks
for i=1:length(event_times)
    if length(data_norm{i}) < 250
        continue
    elseif sum(all(abs(data_norm{i}(1:250,[1,2,3,4])) < 200)) == 4 %This looks messy... but it works!
        data_norm_noblinks{j,1}(:,:) = data_norm{i}(1:250,[1,2,3,4]);
        event_times_noblinks{j,1} = event_times{i};
    else
        continue
    end
    j = j+1; %Indexing for the data_norm_noblinks    
end

size(data_norm_noblinks) %should be 315 x 1
size(event_times_noblinks) %should also be 315


%% Now, let's plot all of the trials for each channel of the no-blink data and we can sort them. 

%CHANGE THE FOLLOWING NUMBERS/VARIABLES TO YOUR CHANNEL
channel = 4; %Channel to that will be plotted and stored in the script!!!!!!! 
good_trials_Ch4 = NaN(length(data_norm_noblinks), 250); %initializing the matrix. Format: (# of potentially good trials, # of time points we care about)

%Okay, we're good. Make sure the good_trials_Ch# is changed below too.
k = 1; %

for i=1:length(data_norm_noblinks) 
    close
    figure;
    plot(event_times_noblinks{i}(1:250, 1), data_norm_noblinks{i}(1:250,channel));
    title(['Trial' num2str(i)]);
    legend(['Channel' num2str(channel)])
    xlim([0,500]);
    w = waitforbuttonpress;
    if w == 0
        continue %CLICK FOR BAD DATA. The bad data is not stored
    else
        good_trials_Ch4(k,:) = data_norm_noblinks{i}(1:250,channel)'; %PRESS THE SPACE BAR FOR GOOD DATA. Stores the first 250 time events.
        conditions_Ch4(k,1) = stimulus_type(i);
    end
    k = k+1;
 end

size(good_trials_Ch4)

%% Plotting the Channel 1 each condition just to see what it looks like
%Note load the Channel 1 Data
load conditions_Ch1.mat
load good_trials_Ch1.mat

plot(0:2:498, mean(good_trials_Ch1(conditions_Ch1 == 1, :),'omitnan'))
hold on
plot(0:2:498, mean(good_trials_Ch1(conditions_Ch1 == 2, :),'omitnan'))
plot(0:2:498, mean(good_trials_Ch1(conditions_Ch1 == 3, :),'omitnan'))
title('Channel 1')
legend('Stimulus 1', 'Stimulus 2', 'Stimulus 3')
xlabel('Time (ms)')
ylabel('mV')

%% Plotting the Channel 2 data for each conditiont to see what it looks like

load conditions_Ch2.mat
load good_trials_Ch2.mat

plot(0:2:498, mean(good_trials_Ch2(conditions_Ch2 == 1, :),'omitnan'))
hold on
plot(0:2:498, mean(good_trials_Ch2(conditions_Ch2 == 2, :),'omitnan'))
plot(0:2:498, mean(good_trials_Ch2(conditions_Ch2 == 3, :),'omitnan'))
title('Channel 2')
legend('Stimulus 1', 'Stimulus 2', 'Stimulus 3')
xlabel('Time (ms)')
ylabel('mV')

%% Plotting the Channel 3 data for each conditiont to see what it looks like

load conditions_Ch3.mat
load good_trials_Ch3.mat

plot(0:2:498, mean(good_trials_Ch3(conditions_Ch3 == 1, :),'omitnan'))
hold on
plot(0:2:498, mean(good_trials_Ch3(conditions_Ch3 == 2, :),'omitnan'))
plot(0:2:498, mean(good_trials_Ch3(conditions_Ch3 == 3, :),'omitnan'))
title('Channel 3')
legend('Stimulus 1', 'Stimulus 2', 'Stimulus 3')
xlabel('Time (ms)')
ylabel('mV')

%% Plotting the Channel 4 data for each conditiont to see what it looks like

load conditions_Ch4.mat
load good_trials_Ch4.mat

plot(0:2:498, mean(good_trials_Ch4(conditions_Ch4 == 1, :),'omitnan'))
hold on
plot(0:2:498, mean(good_trials_Ch4(conditions_Ch4 == 2, :),'omitnan'))
plot(0:2:498, mean(good_trials_Ch4(conditions_Ch4 == 3, :),'omitnan'))
title('Channel 4')
legend('Stimulus 1', 'Stimulus 2', 'Stimulus 3')
xlabel('Time (ms)')
ylabel('mV')

%% Plotting the mean of Channels 2 & 3

figure;
plot(0:2:498, mean([good_trials_Ch4(conditions_Ch4 == 1, :); good_trials_Ch3(conditions_Ch3 == 1, :)],'omitnan'))
hold on
plot(0:2:498, mean([good_trials_Ch4(conditions_Ch4 == 2, :); good_trials_Ch3(conditions_Ch3 == 2, :)],'omitnan'))
plot(0:2:498, mean([good_trials_Ch4(conditions_Ch4 == 3, :); good_trials_Ch3(conditions_Ch3 == 1, :)],'omitnan'))
title('Channel 3&4')
legend('Stimulus 1', 'Stimulus 2', 'Stimulus 3')
xlabel('Time (ms)')
ylabel('mV')
